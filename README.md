# Worksuite

Worksuite is a modular productivity and workspace platform. Built on a multi-repository architecture using **Git
Submodules**, the project is orchestrated locally using Docker Compose to glue together the frontend, backend services,
auth service, reverse proxy, and underlying databases.

---

## Prerequisites

Ensure the following tools are installed on your machine:

- **Git** (v2.30+ recommended)
- **Docker Engine** (v24.0+)
- **Docker Compose** (Plugin v2.x+)
- **PowerShell** (on Windows) or **Bash** (on Linux/macOS) for running setup scripts

---

## Getting Started & Installation

### 1. Clone the Repository (Including Submodules)

Because Worksuite relies on Git Submodules for the application code (`frontend`, `backend`, and `auth-backend`), clone
the repository recursively:

```bash
git clone --recurse-submodules git@github.com:haevnEU/WorkSuite.git
cd WorkSuite
# If you already cloned without --recurse-submodules:
git submodule update --init --recursive
git submodule foreach 'git checkout master'
```

### 2. Initialize Directory Structure & .env Files

Execute the initialization script suitable for your OS in the repository root. This creates the shared/ directory, the
env/dev/ and env/prod/ folder hierarchies, and populates all required .env files with working defaults:

On Windows (PowerShell):

````powershell
.\init-structure.ps1
````

On Linux/macOS (Bash):

```bash
chmod +x init-structure.sh
./init-structure.sh
```

### 3. Modify Environment Variables

Modify the `.env` files in `env/dev/` and `env/prod/` as needed to customize your development and production
environments. Ensure that sensitive information (like database passwords) is kept secure.

### 4. Spin Up Containers

Once the environment configuration and folder structure are initialized, build and run the development environment:

````
docker compose up --build
````

## Services

### prod

- Proxy (Nginx): http://localhost:80
- Backend (Spring Boot)
- Auth-Backend (Spring Boot)
- PostgreSQL
- MongoDB

### dev

The following services are orchestrated via Docker Compose:

- Proxy (Nginx): http://localhost:80
- Frontend (Vite / React): http://localhost:5173 / http://localhost:3000
- Backend (Spring Boot): Port 5005 (Debug: 5005)
- Auth-Backend (Spring Boot): Port 5006 (Debug: 5005)
- PostgreSQL: Port 5432
- MongoDB: Port 27017
- Redmine: http://localhost:81

## Submodules

This project uses Git Submodules to manage the frontend, backend, and auth-backend codebases. Each submodule is a
separate Git repository that is included within the main Worksuite repository.

