# 発音記号(IPA)変換API

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
