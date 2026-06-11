# AWS AI/ML Specialist BD HTML Deck

## Preview

From the repository root:

```bash
python3 -m http.server 4173
```

Open:

```text
http://localhost:4173/presentation/aws-ai-ml-specialist-bd/html-deck/
```

You can also open `index.html` directly in a browser.

## Controls

- `←` / `→`, `Page Up` / `Page Down`: navigate
- `Space`: next slide
- `Home` / `End`: first / last slide
- `F`: fullscreen
- Touch devices: swipe horizontally

## Source

Content follows `aws_ai_ml_bd_interview_deck_reviewed_v5.md` from the `codex/create-html-slide-deck-in-folder` branch. Dense markdown pages were split into continuation slides so diagram text remains at least 16px.

## Pages split for readability

The following source pages were split into continuation slides:

- Page 3: Emotibot overview and platform architecture
- Page 5: AI Contact Center business needs and AWS architecture
- Page 6: modernization needs and Agentic AI architecture
- Page 9: marketing workflow changes and AWS real-time platform
- Page 12: content workflow change and AWS Agentic Content architecture
- Page 13: interaction design and technical architecture
- Page 15: Agent specification and safety boundaries
- Page 16: multi-agent workflow and specification quality

The resulting HTML deck contains 29 slides.

## Assumptions

- The reviewed markdown is the content source of truth.
- Official AWS service icons are intentionally omitted; service names and restrained AWS-style containers keep the deck offline and easy to maintain.
- Architecture content is simplified visually, but service mappings and stated business results are preserved.
