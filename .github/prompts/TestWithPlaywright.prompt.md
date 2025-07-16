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

After compiling the list, present it to me for confirmation.
If I confirm, proceed to implement and execute all the test cases using Playwright MCP server.
