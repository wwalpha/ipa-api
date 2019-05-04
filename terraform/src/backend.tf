terraform {
  backend "s3" {
    bucket = "ipa-api-backend"
    region = "ap-northeast-1"
    key    = "terraform/tfstate"
  }
}
