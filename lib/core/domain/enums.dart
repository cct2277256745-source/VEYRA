/// VEYRA 领域枚举。取值严格对齐 PRD §8/§9/§11/§21。
library;

/// PRD §21 Task 状态
enum TaskStatus { planned, active, completed, deferred, skipped }

/// PRD 必做 / 可选（Replanner 可在两者间切换）
enum TaskPriority { must, optional }

/// PRD §17 estimatedEffort
enum EstimatedEffort { small, medium, large }

/// PRD §5.1 两种执行模式
enum ExecutionMode { projectOnly, weeklyPlanning }

/// PRD §21 Project 状态
enum ProjectStatus { active, paused, completed, archived }

/// PRD §21 AI Proposal 状态
enum ProposalStatus { draft, accepted, partiallyAccepted, rejected }

/// PRD §11.2 本周容量
enum CapacityLevel { relaxed, normal, busy, survival }

/// PRD §9.5 Plan Health 三状态
enum PlanHealth { onTrack, needsAttention, atRisk }

/// PRD §10 来源引用类型
enum SourceKind { userQuote, document, aiReason }

/// Inbox 条目类型（PRD §15 Inbox）
enum InboxKind { quickTask, idea, file, screenshot, newGoal }

/// Inbox 条目状态
enum InboxStatus { open, converted, archived }

/// ProgressEvent 类型（成果轨迹的最小事件集）
enum ProgressEventType {
  taskCompleted,
  taskDeferred,
  taskSkipped,
  milestoneCompleted,
  phaseChanged,
  proposalApplied,
  weekRebalanced,
  projectCreated,
  projectStatusChanged,
}

/// ReviewSnapshot 范围（PRD §9.6：周复盘 / 项目复盘）
enum ReviewScope { week, project }
