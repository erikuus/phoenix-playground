Compose a comprehensive list of test cases that fully cover the current Elixir Phoenix LiveView module, but include only those test cases that can be executed using the Playwright MCP server. Use any code breakdowns or commentaries I provide as context to improve the quality and coverage of the tests.

Consider the following features, but include each only if present in the module:

- Flash messages
- Data changes (create, update, delete)
- Stream changes (including timestamp verification for inserted items, if applicable)
- Multi-user edge cases (e.g., optimistic locking for concurrent edits and deletes)
- URL manipulation (deep-linking, direct navigation, and browser back/forward navigation)
- Error pages and error handling (e.g., 404, 500, unauthorized access)
- Validation and error feedback for forms
- Real-time updates/broadcasts (presence, PubSub, etc.)
- Access control/authorization
- Loading and empty states

**Important:**
Avoid any duplication of test cases. If features overlap (e.g., testing optimistic locking or real-time broadcasting can also verify correct flash messages), combine them into a single, efficient test case. The goal is to keep the test set minimal, non-redundant, and focused.

**Checklist and Execution Requirements:**

- Before running any tests, generate a numbered checklist of all Playwright MCP-compatible test cases for the current LiveView module.
- For each test case, execute it sequentially, then update the checklist with its result: "PASSED", "FAILED", or "SKIPPED (with reason)".
- Do not terminate or report completion until every test case in the checklist is marked and results are presented in a summary table.
- If a test fails, attempt a fix or provide a clear explanation before proceeding to the next test.
- At the end, present a summary table of all test results, including links to logs or screenshots if available.

After compiling the checklist, present it to me for confirmation.
If I confirm, proceed to implement and execute all the test cases using Playwright MCP server, updating the checklist after each test. Do not report completion until all cases are marked and summarized.
