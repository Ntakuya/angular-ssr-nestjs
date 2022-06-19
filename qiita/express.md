# Express で AngularSSR を利用する

## table of contents

0. Angulr のプロジェクトを作成する
1. `@nguniversal/express-engine` を利用して SSR を実装する

## before development

## 0. Angular の Project を作成する

`ng command`を利用して Angular のプロジェクトを作成します。

```
% ng new angular-ssr-express
? Would you like to add Angular routing? Yes
? Which stylesheet format would you like to use? SCSS   [ https://sass-lang.com/documentation/syntax#scss

% cd angular-ssr-express
```

起動して、angular が動くか確認します。

```
% npm run serve
```

[localhost:4200](http://localhost:4200/)を起動して確認します。

## 1. `@nguniversal/express-engine` を利用して SSR を実装する

`@nguniversal/express-engine`を install して環境を整える。

```
% ng add @nguniversal/express-engine
The package @nguniversal/express-engine@13.1.1 will be installed and executed.
Would you like to proceed? Yes
```

Manual インストールではないため、SSR の環境も同時に設定されます。

設定ができたか確認するため、Server を起動してみます。

```
% npm run dev:ssr
```

[Browser](http://localhost:4200)からは同様に変更がないことを確認します。
[SSR Localhost:4200](view-source:http://localhost:4200/)で Server からのデータを確認します。
