# 项目约定 (Project Conventions)

## ⚠️ 核心规范：新增/删除 Skill 时自动同步 README.md

> **此规范为默认行为**：每次在 `skills/` 目录下新增、删除或重命名 skill 时，**必须在同一次提交中同步更新 README.md**，无需用户额外提醒。

### 需要更新的位置

1. **「📚 技能列表与功能说明」表格** — 添加/删除对应行，链接格式：`[**skill-name**](https://github.com/kennysli1/My-AI-Skills/blob/main/skills/skill-name/SKILL.md)`
2. **「📁 仓库结构概览」目录树** — 添加/删除对应目录条目及中文注释

### 排序规则

以上两处列表均须按 **skill 目录名的英文字母 (a-z) 升序排列**，不得将新条目追加到末尾。

### 功能简介写法

从对应 skill 的 `SKILL.md` 中提取核心信息，写成简介：
- 核心能力的**加粗关键词**
- 适用场景说明
- 长度控制在 1-2 句话

### 示例

假设新增 `my-new-skill`，需要：
1. 在表格中按字母序插入一行：`| [**my-new-skill**](链接) | 功能简介 |`
2. 在目录树中按字母序插入：`├── my-new-skill/  # 中文说明`
