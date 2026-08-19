---
name: create-markdown
description: Write well-structured markdown — docs, READMEs, notes, guides, or blog posts. Use this skill any time markdown needs to be created or edited.
user_invocable: true
---

# create-markdown

Write markdown following a consistent style guide. Works for any markdown — docs, READMEs, notes, blog posts, guides.

When writing for `@san-siva/blogkit-md`, also apply the blogkit-specific rules in the section below.

## Steps

1. Ask the user what they want to write (topic, title, brief outline) if not already provided.
2. Ask if this is for blogkit-md or general markdown.
3. Draft the markdown following the style guide below.
4. Show the result and ask if they'd like any adjustments.

## General Style Guide

### Headings

- Use `#` for the document title (one per file).
- Use `##` for major sections, `###` for subsections.
- Don't skip levels (e.g. `##` → `####`).
- Keep headings short and scannable.
- **No numbers in `#`, `##`, or `###` headings.** Numbers are only allowed in `####` and deeper headings, or in ordered lists.
- **No flow arrows in any heading** — never use `→`, `-->`, `➜`, or similar to depict a sequence in a heading. Write a plain descriptive phrase (e.g. `#### Batch, encode, and send the Beacon`, not `#### Batch → Beacon → collector`) and put the flow in the body text or a diagram.

### Break content into sections with headings

Structure content with real headings, not bold-text labels. Any of these patterns should become a heading (`####` or deeper) instead:

- A standalone bold line acting as a group label — `**Security**` → `#### Security`.
- A bold lead-in that opens a paragraph — `**Consumer** — binds the input topic…` → `#### Consumer` with the sentence moved to the body below.
- Lettered or numbered inline captions — `**(a) Content → background**`, `**1. Bootstrap**`, `Gate 1 — …` → each becomes its own heading.

Rules for the conversion:

- **Move the description into the body.** The heading is a short label; the explanatory sentence (often after an `—` or `:`) goes on the line below it, not in the heading.
- **Nest by depth, never skip a level.** A label that sits under a `####` block becomes `#####` (e.g. `##### Gate 1 — confidence judge` under `#### Routing decision`).
- **Strip numbers, arrows, and `=` from the heading text** per the Headings rules above — rephrase so the label reads as a plain noun phrase.

### Frontmatter

Use YAML frontmatter when metadata is needed:

```markdown
---
title: Your Title
description: A short description.
---
```

### Callouts

GitHub-style blockquote alerts:

```markdown
> [!NOTE]
>
> Something the reader should know.

> [!TIP]
>
> A helpful suggestion.

> [!IMPORTANT]
>
> Critical information.

> [!WARNING]
>
> Something that could go wrong.

> [!CAUTION]
>
> A danger or destructive action.
```

The blank `>` line between the type and content is required.

### Code Blocks

Always specify the language:

````markdown
```typescript
const x: string = 'hello';
```

```bash
npm install my-package
```

```json
{ "key": "value" }
```
````

### Code references and line numbers

- **Never cite a source location as `file:line` in prose.** Do not write things like `EmbedderActor.java:112` or "see `Content.ts:28`" in sentences or bullets.
- When you reference specific code, show it in a fenced code block and put the location as a **comment on the first line** of that block, e.g.:

  ````markdown
  ```ts
  // packages/functional-errors/src/content/Content.ts:28 — initialize()
  this.port = Browser.runtime.connect({ name: 'functional-errors' });
  ```
  ````

- If you don't have the real code to show, reference the file and symbol by **name only** (`ConfigWatcher.setFunctionalErrorsConfig`) and omit the line number entirely.
- Quote code verbatim from the source; elide irrelevant lines with `...`. Never paraphrase or invent code inside a code block.

### Prefer code snippets over prose for technical detail

- When describing how code behaves, **show the code**. Dense bullet lists that narrate code ("`start()` does an initial scan then attaches an observer with these options…") are hard to digest — replace them with a short one-line caption followed by the actual snippet.
- Structure walkthroughs as **numbered steps**, each a bold caption + one code block, rather than long paragraphs.

### Mermaid Diagrams

Use a Mermaid diagram for any architecture, data flow, sequence, or decision logic — a diagram beats a paragraph for anything with more than two moving parts. Color-code node classes when a distinction matters and add a short legend.

````markdown
```mermaid
graph TD
  A[Start] --> B[Process] --> C[End]
```
````

- **Do not add an ASCII-art fallback** (or any duplicate rendering) alongside a Mermaid diagram. Target viewers render Mermaid; a fallback is redundant noise. One diagram, one representation.

### Tables

```markdown
| Column A | Column B | Column C |
| -------- | -------- | -------- |
| value    | value    | value    |
```

- **Never use any text-formatting syntax in table headers** — no code spans (backticks), no `**bold**`, no `_italic_`. They don't render properly in header cells. Write headers as plain text only (e.g. use `Flag`, not `` `--flag` `` or `**Flag**`). Formatting like `` `code` `` is fine in body cells.

### Task Lists

```markdown
- [x] Completed item
- [ ] Pending item
```

### Inline Formatting

| Syntax        | Use                              |
| ------------- | -------------------------------- |
| `**bold**`    | Emphasis, key terms              |
| `_italic_`    | Titles, subtle emphasis          |
| `` `code` ``  | Inline code, commands, filenames |
| `[text](url)` | Links                            |
| `![alt](url)` | Images                           |

### Horizontal rules are banned

**Never emit a horizontal rule to separate sections.** This applies to every horizontal-rule syntax — `---`, `***`, `___`, or any line of three-or-more `-`/`*`/`_` on its own. There are exactly two valid uses of `---` in a document, and nothing else:

1. The opening and closing fences of a YAML frontmatter block at the very top of the file.
2. The dashes inside a table's header-separator row (e.g. `| ---- | ---- |`).

To break up content, use a heading (`##`, `###`) — never a rule. If you are about to write a `---` line that is not one of the two cases above, delete it and add a heading or just a blank line instead.

### General Writing Tips

- Prefer callouts over parenthetical asides for important notes.
- Use code blocks liberally for any technical content.
- Keep paragraphs concise — one idea per paragraph.
- Use lists for three or more related items rather than inline prose.

## blogkit-md Rules

Apply these **in addition** to the general guide when writing for `@san-siva/blogkit-md`.

### Frontmatter

`title` and `description` are both required:

```markdown
---
title: Your Post Title
description: A short, one or two sentence description shown below the title.
---
```

- Do NOT add an `#` H1 — it would be stripped when frontmatter title is present.

### Heading Hierarchy

| Level                   | Purpose                     | Layout effect                           |
| ----------------------- | --------------------------- | --------------------------------------- |
| `##`                    | Major section               | Creates a new `BlogSection`             |
| `###`                   | Subsection within a section | Creates a nested subsection             |
| `####` `#####` `######` | Minor headings              | Rendered as bold text, no layout change |

- Content before the first `##` becomes an untitled intro section — keep it short (2–4 sentences).
- Don't use section separators (`---`) — they are handled automatically.
