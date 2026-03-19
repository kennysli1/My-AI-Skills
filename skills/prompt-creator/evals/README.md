# Prompt-Creator Evals

本目录包含两套 eval，用于对比**使用 / 不使用** prompt-creator 的差别。

## 1. 行为对比：`evals.json`

**用途**：同一句用户输入，分别用「带 skill」和「不带 skill」跑一次，对比输出质量。

- **evals.json**：5 条真实场景的「写开场 prompt」任务（中英、不同角色、含模糊意图与重新定向）。
- **用法**（若使用 skill-creator 流程）：
  - 对每条 `prompt` 各跑两次：一次挂载 prompt-creator，一次不挂载。
  - 对比两次输出：是否出现**角色 / 任务 / 用户背景 / 行为规范**四块结构、是否可直接复制、是否有多余解释、是否追问得当等。
- **预期**：带 skill 时更稳定地输出「加粗块 + 只保留有意义模块 + 无空段落」的完整开场 prompt；不带 skill 时可能结构不统一或缺少模块。

## 2. 触发对比：`trigger_evals.json`

**用途**：检查「该不该触发 prompt-creator」——同一批 query 下，带 skill 时模型是否在**应该触发**的 query 上用了 skill、在**不应触发**的 query 上没用。

- **trigger_evals.json**：15 条 query，每条带 `should_trigger: true/false`。
  - 约 8 条 `should_trigger: true`：写开场 prompt、定义角色/任务、模糊目标整理、中途重新定向、修改已有 prompt 等。
  - 约 7 条 `should_trigger: false`：改文档、写代码、检查 PRD、总结 PDF、写内部邮件等（不涉及「写/改开场 prompt」）。
- **用法**：
  - 用当前模型的 session，对每条 `query` 发一次请求（可多次取平均），记录「是否调用了 prompt-creator」。
  - 计算：触发了且 `should_trigger=true` 为真阳性，未触发且 `should_trigger=false` 为真阴性；反之为误触发/漏触发。
- **对比**：可先在不带 skill 的环境下看模型是否会主动做「写开场 prompt」类行为，再在带 skill 环境下看触发率与误触发率，用于微调 description 或评估 description 优化效果。

## 建议对比流程（简要）

1. **行为对比**：用 `evals.json` 的 5 条 prompt，各跑 with_skill / without_skill，人工或简单 checklist 对比输出（结构、完整性、可复制性）。
2. **触发对比**：用 `trigger_evals.json` 在带 skill 环境下跑一遍，统计 trigger 准确率；若有 skill-creator 的 description 优化脚本，可把该 JSON 作为 trigger eval 输入做优化迭代。
