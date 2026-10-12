# Week 7 Database Lab: Audit Logging, Category Trees, Safe Migrations, and Least-Privilege Security

## Objective

Implement a reusable audit logging system, model hierarchical categories using a recursive CTE, organize schema changes into versioned Flyway migrations, and configure database roles with limited permissions.

## 1. Audit Logging

Created an `audit_log` table with the following fields:

- `id`: Unique audit record identifier.
- `tbl`: Table where the change occurred.
- `op`: Database operation.
- `old_row` and `new_row`: JSONB representations of row data before and after the change.
- `changed_by`: Database user responsible for the change.
- `at`: Timestamp of the event.

Created a reusable PL/pgSQL audit function and attached it to the `students` table for INSERT, UPDATE, and DELETE operations.

### Testing

- Updated student ID 1 from `Makram Adam` to `Kofi M.`.
- Deleted student ID 3.
- Queried the audit log and verified the old and new row values.

## 2. Hierarchical Categories

Created a self-referencing `categories` table using `parent_id` as a foreign key.

Test data:

- Electronics
  - Computers
    - Laptops
  - Phones

Used a recursive CTE to retrieve the category hierarchy and display indentation based on depth.

## 3. Versioned Migrations with Flyway

Created these migration files in the `migrations/` directory:

- `V1__core_tables.sql`
- `V2__audit_log.sql`
- `V3__categories.sql`

Installed Java and Flyway Community Edition 12.0.0 and connected Flyway to PostgreSQL 18.6.

### Migration status

The `students`, `audit_log`, and `categories` tables already existed when Flyway was configured. I therefore created a Flyway baseline at version 3 to register the existing schema.

**Important:** The baseline was recorded successfully, but Flyway did not execute migration versions V1–V3. The files are included as versioned migration examples.

## 4. Least-Privilege Security

Created the database roles `app_read` and `app_write`.

- `app_read`: Granted CONNECT, schema USAGE, and SELECT on existing tables.
- `app_write`: Granted CONNECT, schema USAGE, and SELECT, INSERT, UPDATE, and DELETE on existing tables.
- `api`: Created a login user and made it a member of `app_write`.

### Testing

- Verified that `api` could authenticate to the `bootcamp` database.
- Verified the current database user using `SELECT current_user`.
- Tested reading student records as `api`.
- Tested that `api` could not create a table without schema-creation privileges.

## Technologies

- PostgreSQL 18.6
- PL/pgSQL
- JSONB
- Recursive CTEs
- Flyway Community Edition 12.0.0
- Java
- Ubuntu Linux

## Project Structure

```text
week-7-database-lab/
├── README.md
└── migrations/
    ├── V1__core_tables.sql
    ├── V2__audit_log.sql
    └── V3__categories.sql
Security Note

Database passwords and other secrets must not be committed to version control. The local Flyway configuration file is excluded from the public submission.
