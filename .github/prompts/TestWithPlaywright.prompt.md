---
mode: "agent"
tools: ["playwright"]
description: "Test Elixir Phoenix LiveView module using the Playwright MCP browser (no test scripts)"
---

Goal: Execute tests by driving the Playwright MCP browser directly (navigate, click, type, wait, assert), NOT by generating Playwright code or spec files.

Strict operating rules:

- Use only the Playwright MCP browser to perform actions:
  - Navigate to URLs, wait for text/element states, click, type, select options, capture minimal snapshots or screenshots.
- Do NOT:
  - Generate Playwright test scripts/spec files or code in any language.
  - Create/modify files or run CLI tools like `npx playwright`.
  - Suggest code unless I explicitly ask you to propose a fix patch.
- If the Playwright tool or localhost is unavailable, pause and ask for enablement instead of generating code.

Test design scope:
Compose a minimal, non-duplicative checklist of Playwright-MCP-executable tests that fully cover the current LiveView, prioritizing:

- URL manipulation (direct navigation, deep links, back/forward)
- Validation/error states (if forms exist)
- Flash messages and UI feedback (if present)
- Data/stream updates and real-time broadcasts (if present)
- Loading/empty states, error pages, and access control (if present)
  Combine overlapping verifications to avoid redundancy.

Execution protocol:

1. Present a numbered checklist of all Playwright MCP-compatible tests for confirmation before running.
2. After confirmation, execute tests sequentially using the MCP browser.
3. After each test, update the checklist item with PASSED/FAILED/SKIPPED (with reason).
4. Evidence per test (keep concise):
   - Final URL
   - Page title
   - 1–2 key selector checks (e.g., selected per_page value, active page)
   - Optional: link to screenshot or minimal DOM snapshot
5. On failure:
   - Provide a clear explanation and minimal repro evidence.
   - If a fix is obvious, describe it; do NOT change files unless I explicitly authorize a patch.
6. At the end, present a compact summary table of all results with links to any artifacts.

Performance/verbosity:

- Prefer minimal waits (event- or selector-based), avoid arbitrary timeouts.
- Keep snapshots small and relevant; avoid large DOM dumps unless requested.

After compiling the checklist, present it to me for confirmation. If I confirm, run all tests in the MCP browser, update results inline, and provide the final summary.
