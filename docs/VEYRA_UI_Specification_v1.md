# VEYRA UI Specification v1（正式版）

**定位：第三阶段唯一视觉与交互基准**
**融合：VEYRA_UI设计规范_v1.md + 参考图氛围提取 + impeccable 设计标准（Operate 模式）**
**核心体验：清晰 · 平静 · 推进感**
**核心目的：轻盈——用户打开 App 的第一秒，感觉事情被整理好了，而不是又压过来一堆**

---

# 0. 文档地位与使用方式

1. 本文档是 Phase 3 全部 UI 工作的**唯一视觉基准**。与旧文档冲突时以本文档为准。
2. 参考图（Structured 风格日历 App）只提供**氛围**：暖白、留白、呼吸感、低饱和点缀。
   不复制它的布局、日历结构、图标与配色。
3. 实施顺序不变（见 §10）：**Design Tokens → Project Focus View → 截图验收 → STOP**，
   用户确认后才允许把设计语言推广到其他页面。
4. UI 文案一律以本文档 §7 的**中文文案总表**为准（菜单以中文为主）。

---

# 1. 产品真相（Product Truth）

- **VEYRA**：本地优先、轻量的个人规划桌面 App。把目标或已有规划，变成一条真正能走下去的路径。
- **不是**：企业项目后台、AI Agent 控制台、Todo List 套 AI、日历工具。
- **核心用户状态**：「我有很多计划，但我现在只需要处理眼前这一点。」
- **impeccable 模式判定：Operate**。用户来完成任务：扫读性、一致性、桌面原生习惯高于表达欲。
  品牌感藏在精确的细节里（间距、圆角、文案语气），不做装饰性炫技。
- **产品 slop test（ Earned familiarity）**：类别内熟练用户应能立刻信任这个界面。
  用熟悉的桌面范式（侧栏 + 主内容、Drawer、Dialog），不发明怪异控件。

---

# 2. 设计世界（Visual World）

```text
Things 的轻 + Sunsama 的 calm + Structured 的直观进度 + Apple 的留白克制
```

一句话：**暖中性底色，低饱和点缀，大量留白，层级极简。**

## 2.1 从参考图提取（允许）

- 暖白偏灰的底色，非纯白
- 大面积留白，卡片间明显呼吸感
- 柔和圆角（16–20 主卡片）
- 低饱和 Sage / Dusty Blue / Soft Coral 作为**极小面积**功能点缀
- 状态用轻量视觉表达（轨迹、圆点），不用数字轰炸
- 大点击区域、单线圆润小图标
- 信息密度低，内容「漂浮」而非堆叠

## 2.2 禁止（来自参考图与通用判例）

- 日历/时间轴作为核心布局；左侧密集任务列表；每条任务一张独立卡
- 高饱和粉蓝绿大色块；彩色渐变；AI 紫色霓虹
- 企业 Dashboard 统计卡、红色 Overdue、满屏 checklist
- 彩色 emoji 当 UI 图标、大面积 Sparkle、Confetti / XP / Streak
- 模板感营销页、极端胶囊化 UI、重阴影漂浮 SaaS 卡

---

# 3. Design Tokens（Flutter 级，直接可抄）

实现位置：`lib/core/design/tokens.dart`，全 App 禁止硬编码颜色/间距/圆角。

## 3.1 颜色

```text
// 基础
background        #F7F6F3   页面底（暖白，非纯白）
backgroundAlt     #F2F1ED   侧栏 / 次级面板（第二中性层）
surface           #FFFFFF   卡片 / Drawer
textPrimary       #252522   非纯黑
textSecondary     #74736E
textTertiary      #AAA8A1
border            #E7E5DF   1px 低对比描边

// 项目 Accent（低饱和，仅小面积：圆点 / 节点 / 10–15% 选中底）
accentSage        #A8B9A2
accentDustyBlue   #A8B7C8
accentSoftCoral   #D7AAA2
accentMutedViolet #B6AEC7
accentPaleOchre   #C9B98E

// 语义状态（Operate 必须成套）
success           #8FA98B
warning           #C9B98E
danger            #C98880   仅用于破坏性确认按钮，绝不用于 Overdue 标语
focusRing         #A8B7C8   键盘焦点 2px

// 交互
hoverOverlay      #252522 @ 4%
pressedOverlay    #252522 @ 8%
selectedSurface   项目 Accent @ 12%（或 #EFEEEA 中性）
```

## 3.2 字体（单一家族：SF Pro / macOS 系统字体）

```text
display    28 / 34  Semibold  行高 1.15   页面主标题（每页仅一个）
title      18 / 24  Semibold              区块标题
body       15 / 22  Regular               正文
caption    13 / 18  Regular    textSecondary
micro      12 / 16  Regular    textTertiary
```

规则：固定字号（桌面固定 DPI，不用流式缩放）；层级比 ≤1.2；不做全大写标签；
粗体克制；正文行宽 ≤72ch（约 620–680px）。

## 3.3 间距（4/8 体系）

```text
4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64
页面分区之间 40–64；卡片内 16–24；同组元素 8–12
宁多勿挤：怀疑时加大留白。
```

## 3.4 圆角

```text
small 8（Chip、小按钮）  medium 12（输入框、列表项）  large 18（主卡片）
xl 24（Dialog / Drawer / Preview）
```

## 3.5 描边与阴影

- 主卡片 = `surface + 1px border`，**不用阴影**
- 阴影只给悬浮物：`0 8 24 rgba(37,37,34,0.08)`（Dialog / Drawer / Preview）

## 3.6 动效（解释状态，只有状态）

```text
fast      120–160ms   hover / 按压
standard  180–240ms   展开 / 收起 / 页面切换（淡入 + 4px 位移）
progress  280–420ms   Progress Path 推进、完成点亮
curve     easeOutCubic（禁大弹簧 / 循环动画）
```

impeccable 补充：无页面加载编排动画；加载用 skeleton（见 §5）。

---

# 4. 布局系统

```text
┌──────────────┬─────────────────────────────────────┐
│ Sidebar 224  │   Main（max-width 920，居中）        │
│              │                                     │
│ VEYRA        │   page title                        │
│              │                                     │
│ 周计划        │   …content…                         │
│ 项目          │                                     │
│ 收件箱        │                                     │
│              │                                     │
│ ⚙ 设置       │                                     │
└──────────────┴─────────────────────────────────────┘
```

- Sidebar 固定 224px（220–250 区间），背景 backgroundAlt，右侧 1px border
- Main 内容列 max-width 820–1040（默认 920），两侧留白随窗口增大
- 三档窗口：Small 1100×700（margin 收窄）/ Standard 1440×900 / Wide 1728+（只增留白）
- 禁止横向 overflow；Sidebar 不随大屏变宽
- 当前选中项：浅暖灰底 + 圆角 12，无 badge、无数字、无 AI 入口

---

# 5. 组件状态矩阵（每个交互组件必须全态）

impeccable 硬性要求：所有可交互组件具备以下状态，缺一不可。

| 状态 | 规范 |
|---|---|
| default | surface / 透明底 |
| hover | hoverOverlay 4%，120–160ms |
| pressed | pressedOverlay 8%，无缩放 |
| selected | selectedSurface（Accent 12% 或 #EFEEEA） |
| focus（键盘） | 2px focusRing 外描边，圆角随组件 |
| disabled | 内容 textTertiary @ 60%，无事件 |
| loading | **skeleton 灰块**（#ECEBE7，1.2s 缓慢呼吸），列表页禁用居中 spinner |
| empty | 见 §7 文案（教用户下一步，不说"没有数据"） |
| error | 简短标题 + 一句解释 + 一个动作按钮（§7），永不显示堆栈 |

按钮体系（不全屏 Primary）：

```text
Primary    深炭 #3A3A36 底 / 白字 / 圆角 12   仅：创建项目、应用调整、保存、生成规划
Secondary  surface 底 + 1px border
Tertiary   纯文字按钮（textSecondary，hover 变 textPrimary）
Destructive danger 底白字，仅出现在确认 Dialog 内
```

Dialog 只用于：破坏性确认、新建项目流、必要配置。行内编辑优先 Drawer/内联，Dialog 不嵌套。

---

# 6. 页面规格

## 6.1 Global Shell

- Sidebar（中文，固定顺序）：`VEYRA`（纯文字字标，display 缩小版）→ `周计划` `项目` `收件箱` → 底部 `设置`
- Sidebar 规则：无 badge、无任务数字、无 AI 入口、无二级树
- 窗口 titlebar 保持 macOS 原生；Esc 关闭 Dialog / Drawer；后续可加 ⌘N

## 6.2 Project Focus View（最重要，第一轮唯一实现页面）

```text
← 项目

[Accent 圆点] AI 产品经理求职          ← display 28
拿到 offer，开始投递。                 ← body，textSecondary

            58%                        ← 大而轻的数字，textPrimary

Research ─── 简历 ─── 作品集 ─── 面试 ─── 投递
   ●        ●        ●        ○       ○     ← Progress Path（§6.3）

当前阶段
作品集

接下来
· 完成第一组 Case Study 视觉
· 写作品集介绍页
· 过一遍 AI 架构章节

计划状态
推进正常

查看完整规划 →                        ← Tertiary 文字按钮
```

**只允许显示**：项目名 / Outcome / 整体进度数字 / Phase Path / 当前阶段 /
1–3 个下一步 / 必要时计划状态 / 查看完整规划。
**禁止**：完整 backlog、任务总数、overdue 计数、Deadline 表格、依赖图、统计卡、大按钮堆叠。

## 6.3 Progress Path（品牌视觉重点）

- 用节点轨迹代替百分比条：`●───●───●───○───○`，节点下（或上）标注 Phase 名
- 已完成：实心 Accent 节点 + 实线；当前：实心 + 外圈 2px Accent 30%；未来：1.5px border 空心
- 任务完成时当前节点线段**向前推进 280–420ms**；无彩带、无音效
- 卡片内迷你版：只画节点线，不带文字

## 6.4 Projects 页

```text
项目
你正在推进的路径。

[ 项目卡 ]
  [Accent 点] 求职作品集
  作品集
  ●───●───●───○───○          ← 迷你 Path
  下一步：完成第一组 Case Study 视觉

+ 新建项目                    ← Secondary 虚线卡或文字按钮
```

禁止卡片上出现：`24/52 tasks`、`8 overdue`、`12 days left`、红色 Deadline。
空状态：`还没有项目。` / `从一个目标开始，或者导入你已有的规划。` / `新建项目`

## 6.5 Week 页

```text
本周
9 月 14 日 — 9 月 20 日
容量：正常                    ← 轻量 Chip 行，点开才展开选择

本周三件重要的事

01  雅思                     ← 序号用 textTertiary 等宽
    完成阅读模块 02
    4 个关联任务              ← 折叠，点开才展开支持任务（勾选完成/移出本周）

02  作品集
    完成 Campaign 视觉
    5 个关联任务

03  求职
    准备 AI PM 投递材料
    3 个关联任务

重新平衡本周                  ← Tertiary 文字按钮
本周复盘 →
```

规则：默认 2–5 个目标；不做日历格、不做小时时间轴；不显示"18 个任务"。
空状态：`本周还没有需要你处理的事。` / `加入周规划的项目会出现在这里。`

## 6.6 Inbox 页

```text
收件箱
先放进来，稍后再决定。

[ 又想到了什么？                        + ]

────────────

周五面试准备
建议：AI 产品经理求职            ← 若已转入则显示去向，不显示则无此行
编辑 · 转入已有项目 · 创建为新项目 · 归档 · 删除
```

规则：临时缓冲区，不是邮件客户端；条目不是卡片墙，用分隔线轻列表；
每条只露一行主操作（More 菜单收纳）。
空状态：`收件箱是空的。` / `任何新想法都可以先放在这里。`

## 6.7 Rebalance Preview（AI 产品感最强的页面）

```text
重新平衡
建议了 3 项调整

雅思写作 Task 2
本周 → 下周

作品集视觉
可选 → 必做

周五面试准备
+ 加入本周

[取消]              [应用所选]      ← Primary 只给"应用所选"
```

规则：变化优先、old → new 一目了然、可勾选；不展示 AI 长解释；
调整理由一行小字放卡内（textSecondary）。

## 6.8 Plan View（第二层复杂度，Vertical grouped list，非 Kanban）

```text
01 研究
   ✓ 分析岗位要求
   ✓ 找出差距

02 简历
   ✓ 重写项目经历
   ○ 最终校对

03 作品集
   ● 完成第一组 Case Study     ← ● 当前 / ○ 未来 / ✓ 完成
```

Phase 序号用 textTertiary；已完成行加删除线但不加灰块；保持轻，可折叠。

## 6.9 Review / Progress Story

```text
项目完成
AI 产品经理求职

研究      ✓
简历      ✓
作品集    ✓
面试      ✓
投递      ✓

你做出的东西

一份针对 AI PM 优化的简历
2 个完整 Case Study
一套面试题库
12 个定制投递

历时 24 天 · 完成 31 个任务      ← micro，最后一行
```

安静、有成就感；非游戏庆祝 UI。AI 一句总结放在顶部轻卡片（surface + border）。

## 6.10 New Project 三步流（Dialog 或独立流，一次只问一件事）

```text
Step 1  创建项目 → 你想推进什么？ [项目名称] 继续
Step 2  怎么开始？ 导入已有规划 / 让 VEYRA 帮你规划 / 从空白开始
Step 3  它以什么方式推进？
        仅项目内：留在这个项目里推进
        加入周规划：让它参与你的每周重点
```

## 6.11 Settings（朴素功能页）

```text
设置

AI 服务
Base URL        [ https://open.bigmodel.cn/api/paas/v4 ]
Model           [ GLM-5.3-Flash ]
API Key         [ ●●●●●●●●●●●● ]  已保存在系统安全存储（留空则不修改）
[保存]  [测试连接]

数据位置
~/Library/Application Support/veyra
所有数据保存在本机，VEYRA 不上传任何内容。
```

## 6.12 AI 未配置 / 加载 / 错误

- AI 未配置（无技术错误词）：
  `先配置一下 AI 服务` / `你的项目和周规划不受影响，照常可用。` / `去设置 →`
- AI Loading：`正在生成你的规划…` / `正在读取规划书…` + skeleton，不显示 thinking/agent/工具链
- 错误统一：简短标题 + 一句解释 + 一个动作（例：`这份文件读不了` /
  `可能是扫描件或暂不支持的 PDF 格式。` / `换一个文件`）。永不显示堆栈。

---

# 7. 中文文案总表（实现直接抄，菜单以中文为主）

| 场景 | 文案 |
|---|---|
| 导航 | 周计划 / 项目 / 收件箱 / 设置 |
| 页面标题 | 本周 / 项目 / 收件箱 / 设置 / 完整规划 / 拟调整 / 确认规划草案 / 本周复盘 / 项目复盘 |
| 主按钮 | 新建项目 / 创建 / 保存 / 确认，创建项目 / 应用所选 / 全部应用 / 生成规划草案 / 测试连接 |
| 次按钮 | 查看完整规划 → / 重新平衡 / 本周复盘 → / 项目复盘 / 转入已有项目 / 创建为新项目 / 归档 / 编辑 / 删除 / 取消 |
| 项目卡 | 下一步：… / 暂无下一步 / 加入周规划 / 仅项目内 |
| Week | 本周三件重要的事（按数量：本周两件事 / 三件事…） / X 个关联任务已折叠 / 容量：轻松·正常·忙碌·生存模式 / 移出本周 |
| Inbox | 先放进来，稍后再决定。 / 又想到了什么？ / 建议：… |
| 空状态-项目 | 还没有项目。 / 从一个目标开始，或者导入你已有的规划。 |
| 空状态-周 | 本周还没有需要你处理的事。 / 加入周规划的项目会出现在这里。 |
| 空状态-收件箱 | 收件箱是空的。 / 任何新想法都可以先放在这里。 |
| AI 未配置 | 先配置一下 AI 服务 / 你的项目和周规划不受影响，照常可用。 / 去设置 → |
| AI 加载 | 正在生成你的规划… / 正在读取规划书… / 正在整理本周… |
| AI 完成 SnackBar | 已创建项目：… / 已应用 N 项调整。 / 已保存。Key 存在系统安全存储里。 |
| 错误 | 这份文件读不了 / AI 暂时连不上。检查网络后重试，本地功能不受影响。 / 这份 PDF 加密了，暂时无法读取。 |
| 计划状态 | 推进正常 / 需要关注 / 有延期风险（绝不出现：失败/严重落后/overdue） |

语气规则：温和、短句、说「下一步」而不是「还差多少」；禁 `API_KEY_MISSING / HTTP 401 / FAILED` 出现在 UI。

---

# 8. AI 存在感规则

- 不做「Ask AI」大按钮；AI 动作用**行为名称**：生成规划 / 拆解任务 / 重新平衡 / 生成复盘
- Sparkle 图标：最多一处、小尺寸、辅助；页面主体永远是用户的规划
- AI 结果一律先 Preview 再确认（沿用 Phase 2 流程，视觉上 Preview 是 xl 圆角轻卡片）
- AI 失败绝不阻塞本地功能（Phase 2.10 行为不变，只换文案）

---

# 9. 桌面规范

- hover 120–160ms 轻背景变化；键盘焦点 2px focusRing；Esc 关 Modal/Drawer
- 窗口三档尺寸逐档截图检查（Small/Standard/Wide），无横向 overflow
- 不是移动 App 放大版：点击区域大但不做移动式巨型列表行

---

# 10. 实施顺序与第一轮验收（沿用原规范 §35–36）

```text
01 Design Tokens → 02 Project Focus View → 用户截图验收 → 03 Global Shell
→ 04 Projects → 05 Plan View → 06 Week → 07 Inbox → 08 Rebalance
→ 09 Review → 10 New Project → 11 Settings → 12 Final QA
```

**第一轮只做**：Design Tokens + Project Focus View 最终视觉 + 真实运行 + 三档窗口截图 +
analyze/test + STOP。Focus View 未经用户确认，禁止把设计语言批量推广到其他页面。
禁止：新 AI 功能、附件、Calendar、Today、云同步、登录、新业务表、Planning Engine 重构。

---

# 11. 每页最终判断四问（impeccable 精炼）

1. 用户一次看到的东西是否太多？→ 删。
2. 「还没做的」是否比「正在推进的」更抢眼？→ 改。
3. AI 是否抢了产品主体？→ 降。
4. 3 秒内能否知道「现在该做什么」？→ 不能就是层级错了。

---

# 12. 核心原则

> **不要展示所有东西。展示现在重要的东西。**
> **不要提醒用户还有多少没完成。让用户看到自己已经走到哪里。**
> **不要让 AI 变成产品。让产品本身显得聪明。**
