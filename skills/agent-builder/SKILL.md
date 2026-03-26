---
name: agent-builder
description: Build complete, runnable AI agent applications from scratch through spec-driven guided conversation. Use this skill whenever the user wants to build an agent, create an AI assistant, develop a chatbot, make an LLM-powered tool, or scaffold any autonomous AI application — whether CLI, web GUI, API, or hybrid. Also trigger when the user mentions "agent builder", "build agent", "create agent", "造个agent", "搭建agent", "构建agent", "做一个agent", "开发智能体", "做个AI助手", "LLM application", or describes wanting to build something that uses an LLM to call tools, manage conversations, or orchestrate multi-step workflows. Even if the user doesn't say "agent" explicitly, use this skill if the described project clearly involves an LLM loop with tool calling.
---

# Agent Builder Skill

Build complete, runnable AI agent applications from scratch through guided conversation.
Uses **DEV_SPEC.md** for specification-driven development and **auto-coder** for automated implementation.

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

本 skill 采用 **DEV_SPEC.md + auto-coder** 的开发模式：

1. **DEV_SPEC.md**：项目规范文档，包含项目的所有设计决策和技术细节
2. **auto-coder**：自动化开发代理，读取 DEV_SPEC.md 并按任务排期逐个实现

### 工作流分工

| 阶段 | 工具 | 产出 |
|------|------|------|
| 需求收集与规范编写 | **agent-builder** (本 skill) | `DEV_SPEC.md` — 完整项目规范 |
| 自动化开发 | **auto-coder** skill | 代码、测试、提交 |

### DEV_SPEC.md 标准章节

DEV_SPEC.md 必须包含以下 7 个章节（auto-coder 依赖此结构）：

| 章节 | 标题格式 | 内容 |
|------|----------|------|
| 1 | `## 1. 项目概述` | 项目名称、一句话描述、目标用户、设计理念 |
| 2 | `## 2. 核心特点` | 功能特性列表、每个特性的详细说明 |
| 3 | `## 3. 技术选型` | 语言、框架、LLM 后端、依赖库及版本、选型理由 |
| 4 | `## 4. 测试方案` | 测试策略、覆盖率要求、测试工具、Mock 策略 |
| 5 | `## 5. 系统架构与模块设计` | 架构图、模块职责、接口定义、数据流 |
| 6 | `## 6. 项目排期` | 任务拆解（含 ID）、依赖关系、状态标记 `[ ]`/`[x]` |
| 7 | `## 7. 可扩展性与未来展望` | 扩展点、未来功能规划、技术演进方向 |

---

## Workflow: 5 Stages

```
Discovery → Spec Drafting → Spec Review → Build → Polish
 (需求收集)   (规范编写)     (规范确认)   (开发)   (交付)
```

**阶段门控规则**：每个阶段结束必须用户确认后才能进入下一阶段。不可跳过。

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

### Stage 2: Spec Drafting (规范编写)

Goal: Generate a complete DEV_SPEC.md based on the confirmed requirements and Agent domain knowledge.

Before drafting, read the following references for Agent-specific context:
- `references/agent-architecture.md` — for layer design and directory structure
- `references/delivery-patterns.md` — for the chosen delivery pattern
- `references/interface-spec.md` — for tool interface standards

#### 2a: Write DEV_SPEC.md

Create `DEV_SPEC.md` in the project root with all 7 chapters:

**Chapter 1 — 项目概述**:
- 项目名称、一句话定位
- 目标用户与使用场景
- 设计理念（Agent 特有：工具编排、对话管理、错误恢复）

**Chapter 2 — 核心特点**:
- Agent 核心循环（prompt → LLM → tool_use or text → repeat）
- 每个工具/能力的功能描述
- 内存/会话管理策略
- 系统提示词设计方向

**Chapter 3 — 技术选型**:
- 语言、框架、LLM SDK
- 依赖库清单及版本
- 选型理由（为什么选 X 而不选 Y）

**Chapter 4 — 测试方案**:
- 单元测试：每个模块独立测试，Mock 外部依赖
- 集成测试：模块间协作
- E2E 测试：端到端冒烟测试（Mock LLM）
- 测试工具与覆盖率目标

**Chapter 5 — 系统架构与模块设计**:
- 架构分层：Config → LLM Client → Memory → Tool Registry → Agent Loop → Interface
- 目录结构（参考 `references/agent-architecture.md`）
- 模块职责与接口定义
- 数据流与调用关系

**Chapter 6 — 项目排期**:
- 按依赖关系排序的任务列表
- 每个任务包含：ID、标题、描述、预期产出文件
- 使用 `[ ]` 标记未完成，`[x]` 标记已完成
- 任务顺序遵循自底向上构建：
  1. Setup — 项目初始化、配置、依赖
  2. LLM Client — API 封装、重试/超时
  3. Memory — 会话存储
  4. Tool Registry + Tools — 注册、路由、各工具实现
  5. Agent Loop — 主循环编排
  6. Interface — CLI/GUI/API
  7. System Prompt — 提示词工程
  8. Integration — 串联所有模块
  9. Polish — 测试、文档、脚本

**Chapter 7 — 可扩展性与未来展望**:
- 可扩展点：新工具接入、新 LLM 后端、新交付形态
- 未来功能规划
- 技术演进方向

---

### Stage 3: Spec Review (规范确认)

Goal: Walk the user through DEV_SPEC.md, get confirmation on each major section.

Present the spec in digestible sections:

1. **Architecture overview** — 展示架构图（ASCII）和数据流
2. **Module breakdown** — 展示模块依赖关系
3. **Task schedule** — 展示任务列表和预估工作量
4. **Key technical decisions** — 列出重要的技术选择及理由

For each section, ask: "这部分确认？(Y/修改项)"

After all sections confirmed:
```
╔══════════════════════════════════════════╗
║        📋 DEV_SPEC.md 规范已确认         ║
╠══════════════════════════════════════════╣
║  文件位置：<path>/DEV_SPEC.md            ║
║  章节数量：7                             ║
║  任务总数：<N> 个                        ║
║                                          ║
║  下一步：选择开发方式                     ║
╚══════════════════════════════════════════╝
```

#### Handoff Decision (开发路径选择)

Ask user:
```
开发方式选择：
1. 🤖 auto-coder 自动开发 — 按 DEV_SPEC.md 排期自动编码、测试、提交
2. 🔨 本 skill 引导构建 — 我来逐模块引导开发，每步确认
3. 📋 仅交付规范 — 到此为止，只要 DEV_SPEC.md

选哪个？(1/2/3)
```

- **Option 1**: 告知用户使用 `auto code` 或 `/auto-coder` 触发 auto-coder skill，它会自动读取 DEV_SPEC.md 并按排期开发
- **Option 2**: Continue to Stage 4 (manual guided build)
- **Option 3**: Done. DEV_SPEC.md is the deliverable.

---

### Stage 4: Build (逐模块构建)

Goal: Implement the agent module by module, **strictly following DEV_SPEC.md**.

> **Core rule**: Every coding decision must trace back to DEV_SPEC.md. If something isn't in the spec, don't implement it — update the spec first.

**Build order**: Follow the task sequence from Chapter 6.

For each task:

1. **Read DEV_SPEC.md** relevant sections before coding:
   - Chapter 5 — architecture and module design
   - Chapter 3 — tech stack details
   - Chapter 4 — testing conventions
   - `references/` — Agent-specific patterns from this skill

2. **Implement** following the spec's architecture and interface contracts

3. **Write tests** alongside code per the spec's testing strategy

4. **Smoke test** after each module

5. **Mark task complete** in `DEV_SPEC.md`: `[ ]` → `[x]`

**During build**:
- Show progress after each module: "✅ A1 Config 完成 | ⬜ A2 LLM Client | ⬜ A3 Memory | ..."
- Read `references/agent-architecture.md` for robustness checklist after completing core modules
- Only ask user to confirm if implementation needs to diverge from spec
- If divergence is needed: update DEV_SPEC.md first, then implement

---

### Stage 5: Polish (收尾交付)

Goal: Test, document, deliver.

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

**Step 3: Delivery Summary**
Show final card:

```
╔══════════════════════════════════════════════════╗
║            ✅ Agent 交付确认                      ║
╠══════════════════════════════════════════════════╣
║  项目目录：<path>                                ║
║  文件数量：<N> 个文件                            ║
║  测试结果：<pass/fail summary>                   ║
║                                                  ║
║  规范文件：                                       ║
║    DEV_SPEC.md — 完整项目规范 ✅                 ║
║                                                  ║
║  启动方式：                                       ║
║    <run command>                                 ║
║                                                  ║
║  后续迭代：                                       ║
║    更新 DEV_SPEC.md → auto code                  ║
╚══════════════════════════════════════════════════╝
```

**Step 4: Iteration Offer**
Ask: "需要优化吗？可以：添加工具 / 修复bug / 优化prompt / 优化界面 / 其他"

- If yes → update DEV_SPEC.md with new tasks, then use auto-coder to implement
- If no → done

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
- **Spec is law**: No code without spec backing. If it's not in DEV_SPEC.md, it doesn't get built
- **Spec before code**: Always update DEV_SPEC.md first, then implement
- **Traceability**: Every module, every test, every config should trace to DEV_SPEC.md
- **Living spec**: Update DEV_SPEC.md as the project evolves, keep it as the single source of truth

### Code Quality
- Type hints (Python) or TypeScript strict mode
- Docstrings on all public functions
- No magic numbers — constants with names
- Consistent naming: snake_case (Python), camelCase (TypeScript)
- Error messages follow pattern: "Failed to X: Y. Try Z."
