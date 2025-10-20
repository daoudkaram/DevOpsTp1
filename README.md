# Docker Lab - Template Repository

Welcome to the Docker Lab! This repository contains 8 progressive exercises to master Docker fundamentals, from simple containers to complex microservices architectures.

## Getting Started

### Prerequisites

- Docker installed ([Install Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed ([Install Docker Compose](https://docs.docker.com/compose/install/))
- Git
- A GitHub account

### Setup

1. **Use this template:**
   - Click the "Use this template" button at the top of this repository
   - Create your own repository (must be **public**)
   - Clone your new repository locally

2. **Verify your Docker installation:**
```bash
docker --version
docker-compose --version
```

## Exercises Overview

| Exercise | Topic | Difficulty | Files to Create |
|----------|-------|------------|-----------------|
| 1 | Hello Whale | ⭐ | `1-hello-whale.sh` |
| 2 | Interactive Python | ⭐ | `2-python.sh` |
| 3 | Simple Dockerfile | ⭐⭐ | `3-curl.dockerfile` |
| 4 | Broken Development Setup | ⭐⭐ | `4-dev-app.dockerfile`, `4-run.sh` |
| 5 | Image Size Optimization | ⭐⭐⭐ | `5-optimized.dockerfile`, `5-comparison.txt` |
| 6 | Database Persistence | ⭐⭐⭐ | `6-setup.sh` |
| 7 | Microservices Communication | ⭐⭐⭐⭐ | `7-microservices.sh` |
| 8 | AI Chat Interface | ⭐⭐⭐⭐ | Complete `8-ai/` directory |

---

## Exercise 1: Hello Whale 🐋

**Goal:** Run a container and auto-remove it

**Requirements:**
- Use the `anthonyjhoiro/whalesay` image
- Display: `Hello M1 Cyber 2025`
- Container must be deleted after execution

**What you'll learn:**
- Basic `docker run` command
- Auto-removal flag
- Passing arguments to containers

**Output:** Create `1-hello-whale.sh` script

---

## Exercise 2: Interactive Python Shell

**Goal:** Start an interactive Python environment

**Requirements:**
- Use Python 3 image
- Start an **interactive** console
- Container must be deleted when exited

**What you'll learn:**
- Interactive mode flags
- Using standard Docker images
- Terminal attachment

**Output:** Create `2-python.sh` script

---

## Exercise 3: Simple Dockerfile - Curl Tool

**Goal:** Create a Dockerfile for a curl utility

**Requirements:**
- Build with: `docker build -t my-curl -f 3-curl.dockerfile .`
- Run with: `docker run --rm my-curl https://example.com`
- The URL should be passed as argument
- Run with non-root user

**What you'll learn:**
- Writing Dockerfiles
- ENTRYPOINT vs CMD
- Security best practices (non-root users)
- Package installation in containers

**Output:** Create `3-curl.dockerfile`

---

## Exercise 4: The Broken Development Setup

**Situation:**
A junior developer tried to containerize a Node.js application but left frustrated. You found their incomplete notes in `broken-app/`:
- "Express app, entry point is server.js"
- "package.json exists"
- "Needs port 3000"
- "Kept getting permission errors?"

The app code is there but no working Dockerfile exists.

**Your Task:**
- Figure out what's needed and create `4-dev-app.dockerfile`
- Install dependencies correctly
- App accessible on host machine port 3000
- Run as non-root user (fixes permission issue!)
- Create `4-run.sh` with build and run commands

**What you'll learn:**
- Node.js containerization
- Port mapping
- File permissions in containers
- Debugging containerization issues

**Output:** `4-dev-app.dockerfile` + `4-run.sh`

**Test your solution:**
```bash
bash 4-run.sh
curl http://localhost:3000
```

---

## Exercise 5: The Image Size Investigation

**Situation:**
Your colleague built a Go application and created a Dockerfile (`bloated-go-app.dockerfile`). The app works, but:
- Image size is 800MB+
- "It's just a simple REST API!"
- DevOps rejected it for production
- Fix this without changing app code

App code is in `go-app/` directory.

**Your Task:**
- Create `5-optimized.dockerfile` using **multi-stage build**
- Reduce image drastically (target: **< 20MB**)
- Maintain same functionality
- Run as non-root user
- Create `5-comparison.txt` showing before/after sizes

**What you'll learn:**
- Multi-stage builds
- Image optimization techniques
- Minimal base images (scratch, alpine, distroless)
- Build vs runtime dependencies

**Hint:** Explore scratch, alpine, or distroless base images

**Output:** `5-optimized.dockerfile` + `5-comparison.txt`

**Test your solution:**
```bash
docker build -t bloated-app -f go-app/bloated-go-app.dockerfile go-app/
docker build -t optimized-app -f 5-optimized.dockerfile go-app/
docker images | grep app
```

---

## Exercise 6: The Disappearing Database

**Situation:**
The QA team is frustrated. Every time they restart the test database:
- All test data vanishes
- They manually recreate tables
- No one documented the setup

You need a **reliable, reproducible** PostgreSQL setup.

**Your Task:**
Create `6-setup.sh` that:
- Sets up PostgreSQL with Docker Compose
- Data persists across container restarts
- Auto-initializes database with:
  - `users` table (id, username, email, created_at)
  - `products` table (id, name, price, stock)
- Database on localhost:5432

**What you'll learn:**
- Docker volumes for persistence
- PostgreSQL initialization scripts
- Docker Compose basics
- Database containerization

**The script can create any needed files** (compose.yml, .sql files, etc.)

**Output:** `6-setup.sh` only (script creates everything else)

**Test your solution:**
```bash
bash 6-setup.sh
# Connect and verify tables exist
docker exec -it <container-name> psql -U postgres -d testdb -c "\dt"
```

---

## Exercise 7: The Microservices Communication Problem

**Situation:**
You're joining a project migrating to microservices. There's an existing app in `microservices-app/`:
- **API service** (Node.js, port 4000) - has Dockerfile
- **Worker service** (Python) - processes Redis jobs
- Needs Redis and PostgreSQL

**Problem:** Services can't communicate! Previous dev ran everything with separate `docker run` commands using localhost.

**Your Task:**
Create `7-microservices.sh` setup script that:
- Creates docker-compose.yml for all services
- Services communicate using service names
- Only API accessible from host (port 4000)
- PostgreSQL data persists
- Redis doesn't need persistence
- Custom network

**What you'll learn:**
- Multi-service Docker Compose
- Service discovery and networking
- Inter-container communication
- Environment variables
- Dependencies between services

**Hint:** Use existing Dockerfiles from the template

**Output:** `7-microservices.sh` (creates compose + configs)

**Test your solution:**
```bash
bash 7-microservices.sh
curl http://localhost:4000/health
curl http://localhost:4000/queue
```

---

## Exercise 8: AI is Fun 🤖

**Situation:**
Your team wants a local ChatGPT-like interface for development to:
- Keep data private (no cloud AI)
- Use local models via Ollama
- Have a user-friendly web interface

You've heard about **LibreChat** (chatbot UI) and need to set it up with:
- **Ollama** for local models (`qwen2.5:3b` model)
- **Context7 MCP** integration (works without API key)
- Everything running on Docker

Server: Debian 12 with Docker and Docker Compose

**Your Task:**
Create complete setup in `8-ai/` directory:

1. `docker-compose.yml` with all required services
2. `setup.sh` script that:
   - Starts all services
   - Pulls qwen2.5:3b model
   - Configures LibreChat with Ollama
   - Sets up Context7 MCP
3. `README.md` with:
   - Architecture overview
   - How to access the interface
   - Verification steps
   - Troubleshooting tips

**What you'll learn:**
- Complex multi-container setups
- AI/ML containerization
- Configuration management
- Production-ready documentation

**Output:** Complete `8-ai/` directory with working AI chat interface

**Test your solution:**
```bash
cd 8-ai
bash setup.sh
# Access http://localhost:3000 in your browser
```

---

## Submission Checklist

Before submitting, ensure:

- [ ] Repository is **public**
- [ ] All required files at repository root with **exact names**
- [ ] Exercise 8 in `8-ai/` directory
- [ ] All scripts are executable (`chmod +x *.sh`)
- [ ] Scripts run without errors
- [ ] Each exercise tested and working

## File Structure

Your final repository should look like this:

```
.
├── README.md
├── 1-hello-whale.sh
├── 2-python.sh
├── 3-curl.dockerfile
├── 4-dev-app.dockerfile
├── 4-run.sh
├── 5-optimized.dockerfile
├── 5-comparison.txt
├── 6-setup.sh
├── 7-microservices.sh
├── broken-app/
│   ├── package.json
│   └── server.js
├── go-app/
│   ├── bloated-go-app.dockerfile
│   ├── go.mod
│   └── main.go
├── microservices-app/
│   ├── api/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── server.js
│   └── worker/
│       ├── Dockerfile
│       ├── requirements.txt
│       └── worker.py
└── 8-ai/
    └── (your solution files)
```

## Tips & Resources

### General Docker Tips
- Always read error messages carefully
- Use `docker logs <container>` to debug
- Use `docker ps -a` to see all containers
- Clean up with `docker system prune` when needed

### Useful Commands
```bash
docker images
docker ps -a
docker logs <container-name>
docker exec -it <container-name> /bin/sh
docker-compose logs -f
docker system df
```

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## Getting Help

If you're stuck:
1. Read the error messages
2. Check Docker logs
3. Review the documentation links
4. Search for similar issues online
5. Ask your instructor

## License

This is an educational project for M1 Cyber 2025.

Good luck! 🐋
