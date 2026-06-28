# nixos-update

Production-grade update tool for NixOS systems.

---

## Overview

`nixos-update` is a modular Bash project designed to safely update one or more NixOS systems managed with Git and Flakes.

The project is intended for long-term maintenance of personal and server infrastructures.

---

## Project Goals

* Safe NixOS upgrades
* Fully reproducible workflow
* One codebase for all NixOS machines
* Automatic verification before update
* Rollback support
* Modular architecture
* Easy maintenance
* ShellCheck clean
* Comprehensive documentation

---

## Features (planned)

* Environment validation
* Git repository validation
* Automatic backup
* Flake update
* Build verification
* NixOS switch
* Rollback
* Package analysis (`nvd`)
* Kernel change detection
* systemd change detection
* Generation comparison
* Summary report
* Logging
* Desktop notifications
* Git commit & push

---

## Project Structure

```text
tools/nixos-update
├── bin/
├── config/
├── docs/
├── lib/
├── tests/
├── VERSION
├── README.md
├── CHANGELOG.md
├── ROADMAP.md
├── LICENSE
├── Makefile
└── shellcheck.sh
```

---

## Development Workflow

Every development step follows the same workflow.

1. One milestone
2. One commit
3. One tested feature
4. Push to GitHub
5. Continue with next milestone

---

## Supported Platforms

| Platform          | Status       |
| ----------------- | ------------ |
| NixOS 26.05       | Supported    |
| KDE Plasma        | Supported    |
| Server (headless) | Planned      |
| Raspberry Pi      | Planned      |
| NixOS unstable    | Experimental |

---

## Versioning

Semantic Versioning is used.

Example:

* 0.1.0
* 0.2.0
* 0.3.0
* ...
* 1.0.0

---

## Current Status

Current milestone:

Project Structure (0.1.0)

The first functional milestone will be:

Logging Framework (0.2.0)
