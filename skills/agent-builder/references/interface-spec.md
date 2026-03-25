# Agent Interface Specification

## Design Philosophy

Every agent exposes **MCP-style tool/resource interfaces** — standardized, discoverable, composable. This enables agents to call each other and integrate with any MCP-compatible host.

## Tool Interface Standard

Each tool an agent exposes follows this schema:

```json
{
  "name": "tool_name",
  "description": "Clear, one-line description of what this tool does",
  "inputSchema": {
    "type": "object",
    "properties": {
      "param1": {
        "type": "string",
        "description": "What this parameter is for"
      }
    },
    "required": ["param1"]
  }
}
```

### Rules for Tool Design

1. **Naming**: `snake_case`, verb_noun format (`read_file`, `search_web`, `run_query`)
2. **Description**: One sentence. Must tell the LLM WHEN to use this tool
3. **Parameters**: Minimal — only what's necessary. Use smart defaults
4. **Return format**: Always return structured data:

```json
{
  "success": true,
  "data": { ... },
  "error": null
}
```

Or on failure:

```json
{
  "success": false,
  "data": null,
  "error": "Clear description of what went wrong"
}
```

5. **Idempotency**: Read operations must be idempotent. Write operations should be safely retriable
6. **No side effects in descriptions**: The description must not cause the LLM to avoid using the tool

## Tool Implementation Template

### Python

```python
from typing import Any

def tool_definition() -> dict:
    """Return the tool's schema for LLM registration."""
    return {
        "name": "example_tool",
        "description": "Does X when the user needs Y",
        "inputSchema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "The search query"
                },
                "limit": {
                    "type": "integer",
                    "description": "Max results to return",
                    "default": 10
                }
            },
            "required": ["query"]
        }
    }

def handle(params: dict) -> dict[str, Any]:
    """Execute the tool. Returns {success, data, error}."""
    try:
        query = params["query"]
        limit = params.get("limit", 10)
        # ... do work ...
        results = do_search(query, limit)
        return {"success": True, "data": results, "error": None}
    except Exception as e:
        return {"success": False, "data": None, "error": str(e)}
```

### TypeScript

```typescript
interface ToolResult {
  success: boolean;
  data: any;
  error: string | null;
}

export const definition = {
  name: "example_tool",
  description: "Does X when the user needs Y",
  inputSchema: {
    type: "object" as const,
    properties: {
      query: { type: "string", description: "The search query" },
      limit: { type: "integer", description: "Max results", default: 10 }
    },
    required: ["query"]
  }
};

export async function handle(params: Record<string, any>): Promise<ToolResult> {
  try {
    const { query, limit = 10 } = params;
    const results = await doSearch(query, limit);
    return { success: true, data: results, error: null };
  } catch (e) {
    return { success: false, data: null, error: String(e) };
  }
}
```

## Tool Registry Pattern

```python
class ToolRegistry:
    def __init__(self):
        self._tools: dict[str, dict] = {}

    def register(self, definition: dict, handler: callable):
        self._tools[definition["name"]] = {
            "definition": definition,
            "handler": handler
        }

    def get_definitions(self) -> list[dict]:
        """Return all tool schemas for LLM."""
        return [t["definition"] for t in self._tools.values()]

    def execute(self, name: str, params: dict) -> dict:
        """Route a tool call to its handler."""
        if name not in self._tools:
            return {"success": False, "data": None,
                    "error": f"Unknown tool: {name}"}
        try:
            return self._tools[name]["handler"](params)
        except Exception as e:
            return {"success": False, "data": None, "error": str(e)}
```

## Resource Interface (for data exposure)

When an agent needs to expose data (not actions), use resources:

```json
{
  "uri": "agent://my-agent/status",
  "name": "Agent Status",
  "description": "Current agent state and metrics",
  "mimeType": "application/json"
}
```

Resources are read-only. Use tools for mutations.

## Inter-Agent Communication

When agents need to call each other:

```
Agent A                         Agent B
  │                                │
  ├── tool_call: "ask_agent_b" ──> │
  │     params: {question: "..."}  │
  │                                ├── process
  │ <── tool_result ───────────────┤
  │     {success: true, data: ...} │
```

Implementation: Agent B runs as a subprocess or HTTP service. Agent A has a tool that calls Agent B's interface.

## Common Tool Categories

### File Operations
- `read_file(path)` — Read file contents
- `write_file(path, content)` — Write/create file
- `list_directory(path)` — List directory contents

### Web Operations
- `web_search(query, limit)` — Search the web
- `fetch_url(url)` — Fetch and parse a URL

### Data Operations
- `run_query(sql, database)` — Execute a database query
- `parse_json(text)` — Parse and validate JSON
- `transform_data(data, format)` — Convert between formats

### System Operations
- `run_command(cmd)` — Execute a shell command
- `get_env(key)` — Read environment variable

### Communication
- `send_message(to, content)` — Send to another agent/service
- `notify_user(message)` — Push notification to user
