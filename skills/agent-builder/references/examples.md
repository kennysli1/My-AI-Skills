# Agent Architecture Examples

## Example 1: Code Review Agent (CLI, Python, Claude)

**Purpose**: Reviews code changes and provides actionable feedback.

```
code-review-agent/
├── config.yaml
├── requirements.txt
├── README.md
├── run.sh
├── src/
│   ├── main.py
│   ├── agent.py
│   ├── llm_client.py
│   ├── memory.py
│   ├── config.py
│   └── tools/
│       ├── registry.py
│       ├── git_tools.py      # git diff, git log, git blame
│       └── file_tools.py     # read_file, list_directory
├── prompts/
│   └── system.md
├── memory/
└── tests/
```

**System Prompt Sketch**:
```
You are a senior code reviewer. You review diffs for:
- Bugs and logic errors
- Security vulnerabilities
- Performance issues
- Code style violations

Tools available: git_diff, git_log, read_file, list_directory
Always read surrounding code before making judgments.
Output format: list issues by severity (critical > warning > suggestion).
```

**Key Tools**:
- `git_diff(branch?)` — Get current changes
- `git_log(n?)` — Recent commit history
- `read_file(path)` — Read source file for context
- `list_directory(path)` — Explore project structure

---

## Example 2: Research Assistant (Web GUI, Python, OpenAI)

**Purpose**: Searches the web, summarizes findings, maintains research context.

```
research-assistant/
├── config.yaml
├── requirements.txt
├── README.md
├── app.py                    # Streamlit entry
├── src/
│   ├── agent.py
│   ├── llm_client.py
│   ├── memory.py
│   ├── config.py
│   └── tools/
│       ├── registry.py
│       ├── web_tools.py      # web_search, fetch_url
│       └── note_tools.py     # save_note, list_notes
├── prompts/
│   └── system.md
├── memory/
└── tests/
```

**Key Design Decisions**:
- Streamlit for rapid GUI (chat interface + sidebar for saved notes)
- OpenAI GPT-4 as backend
- Web search via SerpAPI or Tavily
- Notes saved as markdown files in `notes/` directory

---

## Example 3: Data Analysis Agent (CLI, TypeScript, Claude)

**Purpose**: Analyzes CSV/JSON data files, generates insights and charts.

```
data-analyst/
├── config.yaml
├── package.json
├── tsconfig.json
├── README.md
├── src/
│   ├── main.ts
│   ├── agent.ts
│   ├── llm-client.ts
│   ├── memory.ts
│   ├── config.ts
│   └── tools/
│       ├── registry.ts
│       ├── data-tools.ts     # load_csv, query_data, describe_data
│       ├── chart-tools.ts    # create_chart (writes PNG via vega-lite)
│       └── file-tools.ts     # read_file, write_file
├── prompts/
│   └── system.md
├── memory/
└── tests/
```

---

## Example 4: Customer Support Agent (Hybrid CLI+API, Python, Claude)

**Purpose**: Answers customer questions using a knowledge base.

```
support-agent/
├── config.yaml
├── requirements.txt
├── README.md
├── src/
│   ├── main.py               # CLI entry
│   ├── server.py             # FastAPI entry (API mode)
│   ├── agent.py              # Shared agent core
│   ├── llm_client.py
│   ├── memory.py
│   ├── config.py
│   └── tools/
│       ├── registry.py
│       ├── kb_tools.py       # search_knowledge_base, get_article
│       ├── ticket_tools.py   # create_ticket, update_ticket
│       └── escalate_tools.py # escalate_to_human
├── knowledge_base/
│   ├── index.json            # Search index
│   └── articles/             # Markdown articles
├── prompts/
│   └── system.md
├── memory/
└── tests/
```

**Hybrid Pattern**: Same `Agent` class used by both CLI (`main.py`) and API (`server.py`).

---

## Example 5: Multi-Agent Pipeline (Python, orchestrator pattern)

**Purpose**: Complex task broken into specialized sub-agents.

```
multi-agent-pipeline/
├── config.yaml
├── requirements.txt
├── README.md
├── src/
│   ├── main.py
│   ├── orchestrator.py       # Routes tasks to sub-agents
│   ├── agents/
│   │   ├── researcher.py     # Finds information
│   │   ├── writer.py         # Drafts content
│   │   └── reviewer.py       # Reviews and refines
│   ├── llm_client.py         # Shared LLM client
│   ├── memory.py
│   ├── config.py
│   └── tools/
│       ├── registry.py
│       └── ...
├── prompts/
│   ├── orchestrator.md
│   ├── researcher.md
│   ├── writer.md
│   └── reviewer.md
├── memory/
└── tests/
```

**Orchestration Flow**:
```
User Request
    │
    ▼
Orchestrator ──> Researcher (search + summarize)
    │                  │
    │ <── findings ────┘
    │
    ├──> Writer (draft based on findings)
    │        │
    │ <── draft
    │
    ├──> Reviewer (critique draft)
    │        │
    │ <── feedback
    │
    ├──> Writer (revise with feedback)
    │        │
    │ <── final
    │
    ▼
  User
```

## Anti-Patterns to Avoid

1. **God Agent**: One agent that does everything → Split into focused tools
2. **Over-abstraction**: 5 layers of abstraction for a simple API call → Keep it flat
3. **Hidden state**: State scattered across global variables → Centralize in memory layer
4. **Chatty tools**: Tools that return paragraphs of text → Return structured data
5. **No error paths**: Only handling the happy path → Every tool needs try/catch
6. **Hardcoded config**: API keys and model names in source → Use config.yaml + env vars
7. **Infinite loops**: No max iteration guard on agent loop → Always cap iterations
