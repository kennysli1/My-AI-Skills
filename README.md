# 🚀 我的个人 AI 技能库 (Personal AI Skills)

此仓库用于沉淀个人 AI 提示词资产，可直接复制到 Cursor / Claude 等环境中作为 Skills 使用。  
仓库地址：[GitHub - kennysli1/My-AI-Skills](https://github.com/kennysli1/My-AI-Skills)

---

## 📚 技能列表与功能说明

| 技能目录 | 功能简介 |
|----------|----------|
| [**agent-builder**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/agent-builder/SKILL.md) | **规范驱动构建 AI Agent**：使用 **speckit**（0→1）完成 constitution→spec→plan→tasks→implement 全流程，使用 **openspec**（1→N）进行后续功能扩展。需求收集→speckit 规范生成→架构审查→自动/引导开发→交付并初始化 openspec 扩展基线。 |
| [**algorithmic-art**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/algorithmic-art/SKILL.md) | 用 **p5.js** 做算法艺术：种子随机、粒子/流场、参数可调。先写「算法哲学」(.md)，再实现为可交互 HTML。适合：生成艺术、粒子系统、流场、代码艺术。 |
| [**brand-guidelines**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/brand-guidelines/SKILL.md) | 为任意产物应用 **Anthropic 官方品牌**：主色/强调色、Poppins+Lora 字体、标题与正文样式。适合：需要品牌一致性的文档、幻灯片、页面。 |
| [**canvas-design**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/canvas-design/SKILL.md) | 用设计哲学做**静态视觉设计**：先写视觉哲学 (.md)，再在画布上产出 .png/.pdf。适合：海报、艺术图、品牌视觉，强调工艺感与极简文字。 |
| [**claude-api**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/claude-api/SKILL.md) | 使用 **Claude API / Anthropic SDK** 开发应用：单次调用、流式、Tool Use、Agent SDK、多语言 (Python/TS/Java/Go 等)。触发：代码里用 `anthropic` 或用户提到 Claude API。 |
| [**doc-coauthoring**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/doc-coauthoring/SKILL.md) | **文档共创流程**：上下文收集 → 逐段精修与结构 → 用「读者测试」验证可读性。适合：技术文档、提案、PRD、决策文档、RFC。 |
| [**docx**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/docx/SKILL.md) | **Word 文档**：用 docx-js 新建 .docx，或 unpack → 改 XML → pack 编辑已有文档。支持样式、表格、图片、目录、修订与批注。 |
| [**frontend-design**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/frontend-design/SKILL.md) | 创建独特的**生产级前端界面**：拒绝千篇一律的 AI 风格，强调大胆的美学方向（极简/极繁/复古未来/有机自然等）、独特字体选择、精致动效与空间构图。适合：网页组件、落地页、仪表盘、React 组件、HTML/CSS 布局。 |
| [**internal-comms**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/internal-comms/SKILL.md) | **内部沟通写作**：3P 更新、周报、FAQ、事故报告、项目更新等，按公司格式与范例 (examples/) 撰写。 |
| [**mcp-builder**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/mcp-builder/SKILL.md) | 开发 **MCP (Model Context Protocol) 服务器**：工具设计、TypeScript/Python 实现、测试与评估。适合：把外部 API/服务接入 LLM。 |
| [**pdf**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/pdf/SKILL.md) | **PDF 处理**：读取/提取文字表格、合并/拆分、旋转、水印、新建 PDF、填表、加解密、OCR。用 pypdf、pdfplumber、reportlab 等。 |
| [**pptx**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/pptx/SKILL.md) | **PPT 幻灯片**：用 markitdown 读内容、thumbnail 看版式；编辑用 unpack→改→pack；从零做用 pptxgenjs。含设计建议与 QA 流程。 |
| [**prompt-creator**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/prompt-creator/SKILL.md) | **初始 Prompt 生成**：把模糊的角色定位（如"资深数据分析师"）转化为结构完整的初始 prompt，涵盖角色定位、任务目标、用户背景、行为规范四个维度。信息不足时主动追问，输出可直接复制使用的纯文本 prompt。 |
| [**qa-tester**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/qa-tester/SKILL.md) | **全自动 QA 测试**：读取 QA_TEST_PLAN.md，自动执行 CLI / Dashboard UI / MCP 协议等全类型测试，失败自动诊断并最多 3 轮修复重试，结果记录到 QA_TEST_PROGRESS.md。 |
| [**skill-creator**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/skill-creator/SKILL.md) | **创建与优化 Skill**：从意图到 SKILL.md 草稿、写测试用例、跑评测、根据反馈迭代、可选描述优化与打包。适合：做新 skill 或改进现有 skill。 |
| [**slack-gif-creator**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/slack-gif-creator/SKILL.md) | 做 **Slack 用动图**：尺寸/帧率/颜色约束、GIFBuilder、校验、缓动与帧辅助。用 PIL 画图，支持抖动/脉冲/旋转/粒子等动画思路。 |
| [**theme-factory**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/theme-factory/SKILL.md) | 为幻灯片/文档/落地页等**套用主题**：10 套预设主题（颜色+字体），或按需求生成新主题，再应用到已有产物。 |
| [**web-artifacts-builder**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/web-artifacts-builder/SKILL.md) | 用 **React + TypeScript + Vite + Tailwind + shadcn/ui** 做复杂前端产物：init → 开发 → bundle 成单 HTML，便于在对话里以 artifact 展示。 |
| [**webapp-testing**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/webapp-testing/SKILL.md) | 用 **Playwright** 测本地 Web 应用：起服、截图、查 DOM、写自动化脚本。提供 with_server 等脚本，支持单/多服务。 |
| [**xlsx**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/xlsx/SKILL.md) | **Excel/表格**：用 pandas 分析、openpyxl 做公式与格式，脚本重算公式并查错。含金融模型配色与数字格式规范。 |

---

## 🛠 如何扩展新 Skill

### 1. 目录结构建议

每个 skill 建议单独一个目录，且包含 `SKILL.md`：

```
skills/
├── 你的技能名/
│   ├── SKILL.md          # 必需：YAML 头 (name, description) + 正文说明
│   ├── scripts/          # 可选：可执行脚本
│   ├── references/       # 可选：参考文档
│   ├── examples/         # 可选：示例文件
│   └── assets/           # 可选：模板、字体等
```

### 2. SKILL.md 基本格式

```yaml
---
name: 技能标识符
description: "何时触发、做什么。尽量写具体场景和关键词，便于被正确调用。"
license: 可选
---

# 技能标题

正文：使用步骤、规范、示例、注意事项等。
```

- **name**：唯一、简短，一般和目录名一致。  
- **description**：触发条件 + 能力说明，写清楚「在什么情况下用这个 skill」「能解决什么问题」。

### 3. 编写原则（参考 skill-creator）

- **渐进披露**：SKILL.md 控制在可读长度（例如约 500 行内），大块内容放到 `references/` 并在正文里说明何时去读。
- **说清原因**：多解释「为什么要这样做」，而不是堆 MUST/NEVER。
- **示例**：关键步骤配上输入/输出或代码片段，方便模型和人类理解。
- **可测试**：若技能有明确产出（如生成文件、固定流程），可顺便写 2～3 个测试用例，便于以后用 skill-creator 做评测。

### 4. 本地安装与使用（Cursor）

- 将整个 `skills/` 或单个技能目录放到 Cursor 的 skills 路径下（例如 `~/.cursor/skills-cursor/` 或项目内指定目录），具体以 Cursor 文档为准。
- 若环境支持「按目录加载 skill」，只需保证该目录下有 `SKILL.md` 即可。

### 5. 用 skill-creator 做迭代

- 新建或改完一个 skill 后，可用本仓库里的 **skill-creator**：
  - 写测试 prompt → 跑「带 skill / 不带 skill」对比 → 看结果与 benchmark。
  - 根据反馈改 SKILL.md，再跑一轮，直到满意。
  - 需要时还可做 **description 优化**，提高触发准确率。

---

## 📁 仓库结构概览

```
My-AI-Skills/
├── README.md           # 本文件：技能说明 + 扩展指南
└── skills/
    ├── agent-builder/         # AI Agent 构建
    ├── algorithmic-art/       # 算法艺术
    ├── brand-guidelines/      # 品牌规范
    ├── canvas-design/         # 静态视觉设计
    ├── claude-api/            # Claude API 开发
    ├── doc-coauthoring/       # 文档共创
    ├── docx/                  # Word 文档
    ├── frontend-design/       # 前端界面设计
    ├── internal-comms/        # 内部沟通
    ├── mcp-builder/           # MCP 服务器
    ├── pdf/                   # PDF 处理
    ├── pptx/                  # PPT 幻灯片
    ├── prompt-creator/        # Prompt 生成
    ├── qa-tester/             # QA 测试
    ├── skill-creator/         # Skill 创建
    ├── slack-gif-creator/     # Slack 动图
    ├── theme-factory/         # 主题工厂
    ├── web-artifacts-builder/ # 前端产物
    ├── webapp-testing/        # Web 测试
    └── xlsx/                  # Excel 表格
```

每个子目录内以对应技能的 `SKILL.md` 为主入口，详细用法见各技能目录内文档。

---

## 📄 License

各技能在各自目录或 SKILL.md 中可能标注不同 license（如 Proprietary、LICENSE.txt 等），使用前请查看对应说明。
