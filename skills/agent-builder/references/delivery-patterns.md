# Delivery Patterns Reference

## Pattern 1: CLI Agent

Best for: Developer tools, automation, pipelines, power users.

### Architecture

```
User ──stdin──> CLI Parser ──> Agent Loop ──> stdout ──> User
                                  │
                              LLM + Tools
```

### Python Implementation Skeleton

```python
# Entry point: main.py
import argparse
import sys
from agent import Agent
from config import load_config

def main():
    parser = argparse.ArgumentParser(description="Agent description")
    parser.add_argument("--config", default="config.yaml")
    parser.add_argument("--verbose", action="store_true")
    parser.add_argument("prompt", nargs="?", help="One-shot prompt")
    args = parser.parse_args()

    config = load_config(args.config)
    agent = Agent(config)

    if args.prompt:
        # One-shot mode
        response = agent.run(args.prompt)
        print(response)
    else:
        # Interactive REPL mode
        agent.repl()

if __name__ == "__main__":
    main()
```

### TypeScript Implementation Skeleton

```typescript
// Entry point: src/main.ts
import { Agent } from './agent';
import { loadConfig } from './config';
import * as readline from 'readline';

async function main() {
  const config = loadConfig();
  const agent = new Agent(config);

  const args = process.argv.slice(2);
  if (args.length > 0) {
    const response = await agent.run(args.join(' '));
    console.log(response);
  } else {
    await agent.repl();
  }
}

main().catch(console.error);
```

### UX Patterns for CLI

- **Spinner**: Show during LLM calls (`ora` in JS, `rich` in Python)
- **Streaming**: Print tokens as they arrive (no waiting for full response)
- **Colors**: Use sparingly — green for success, red for errors, dim for metadata
- **Progress bar**: For multi-step operations
- **Markdown rendering**: Render markdown in terminal (`rich.markdown` or `marked-terminal`)

---

## Pattern 2: Web GUI Agent

Best for: Non-technical users, visual workflows, dashboards.

### Architecture

```
Browser ──HTTP/WS──> Web Server ──> Agent Loop ──> Response ──> Browser
                                       │
                                   LLM + Tools
```

### Option A: Streamlit (Python, fastest to build)

```python
# app.py
import streamlit as st
from agent import Agent
from config import load_config

st.set_page_config(page_title="My Agent", layout="wide")

if "agent" not in st.session_state:
    config = load_config("config.yaml")
    st.session_state.agent = Agent(config)
    st.session_state.messages = []

for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

if prompt := st.chat_input("Ask me anything..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)
    with st.chat_message("assistant"):
        with st.spinner("Thinking..."):
            response = st.session_state.agent.run(prompt)
        st.markdown(response)
    st.session_state.messages.append({"role": "assistant", "content": response})
```

### Option B: Gradio (Python, good for demos)

```python
# app.py
import gradio as gr
from agent import Agent
from config import load_config

config = load_config("config.yaml")
agent = Agent(config)

def chat(message, history):
    response = agent.run(message)
    return response

demo = gr.ChatInterface(fn=chat, title="My Agent")
demo.launch()
```

### Option C: React + FastAPI (TypeScript/Python, production-grade)

```
Frontend (React):
  src/
  ├── App.tsx          # Main layout
  ├── ChatWindow.tsx   # Message display
  ├── InputBar.tsx     # User input
  └── api.ts           # WebSocket/fetch calls

Backend (FastAPI):
  src/
  ├── server.py        # FastAPI app + WebSocket endpoint
  ├── agent.py         # Agent loop
  └── ...
```

### Option D: Next.js Full-Stack (TypeScript, all-in-one)

```
src/
├── app/
│   ├── page.tsx           # Chat UI
│   ├── api/chat/route.ts  # API route → agent
│   └── layout.tsx
├── lib/
│   ├── agent.ts
│   ├── llm-client.ts
│   └── tools/
└── ...
```

---

## Pattern 3: Hybrid (CLI + API)

Best for: Tools that serve both developers and applications.

```
CLI User ──stdin──┐
                  ├──> Agent Core ──> LLM + Tools
API Client ──HTTP─┘
```

Implementation: Build the agent core as a library, then wrap with both CLI and HTTP interfaces.

---

## Pattern Selection Guide

| Factor              | CLI             | Web GUI          | Hybrid          |
|---------------------|-----------------|------------------|-----------------|
| Time to build       | ⚡ Fastest      | 🔨 Medium        | 🔨 Medium       |
| User skill level    | Technical       | Anyone           | Both            |
| Deployment          | Local/pip       | Docker/cloud     | Both            |
| Real-time feedback  | Streaming text  | Rich UI          | Both            |
| Collaboration       | ❌              | ✅               | Partial         |
| Best frameworks     | argparse/click  | Streamlit/Gradio | FastAPI+click   |

## Framework Selection Guide

### Python Frameworks

| Framework    | Best for                    | Complexity | Notes                       |
|-------------|-----------------------------|-----------|-----------------------------|
| No framework | Simple agents, learning     | Low       | Full control, no magic      |
| LangChain    | Complex chains, many tools  | High      | Large ecosystem, verbose    |
| LangGraph    | Stateful multi-agent flows  | High      | Graph-based orchestration   |
| CrewAI       | Multi-agent collaboration   | Medium    | Role-based agents           |
| Pydantic AI  | Type-safe, structured output| Medium    | Clean, modern               |

### TypeScript Frameworks

| Framework     | Best for                   | Complexity | Notes                      |
|--------------|----------------------------|-----------|-----------------------------|
| No framework  | Simple agents, learning    | Low       | Full control                |
| LangChain.js  | Port of Python LangChain   | High      | Same patterns, JS ecosystem |
| Vercel AI SDK | Next.js integration        | Medium    | Streaming-first, React hooks|
| Mastra        | TypeScript-native agents   | Medium    | Modern, opinionated         |

### Recommendation Logic

```
IF user is learning OR agent is simple:
  → No framework (raw API calls)
IF user wants fastest prototype:
  → Streamlit (GUI) or argparse (CLI)
IF user needs production multi-agent:
  → LangGraph or CrewAI
IF user uses Next.js:
  → Vercel AI SDK
DEFAULT:
  → No framework + clean architecture
```
