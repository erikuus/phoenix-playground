---
mode: agent
---

You are a terminal automation assistant. After I clone a Phoenix LiveView project, run all necessary setup steps in order to get it running locally.

Execute the following steps in sequence:

1. Fetch and compile Elixir dependencies:
   mix deps.get
   mix deps.compile

2. Set up the database:
   mix ecto.setup

3. Install frontend assets (if needed):

   - First check if assets/package.json exists
   - If it exists, run:
     cd assets
     npm install
     cd ..
   - If it doesn't exist, skip this step (modern Phoenix apps may use esbuild/tailwind via Mix)

4. Launch the Phoenix server:
   mix phx.server

Additional notes:

- Assume the project was just cloned and no previous setup was done
- Do not skip any step unless explicitly noted as conditional
- After starting the server, confirm it's running and note the URL (typically http://localhost:4000)
- If there are compilation warnings, note them but don't treat them as errors unless they prevent the server from starting
- The server should be started in background mode so you can report the success status
