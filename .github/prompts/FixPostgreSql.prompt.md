---
mode: agent
description: "Fix PostgreSQL Startup Issues on macOS"
---

Check if the PostgreSQL service is failing to start on macOS due to a stale postmaster.pid file.

1. Run:
   brew services list

   If the output contains:
   postgresql@14 error 1 [some path]

   Then proceed to step 2.

2. Try starting manually:
   pg_ctl -D /opt/homebrew/var/postgresql@14 start

   If the output contains:
   FATAL: lock file "postmaster.pid" already exists
   HINT: Is another postmaster (PID XXXX) running in data directory "/opt/homebrew/var/postgresql@14"?

   Then run:
   rm /opt/homebrew/var/postgresql@14/postmaster.pid

3. Retry:
   pg_ctl -D /opt/homebrew/var/postgresql@14 start

4. Confirm it's running:
   pg_ctl -D /opt/homebrew/var/postgresql@14 status

   Expected output:
   pg_ctl: server is running
