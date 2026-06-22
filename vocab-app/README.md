# Class 8 下 单词练习

This app is fully static. Open index.html directly in a browser.
No server, no database, no internet connection, and no external dependency are required.

## 如何打开

1. 复制整个 `vocab-app` 文件夹到任意电脑。
2. 双击打开 `index.html`。
3. 选择 Unit 和练习模式后点击“开始练习”。

## 功能

- 英译中
- 中译英
- 拼写
- 听写（使用浏览器自带 SpeechSynthesis API）
- 错题本（保存在浏览器 localStorage）

## 如何修改词库

词库数据在 `vocab-data.js`。

按下面格式添加或修改单词即可：

```js
{
  id: "class8b-unit1-example",
  word: "example",
  meaning: "例子"
}
```

请确保同一个单词的 `id` 唯一，并放在正确的 Unit 的 `words` 数组中。

## 错题本保存位置

错题本保存在当前浏览器的 `localStorage` 中。关闭网页后再次打开，错题本仍会保留。不同浏览器或不同电脑之间不会自动同步。

## 如何清空错题本

打开应用后点击“查看错题本”，再点击“清空错题本”。
