---
name: agent-builder
description: Build complete, runnable AI agent applications from scratch through spec-driven guided conversation. Use this skill whenever the user wants to build an agent, create an AI assistant, develop a chatbot, make an LLM-powered tool, or scaffold any autonomous AI application — whether CLI, web GUI, API, or hybrid. Also trigger when the user mentions "agent builder", "build agent", "create agent", "造个agent", "搭建agent", "构建agent", "做一个agent", "开发智能体", "做个AI助手", "LLM application", or describes wanting to build something that uses an LLM to call tools, manage conversations, or orchestrate multi-step workflows. Even if the user doesn't say "agent" explicitly, use this skill if the described project clearly involves an LLM loop with tool calling.
---

# Agent Builder Skill

Build complete, runnable AI agent applications from scratch through guided conversation.
Uses **speckit** (0→1) for initial specification-driven development and **openspec** (1→N) for iterative feature expansion.

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

---

## Spec-Driven Development Philosophy

> **核心理念：先写规范，再写代码。规范即合同，代码是履约。**

本 skill 采用业界成熟的规范驱动工具链：

- **speckit** (`specify` CLI + `/speckit.*` slash commands)：0→1 新建项目，严格的阶段门控流程
  - constitution → specify → plan → tasks → implement
  - 确保需求、规范、技术方案、任务拆解每一步都经过确认
- **openspec** (`openspec` CLI + `/opsx:*` slash commands)：1→N 功能扩展，轻量增量循环
  - propose → apply → archive
  - 不干扰已有规范，通过 delta spec 增量修改

### 工具链分工

| 阶段 | 工具 | 命令 | 产出 |
|------|------|------|------|
| 项目初建 | **speckit** | `specify init` → `/speckit.constitution` → `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement` | `.specify/` 目录：constitution, spec.md, plan.md, tasks.md, 以及生成的代码 |
| 功能扩展 | **openspec** | `openspec init` → `/opsx:propose` → `/opsx:apply` → `/opsx:archive` | `openspec/` 目录：specs/, changes/, archive/ |

### 前置条件

本 skill 依赖以下 CLI 工具（须已安装）：
- `specify` — speckit CLI（`uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`）
- `openspec` — openspec CLI（`npm install -g @fission-ai/openspec@latest`）

---

## Workflow: 5 Stages

```
Preflight → Discovery → Speckit Setup → Specification & Planning → Build → Polish
 (环境检查)   (需求)     (初始化项目)     (规范+方案+任务)        (开发)   (交付)
```

**阶段门控规则**：每个阶段结束必须用户确认后才能进入下一阶段。不可跳过。

---

### Stage 0: Preflight (环境前置检查)

Goal: Verify all required CLI tools are installed and functional before starting any work.

**在与用户交互之前，静默执行以下检查**（不需要用户操作）：

```bash
# 1. Check speckit (specify CLI)
specify --version

# 2. Check openspec
openspec --version
```

**结果处理**：

- ✅ 两个工具都可用 → 显示简短确认，进入 Stage 1：
  ```
  ✅ 环境检查通过：specify vX.X.X / openspec vX.X.X — 开始需求收集
  ```

- ❌ `specify` 不可用 → **阻断，不继续**。告知用户：
  ```
  ❌ 未检测到 specify CLI，本 skill 依赖 speckit 进行规范驱动开发。

  安装命令：
    uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

  安装后重新启动即可。
  ```

- ❌ `openspec` 不可用 → **警告但不阻断**（仅 Stage 5 扩展用）。告知用户：
  ```
  ⚠️ 未检测到 openspec CLI，项目交付后的扩展功能（1→N）将不可用。

  安装命令：
    npm install -g @fission-ai/openspec@latest

  可以先继续，后续需要时再安装。
  ```

---

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

### Stage 2: Speckit Setup (项目初始化)

Goal: Initialize the project with speckit and establish the project constitution.

**Step 1: Initialize speckit project**

In the project directory, run:
```bash
specify init <agent-name>
```

This creates the `.specify/` directory with templates, scripts, and memory.

**Step 2: Create project constitution**

Guide the user through `/speckit.constitution`:
- Feed the constitution command with the project principles derived from Stage 1 (tech stack, naming conventions, coding standards, testing requirements)
- Include Agent-specific principles:
  - Error handling pattern: "Failed to X: Y. Try Z."
  - Tool design: one tool = one job, stateless, input validation
  - Config-driven: all tunable params in YAML, no hardcoded values
  - LLM interaction: retry with backoff, timeout enforcement, clear error messages

**Step 3: Verify setup**

Run `specify check` to verify all required tools are installed.

Present summary:
```
╔══════════════════════════════════════════╗
║        📁 Speckit 项目已初始化           ║
╠══════════════════════════════════════════╣
║  项目目录：<path>                        ║
║  .specify/ 结构已创建                    ║
║  Constitution 已建立                     ║
║                                          ║
║  下一步：进入规范编写                     ║
╚══════════════════════════════════════════╝
```

---

### Stage 3: Specification & Planning (规范 + 方案 + 任务)

Goal: Use speckit's full pipeline to produce spec → plan → tasks, with Agent domain knowledge injected at each step.

> **Why speckit handles this better than hand-writing:**
> - Strict phase gates prevent skipping steps
> - Built-in quality checklist auto-validates each spec
> - Clarification loop ensures no ambiguity before planning
> - Tasks are dependency-ordered and ready for implementation

#### Step 3a: Feature Specification (`/speckit.specify`)

Feed the speckit specify command with the feature description from the Requirement Card (Stage 1).

Before speckit generates the spec, read `references/agent-architecture.md` to provide Agent-specific context. Ensure the generated spec covers:
- Agent's core loop (prompt → LLM → tool_use or text → repeat)
- Tool definitions (name, description, input schema, handler)
- Memory strategy (JSON file, load/save per turn, atomic writes)
- Interface pattern (CLI/GUI/API from Stage 1)
- System prompt design (role + capabilities + constraints + output format)

After speckit generates `spec.md`, review with user. Use `/speckit.clarify` if any [NEEDS CLARIFICATION] markers remain.

Ask: "功能规范确认？(Y/修改项)"

#### Step 3b: Technical Plan (`/speckit.plan`)

Run `/speckit.plan`. Before it executes, read:
- `references/agent-architecture.md` — for layer design and directory structure
- `references/delivery-patterns.md` — for the chosen delivery pattern (CLI/GUI/Hybrid)
- `references/interface-spec.md` — for tool interface standards

Ensure the plan covers:
- Architecture layers (Config → LLM Client → Memory → Tool Registry → Agent Loop → Interface)
- Directory structure per `references/agent-architecture.md`
- Data model for memory/session storage
- API contracts for tool interfaces per `references/interface-spec.md`

After speckit generates `plan.md`, `research.md`, `data-model.md`, present the architecture to user:

1. **Architecture diagram** (ASCII) showing data flow
2. **Module dependency graph**
3. **Key technical decisions** with rationale

Ask: "技术方案确认？(Y/修改项)"

#### Step 3c: Task Breakdown (`/speckit.tasks`)

Run `/speckit.tasks` to generate the implementation task list.

Ensure tasks follow the Agent build order (bottom-up by dependency):
1. Setup — project init, config, dependencies
2. LLM Client — API wrapper with retry/timeout
3. Memory — JSON session storage
4. Tool Registry + Tools — registration, routing, individual tools
5. Agent Loop — main orchestration
6. Interface — CLI/GUI/API
7. System Prompt — prompt engineering
8. Integration — wire everything together
9. Polish — tests, docs, scripts

After speckit generates `tasks.md`, present the task overview to user.

Ask: "任务拆解确认？(Y/修改项)"

---

### Stage 3.5: Handoff Decision (交付路径选择)

After spec, plan, and tasks are all confirmed, ask user:

```
开发方式选择：
1. 🤖 speckit 自动实现 — /speckit.implement 按 tasks.md 自动编码
2. 🔨 本 skill 引导构建 — 我来逐模块引导开发，每步确认
3. 📋 仅交付规范 — 到此为止，只要 spec + plan + tasks

选哪个？(1/2/3)
```

- **Option 1**: Run `/speckit.implement`. It will read tasks.md, execute phase by phase, write tests, implement code, mark tasks `[X]`. Agent-builder monitors and provides Agent domain guidance when needed.
- **Option 2**: Continue to Stage 4 (manual guided build).
- **Option 3**: Done. The `.specify/` directory is the deliverable.

---

### Stage 4: Build (逐模块构建)

Goal: Implement the agent module by module, **strictly following the speckit-generated plan and tasks**.

> **Core rule**: Every coding decision must trace back to spec.md or plan.md. If something isn't in the spec, don't implement it — update the spec first.

**Build order**: Follow the task sequence from `tasks.md`.

For each task:

1. **Read relevant speckit artifacts** before coding:
   - `spec.md` — what to build (functional requirements)
   - `plan.md` — how to build (architecture, tech decisions)
   - `data-model.md` — entities and relationships (if applicable)
   - `references/` — Agent-specific patterns from this skill

2. **Implement** following the plan's architecture and interface contracts

3. **Write tests** alongside code per the plan's testing strategy

4. **Smoke test** after each module

5. **Mark task complete** in `tasks.md`: `- [ ]` → `- [x]`

**During build**:
- Show progress after each module: "✅ T001 Config 完成 | ⬜ T002 LLM Client | ⬜ T003 Memory | ..."
- Read `references/agent-architecture.md` for robustness checklist after completing core modules
- Only ask user to confirm if implementation needs to diverge from plan
- If divergence is needed: update spec/plan first, then implement

---

### Stage 5: Polish (收尾交付)

Goal: Test, document, deliver, and set up for future expansion.

**Step 1: Automated Testing**
Run tests automatically. Fix failures (up to 3 rounds).
- Import/syntax check
- Unit tests per module
- Integration tests
- E2E smoke test (mock LLM if no API key)

**Step 2: Project Files**
Generate all supporting files:
- `README.md` — Setup, config, usage, examples
- `requirements.txt` or `package.json` — All dependencies with versions
- `run.sh` + `run.bat` — Start scripts for Unix and Windows
- `.env.example` — Template for API keys
- `.gitignore` — Standard ignores for the language

**Step 3: Initialize openspec for future expansion**

> Skip this step if openspec was marked unavailable in Stage 0 Preflight. Inform user that expansion workflow can be set up later after installing openspec.

Run in the project directory:
```bash
openspec init --tools claude
```

This creates the `openspec/` directory and registers `/opsx:*` slash commands.

Then **bridge the baseline**: create an initial spec in `openspec/specs/` that summarizes the current project state from speckit's artifacts:

1. Read `.specify/<feature>/spec.md` — extract core requirements
2. Read `.specify/<feature>/plan.md` — extract architecture decisions
3. Write a baseline spec to `openspec/specs/core/spec.md` with:
   - Current capabilities (tools, features)
   - Architecture overview (modules, interfaces)
   - Technical constraints (from constitution)

This ensures future `/opsx:propose` commands have full context of what already exists.

**Step 4: Delivery Summary**
Show final card:

```
╔══════════════════════════════════════════════════╗
║            ✅ Agent 交付确认                      ║
╠══════════════════════════════════════════════════╣
║  项目目录：<path>                                ║
║  文件数量：<N> 个文件                            ║
║  测试结果：<pass/fail summary>                   ║
║                                                  ║
║  规范体系：                                       ║
║    .specify/  — speckit 初始规范 ✅              ║
║    openspec/  — openspec 扩展基线 ✅             ║
║                                                  ║
║  启动方式：                                       ║
║    <run command>                                 ║
║                                                  ║
║  后续扩展：                                       ║
║    /opsx:propose "新功能描述"                     ║
║    /opsx:apply                                   ║
║    /opsx:archive                                 ║
╚══════════════════════════════════════════════════╝
```

**Step 5: Iteration Offer**
Ask: "需要优化吗？可以：添加工具 / 修复bug / 优化prompt / 优化界面 / 其他"

- If yes → use `/opsx:propose` to create a change proposal, then `/opsx:apply` to implement
- If no → done

---

## Extension Workflow: OpenSpec (1→N)

After initial delivery, all feature additions and modifications go through openspec:

### When to use

- Adding new tools/capabilities to existing agent
- Changing existing behavior
- Refactoring modules
- Any post-v1 changes

### Workflow

```bash
# 1. Propose a change
/opsx:propose "add-web-search-tool"
# → Creates openspec/changes/add-web-search-tool/ with proposal.md, design.md, tasks.md

# 2. Implement the change
/opsx:apply
# → Reads tasks.md, implements each task, marks complete

# 3. Archive when done
/opsx:archive
# → Moves to openspec/changes/archive/YYYY-MM-DD-add-web-search-tool/
# → Syncs delta specs to openspec/specs/
```

### Agent-specific guidance for openspec changes

When `/opsx:propose` runs, ensure the proposal considers:
- Impact on the Agent Loop (does the new tool need special handling?)
- Impact on memory (does context window management need updating?)
- Impact on system prompt (does the LLM need to know about new capabilities?)
- New tool must follow the interface standard in `references/interface-spec.md`
- New tests must follow existing testing patterns

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

### Spec Discipline
- **Spec is law**: No code without spec backing. If it's not in the speckit artifacts, it doesn't get built
- **Spec before code**: Always update spec/plan first, then implement
- **Traceability**: Every module, every test, every config should trace to spec.md or plan.md
- **Living specs**: Use openspec to evolve specifications incrementally after v1

### Code Quality
- Type hints (Python) or TypeScript strict mode
- Docstrings on all public functions
- No magic numbers — constants with names
- Consistent naming: snake_case (Python), camelCase (TypeScript)
- Error messages follow pattern: "Failed to X: Y. Try Z."
