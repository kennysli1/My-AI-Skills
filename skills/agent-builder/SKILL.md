# Agent Builder Skill

Build complete, runnable AI agent applications from scratch through guided conversation.

## Trigger

Activate when user says: "build an agent", "create an agent", "agent builder", "build agent", "造个agent", "搭建agent", "构建agent", "做一个agent".

## Interaction Language

- This file and code comments: English
- All conversation with user: 中文 (Chinese)
- Code identifiers and config keys: English

## References

Load these on demand (not all at once):
- `references/agent-architecture.md` — Core layers, directory structure, robustness checklist
- `references/delivery-patterns.md` — CLI/GUI/Hybrid patterns, framework selection
- `references/interface-spec.md` — Tool/resource interface standards, registry pattern
- `references/examples.md` — Complete agent architecture examples

## Workflow: 4 Stages

### Stage 1: Discovery (需求收集)

Goal: Understand what agent to build. Ask 2-3 questions per round. Use progressive disclosure.

**Round 1 — Core Purpose**:
Ask:
1. 这个Agent要解决什么问题？（一句话描述它的核心任务）
2. 谁会用它？（开发者/非技术用户/API调用方）

**Round 2 — Technical Stack**:
Based on Round 1 answers, ask:
1. 交付形态？ CLI / Web GUI / API / 混合
2. 编程语言？ Python / TypeScript / 其他
3. LLM后端？ Claude / OpenAI / 其他（提供智能默认推荐）

**Round 3 — Capabilities**:
Ask:
1. 这个Agent需要哪些工具/能力？（列出建议清单，让用户勾选+补充）
2. 需要过程可视化吗？（进度条、步骤展示、中间结果）
3. 项目放在哪个目录？（默认：当前目录下创建子目录 `./agent名称/`）

**Round 3.5 — Framework** (only if relevant):
If the chosen language has popular agent frameworks, ask:
- 用框架还是从零搭建？（给出推荐理由）

**Output: Requirement Card** (需求确认卡):
Display a summary card in this format, then ask for confirmation:

```
╔══════════════════════════════════════════╗
║           🤖 Agent 需求确认卡            ║
╠══════════════════════════════════════════╣
║  名称：<agent-name>                      ║
║  用途：<one-line description>            ║
║  用户：<target user>                     ║
║  形态：<CLI / GUI / Hybrid>              ║
║  语言：<Python / TypeScript>             ║
║  LLM ：<Claude / OpenAI / ...>           ║
║  框架：<None / LangChain / ...>          ║
║  工具：                                  ║
║    - <tool 1>                            ║
║    - <tool 2>                            ║
║    - ...                                 ║
║  可视化：<是/否>                          ║
║  目录：<output path>                     ║
╚══════════════════════════════════════════╝
```

Ask: "确认以上需求？(Y/修改项)" — proceed only on confirmation.

---

### Stage 2: Architecture (架构设计)

Goal: Design the architecture and get approval before writing code.

**Step 1**: Read `references/agent-architecture.md` and `references/delivery-patterns.md`.

**Step 2**: Generate architecture plan with:

1. **Directory structure** (tree format)
2. **ASCII architecture diagram** showing data flow:
```
User ──> [Interface] ──> [Agent Loop] ──> [LLM Client] ──> LLM API
                              │
                         [Tool Registry]
                          ├── tool_a
                          ├── tool_b
                          └── tool_c
                              │
                         [Memory Store]
```
3. **Module responsibility list** — one line per file
4. **Key decisions** with rationale (e.g., "Using JSON memory because: simple, no external deps, sufficient for single-session")

**Step 3**: Present the architecture and ask: "架构方案确认？(Y/修改项)"

Proceed only on confirmation.

---

### Stage 3: Build (逐模块构建)

Goal: Implement the agent module by module. Only confirm on divergence from plan.

**Build order** (each step = working code before moving on):

1. **Config** (`config.yaml` + config loader)
   - All tunable params in YAML
   - Validation on load, fail fast on bad config
   - Environment variable overrides for secrets

2. **LLM Client** (API wrapper)
   - Read `references/interface-spec.md` for patterns
   - send_message(), send_with_tools()
   - Retry with exponential backoff
   - Timeout enforcement
   - Clear error messages

3. **Memory** (session storage)
   - JSON file backend
   - Load/save per turn
   - Atomic writes (temp file + rename)
   - Context truncation when window fills

4. **Tool Registry + Tools**
   - Read `references/interface-spec.md` for tool interface standard
   - Registry with register/execute/list
   - Each tool: definition + handler + error handling
   - Input validation per tool

5. **Agent Loop** (orchestration)
   - Read `references/agent-architecture.md` for loop pattern
   - Main loop: prompt → LLM → tool_use or text → repeat
   - Max iteration guard (default: 20)
   - Streaming support if CLI

6. **Interface** (CLI / GUI / API)
   - Read `references/delivery-patterns.md` for the chosen pattern
   - Wire up to agent loop
   - User-facing error messages
   - Clean shutdown (Ctrl+C)

7. **System Prompt** (`prompts/system.md`)
   - Role + capabilities + constraints + output format
   - Tool usage guidelines
   - Keep under 1000 tokens

8. **Memory integration**
   - Wire memory into agent loop
   - Save after each turn
   - Load on startup

**During build**:
- Show progress after each module: "✅ Config 完成 | ⬜ LLM Client | ⬜ Memory | ..."
- Run quick smoke test after each module where possible
- Only ask user to confirm if implementation diverges from architecture plan

---

### Stage 4: Polish (收尾交付)

Goal: Test, document, and deliver.

**Step 1: Automated Testing**
Run tests automatically. Fix failures (up to 3 rounds).
- Import/syntax check
- Config loading test
- Tool execution tests
- Agent loop smoke test (mock LLM if no API key)

**Step 2: Project Files**
Generate all supporting files:
- `README.md` — Setup, config, usage, examples
- `requirements.txt` or `package.json` — All dependencies with versions
- `run.sh` + `run.bat` — Start scripts for Unix and Windows
- `.env.example` — Template for API keys
- `.gitignore` — Standard ignores for the language

**Step 3: Delivery Summary**
Show final card:

```
╔══════════════════════════════════════════╗
║          ✅ Agent 交付确认               ║
╠══════════════════════════════════════════╣
║  项目目录：<path>                        ║
║  文件数量：<N> 个文件                    ║
║  测试结果：<pass/fail summary>           ║
║                                          ║
║  启动方式：                              ║
║    <run command>                         ║
║                                          ║
║  配置文件：config.yaml                   ║
║  API Key ：设置 .env 文件               ║
╚══════════════════════════════════════════╝
```

**Step 4: Iteration Offer**
Ask: "需要优化吗？可以：添加工具 / 修复bug / 优化prompt / 优化界面 / 其他"

If yes → loop back to the relevant build step.
If no → done.

---

## Design Principles (apply throughout)

### Engineering (Linus Torvalds Style)
- Every line of code must earn its place. No dead code, no "just in case" abstractions
- Errors are first-class citizens: clear message, context, suggested fix
- Unix philosophy: one module = one job, composable via clean interfaces
- Incremental: make it work first, then make it good

### Product (Chief Product Expert Style)
- User always knows what's happening (progress indicators, status updates)
- Smart defaults: the default should be what 80% of users want
- Progressive complexity: start simple, reveal advanced options only when needed
- Every confirmation point gives the user control without overwhelming them

### Code Quality
- Type hints (Python) or TypeScript strict mode
- Docstrings on all public functions
- No magic numbers — constants with names
- Consistent naming: snake_case (Python), camelCase (TypeScript)
- Error messages follow pattern: "Failed to X: Y. Try Z."
