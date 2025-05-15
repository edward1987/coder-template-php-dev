---
display_name: Laravel Dev Environment (PHP 8.3)
description: Full-featured Laravel development container with PHP 8.3, Nginx, MariaDB 10 and Git integration.
icon: ../../../site/static/icon/laravel.svg
maintainer_github: your_github_username
verified: true
tags: [laravel, php, nginx, mariadb, docker, devcontainer, git]
---

# 🚀 Laravel Development Environment (PHP 8.3 + Nginx + MariaDB)

This Coder template provisions a complete Docker-based Laravel development environment using PHP 8.3, Nginx, and MariaDB 10. It supports automatic Git cloning or fresh Laravel installation via Composer, complete with Node.js, database setup, and VSCode in the browser.

---

## 🧰 Stack Overview

- **PHP 8.3 (FPM)**
- **Nginx**
- **MariaDB 10**
- **Laravel (auto-install or Git-based)**
- **Node.js (via NVM)**
- **Code-Server (VSCode in browser)**
- **PhpMyAdmin** available at `/phpmyadmin`

---

## 📦 Features

- Automatic cloning of a Git repo _or_ `composer create-project`
- Environment variables injected: `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- `.env` file automatically generated and configured
- Unique MySQL container per workspace
- PhpMyAdmin for DB management
- Code-server available at port `13337`
- Laravel auto-setup: `key:generate`, `.env`, dependencies
- `npm install` and `npm run build` auto-executed if `package.json` exists

---

## ⚙️ How It Works

### 🗃️ Parameters

| Parameter           | Description                                                |
|---------------------|------------------------------------------------------------|
| `repo`              | Select Laravel default or custom Git repository           |
| `custom_repo`       | If custom repo selected, provide a Git URL (https supported) |
| `custom_repo_user`  | (Optional) Username for private Git repository            |
| `custom_repo_token` | (Optional) Access token for private Git repository        |

> The template decides whether to clone or install based on these values.

---

### 🗂 Folder Structure

The Laravel project is installed or cloned to:

/var/www/html

yaml
Copy
Edit

Volumes are mounted per workspace. All PHP, Nginx, and Laravel files are persistent.

---

### 🧱 MySQL Configuration

- The template creates a **unique MariaDB container per workspace**
- A random or parameterized:
  - Database name
  - Username
  - Password
- `.env` values are injected dynamically, even if defaults are commented in `env.example`

Sample injected values:

```env
DB_CONNECTION=mysql
DB_HOST=coder-workspace-mysql-123abc
DB_PORT=3306
DB_DATABASE=dev_db_xyz
DB_USERNAME=user_xyz
DB_PASSWORD=securepass123
PhpMyAdmin is accessible at http://localhost/phpmyadmin.

🛠 Node & Assets
Installs Node.js 22 using NVM

Automatically runs:

bash
Copy
Edit
npm install
npm run build
If package.json is present.

🧪 Prerequisites
Make sure the coder user on the Coder host is in the Docker group:

bash
Copy
Edit
sudo usermod -aG docker coder
sudo systemctl restart coder
sudo -u coder docker ps