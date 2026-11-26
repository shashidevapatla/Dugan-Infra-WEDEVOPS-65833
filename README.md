# Dugan-Infra

## This repository controls every infrastructure provisioning and configuring aspect of the `Dugan-Infra`.

Workspace `nonprod` (workflow `openmetal-nonprod`, project `om-Dugan`) builds the Dugan non-prod SQL Server
`ndugsql01` (Windows, SQL Server 2019) and its DB gateway load balancer, using `openstack-mssql-server-instance-module`.
The VM sits on `w-app-dugan-subnet` (172.21.13.192/27) and hosts `dugan_tempdoppa` and `dugan_tempdoppa_analytics`.

Passwords are not stored here: the local administrator password is generated and kept in Barbican
(`ndugsql01_local_administrator`). The domain-join password is not set here: the module's default applies.

### ⚠️ Key instructions for running terraform:
1. Clone the repository.
2. Open a new branch.
3. Commit your changes to that branch.
4. Open a PR from your `new branch` to the `main` branch.
5. Comment in that PR with `atlantis` commands: https://www.runatlantis.io/docs/using-atlantis
   (`atlantis plan -w nonprod`, read the whole plan).
6. Ask for approval before applying.
7. After the PR is approved, apply the changes (`atlantis apply -w nonprod`), validate and then merge.
