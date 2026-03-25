# Agent Builder Skill

Build complete, runnable AI agent applications from scratch through guided conversation.
Every project **must** produce a `DEV_SPEC.md` before any code is written — this is the single source of truth for the entire development lifecycle.

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

---

## Spec-Driven Development Philosophy

> **核心理念：先写规范，再写代码。规范即合同，代码是履约。**

本 skill 遵循 **speckit 式 0→1 流程**：完整的阶段门控，确保需求→规范→计划→任务→实现每一步都经过确认，不跳步。

生成的 `DEV_SPEC.md` 与 **auto-coder** 完全兼容（7 章结构），用户确认 spec 后可随时切换到 auto-coder 自动开发。

后续功能扩展推荐使用 **openspec 式 1→N 流程**：通过 proposal→review→apply→archive 循环增量修改 spec，而非重写。

### Spec 工具选型指南

| 场景 | 推荐方案 | 理由 |
|------|---------|------|
| 从零构建新 Agent | **speckit 式**（本 skill 内置） | 严格阶段流程确保基础设计不跳过 |
| 给已有 Agent 加功能 | **openspec 式** | 轻量 proposal 循环，不干扰已有 spec |
| 自动化开发执行 | **auto-coder** | 读 DEV_SPEC.md → 按任务自动编码测试 |

---

## Workflow: 5 Stages

```
Discovery → Specification → Architecture Review → Build → Polish
   (需求)      (写规范)        (审架构)        (开发)   (交付)
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

### Stage 2: Specification (规范文档生成)

Goal: **将 Stage 1 的需求转化为完整的 `DEV_SPEC.md` 并写入项目目录**。这是整个项目的单一事实来源 (Single Source of Truth)。

> **为什么先写 spec？**
> - 让你在写代码前看清全貌：项目概述、核心特性、技术选型、测试方案、架构模块、开发计划
> - 作为 AI 开发的"合同"：后续 auto-coder 严格按 spec 执行，不会自由发挥
> - 防止 vibe coding：每一行代码都能追溯到 spec 中的某条要求

**Step 1**: Read `references/agent-architecture.md` and `references/delivery-patterns.md` to inform spec content.

**Step 2**: Generate `DEV_SPEC.md` in project root directory, strictly following the **7-chapter structure** (compatible with auto-coder):

```markdown
## 1. Project Overview (项目概述)

### 1.1 项目名称与定位
- 名称、一句话描述、解决的核心问题

### 1.2 目标用户
- 用户画像、使用场景

### 1.3 成功指标
- 可衡量的验收标准（如：能完成 X 任务、响应时间 < Y 秒）

---

## 2. Core Features (核心特性)

### 2.1 功能清单
按优先级列出所有功能，每个功能包含：
- **功能名**：一句话描述
- **输入/输出**：明确数据流
- **用户故事**：作为<用户>，我希望<做什么>，以便<达到什么目的>
- **验收标准**：GIVEN-WHEN-THEN 格式

### 2.2 工具/能力清单
Agent 需要的每个工具：
- 工具名、触发条件、输入参数、输出格式、错误处理

### 2.3 非功能需求
- 性能要求、安全约束、可用性目标

### 2.4 明确不做 (Out of Scope)
- 本版本明确排除的功能，防止范围蔓延

---

## 3. Tech Stack (技术选型)

### 3.1 语言与运行时
- 语言版本、包管理器

### 3.2 核心依赖
| 依赖 | 版本 | 用途 | 选型理由 |
|------|------|------|---------|
| ...  | ...  | ...  | ...     |

### 3.3 LLM 后端
- Provider、模型、参数（temperature/max_tokens）
- Fallback 策略

### 3.4 框架选择
- 选用/不选用框架的理由
- 如选用：版本、核心用法

### 3.5 开发工具链
- Linter、Formatter、Pre-commit hooks

---

## 4. Testing Strategy (测试方案)

### 4.1 测试分层
| 层级 | 覆盖范围 | 工具 | 运行时机 |
|------|---------|------|---------|
| 单元测试 | 各模块独立功能 | pytest/vitest | 每次提交 |
| 集成测试 | 模块间协作 | pytest/vitest | 每个任务完成 |
| 冒烟测试 | 端到端基本流程 | 自定义脚本 | 每个阶段完成 |

### 4.2 Mock 策略
- LLM 调用：Mock response 文件路径
- 外部 API：Mock server 或 fixture
- 文件系统：临时目录

### 4.3 测试命名规范
- 文件：`test_<module>.py` / `<module>.test.ts`
- 函数：`test_<action>_<scenario>_<expected>`

### 4.4 验收测试用例
从 2.1 的验收标准推导，列出关键 E2E 测试场景

---

## 5. Architecture (系统架构)

### 5.1 架构总览图
ASCII 图展示模块间数据流与调用关系

### 5.2 模块设计
每个模块包含：

#### 5.2.x <模块名>
- **职责**：一句话
- **文件**：`src/xxx.py`
- **对外接口**：公开函数/类签名
- **依赖**：依赖哪些其他模块
- **设计决策**：为什么这样设计（附理由）

模块列表（按依赖顺序，底层在前）：
1. Config — 配置加载与校验
2. LLM Client — API 调用封装
3. Memory — 会话存储
4. Tool Registry — 工具注册与路由
5. Tools — 具体工具实现
6. Agent Loop — 主循环编排
7. Interface — 用户界面
8. System Prompt — 提示词管理

### 5.3 目录结构
完整 tree 格式，每个文件附中文注释

### 5.4 关键设计决策
| 决策 | 选择 | 备选 | 理由 |
|------|------|------|------|
| 内存后端 | JSON 文件 | SQLite | 简单无依赖，单会话够用 |
| ... | ... | ... | ... |

---

## 6. Schedule (开发计划)

### 6.1 阶段划分
按依赖顺序排列，每个阶段包含若干任务。

### 6.2 任务清单
使用 auto-coder 兼容的 checkbox 格式：

| 阶段 | 任务ID | 任务名称 | 状态 | 产出文件 | 验收标准 |
|------|--------|---------|------|---------|---------|
| A. 基础设施 | A1 | 项目初始化与配置 | [ ] | config.yaml, src/config.py | 配置加载成功，校验失败时报错 |
| A. 基础设施 | A2 | LLM Client 封装 | [ ] | src/llm_client.py | send_message 返回有效响应 |
| B. 核心能力 | B1 | Memory 模块 | [ ] | src/memory.py | 读写持久化，原子写入 |
| ... | ... | ... | ... | ... | ... |

> 状态标记：`[ ]` 未开始 | `[~]` 进行中 | `[x]` 已完成

---

## 7. Future Roadmap (未来规划)

### 7.1 下一版本候选功能
- 功能名 + 简述 + 优先级（P0/P1/P2）

### 7.2 已知限制
- 当前版本的已知约束和 workaround

### 7.3 扩展方向
- 多 Agent 协作、插件系统、Web UI 等
```

**Step 3**: Write `DEV_SPEC.md` to the project directory.

**Step 4**: Present spec summary to user:

```
╔══════════════════════════════════════════════════╗
║          📋 DEV_SPEC.md 已生成                   ║
╠══════════════════════════════════════════════════╣
║  位置：<project-dir>/DEV_SPEC.md                 ║
║                                                  ║
║  章节概览：                                       ║
║  1. 项目概述 — <agent名称>，<一句话定位>          ║
║  2. 核心特性 — <N> 个功能，<M> 个工具             ║
║  3. 技术选型 — <语言> + <框架> + <LLM>           ║
║  4. 测试方案 — 单元/集成/冒烟 三层覆盖            ║
║  5. 系统架构 — <K> 个模块，依赖关系已标注          ║
║  6. 开发计划 — <P> 个阶段，<T> 个任务             ║
║  7. 未来规划 — <F> 个候选功能                     ║
║                                                  ║
║  下一步：                                         ║
║  • 审阅后回复 "确认" → 进入架构审查               ║
║  • 回复修改意见 → 更新对应章节                     ║
║  • 回复 "auto-coder" → 直接交给 auto-coder 开发  ║
╚══════════════════════════════════════════════════╝
```

Ask: "请审阅 DEV_SPEC.md，确认或提出修改意见。"

**修改循环**: If user proposes changes, update the specific chapter(s) in DEV_SPEC.md, show diff summary, and ask again. Repeat until confirmed.

---

### Stage 3: Architecture Review (架构审查)

Goal: User visually reviews and confirms the architecture before any code is written.

> This stage extracts and highlights the architecture from Chapter 5 of DEV_SPEC.md for focused review. No new content is created — this is a review gate.

**Step 1**: Extract from DEV_SPEC.md Chapter 5 and present:

1. **Architecture diagram** (ASCII, from 5.1)
2. **Module dependency graph** (which module depends on which)
3. **Build order** (the sequence modules will be implemented, from 6.2)
4. **Risk check**: Flag any circular dependencies, missing error handling paths, or modules without test coverage in Chapter 4

**Step 2**: Ask: "架构方案确认？(Y/修改项)"

If modifications needed → update DEV_SPEC.md Chapters 5 and 6, re-present.

Proceed only on confirmation.

---

### Stage 3.5: Handoff Decision (交付路径选择)

After spec and architecture are confirmed, ask user:

```
开发方式选择：
1. 🤖 auto-coder 自动开发 — 交给 auto-coder 按 DEV_SPEC.md 逐任务自动编码
2. 🔨 本 skill 继续构建 — 我来逐模块引导开发
3. 📋 仅交付规范 — 到此为止，只要 DEV_SPEC.md

选哪个？(1/2/3)
```

- **Option 1**: Remind user to run `auto code` or `自动开发`, agent-builder 任务结束.
- **Option 2**: Continue to Stage 4.
- **Option 3**: Done. DEV_SPEC.md is the deliverable.

---

### Stage 4: Build (逐模块构建)

Goal: Implement the agent module by module, **strictly following DEV_SPEC.md**.

> **Core rule**: Every coding decision must trace back to a specific section in DEV_SPEC.md. If something isn't in the spec, don't implement it — ask user to update the spec first.

**Build order**: Follow the task sequence from DEV_SPEC.md Chapter 6.2.

For each task:

1. **Read relevant spec chapters** before coding:
   - Architecture: Chapter 5.2.x (target module)
   - Tech details: Chapter 3
   - Testing conventions: Chapter 4

2. **Implement** following spec's interface definitions and design decisions

3. **Write tests** alongside code per Chapter 4 conventions

4. **Smoke test** after each module

5. **Update DEV_SPEC.md** Chapter 6.2: change task status `[ ]` → `[x]`

**During build**:
- Show progress after each module: "✅ A1 Config 完成 | ⬜ A2 LLM Client | ⬜ B1 Memory | ..."
- Only ask user to confirm if implementation needs to diverge from spec
- If divergence is needed: update DEV_SPEC.md first, then implement

---

### Stage 5: Polish (收尾交付)

Goal: Test, document, and deliver.

**Step 1: Automated Testing**
Run tests automatically per Chapter 4. Fix failures (up to 3 rounds).
- Import/syntax check
- Unit tests per module
- Integration tests
- E2E smoke test (mock LLM if no API key)

**Step 2: Project Files**
Generate all supporting files:
- `README.md` — Setup, config, usage, examples
- `requirements.txt` or `package.json` — All dependencies with versions (from Chapter 3.2)
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
║  规范文件：DEV_SPEC.md ✅               ║
║                                          ║
║  启动方式：                              ║
║    <run command>                         ║
║                                          ║
║  配置文件：config.yaml                   ║
║  API Key ：设置 .env 文件               ║
║                                          ║
║  后续扩展：                              ║
║    修改 DEV_SPEC.md → auto code          ║
╚══════════════════════════════════════════╝
```

**Step 4: Iteration Offer**
Ask: "需要优化吗？可以：添加工具 / 修复bug / 优化prompt / 优化界面 / 其他"

- Small changes → update DEV_SPEC.md Chapter 2 + 6, then implement
- Large changes → recommend using openspec proposal flow (see below)

---

## Extension Workflow: OpenSpec Mode (1→N 扩展)

When user wants to add features to an **existing** agent that already has DEV_SPEC.md:

### When to use

- Adding new tools/capabilities to existing agent
- Changing existing behavior
- Refactoring modules

### Workflow

```
Proposal → Review → Apply → Archive
```

**Step 1: Proposal** — Create a change description:
- What to change and why
- Which DEV_SPEC.md chapters are affected
- New/modified tasks for Chapter 6

**Step 2: Review** — Present the proposed changes to user:
- Show diff of DEV_SPEC.md (before/after for each affected chapter)
- Highlight impact on existing modules

**Step 3: Apply** — On confirmation:
- Update DEV_SPEC.md with the changes
- Implement new/modified tasks (or hand off to auto-coder)

**Step 4: Archive** — Record what was changed:
- Add entry to Chapter 7.1 if applicable
- Update task statuses in Chapter 6.2

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
- **Traceability**: Every module, every test, every config should trace to a spec chapter
- **Living document**: DEV_SPEC.md evolves with the project, task statuses stay current

### Code Quality
- Type hints (Python) or TypeScript strict mode
- Docstrings on all public functions
- No magic numbers — constants with names
- Consistent naming: snake_case (Python), camelCase (TypeScript)
- Error messages follow pattern: "Failed to X: Y. Try Z."
