# Coding Style

The goal of this document is to keep the project readable, maintainable and consistent.

---

# General Rules

* Use Bash only.
* Always start scripts with:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

* Every executable file must be ShellCheck clean.

---

# Naming

Functions

```text
snake_case
```

Example

```bash
check_environment()
backup_configuration()
run_build()
```

Variables

```text
UPPER_CASE
```

Example

```bash
LOG_DIR
HOSTNAME
ENABLE_PUSH
```

Local variables

```bash
local current_generation
```

---

# File Layout

Each file should contain only one responsibility.

Example

logging.sh

* logging
* banner
* step output

build.sh

* build
* switch
* flake update

git.sh

* git only

rollback.sh

* rollback only

---

# Main Script

The main executable should contain almost no business logic.

Example

```text
Load configuration

Load libraries

Run checks

Run backup

Run build

Run analysis

Run summary
```

---

# Logging

Never use

```bash
echo
```

for runtime messages.

Always use logging functions.

---

# Configuration

Never hardcode:

* paths
* host names
* branch names
* repository locations

Everything belongs into configuration files.

---

# Error Handling

Never ignore errors.

Use common helper functions.

Example

```bash
die

warn

abort
```

---

# Testing

Every milestone must satisfy:

* ShellCheck
* Manual test
* Git commit
* Git push

Only then continue to the next milestone.

---

# Development Rule

One milestone

↓

One commit

↓

One tested feature

↓

Push

↓

Next milestone
