# Local AI Chat (LibreChat + Ollama + Context7 MCP)

A private, Dockerized chat UI with local models (Ollama) and MCP tools (Context7).  
**Ports:** UI at `http://localhost:3000`, Ollama API at `http://localhost:11434`.

## Architecture

- **LibreChat** (Web UI + server) — single container, reads `librechat.yaml` for endpoints & MCP  
- **MongoDB** — chat history/presets storage for LibreChat  
- **Ollama** — runs local models; we pull `qwen2.5:3b` on first boot  
- **Context7 MCP** — added as an MCP server via HTTPS URL (no API key required)

```text
Browser ──(http://localhost:3000)──> LibreChat ─────┬──> MongoDB
                                                   ├──> Ollama (http://ollama:11434)
                                                   └──> MCP (Context7 via https://mcp.context7.com/mcp)

