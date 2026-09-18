import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_scope.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_badge.dart';
import '../../core/domain/entities.dart';
import 'zen_breathing_ring.dart';

enum _ZenMode { focus25, break5, stopwatch }

/// 禅意专注心流页面（Zen Focus Mode）
/// 遵循 impeccable 设计规范与多巴胺极简主义，消除一切侧边栏干扰，沉浸推进当前任务。
class ZenFocusPage extends StatefulWidget {
  const ZenFocusPage({
    super.key,
    required this.project,
    this.phase,
    required this.initialTask,
    this.remainingTasks = const [],
  });

  final Project project;
  final Phase? phase;
  final Task initialTask;
  final List<Task> remainingTasks;

  @override
  State<ZenFocusPage> createState() => _ZenFocusPageState();
}

class _ZenFocusPageState extends State<ZenFocusPage> with AppServicesAccess {
  late Task _currentTask;
  late List<Task> _taskQueue;

  _ZenMode _mode = _ZenMode.focus25;
  int _totalSeconds = 25 * 60;
  int _secondsRemaining = 25 * 60;
  int _stopwatchElapsed = 0;
  bool _isRunning = true;
  Timer? _timer;

  bool _isCompletedState = false;
  bool _completing = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentTask = widget.initialTask;
    _taskQueue = List.of(widget.remainingTasks);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) return;
      setState(() {
        if (_mode == _ZenMode.stopwatch) {
          _stopwatchElapsed++;
        } else {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _isRunning = false;
          }
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _add5Minutes() {
    setState(() {
      if (_mode != _ZenMode.stopwatch) {
        _secondsRemaining += 300;
        _totalSeconds += 300;
      }
    });
  }

  void _resetTimer() {
    setState(() {
      if (_mode == _ZenMode.focus25) {
        _totalSeconds = 25 * 60;
        _secondsRemaining = 25 * 60;
      } else if (_mode == _ZenMode.break5) {
        _totalSeconds = 5 * 60;
        _secondsRemaining = 5 * 60;
      } else {
        _stopwatchElapsed = 0;
      }
      _isRunning = true;
    });
  }

  void _setMode(_ZenMode newMode) {
    setState(() {
      _mode = newMode;
      if (_mode == _ZenMode.focus25) {
        _totalSeconds = 25 * 60;
        _secondsRemaining = 25 * 60;
      } else if (_mode == _ZenMode.break5) {
        _totalSeconds = 5 * 60;
        _secondsRemaining = 5 * 60;
      } else {
        _stopwatchElapsed = 0;
      }
      _isRunning = true;
    });
  }

  Future<void> _completeCurrentTask() async {
    if (_completing) return;
    setState(() => _completing = true);

    try {
      await services.projects.completeTask(_currentTask.id);
    } catch (_) {}

    if (!mounted) return;

    // 触感延迟过渡
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (_taskQueue.isNotEmpty) {
      setState(() {
        _currentTask = _taskQueue.removeAt(0);
        _completing = false;
        _resetTimer();
      });
    } else {
      setState(() {
        _completing = false;
        _isCompletedState = true;
      });
    }
  }

  String _formatTime() {
    if (_mode == _ZenMode.stopwatch) {
      final m = _stopwatchElapsed ~/ 60;
      final s = _stopwatchElapsed % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      final m = _secondsRemaining ~/ 60;
      final s = _secondsRemaining % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
  }

  double _calcProgress() {
    if (_mode == _ZenMode.stopwatch) {
      // 每 60 分钟转一圈
      return (_stopwatchElapsed % 3600) / 3600.0;
    } else {
      if (_totalSeconds <= 0) return 1.0;
      return 1.0 - (_secondsRemaining / _totalSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            _togglePause();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.of(context).pop(true);
          } else if (event.logicalKey == LogicalKeyboardKey.enter &&
              HardwareKeyboard.instance.isMetaPressed) {
            _completeCurrentTask();
          }
        }
      },
      child: Scaffold(
        backgroundColor: VeyraColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 580),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: VeyraSpacing.s24,
                          vertical: VeyraSpacing.s32,
                        ),
                        child: _isCompletedState
                            ? _buildCelebrationView()
                            : _buildFocusView(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
    final leftPadding = isMacOS ? 84.0 : VeyraSpacing.s24;

    return Container(
      padding: EdgeInsets.fromLTRB(
        leftPadding,
        VeyraSpacing.s12,
        VeyraSpacing.s24,
        VeyraSpacing.s12,
      ),
      decoration: const BoxDecoration(
        color: VeyraColors.surface,
        border: Border(bottom: BorderSide(color: VeyraColors.border)),
      ),
      child: Row(
        children: [
          // 左侧：项目与阶段面包屑（安全避让 macOS 原生红绿灯按钮）
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s10,
                vertical: VeyraSpacing.s4,
              ),
              decoration: BoxDecoration(
                color: VeyraColors.backgroundAlt,
                borderRadius: BorderRadius.circular(VeyraRadius.small),
                border: Border.all(color: VeyraColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.folder_outlined,
                      size: 13, color: VeyraColors.textTertiary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      widget.project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: VeyraColors.textSecondary,
                      ),
                    ),
                  ),
                  if (widget.phase != null) ...[
                    const Text(' · ',
                        style: TextStyle(color: VeyraColors.textTertiary)),
                    Flexible(
                      child: Text(
                        widget.phase!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: VeyraColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: VeyraSpacing.s16),
          const Spacer(),

          // 中间：模式切换胶囊
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: VeyraColors.backgroundAlt,
              borderRadius: BorderRadius.circular(VeyraRadius.full),
              border: Border.all(color: VeyraColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeTab('25m 专注', _ZenMode.focus25),
                _buildModeTab('5m 休息', _ZenMode.break5),
                _buildModeTab('正向流', _ZenMode.stopwatch),
              ],
            ),
          ),
          const Spacer(),

          // 右侧：退出按钮
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('退出专注 (Esc)'),
            style: TextButton.styleFrom(
              foregroundColor: VeyraColors.textTertiary,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(String label, _ZenMode mode) {
    final isSelected = _mode == mode;
    return InkWell(
      onTap: () => _setMode(mode),
      borderRadius: BorderRadius.circular(VeyraRadius.full),
      child: AnimatedContainer(
        duration: VeyraMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? VeyraColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(VeyraRadius.full),
          boxShadow: isSelected ? VeyraShadows.subtle : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? VeyraColors.textPrimary
                : VeyraColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildFocusView() {
    final progress = _calcProgress();
    final timeStr = _formatTime();
    final stateLabel = _isRunning
        ? (_mode == _ZenMode.break5 ? '舒缓喘息 · 恢复精力' : '保持专注 · 心流推进中')
        : '心流已暂歇';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 任务焦点 Anchor
        Container(
          padding: const EdgeInsets.all(VeyraSpacing.s20),
          decoration: BoxDecoration(
            color: VeyraColors.surface,
            borderRadius: BorderRadius.circular(VeyraRadius.large),
            border: Border.all(color: VeyraColors.border),
            boxShadow: VeyraShadows.subtle,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VeyraPriorityBadge(priority: _currentTask.priority),
                  const SizedBox(width: VeyraSpacing.s8),
                  Text(
                    '当前攻坚目标 (${_taskQueue.length + 1} 项待办)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: VeyraColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VeyraSpacing.s12),
              AnimatedDefaultTextStyle(
                duration: VeyraMotion.fast,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  color: _completing
                      ? VeyraColors.dopamineMint
                      : VeyraColors.textPrimary,
                  decoration:
                      _completing ? TextDecoration.lineThrough : null,
                ),
                child: Text(
                  _currentTask.title,
                  textAlign: TextAlign.center,
                ),
              ),
              if (_currentTask.description != null &&
                  _currentTask.description!.isNotEmpty) ...[
                const SizedBox(height: VeyraSpacing.s8),
                Text(
                  _currentTask.description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: VeyraColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: VeyraSpacing.s32),

        // 2. 呼吸心流环
        ZenBreathingRing(
          progress: progress,
          timeDisplay: timeStr,
          stateLabel: stateLabel,
          isRunning: _isRunning,
          ringColor: _mode == _ZenMode.break5
              ? VeyraColors.dopamineMint
              : VeyraColors.dopamineIris,
        ),

        const SizedBox(height: VeyraSpacing.s32),

        // 3. 极简控制条
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              tooltip: '重置计时器',
              onPressed: _resetTimer,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
            ),
            const SizedBox(width: VeyraSpacing.s16),
            FilledButton.icon(
              onPressed: _togglePause,
              icon: Icon(
                _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 20,
              ),
              label: Text(_isRunning ? '暂歇 (空格)' : '继续专注 (空格)'),
              style: FilledButton.styleFrom(
                backgroundColor: VeyraColors.primaryButton,
                padding: const EdgeInsets.symmetric(
                  horizontal: VeyraSpacing.s24,
                  vertical: VeyraSpacing.s14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(VeyraRadius.full),
                ),
              ),
            ),
            if (_mode != _ZenMode.stopwatch) ...[
              const SizedBox(width: VeyraSpacing.s16),
              Tooltip(
                message: '增加 5 分钟',
                child: OutlinedButton(
                  onPressed: _add5Minutes,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VeyraSpacing.s14,
                      vertical: VeyraSpacing.s14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(VeyraRadius.full),
                    ),
                  ),
                  child: const Text('+5 分钟'),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: VeyraSpacing.s24),

        // 4. Things 3 风格完成任务主按钮
        InkWell(
          onTap: _completing ? null : _completeCurrentTask,
          borderRadius: BorderRadius.circular(VeyraRadius.large),
          child: AnimatedContainer(
            duration: VeyraMotion.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: VeyraSpacing.s20,
              vertical: VeyraSpacing.s12,
            ),
            decoration: BoxDecoration(
              color: _completing
                  ? VeyraColors.selectedSurface(VeyraColors.dopamineMint)
                  : VeyraColors.surface,
              borderRadius: BorderRadius.circular(VeyraRadius.large),
              border: Border.all(
                color: _completing
                    ? VeyraColors.dopamineMint
                    : VeyraColors.border,
                width: 1.5,
              ),
              boxShadow: VeyraShadows.subtle,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _completing
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 18,
                  color: _completing
                      ? VeyraColors.dopamineMint
                      : VeyraColors.textSecondary,
                ),
                const SizedBox(width: VeyraSpacing.s8),
                Text(
                  _completing ? '已完成！正在切换下一项行动...' : '标记任务已达成 (⌘ + Enter)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _completing
                        ? const Color(0xFF047857)
                        : VeyraColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationView() {
    return Container(
      padding: const EdgeInsets.all(VeyraSpacing.s32),
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        border: Border.all(color: VeyraColors.border),
        boxShadow: VeyraShadows.subtle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VeyraColors.selectedSurface(VeyraColors.dopamineMint),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 36,
              color: VeyraColors.dopamineMint,
            ),
          ),
          const SizedBox(height: VeyraSpacing.s20),
          const Text(
            '心流圆满完成',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: VeyraColors.textPrimary,
            ),
          ),
          const SizedBox(height: VeyraSpacing.s8),
          const Text(
            '当前阶段的所有待办任务已全部落实！保持这份专注节奏。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: VeyraColors.textSecondary,
            ),
          ),
          const SizedBox(height: VeyraSpacing.s24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('返回项目'),
            style: FilledButton.styleFrom(
              backgroundColor: VeyraColors.primaryButton,
              padding: const EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s24,
                vertical: VeyraSpacing.s12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(VeyraRadius.medium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
