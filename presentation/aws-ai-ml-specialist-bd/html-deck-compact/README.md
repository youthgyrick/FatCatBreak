# AWS AI/ML Specialist BD — Compact HTML Deck

这是 v7 演示内容的紧凑版本。完整版本保留在 `../html-deck/`，紧凑版控制在 35 页以内，适合时间较短的面试或 Executive Briefing。

## 本地预览

在仓库根目录运行：

```bash
python3 -m http.server 4173
```

访问：

```text
http://localhost:4173/presentation/aws-ai-ml-specialist-bd/html-deck-compact/
```

## 控制方式

- `←` / `→`、`Page Up` / `Page Down`：翻页
- `Space`：下一页
- `Home` / `End`：首尾页
- `F`：全屏
- 移动设备：左右滑动
- 点击卡片、表格行、架构框或 Workflow node：高亮
- 点击空白区域或按 `Esc`：清除高亮

## 紧凑策略

- 保留 v7 的全部 17 个 Markdown Page。
- 合并同一主题下的说明、能力列表和 Business Value。
- Architecture、Agent Workflow、RAG / Knowledge、Data Flow 和 Multi-agent Diagram 仍使用独立页面。
- 8 项 AWS Mapping 改为双栏卡片，不压缩为小字号表格。
- 正文、表格和 Diagram 文字保持 16px 或以上。
- 不生成 PPTX，不依赖外部 CDN、字体或 JavaScript 库。
