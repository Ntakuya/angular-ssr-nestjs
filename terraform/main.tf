terraform {
  required_version = "~> 1.1"
  required_providers {
    vercel = {
      source = "vercel/vercel"
      version = "~> 0.6"
    }
  }
}