# DESIGN.md — VEYRA 视觉世界（多巴胺活力与极简高级感）

> 权威来源：已获批的多巴胺设计方案与 docs/VEYRA_UI_Specification_v1.md。

## World

**多巴胺轻快活力 + 瑞士极简高级感（Dopamine Energy & Crisp Swiss Precision）。**
文化坐标：Linear 的精密层级、Things 3 的圆环呼吸感、Apple Human Interface 的克制留白与排版质感。
一句话：纯净冷白的高级桌面画布上，跳跃着清透愉悦的多巴胺电光色彩，让长期规划与推进充满活力与确定感。

## Mode

**Operate**（用户来专注推进）。扫读性、精密一致性、桌面原生习惯优先；去除一切干扰注意力的多余装饰。

## Palette

- **纯净画布**：底色 `#F8FAFC` / 次级背景 `#F1F5F9` / 卡片底色 `#FFFFFF`；发丝细边框 `#E2E8F0`
- **深邃文字**：主标题与重要内容 `#0F172A`（Slate 900）/ 次级文本 `#475569` / 辅助说明 `#94A3B8`
- **多巴胺活力色彩体系**：
  - Electric Iris（电光鸢尾紫）：`#6366F1`（导航高亮、主焦点）
  - Fresh Mint（霓虹薄荷绿）：`#10B981`（完成态、健康进度）
  - Vivid Coral（晚霞活力橙）：`#F97316`（进行中重点、必做微胶囊）
  - Radiant Berry（鲜嫩浆果粉）：`#EC4899`
  - Sky Cyan（晴空电光青）：`#0EA5E9`
  - Deep Violet（极光紫）：`#8B5CF6`
- **Primary 按钮**：深邃深炭 `#0F172A` 白字；高亮聚焦胶囊使用多巴胺浅色底（如 `#EEF2FF` 配 `#6366F1`）。
- **彻底禁用**：陈旧琥珀土黄色、脏黄色底色。

## Type

现代高质感排版。
- display 26/32（tracking: `-0.025em` / `-0.6px`，粗体有力）
- title 17/24（tracking: `-0.02em` / `-0.3px`，半粗）
- body 14–15/20–22（正常字距，呼吸自如）
- caption 12–13/18 · micro 11/14

## Composition

Sidebar 224px（`backgroundAlt` + 1px 细边框）+ 主内容居中（760 / 840 / 920 响应式档位）。
卡片 = 纯白 surface + 1px border (`#E2E8F0`) + 圆角 14–16px + 柔和贴地微阴影；杜绝嵌套卡片。

## Signature

**Progress Path**：精密横贯的里程碑推进缎带。已完成节点使用薄荷绿实心圆点 + 白色对勾；当前活跃节点呈现电光双同心发光圆环；未开始节点为淡灰圆环。

## Bans（Craft Floor 承诺）

1. **禁黄色土色**：无泛黄纸质感，无黄色勋章卡片。
2. **禁 🌟 表情**：彻底移除 `Icons.auto_awesome_rounded` / `Icons.star` 等 emoji 星星图标，改用精密几何图腾。
3. **禁套壳 AI 味**：杜绝浮夸宣传语，文案一律采用人本生产力语言。
4. **禁彩色 border-left > 1px**：卡片与条目一律采用统一边框与内嵌微徽标，拒绝左侧贴粗条。
5. **禁厚重硬偏移阴影与渐变文字**。
