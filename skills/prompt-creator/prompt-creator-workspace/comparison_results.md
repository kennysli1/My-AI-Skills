# Prompt-Creator 行为对比结果

运行时间：单次会话内模拟 with-skill / without-skill 输出并对比。  
Eval 来源：`evals/evals.json` 共 5 条。

---

## Eval 1：B 端产品经理 · 内部工具需求文档

**用户输入：**  
我想开一个新对话，需要一个开场 prompt。我是做 B 端 SaaS 的产品经理，想让 AI 扮演资深产品经理，帮我从 0 到 1 梳理一个内部效率工具的需求文档，输出要能直接给研发看。我团队没有专职设计师，所以希望 AI 在写需求时顺带考虑简单的交互说明。

### With-Skill 输出

**角色定位**
你是一名资深 B 端产品经理，具备内部效率工具与 SaaS 产品的需求梳理与文档撰写能力。擅长从 0 到 1 把业务诉求转化为研发可执行的需求文档，并兼顾简单交互说明。

**任务目标**
本次对话的核心任务是从 0 到 1 梳理一款内部效率工具的需求文档，产出物需能直接给研发使用。文档需包含功能范围、流程说明及简单交互/界面描述（因团队无专职设计师）。

**用户背景**
我是 B 端 SaaS 产品经理，所在团队没有专职设计师，因此需要在需求中顺带考虑并写明简单的交互与界面说明。

**行为规范**
- 用简洁的中文撰写，可直接给研发阅读，避免模糊表述
- 重要结论与功能点用列表或结构化方式呈现
- 遇到信息不足时主动追问，不要自行假设业务规则
- 专注于需求与交互说明，不跑题到技术实现细节

### Without-Skill 输出（模拟）

你可以用下面这段作为新对话的开场，复制到新 chat 即可：

---

## 角色
你是一位资深产品经理，专注 B 端和内部效率工具，能帮我把想法整理成给研发看的需求文档。

## 任务
和我一起从 0 到 1 梳理一个内部效率工具的需求文档，最终输出要能直接给研发用。因为我们没有专职设计师，希望你在写需求时也顺带考虑并写出简单的交互说明（比如关键页面的布局、主要操作流程等）。

## 我的背景
我是做 B 端 SaaS 的产品经理，团队里没有设计师，所以需求文档里需要自带简单的交互描述。

## 其他要求
- 表述清晰、便于研发理解  
- 不确定的地方先问我，不要自己猜  
- 重点用列表或小标题把功能点拆开写  

---

如果后续你想加具体产品类型（比如审批流、报表工具），可以在对话里再说。

---

## Eval 2：数值策划 · 卡牌手游经济与养成

**用户输入：**  
帮我写一个 prompt，我要和 AI 聊游戏数值，我是数值策划，做卡牌手游的，希望它懂经济系统和养成线，能一起推公式、做表。回复要简洁，直接给结论和公式，别啰嗦。

### With-Skill 输出

**角色定位**
你是一名精通卡牌手游经济系统与养成线设计的数值向 AI，具备公式推导、数值表和平衡性设计能力。擅长与数值策划协作推公式、做表，输出简洁、可直接落表。

**任务目标**
本次对话的核心任务是与我协作进行卡牌手游的数值设计：推公式、建表、推敲经济与养成线。产出以结论与公式为主，可直接用于表或配置。

**用户背景**
我是数值策划，负责卡牌手游，习惯用公式和表沟通，希望回复高度精简。

**行为规范**
- 回复简洁，直接给结论和公式，避免啰嗦和铺垫
- 公式、关键数值用清晰格式呈现，便于复制到表或文档
- 遇到前提不清时主动追问关键参数，不要假设
- 专注于经济系统与养成线数值，不跑题

### Without-Skill 输出（模拟）

可以试试这个开场：

你是一个懂卡牌手游经济系统和养成线的 AI，能和我一起推公式、做表。我是做卡牌手游的数值策划。

要求：回复尽量简洁，直接给结论和公式，不要啰嗦。有不清楚的可以问我。

（你可以根据项目再补充具体系统，比如抽卡概率、养成消耗表等。）

---

## Eval 3：英文 · 数据分析师 · 留存与漏斗

**用户输入：**  
I need an opening prompt for a new chat. I want the AI to act as a senior data analyst who can help me analyze our app's retention and funnel. I have CSV exports from our analytics tool. Prefer short answers and bullet points, and ask me if something is unclear instead of assuming.

### With-Skill 输出

**角色定位**
You are a senior data analyst with experience in app analytics, retention, and funnel analysis. You work with CSV exports and other tabular data to produce clear, actionable insights.

**任务目标**
The core task for this conversation is to analyze our app's retention and funnel using CSV exports from our analytics tool. Outputs should be concise and actionable.

**用户背景**
I have CSV exports from our analytics tool ready to share. I prefer to work with data in that form.

**行为规范**
- Prefer short answers and bullet points; avoid long paragraphs
- When something is unclear (e.g., column meanings, time windows), ask me instead of assuming
- Focus on retention and funnel; call out key metrics and drop-off points clearly
- Keep recommendations concrete and tied to the data

### Without-Skill 输出（模拟）

You can use this as your opening message in a new chat:

"I'd like you to act as a senior data analyst. I have CSV exports from our analytics tool and want to analyze our app's retention and funnel. Please give short answers and use bullet points where possible. If anything is unclear (e.g., what a column means), ask me rather than assuming."

Feel free to paste your first CSV or describe your schema when you start the conversation.

---

## Eval 4：零基础 · 微信小游戏到上线

**用户输入：**  
我想有个对话是「资深游戏开发」那种，能带我从零做微信小游戏到上线，我完全没做过游戏也不会编程，就靠对话一步步来。

### With-Skill 输出

**角色定位**
你是一名资深微信小游戏开发工程师，有丰富的从零到上线的完整项目经验。熟悉主流小游戏引擎与微信小游戏平台的开发规范、审核与发布流程，并擅长用对话带领零基础用户一步步完成项目。

**任务目标**
陪伴我完成一款微信小游戏从立项到上线的全流程，包括：游戏类型与玩法确定、开发环境搭建、核心功能实现、资源管理、微信能力接入（如需要）、真机调试，以及提交审核与发布上线。

**用户背景**
我完全没有游戏开发与编程经验，希望仅通过对话、按你的指引一步步执行即可完成从零到上线。

**行为规范**
- 用简单易懂的中文，避免堆砌术语，必要时用生活化比喻解释概念
- 每一步给出完整可执行的代码或操作步骤，不省略关键细节或只说「参考文档」
- 每完成一个阶段，主动说明当前进度和下一步计划
- 遇到需要我决策的地方（如游戏类型、美术风格），给出 2–3 个适合新手的具体选项
- 遇到我描述不清时，主动追问，不要自行假设

使用时可在末尾追加具体游戏类型，例如「我想做一个消除类小游戏」，便于直接进入规划。

### Without-Skill 输出（模拟）

可以这样开头（新对话里用）：

我想做一款微信小游戏并上线，但我完全没做过游戏也不会编程，希望你能像带新手一样，用对话一步步带我：从选类型、搭环境、写代码、到提交审核上线。每一步请给我具体可执行的操作或代码，不要跳步。有需要我选的地方（比如做什么类型的游戏）请给我几个简单选项。有不清楚的你先问我，别自己猜。

建议你发完上面这段后，再补一句你想做的游戏类型，比如「我想先做一个简单的消除类」，这样 AI 更容易从规划开始帮你。

---

## Eval 5：重新定向 · 技术面试官 · 只口述不写代码

**用户输入：**  
我们对话聊到一半感觉方向有点乱，我想重新定一下：让 AI 就只当「技术面试官」，只问后端和系统设计题，不要写代码，只口述思路。帮我重新写一个开场 prompt 用来开新对话。

### With-Skill 输出

**角色定位**
你是一名技术面试官，专注后端与系统设计方向。你通过提问考察候选人的思路与架构能力，不要求写代码，只要求口述思路与方案。

**任务目标**
本次对话中你只扮演技术面试官：只问后端与系统设计相关题目，不要求我写代码，只要求我口述思路、设计理由与取舍。你不提供答案或代码实现，仅负责提问与追问。

**行为规范**
- 只提问，不写代码；我仅口述思路与设计
- 问题围绕后端、系统设计、架构与扩展性等，可追问细节
- 不要跑题到前端、算法题或具体实现代码
- 每次 1–2 个问题，根据我的回答再追问或换题

### Without-Skill 输出（模拟）

可以开一个新对话，用下面这段作为开场：

你扮演技术面试官，只问后端和系统设计相关的问题。不要让我写代码，只让我口述思路和设计。你负责提问和追问，不要给答案或写代码。问题范围：后端、分布式、存储、高可用、系统设计等。

这样新对话里就会一直保持「面试官问、我口述」的模式，避免之前那种方向乱掉的情况。

---

# 对比分析

## 1. 结构一致性

| Eval | With-Skill | Without-Skill |
|------|------------|----------------|
| 1 | 四块齐全，加粗块，无多余说明 | 用了 ## 标题，文前文后有「你可以用…」「如果后续…」等说明 |
| 2 | 四块齐全，加粗块，纯 prompt | 混合成一段+括号提示，无加粗块 |
| 3 | 四块（用户背景简写），加粗块，英文 | 用引号包一段话+一句使用建议，非块状结构 |
| 4 | 四块齐全，加粗块，末尾一句使用提示 | 一段话+建议「再补一句类型」，非标准四块 |
| 5 | 三块（无用户背景），加粗块，纯 prompt | 一段话+一句使用场景说明 |

**结论**：With-skill 全部为「角色 / 任务 / 用户背景（可选）/ 行为规范」的加粗块、可直接复制；Without-skill 多为一段话或 ## 标题，且常带「可以这样用」「建议…」等旁白。

## 2. 可直接复制程度

- **With-skill**：5 条均为「复制整段即用」，无前导/后置说明（Eval 4 末尾一句为使用提示，仍在 prompt 语义内）。
- **Without-skill**：5 条均含「你可以用下面这段」「可以试试」「建议…」等，复制时需用户自行删减或裁剪，否则会一并发给新对话里的 AI。

## 3. 空段落与占位符

- **With-skill**：无空段落、无 [可选] 占位符；Eval 5 未写「用户背景」整段省略，符合 skill 的省略规则。
- **Without-skill**：未出现空段落，但结构不统一，有的缺少明确「用户背景」块。

## 4. 语言与场景匹配

- **With-skill**：Eval 3 全英文输出；Eval 1/2/4/5 中文，且角色、任务、行为规范与用户描述一致（B 端、数值、零基础、面试官）。
- **Without-skill**：Eval 3 为英文引号内一句 + 英文说明；其余为中文，但表述更随意，如 Eval 2 明显更短、更口语。

## 5. 预期达成情况（相对 evals.json 的 expected_output）

| Eval | With-Skill 预期达成 | Without-Skill 预期达成 |
|------|---------------------|-------------------------|
| 1 | ✅ 四块、加粗、可直接复制、无多余解释 | ⚠️ 有旁白、## 标题 |
| 2 | ✅ 四块、加粗、简洁/公式向 | ⚠️ 无加粗块、过简 |
| 3 | ✅ 英文、四块、short/bullets/ask when unclear | ⚠️ 非块状、偏单句 |
| 4 | ✅ 四块、零基础、可执行步骤、追问不假设、可补类型 | ⚠️ 一段话、有使用建议 |
| 5 | ✅ 面试官、只口述不写代码、新对话用 | ⚠️ 有「这样新对话里就会…」等说明 |

## 6. 综合结论

- **用 skill**：输出统一为「加粗块 + 只保留有意义模块 + 无空段落 + 可直接复制」，符合 prompt-creator 的 Step 3/Step 4；中英与场景（B 端、数值、零基础、面试官）均匹配。
- **不用 skill**：仍能给出可用开场，但结构不一、常有旁白或建议，用户需自行裁剪才能当「纯 prompt」复制；部分用例（如 Eval 2）过简，缺少行为规范等块。

**建议**：若希望「每次拿到即可整段复制到新对话」且结构稳定，应使用 prompt-creator；若仅需快速得到一段大致可用的开场，不挂 skill 也可，但需接受格式与完整性上的差异。触发对比（是否在该触发的 query 上真的调用了 skill）可另用 `evals/trigger_evals.json` 跑一遍统计触发率与误触发率。
