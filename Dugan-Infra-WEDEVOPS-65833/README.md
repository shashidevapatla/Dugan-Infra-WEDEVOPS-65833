# kinetik-infra

Infrastructure for Kinetik, applied by Atlantis. Do not run `terraform apply` locally.

Workspace `nonprod` (workflow `openmetal-nonprod`, project `om-Kinetik`) builds the Kinetik non-prod SQL Server
`nkinsql01` and the DB gateway `kinetik-test2-sql.wenergysoftware.com` for WEDEVOPS-61443, using
`openstack-mssql-server-instance-module` v2.2.3. The VM sits on the app's own subnet (`w-app-eagleclaw-subnet`,
172.100.4.64/27) and hosts `kinetik_test2` and `kinetik_test2_analytics`, moved off the shared `domsq02`.

The load balancer `kinetik-sql-external` (TCP/1433) is opened in two stages: P81 egress only at build time (PR #1), then
P81 plus Kinetik's 14 egress IPs (`local.kinetik_client_cidrs`) once the cutover is verified (PR #2).

The read-only login `kinetik_ro` (db_datareader on `kinetik_test2_analytics`) was created by hand with a new password
kept in the team vault. The `kinetik_ro` secret in Barbican (`nkinsql01_mssql_users_credentials`) does not match it.
See the comment in `database.tf`.

Passwords are not stored here: the local administrator password is generated and kept in Barbican
(`nkinsql01_local_administrator`). The domain-join password is not set here: the module's default applies.

## Workflow
1. Branch, commit, open a PR to `main`.
2. Comment `atlantis plan -w nonprod` and read the whole plan.
3. Get the PR approved, comment `atlantis apply -w nonprod`, verify, merge.
