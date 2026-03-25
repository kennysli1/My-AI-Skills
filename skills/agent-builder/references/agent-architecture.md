# Agent Architecture Reference

## Core Architecture Layers

Every agent application consists of these layers, from bottom to top:

```
┌─────────────────────────────────────┐
│           UI / Interface            │  CLI, GUI, API, or Hybrid
├─────────────────────────────────────┤
│         Orchestration Loop          │  Main agent loop + routing
├─────────────────────────────────────┤
│          Tool Registry              │  Available tools/actions
├─────────────────────────────────────┤
│        Memory / Context             │  Short-term JSON store
├─────────────────────────────────────┤
│         LLM Client                  │  API calls + retry/fallback
├─────────────────────────────────────┤
│       Config (YAML)                 │  All tunable parameters
└─────────────────────────────────────┘
```

## Layer Details

### 1. Config Layer (`config.yaml`)

All tunable parameters in one file. Never hardcode values that might change.

```yaml
agent:
  name: "my-agent"
  version: "0.1.0"
  description: "What this agent does"

llm:
  provider: "claude"          # claude | openai | ollama | ...
  model: "claude-sonnet-4-20250514"
  max_tokens: 4096
  temperature: 0.7
  timeout_seconds: 30
  max_retries: 3
  retry_delay_seconds: 1

memory:
  backend: "json"             # json | sqlite | redis
  file: "memory/session.json"
  max_context_messages: 50

tools:
  enabled:
    - "file_read"
    - "file_write"
    - "web_search"

logging:
  level: "INFO"               # DEBUG | INFO | WARNING | ERROR
  file: "logs/agent.log"
```

### 2. LLM Client Layer

Thin wrapper around the LLM API. Responsibilities:
- Send messages, receive responses
- Retry with exponential backoff on transient errors (429, 500, 503)
- Timeout enforcement
- Graceful degradation (fallback model or cached response)
- Token counting / budget tracking
- Streaming support (optional)

Key design rules:
- **One function per concern**: `send_message()`, `send_with_tools()`, `stream_message()`
- **Never swallow errors**: Log and re-raise with context
- **Idempotent retries**: Same input → same output (no side effects in retry path)

### 3. Memory Layer

Short-term memory using JSON files (default). Stores:

```json
{
  "session_id": "uuid",
  "created_at": "ISO-8601",
  "messages": [
    {"role": "user", "content": "..."},
    {"role": "assistant", "content": "..."}
  ],
  "metadata": {
    "total_tokens_used": 0,
    "tool_calls": []
  }
}
```

Design rules:
- Load on start, save after each turn
- Atomic writes (write to temp file, then rename)
- Truncate old messages when context window fills (keep system prompt + last N)

### 4. Tool Registry

Tools are the agent's actions. Each tool is a function with:
- **Name**: snake_case identifier
- **Description**: What it does (for LLM to understand)
- **Input schema**: JSON Schema for parameters
- **Handler function**: The actual implementation

```
Tool Registration Flow:
  1. Define tool with name + description + schema + handler
  2. Register in tool registry at startup
  3. Pass tool definitions to LLM with each request
  4. LLM returns tool_use → registry routes to handler
  5. Handler executes → result returned to LLM
```

Design rules:
- Each tool does ONE thing well
- Tools are stateless (no side effects between calls)
- Input validation before execution
- Clear error messages on failure
- Timeout per tool call

### 5. Orchestration Loop

The main agent loop:

```
while not done:
  1. Build messages array (system prompt + memory + user input)
  2. Send to LLM with available tools
  3. If response is text → show to user, save to memory
  4. If response is tool_use → execute tool → add result → goto 2
  5. If error → handle gracefully (retry / inform user)
  6. If user says "quit" → save memory, exit
```

Key patterns:
- **Max iterations guard**: Prevent infinite tool loops (default: 20)
- **Tool result injection**: Tool output goes back as a new message
- **Streaming**: Show partial responses as they arrive (better UX)

### 6. UI / Interface Layer

Three patterns (see `delivery-patterns.md` for details):
- **CLI**: stdin/stdout, rich formatting optional
- **GUI**: Web-based (Streamlit/Gradio/React) or desktop (Electron/Tauri)
- **API**: HTTP/WebSocket server for programmatic access

## Directory Structure Template

```
my-agent/
├── config.yaml              # All configuration
├── requirements.txt         # Python deps (or package.json)
├── README.md                # Setup + usage guide
├── run.sh                   # Start script (Unix)
├── run.bat                  # Start script (Windows)
├── src/
│   ├── __init__.py
│   ├── main.py              # Entry point
│   ├── agent.py             # Orchestration loop
│   ├── llm_client.py        # LLM API wrapper
│   ├── memory.py            # Memory management
│   ├── config.py            # Config loader
│   └── tools/
│       ├── __init__.py
│       ├── registry.py      # Tool registration
│       ├── file_tools.py    # File operations
│       └── web_tools.py     # Web operations
├── prompts/
│   └── system.md            # System prompt
├── memory/
│   └── .gitkeep
├── logs/
│   └── .gitkeep
└── tests/
    ├── test_agent.py
    ├── test_llm_client.py
    └── test_tools.py
```

## Robustness Checklist

- [ ] All API calls have timeouts
- [ ] Retry logic with exponential backoff (max 3 retries)
- [ ] Graceful degradation when LLM is unavailable
- [ ] Input validation on all tool parameters
- [ ] Max iteration guard on agent loop
- [ ] Atomic file writes for memory persistence
- [ ] Clear error messages (what failed + why + what to do)
- [ ] Ctrl+C handling for clean shutdown
- [ ] Log all errors with stack traces
- [ ] Config validation on startup (fail fast if misconfigured)

## System Prompt Design

The system prompt defines the agent's personality and capabilities:

```
Structure:
1. Role definition (1-2 sentences: who you are)
2. Capabilities (bullet list: what you can do)
3. Constraints (bullet list: what you must NOT do)
4. Output format (how to structure responses)
5. Tool usage guidelines (when/how to use each tool)
```

Rules:
- Be specific, not vague ("You are a code review agent" not "You are helpful")
- List concrete capabilities, not abstract ones
- State constraints explicitly (reduces hallucination)
- Include examples of good tool usage
- Keep under 1000 tokens (leave room for context)
