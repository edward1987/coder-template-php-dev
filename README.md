---
display_name: PHP Dev Environment (PHP 8.3 + Nginx + MariaDB)
description: Lightweight PHP development container with Nginx and MariaDB 10.
icon: ../../../site/static/icon/php.png
maintainer_github: your_github_username
verified: true
tags: [php, docker, nginx, mariadb, devcontainer]
---

# ⚙️ PHP Development Environment (PHP 8.3 + Nginx + MariaDB)

This Coder template provisions a Docker-based development container using PHP 8.3 with Nginx and MariaDB 10. It provides a general-purpose PHP setup for developing and testing PHP applications without any framework scaffolding or Git integration.

---

## 🧰 Stack Overview

- **PHP 8.3 (FPM)**
- **Nginx**
- **MariaDB 10**
- **PhpMyAdmin** (accessible at `/phpmyadmin`)
- **Code-Server** (VSCode in browser)

---

## ✅ Features

- Clean PHP 8.3 development environment
- Nginx reverse proxy configured for `/var/www/html`
- Persistent workspace volume for all project files
- Auto-start via Supervisor
- PhpMyAdmin for database management
- Code-server running on port `13337`
- Auto-generated MySQL credentials
- Dynamic `.env` file generation if needed

---

## 🧱 Architecture

- One **ephemeral** Docker container for your development tools
- One **MariaDB 10 container** per workspace, uniquely named
- One **Docker volume** for PHP files mounted at `/var/www/html`

You can build any PHP project from scratch or upload files via VSCode.

---

## 💾 MySQL Configuration

Each workspace provisions a dedicated MariaDB instance with:

- Unique **database name**
- Unique **user**
- Unique **password**

These are injected into the environment and `.env` file (if detected). PhpMyAdmin is available at `http://localhost/phpmyadmin`.

Sample environment variables injected:


🛠 Node.js (Optional)
If your PHP project uses frontend tooling:

Node.js 22 is installed via NVM

Auto-detects package.json and runs:

bash
Copy
Edit
npm install
npm run build
🧪 Prerequisites
Make sure the Coder host supports Docker and the coder user has access:

bash
Copy
Edit
sudo usermod -aG docker coder
sudo systemctl restart coder
sudo -u coder docker ps
🌐 Available Services
Service	Access Path	Description
PHP App	/	Served via Nginx + PHP-FPM
PhpMyAdmin	/phpmyadmin	MariaDB management
Code Server	:13337	VSCode in the browser
