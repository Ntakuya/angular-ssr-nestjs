# Angular Express を dockernise する

## table of contents

1. dockerfile を作成する
2. docker-compose.yaml を作成する
3. server.ts を編集する

## Pre Build

[Qiita](https://qiita.com/Gma_Gama/items/383d7f396bee28c42f24)の環境を利用しています。

環境は以下。

環境

| Package                       | Version  |
| :---------------------------- | -------- |
| @angular-devkit/architect     | 0.1303.8 |
| @angular-devkit/build-angular | 13.3.8   |
| @angular-devkit/core          | 13.3.8   |
| @angular-devkit/schematics    | 13.3.8   |
| @angular/cli                  | 13.3.8   |
| @nguniversal/builders         | 13.1.1   |
| @nguniversal/express-engine   | 13.1.1   |
| @schematics/angular           | 13.3.8   |
| rxjs                          | 6.6.7    |
| typescript                    | 4.6.4    |

## 1. dockerfile を作成する

docker を利用するための`Dockerfile`を作成します。
image は node:alpine16 系を利用想定として初めて行きます。

### 1-1. 下準備

`node_modules`は OS 依存の package があった場合に扱いがすごくだるくなるため、`volume`に追加します。(build の成果物とかもやった方がいいですがとりあえず動くように。。。)

```terminal
% rm -rf node_modules
```

### 1-2. dockerfile を作成する

```terminal
% touch dockerfile
% code ./dockerfile

```

基本的に[nodejs official](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)を利用してコードを整理していきます。

```dockerfile
FROM node:16-alpine as local # targetを利用してproductionの時と書き分ける

ENV ROOT=/usr/src/app # 完全にのり

WORKDIR ${ROOT}

RUN apk update && apk upgrade --available

COPY package*.json .
RUN npm install
COPY . .

CMD [ "npm", "run", "dev:ssr" ] # local開発専用の位置付けなので、コマンド自体も `npm run dev:ssr`で対応を実施
```

## 2. docker-compose.yaml を作成する

```docker-compose.yaml
version: '3.9'
services:
  client:
    container_name: client # つけておいた方がのちのち楽
    build:
      context: .
      dockerfile: ./dockerfile
      target: local # targetを利用して対応
    tty: true
    restart: "always"
    ports:
      - "4200:4200"
    working_dir: /usr/src/app
    volumes:
      - ".:/usr/src/app"
      - clientdependency:/usr/src/app/node_modules

volumes:
  clientdependency: {} # node_modules用のvolumeを追加
```

一応`docker compose up`で動くのですが、画面には rendering されません。。。

```terminal
% docker compose up --build
```

### 3. server.ts を編集する

上記完了後に、`server.ts`に HOST と PORT についての記載を追加します。

```server.ts
<!-- line: 51 -->
function run(): void {
  const port = process.env['PORT'] || 4000;

  // Start up the Node server
  const server = app();
  server.listen(port, () => {
    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}
```

HOST の規定がない + port が number ではないので、追記

```server.ts
function run(): void {
  const port = Number(process.env['PORT']);
  const PORT = Number.isNaN(port) ? 4000 : port;
  const HOST = '0.0.0.0';

  // Start up the Node server
  const server = app();
  server.listen(PORT, HOST, () => {
    console.log(`Node Express server listening on http://${HOST}:${port}`);
  });
}
```

以上の設定が完了したら、起動します。

```terminal
% docker compose up --build
```

[localhost:4200](http://loclhost:4200)と[view-source](view-source:http://localhost:4200/)を利用して起動が完了したことと SSR で build されているかを確認します。
