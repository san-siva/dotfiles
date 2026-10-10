---
name: Analyze Jira Ticket
description: Comprehensive analysis of a Jira ticket across the Nexthink WebExtension ecosystem, environment setup, and implementation planning.
user_invocable: true
---

# Task

- Analyze a specific JIRA ticket and its relationship to the broader Nexthink codebase (Extension, API, Protobufs).
- Automate the local environment setup (branches/worktrees) using internal skills.
- Generate a standardized implementation guide (`TASK-[SPACE]-[TICKET_NUMBER].md`) and output it directly to the `~/Work/personal.san-siva/notes/investigations` directory.

# Context

- **Team:** Nexthink Engineering (WebExtension)
- **Base Directory:** `~/Work/`
- All Nexthink repositories are placed under the work directory `~/Work/*`

# Steps

## Information Gathering & Dependency Mapping

- Use the **Atlassian skill** to fetch the Jira ticket details.
- **Cross-Repo Check:** Determine if the ticket requires changes to `@protobufs` or `json-schema` before the extension logic can be implemented.
- Identify if the task impacts the `background-script`, `content-script`, or `popup/ui` layers of the WebExtension.

## Technical Analysis & Traceability

### Code Search

Use `ripgrep` or symbol search to find existing code related to the ticket’s functional area.

### Impact Assessment

- Check if `manifest.json` permissions need updating.
- Identify state management (Redux/Zustand) changes required.

### Diagramming

Use `mermaid-wizard/SKILL.md` to create:

- **Current State:** The existing data flow or component hierarchy.
- **Target State:** Highlight modified modules, new API contracts, or new message passing between extension parts.

## Environment Preparation

- **Branching:** Use `branch-name/SKILL.md` to generate a consistent branch name (e.g., `feat/PROJECT-123-description`).
- **Workspace:** Use `gitsy/SKILL.md` to create a dedicated worktree in the relevant repository.

> If cross-repo changes are needed, suggest creating worktrees in multiple repos.

## Documentation Generation & Validation

1. **Load the create-markdown skill** — Ensure you understand the style guide before writing
2. **Draft the markdown** following the structure templates below
3. **Validate before output**:
   - ✓ Descriptive headings only (no numbers)
   - ✓ No `---` separators (except frontmatter)
   - ✓ Code locations shown as inline comments, never `file:line` in prose
   - ✓ All architecture/flow diagrams use Mermaid
   - ✓ Callouts (`> [!NOTE]`, etc.) used for emphasis
4. **Output to correct location**: `~/Work/personal.san-siva/notes/investigations/TASK-{ID}.md`

## Documentation (TASK.md)

### Markdown Style Compliance

**Before creating any markdown output:**

1. Load the `create-markdown` skill to review the style guide
2. Apply these non-negotiable rules:
   - ✗ **No numbered section headings** (`## 1.`, `## 2.`, etc.) — use plain descriptive headings instead
   - ✗ **No `---` horizontal rules** (except in YAML frontmatter) — use headings to separate sections
   - ✓ **Use Mermaid diagrams** for any architecture, flow, or decision logic
   - ✓ **Never cite code as `file:line`** in prose — show snippets with location as a comment
   - ✓ **Use callouts** (`> [!NOTE]`, `> [!IMPORTANT]`) for important information

3. Validate the output before writing to disk

### For Spike/Research Tickets

Create the file as `TASK-{JIRA_TICKET_ID}.md` directly in `~/Work/personal.san-siva/notes/investigations/` (not in a worktree).

**Template structure:**
- H1: Investigation title
- **Metadata**: Ticket ID, status, date
- **Executive Summary**: 3–4 bullet points on findings + recommendation
- **Sections**: Use only descriptive H2 headings (no numbers)
- **Diagrams**: Include Mermaid diagrams for flows/architecture
- **Conclusion**: Restatement of recommendation + effort estimates
- **Appendix**: File references, related documentation

### For Implementation Tickets

Create a `TASK.md` in the root of the new worktree using this structure:

```md
---
name: Task Title
jira: TICKET_ID
description: Short description of the task.
---

# High-Level Strategy

A concise summary of the architectural approach.

# Dependency Order

1. Protobuf/Schema changes (if applicable)
2. Backend/API Mocks
3. Extension Implementation

# Diagrams

## Current Architecture

\`\`\`mermaid
graph TD
  A[Component] --> B[Process]
\`\`\`

## Proposed Changes

\`\`\`mermaid
graph TD
  A[Component] --> B[New Process] --> C[Updated State]
\`\`\`

# Impact Checklist

- [ ] **Manifest Permissions:** (e.g., host permissions, storage)
- [ ] **State/Store:** (List affected slices or stores)
- [ ] **Cross-Context Messaging:** (Changes to `chrome.runtime` messaging)

# Implementation Plan

1. First step description
2. Second step description
3. Final step description

# Affected Files

- `packages/path/to/File.ts` — What changed
- `packages/other/Component.tsx` — What changed

# Testing & QA

## Unit Tests

- Logic for...

## Playwright (Component/E2E)

- **Mocks Required:** (List network requests to intercept)
- **Test Cases:** (List new or updated scenarios)
```

**Style Rules for Markdown:**
- Section headings use only `##` and `###` (no numbers)
- Minor callouts use `####` and deeper (only when needed)
- Use code blocks with location comments for code references
- Always include Mermaid diagrams for architecture or flows

# Constraints

- Always use relative paths `~/Work/...` to ensure portability.
- **Load `create-markdown` skill before any markdown output** — validate all generated markdown against the style guide
- Ensure all Mermaid diagrams use the subgraph syntax to clearly separate repositories or extension contexts
- **No numbered section headings, no `---` separators** — use only descriptive headings (H2/H3) to structure content
- Never cite code locations as `file:line` in prose; show code snippets with location as inline comments instead
