# THIRD_PARTY_NOTICES.md — 第三方材料记录

本文件记录 VEYRA 研究与开发中使用的所有第三方仓库、作者、License 与使用方式。

## 1. addyosmani/agent-skills

- 仓库：https://github.com/addyosmani/agent-skills
- 作者：Addy Osmani
- License：MIT（Copyright (c) 2025 Addy Osmani），原文见仓库 LICENSE
- 本地副本：`research/skills-sources/addyosmani-agent-skills`
- 使用方式：**有复制（开发工具）** — 7 个 Skill 目录原样复制到 `~/.zcode/skills/` 供开发阶段使用：spec-driven-development、planning-and-task-breakdown、incremental-implementation、test-driven-development、debugging-and-error-recovery、code-review-and-quality、source-driven-development
- 进入 VEYRA 产品：无。产品运行时不依赖这些 Skill 文件夹。

## 2. britt/agent-skills

- 仓库：https://github.com/britt/agent-skills
- 作者：Britt Crawford
- License：MIT（Copyright (c) 2025 Britt Crawford），原文见仓库 LICENSE
- 本地副本：`research/skills-sources/britt-agent-skills`
- 使用方式：**只参考** — 阅读其中 8 个规划类 Skill（project-planning、issue-decomposition、dependency-mapping、timeline-planning、at-risk-detection、daily-planning-ritual、requirement-elicitation、writing-product-specs）的方法论，映射见 `docs/skill-adaptation-map.md`
- 进入 VEYRA 产品：无代码或大段 Prompt 复制；仅方法论改写为 VEYRA 自有 Planning Engine 策略。

## 3. OthmanAdi/planning-with-files

- 仓库：https://github.com/OthmanAdi/planning-with-files
- 作者：Ahmad Adi
- License：MIT（Copyright (c) 2026 Ahmad Adi），原文见仓库 LICENSE
- 本地副本：`research/skills-sources/planning-with-files`
- 使用方式：**只参考** — 学习 task_plan.md / findings.md / progress.md 的持久化状态管理与中断恢复思想
- 进入 VEYRA 产品：无。VEYRA 运行时使用本地 SQLite，不采用 Markdown 文件存储用户数据。

## 汇总

| 仓库 | License | 只参考 | 有改编 | 有复制 | 进入产品 |
|---|---|---|---|---|---|
| addyosmani/agent-skills | MIT | | | ✓（复制到开发用 Skill 目录） | 否 |
| britt/agent-skills | MIT | ✓ | | | 否（仅方法论） |
| OthmanAdi/planning-with-files | MIT | ✓ | | | 否（仅思想） |

规则回顾（AGENTS.md §11）：License 不明确的仓库只研究，不复制生产代码或大段 Prompt。以上三个仓库 License 均明确为 MIT，无未知 License 项。

## Flutter SDK

- Flutter stable 3.47.4（macOS arm64），来自 https://docs.flutter.dev 官方发布渠道
- 安装位置：`~/development/flutter`（用户级，非本项目文件）
- License：BSD 3-Clause（Flutter 项目）
- 进入 VEYRA 产品：构建工具链，不随产品分发。

## pub 依赖（第二阶段 Slice 2.1 起）

| 包 | 版本 | License | 用途 |
|---|---|---|---|
| drift | 2.35.0 | MIT | typed SQLite 封装（本地数据库主依赖） |
| drift_dev | 2.35.0 | MIT | drift 代码生成（dev） |
| sqlite3 | 3.5.2 | MIT | SQLite Dart 绑定（drift 依赖） |
| sqlite3_flutter_libs | 0.5.42 | MIT | 提供 macOS/Windows 自带 SQLite 原生库 |
| path_provider | 2.1.6 | MIT | 定位本地数据库/附件目录 |
| build_runner | 2.16.1 | MIT | 代码生成（dev） |
| archive | 4.2.0 | MIT | ZIP 解析（DOCX 文本提取，纯 Dart） |
| xml | 6.6.1 | MIT | OOXML 解析（DOCX 文本提取，纯 Dart） |
| file_picker | 10.3.10 | MIT | 系统文件选择器（已验证 SPM 集成正常） |

以上均 License 明确，无未知 License 项。后续新增依赖逐项追加于此。

