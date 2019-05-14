# 発音記号(IPA)変換API
[CMU Pronouncing Dictionary](http://www.speech.cs.cmu.edu/cgi-bin/cmudict)の辞書を元に、変換処理を行います。

## 使い方
APIは**1日200回**のアクセス制限があります。

```sh
$ curl -H 'x-api-key:xxxxxxxxxx' https://m1rb1oo72l.execute-api.ap-northeast-1.amazonaws.com/v1?word=english
```

結果：
```json
{
  "word":"america",
  "pronounce":"əˈmɛrɪkə"
}
```

## インフラアキーテクチャ

### インストール

### 初期データ投入
....

### 使用する技術
|サービス|用途|
|---|---|
API Gateway | REST API管理、アクセスログ、アクセス制限など
Lambda | 発音記号への変換処理
DynamoDB | IPA辞書、発音記号の管理 

## アプリ構成

### 言語
* [Node.js](https://nodejs.org/ja/)
* [TypeScript](https://www.typescriptlang.org/)

### ライブラリ
|ライブラリ|用途|
|---|---|
Webpack | JSライブラリをコンパイルする
webpack-cli | webpackのコマンドツール
webpack-merge | webpackの複数設定ファイルをマージする
clean-webpack-plugin| webpackのプラグイン、ビルドする前に出力フォルダを削除する
copy-webpack-plugin| webpackのプラグイン、ビルドする前に出力フォルダに静的ファイルをコピーする
zip-webpack-plugin | webpackのプラグイン、ビルド成功後、出力フォルダにあるファイルをZip化する
aws-sdk | aws development toolkit
typescript | Javascriptの型付け言語
ts-loader　| webpack用ライブラリ、typescriptから直接コンパイルできる

