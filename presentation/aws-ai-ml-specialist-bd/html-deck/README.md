# AWS AI/ML Specialist BD HTML Deck — v7

## Preview

From the repository root:

```bash
python3 -m http.server 4173
```

Open:

```text
http://localhost:4173/presentation/aws-ai-ml-specialist-bd/html-deck/
```

## Controls

- `←` / `→`, `Page Up` / `Page Down`: navigate
- `Space`: next slide
- `Home` / `End`: first / last slide
- `F`: fullscreen
- Touch devices: swipe horizontally
- Click a card, table row, text block, architecture box, node, or workflow step to highlight it
- Click the empty slide background or press `Esc` to clear the highlight

## Source

The single source of truth is `aws_ai_ml_bd_interview_deck_v7.md` from the `codex/create-html-slide-deck-in-folder` branch:

`https://github.com/youthgyrick/FatCatBreak/blob/codex/create-html-slide-deck-in-folder/presentation/aws-ai-ml-specialist-bd/aws_ai_ml_bd_interview_deck_v7.md`

The source has 17 numbered pages. Every numbered page, architecture, table, STAR section, metric, AWS mapping, business value section, and closing section is represented in the HTML deck.

## Readability splits

Dense source pages were split into continuation slides rather than reducing typography:

- Page 1: cover and key message
- Page 2: positioning and capability mapping
- Page 3: Emotibot portfolio and platform architecture
- Page 4: STAR case and result metrics
- Page 5: Voicebot / Agent Assist, Quality Inspection / Coaching, AWS opportunity, architecture
- Page 6: modernization problem, target architecture, business value
- Page 7: Convertlab capabilities and AI Hub architecture
- Page 8: CIE STAR case
- Page 9: three workflow changes, architecture, AWS mapping Part 1 / Part 2
- Page 10: XiaoIce products and Conversational AI architecture
- Page 11: STAR case and action detail
- Page 12: workflow change, architecture, AWS mapping Part 1 / Part 2, business value
- Page 13: interaction design, architecture, technical decisions
- Page 14: knowledge operations, boundary/evaluation, insight/business value
- Page 15: project context, Agent/safety design, Dashboard Part 1 / Part 2
- Page 16: collaboration architecture, technical tree, responsibility table, Spec quality, AWS relevance, business value
- Page 17: closing capability evidence and BD working style

## Assumptions

- Official AWS icons are not required; service names and restrained AWS-style containers keep the deck offline and maintainable.
- Architecture diagrams simplify routing lines visually but preserve all source components and annotations.
- Footer content automatically added by GitHub's web page is not source presentation content and is not included.
