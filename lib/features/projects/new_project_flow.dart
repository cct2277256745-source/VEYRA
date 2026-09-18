/// 新建项目渐进式流程（UI Specification §30）：
/// Step 1 你想完成什么？ → Step 2 你想怎么开始？ → Step 3 这个项目怎么执行？
/// 上传 / AI 路径沿用既有业务逻辑（导入、校验、Preview → 确认），不新增能力。
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../ai/ai_provider.dart';
import '../../ai/ai_unconfigured.dart';
import '../../ai/plan_application_service.dart';
import '../../ai/plan_models.dart';
import '../../app/app_scope.dart';
import '../../core/design/tokens.dart';
import '../../core/design/veyra_motion.dart';
import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../import/document_import_service.dart';
import 'plan_preview_page.dart';

class NewProjectFlowDialog extends StatefulWidget {
  const NewProjectFlowDialog({super.key});

  @override
  State<NewProjectFlowDialog> createState() => _NewProjectFlowDialogState();
}

enum _NewProjectStep { title, startChoice, aiDescribe, aiBlueprint, execution }

class _NewProjectFlowDialogState extends State<NewProjectFlowDialog> {
  final _titleController = TextEditingController();
  final _outcomeController = TextEditingController();
  final _backgroundController = TextEditingController();
  final _constraintsController = TextEditingController();
  _NewProjectStep _step = _NewProjectStep.title;
  bool _weekly = false;
  int? _sourceDocumentId;
  String? _error;
  String? _uploadedFileName;
  ExtractedPlanFile? _uploadedExtractedPlan;
  bool _loadingAi = false;
  String _aiLoadingMessage = '';
  List<PlanPhaseDraft> _blueprintPhases = [];
  String _selectedDuration = '8周系统冲刺';
  String _selectedPace = '稳健均衡 (1-2h/天)';
  String _selectedBase = '有理论，缺实战落地';

  @override
  void dispose() {
    _titleController.dispose();
    _outcomeController.dispose();
    _backgroundController.dispose();
    _constraintsController.dispose();
    super.dispose();
  }

  void _showNotConfigured() => showAiNotConfigured(context);

  Future<void> _startUpload() async {
    final services = AppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'md', 'markdown', 'pdf', 'docx'],
        withData: true,
      );
      if (!mounted || result == null || result.files.isEmpty) return;

      final file = result.files.single;
      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        final localFile = File(file.path!);
        if (await localFile.exists()) {
          fileBytes = await localFile.readAsBytes();
        }
      }

      if (fileBytes == null) {
        messenger.showSnackBar(const SnackBar(content: Text('未能读取文件内容，请检查文件权限或重试')));
        return;
      }

      final name = file.name;
      final service = DocumentImportService(
        saveSourceDocument: (extracted) async =>
            (await services.sourceDocuments.create(
          fileName: extracted.fileName,
          fileKind: extracted.fileKind,
          extractedText: extracted.text,
        )).id,
      );
      final extracted =
          await service.importFromBytes(fileBytes, name);
      if (!mounted) return;
      _sourceDocumentId =
          (await services.sourceDocuments.getByName(name))?.id;
      _uploadedFileName = name;
      if (_titleController.text.trim().isEmpty) {
        final base = name.contains('.')
            ? name.substring(0, name.lastIndexOf('.'))
            : name;
        _titleController.text = base;
      }
      setState(() {
        _step = _NewProjectStep.execution;
      });
      // 展示提取文本，并提供 AI 解析入口（带瞬时反馈、清晰 Loading 卡片与防并发）。
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) {
          var isParsing = false;
          String? parseError;

          return StatefulBuilder(
            builder: (ctx, setDialogState) {
              Future<void> triggerParse() async {
                // 1. 同步立即切换为加载态，彻底杜绝无响应与重复点击
                setDialogState(() {
                  isParsing = true;
                  parseError = null;
                });

                try {
                  final provider = await AIScope.of(ctx).createOrNull();
                  if (!dialogCtx.mounted) return;
                  if (provider == null) {
                    setDialogState(() {
                      isParsing = false;
                      parseError = 'AI 尚未配置，请先前往设置填入 API Key。';
                    });
                    _showNotConfigured();
                    return;
                  }

                  final planService = PlanApplicationService(
                    services: services,
                    provider: provider,
                  );

                  final planFile = ExtractedPlanFile(
                    fileName: extracted.fileName,
                    text: extracted.text,
                  );

                  final blueprint = await planService.generateBlueprintFromFile(
                    file: planFile,
                  );

                  if (!dialogCtx.mounted) return;
                  Navigator.of(dialogCtx).pop();
                  if (!mounted) return;

                  setState(() {
                    _uploadedExtractedPlan = planFile;
                    _blueprintPhases = List.of(blueprint.phases);
                    if (blueprint.suggestedMode == SuggestedExecutionMode.weeklyPlanning) {
                      _weekly = true;
                    }
                    _step = _NewProjectStep.aiBlueprint;
                  });
                } catch (e) {
                  if (dialogCtx.mounted) {
                    setDialogState(() {
                      isParsing = false;
                      parseError = '$e';
                    });
                  }
                }
              }

              return PopScope(
                canPop: !isParsing,
                child: AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        isParsing
                            ? Icons.hourglass_top_rounded
                            : (parseError != null
                                ? Icons.warning_amber_rounded
                                : Icons.description_outlined),
                        size: 20,
                        color: parseError != null
                            ? VeyraColors.danger
                            : VeyraColors.accentDustyBlue,
                      ),
                      const SizedBox(width: VeyraSpacing.s8),
                      Expanded(
                        child: Text(
                          isParsing
                              ? '正在解析文档规划...'
                              : '已导入：$name',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: 440,
                    child: isParsing
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: VeyraSpacing.s24,
                                horizontal: VeyraSpacing.s8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(strokeWidth: 3),
                                ),
                                const SizedBox(height: VeyraSpacing.s20),
                                const Text(
                                  '正在提炼阶段架构与里程碑',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: VeyraColors.textPrimary),
                                ),
                                const SizedBox(height: VeyraSpacing.s8),
                                Text(
                                  'AI 正在分析「$name」，提炼核心战略阶段与关键里程碑...',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: VeyraColors.textSecondary),
                                ),
                                const SizedBox(height: VeyraSpacing.s16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: VeyraSpacing.s12,
                                      vertical: VeyraSpacing.s8),
                                  decoration: BoxDecoration(
                                    color: VeyraColors.surface,
                                    borderRadius:
                                        BorderRadius.circular(VeyraRadius.small),
                                    border: Border.all(color: VeyraColors.border),
                                  ),
                                  child: const Text(
                                    '完成后将进入「阶段架构确认门禁」，供你审查和增删阶段',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: VeyraColors.textTertiary),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (parseError != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(VeyraSpacing.s12),
                                  decoration: BoxDecoration(
                                    color: VeyraColors.danger.withValues(alpha: 0.08),
                                    borderRadius:
                                        BorderRadius.circular(VeyraRadius.small),
                                    border: Border.all(
                                        color: VeyraColors.danger
                                            .withValues(alpha: 0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.error_outline,
                                              size: 16,
                                              color: VeyraColors.danger),
                                          SizedBox(width: VeyraSpacing.s8),
                                          Text('AI 解析未完成',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: VeyraColors.danger)),
                                        ],
                                      ),
                                      const SizedBox(height: VeyraSpacing.s4),
                                      Text(parseError!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: VeyraColors.textPrimary)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: VeyraSpacing.s12),
                              ],
                              Text(
                                '已成功提取 ${extracted.text.length} 字符，请确认文档内容或直接由 AI 解析为结构化规划：',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: VeyraColors.textSecondary),
                              ),
                              const SizedBox(height: VeyraSpacing.s8),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 180),
                                child: Container(
                                  padding: const EdgeInsets.all(VeyraSpacing.s12),
                                  decoration: BoxDecoration(
                                    color: VeyraColors.surface,
                                    borderRadius:
                                        BorderRadius.circular(VeyraRadius.small),
                                    border: Border.all(color: VeyraColors.border),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      extracted.text.length > 1200
                                          ? '${extracted.text.substring(0, 1200)}…'
                                          : extracted.text,
                                      style: const TextStyle(
                                          fontSize: 12, height: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  actions: [
                    if (!isParsing) ...[
                      TextButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(),
                        child: const Text('跳过，直接创建空白项目'),
                      ),
                      FilledButton.icon(
                        icon: Icon(
                            parseError != null
                                ? Icons.refresh_rounded
                                : Icons.alt_route_rounded,
                            size: 16),
                        label: Text(parseError != null
                            ? '重试提炼'
                            : '提炼阶段架构并确认'),
                        onPressed: triggerParse,
                      ),
                    ] else ...[
                      const FilledButton(
                        onPressed: null,
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      );
    } on ImportException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.reason)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('打开文件选择器失败: $e')));
    }
  }

  String _buildCombinedBackground() {
    final parts = <String>[];
    if (_selectedBase.isNotEmpty) {
      parts.add('基础起点：$_selectedBase');
    }
    final custom = _backgroundController.text.trim();
    if (custom.isNotEmpty) {
      parts.add(custom);
    }
    return parts.join('；');
  }

  String _buildCombinedConstraints() {
    final parts = <String>[];
    if (_selectedDuration.isNotEmpty) {
      parts.add('攻坚周期：$_selectedDuration');
    }
    if (_selectedPace.isNotEmpty) {
      parts.add('日常投入：$_selectedPace');
    }
    final custom = _constraintsController.text.trim();
    if (custom.isNotEmpty) {
      parts.add(custom);
    }
    return parts.join('；');
  }

  Future<void> _generateBlueprint() async {
    final services = AppScope.of(context);
    final aiFactory = AIScope.of(context);
    setState(() {
      _loadingAi = true;
      _aiLoadingMessage = '正在深入分析目标，提炼战略阶段架构与里程碑...';
      _error = null;
    });
    try {
      final provider = await aiFactory.createOrNull();
      if (!mounted) return;
      if (provider == null) {
        setState(() => _loadingAi = false);
        _showNotConfigured();
        return;
      }
      final planService = PlanApplicationService(
        services: services,
        provider: provider,
      );
      final goal = _titleController.text.trim();
      final outcome = _outcomeController.text.trim();
      final background = _buildCombinedBackground();
      final constraints = _buildCombinedConstraints();

      final draft = await planService.generateBlueprint(
        AIBuildPlanRequest(
          goal: goal,
          outcome: outcome.isNotEmpty ? outcome : null,
          background: background.isNotEmpty ? background : null,
          constraints: constraints.isNotEmpty ? constraints : null,
        ),
      );
      if (!mounted) return;
      setState(() {
        _blueprintPhases = List.of(draft.phases);
        if (draft.suggestedMode == SuggestedExecutionMode.weeklyPlanning) {
          _weekly = true;
        }
        _step = _NewProjectStep.aiBlueprint;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) {
        setState(() => _loadingAi = false);
      }
    }
  }

  Future<void> _confirmBlueprintAndGenerateTasks() async {
    if (_blueprintPhases.isEmpty) {
      setState(() => _error = '请至少保留一个阶段。');
      return;
    }
    final services = AppScope.of(context);
    final aiFactory = AIScope.of(context);
    setState(() {
      _loadingAi = true;
      _aiLoadingMessage = '已确认阶段架构，正在细化各阶段具体执行任务...';
      _error = null;
    });
    try {
      final provider = await aiFactory.createOrNull();
      if (!mounted) return;
      if (provider == null) {
        setState(() => _loadingAi = false);
        _showNotConfigured();
        return;
      }
      final planService = PlanApplicationService(
        services: services,
        provider: provider,
      );
      final goal = _titleController.text.trim();
      final outcome = _outcomeController.text.trim();
      final background = _buildCombinedBackground();
      final constraints = _buildCombinedConstraints();

      final proposal = _uploadedExtractedPlan != null
          ? await planService.generateFromFile(
              file: _uploadedExtractedPlan!,
              confirmedPhases: _blueprintPhases,
            )
          : await planService.generateFromGoal(
              AIBuildPlanRequest(
                goal: goal,
                outcome: outcome.isNotEmpty ? outcome : null,
                background: background.isNotEmpty ? background : null,
                constraints: constraints.isNotEmpty ? constraints : null,
                confirmedPhases: _blueprintPhases,
              ),
            );
      if (!mounted) return;
      final created = await Navigator.of(context).push<Project>(
        VeyraPageRoute(
            builder: (_) => PlanPreviewPage(proposalId: proposal.id)),
      );
      if (created != null && mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) {
        setState(() => _loadingAi = false);
      }
    }
  }

  void _appendConstraint(String tag) {
    final current = _constraintsController.text.trim();
    setState(() {
      if (current.isEmpty) {
        _constraintsController.text = tag;
      } else if (!current.contains(tag)) {
        _constraintsController.text = '$current；$tag';
      }
    });
  }

  void _appendBackground(String tag) {
    final current = _backgroundController.text.trim();
    setState(() {
      if (current.isEmpty) {
        _backgroundController.text = tag;
      } else if (!current.contains(tag)) {
        _backgroundController.text = '$current；$tag';
      }
    });
  }

  Future<void> _createBlank() async {
    final services = AppScope.of(context);
    await services.projects.createProject(
      title: _titleController.text.trim(),
      executionMode:
          _weekly ? ExecutionMode.weeklyPlanning : ExecutionMode.projectOnly,
      sourceDocumentId: _sourceDocumentId,
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(switch (_step) {
        _NewProjectStep.title => '创建项目',
        _NewProjectStep.startChoice => '你想怎么开始？',
        _NewProjectStep.aiDescribe => '让 VEYRA 帮我规划 · 意图对齐',
        _NewProjectStep.aiBlueprint => '阶段架构与里程碑确认',
        _NewProjectStep.execution => '这个项目怎么执行？',
      }),
      content: SizedBox(
        width: (_step == _NewProjectStep.aiDescribe || _step == _NewProjectStep.aiBlueprint)
            ? 560
            : 440,
        child: AnimatedSize(
          duration: VeyraMotion.standard,
          curve: VeyraMotion.curveInOut,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: VeyraFadeSwitcher(
            duration: VeyraMotion.fast,
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: switch (_step) {
                _NewProjectStep.title => _step1(),
                _NewProjectStep.startChoice => _step2(),
                _NewProjectStep.aiDescribe => _stepAiDescribe(),
                _NewProjectStep.aiBlueprint => _stepAiBlueprint(),
                _NewProjectStep.execution => _step3(),
              },
            ),
          ),
        ),
      ),
      actions: _actions(),
    );
  }

  Widget _step1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('你想完成什么？',
            style: TextStyle(fontSize: 15, color: VeyraColors.textSecondary)),
        const SizedBox(height: VeyraSpacing.s12),
        TextField(
          controller: _titleController,
          autofocus: true,
          decoration: const InputDecoration(labelText: '项目名称'),
          onChanged: (_) => setState(() {}),
        ),
        if (_error != null) ...[
          const SizedBox(height: VeyraSpacing.s8),
          Text(_error!,
              style: const TextStyle(color: VeyraColors.danger, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _step2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StartOption(
          icon: Icons.upload_file,
          title: '上传已有规划',
          subtitle: 'TXT / Markdown / PDF / DOCX',
          onTap: _startUpload,
        ),
        const SizedBox(height: VeyraSpacing.s8),
        _StartOption(
          icon: Icons.alt_route_rounded,
          title: '让 VEYRA 帮我规划',
          subtitle: '描述目标，智能生成草案，确认后才创建',
          onTap: () {
            if (_outcomeController.text.trim().isEmpty) {
              _outcomeController.text = _titleController.text.trim();
            }
            setState(() {
              _step = _NewProjectStep.aiDescribe;
              _error = null;
            });
          },
        ),
        const SizedBox(height: VeyraSpacing.s8),
        _StartOption(
          icon: Icons.edit_note_rounded,
          title: '从空白开始',
          subtitle: '手动创建阶段与任务，自主规划',
          onTap: () => setState(() {
            _step = _NewProjectStep.execution;
            _error = null;
          }),
        ),
        if (_uploadedFileName != null) ...[
          const SizedBox(height: VeyraSpacing.s8),
          Text('已导入 $_uploadedFileName，继续选择执行方式。',
              style: const TextStyle(
                  fontSize: 13, color: VeyraColors.textSecondary)),
        ],
        if (_error != null) ...[
          const SizedBox(height: VeyraSpacing.s8),
          Text(_error!,
              style: const TextStyle(color: VeyraColors.danger, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _stepAiDescribe() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.70,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s12,
                vertical: VeyraSpacing.s8,
              ),
              decoration: BoxDecoration(
                color: VeyraColors.backgroundAlt,
                borderRadius: BorderRadius.circular(VeyraRadius.small),
                border: Border.all(color: VeyraColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag_outlined,
                      size: 16, color: VeyraColors.accentDustyBlue),
                  const SizedBox(width: VeyraSpacing.s8),
                  Expanded(
                    child: Text(
                      '项目目标：${_titleController.text.trim()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: VeyraColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: VeyraSpacing.s14),

            // 1. 计划攻坚周期
            const Text(
              '1. 计划攻坚周期（点击快速选择）',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VeyraColors.textSecondary,
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            Wrap(
              spacing: VeyraSpacing.s8,
              runSpacing: VeyraSpacing.s6,
              children: [
                _SelectablePill(
                  label: '4周快速攻坚',
                  icon: Icons.bolt_rounded,
                  isSelected: _selectedDuration == '4周快速攻坚',
                  onTap: () => setState(() => _selectedDuration = '4周快速攻坚'),
                ),
                _SelectablePill(
                  label: '8周系统冲刺',
                  icon: Icons.track_changes_rounded,
                  isSelected: _selectedDuration == '8周系统冲刺' || _selectedDuration == '8周冲刺',
                  onTap: () => setState(() => _selectedDuration = '8周系统冲刺'),
                ),
                _SelectablePill(
                  label: '12周季度攻坚',
                  icon: Icons.calendar_month_rounded,
                  isSelected: _selectedDuration == '12周季度攻坚',
                  onTap: () => setState(() => _selectedDuration = '12周季度攻坚'),
                ),
                _SelectablePill(
                  label: '长期习惯推进',
                  icon: Icons.loop_rounded,
                  isSelected: _selectedDuration == '长期习惯推进',
                  onTap: () => setState(() => _selectedDuration = '长期习惯推进'),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s14),

            // 2. 日常精力与时间投入
            const Text(
              '2. 日常精力与时间投入（点击快速选择）',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VeyraColors.textSecondary,
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            Wrap(
              spacing: VeyraSpacing.s8,
              runSpacing: VeyraSpacing.s6,
              children: [
                _SelectablePill(
                  label: '轻量碎片 (30-45m/天)',
                  icon: Icons.coffee_rounded,
                  isSelected: _selectedPace.contains('轻量'),
                  onTap: () => setState(() => _selectedPace = '轻量碎片 (30-45m/天)'),
                ),
                _SelectablePill(
                  label: '稳健均衡 (1-2h/天)',
                  icon: Icons.hourglass_bottom_rounded,
                  isSelected: _selectedPace.contains('稳健'),
                  onTap: () => setState(() => _selectedPace = '稳健均衡 (1-2h/天)'),
                ),
                _SelectablePill(
                  label: '深度全职 (3h+/天)',
                  icon: Icons.rocket_launch_rounded,
                  isSelected: _selectedPace.contains('深度'),
                  onTap: () => setState(() => _selectedPace = '深度全职 (3h+/天)'),
                ),
                _SelectablePill(
                  label: '仅周末集中攻坚',
                  icon: Icons.weekend_rounded,
                  isSelected: _selectedPace.contains('周末'),
                  onTap: () => setState(() => _selectedPace = '仅周末集中攻坚'),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s14),

            // 3. 当前基础与现状
            const Text(
              '3. 当前基础与现状（点击快速选择）',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: VeyraColors.textSecondary,
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            Wrap(
              spacing: VeyraSpacing.s8,
              runSpacing: VeyraSpacing.s6,
              children: [
                _SelectablePill(
                  label: '零基础新手起步',
                  icon: Icons.spa_rounded,
                  isSelected: _selectedBase.contains('零基础'),
                  onTap: () => setState(() => _selectedBase = '零基础新手起步，需循序渐进'),
                ),
                _SelectablePill(
                  label: '有理论，缺实战落地',
                  icon: Icons.menu_book_rounded,
                  isSelected: _selectedBase.contains('有理论'),
                  onTap: () => setState(() => _selectedBase = '有一定理论基础，重在实战练习'),
                ),
                _SelectablePill(
                  label: '已有框架，查漏补缺',
                  icon: Icons.check_circle_outline_rounded,
                  isSelected: _selectedBase.contains('查漏补缺'),
                  onTap: () => setState(() => _selectedBase = '已有完整框架，处于查漏补缺阶段'),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s14),

            // 4. 预期成果与具体交付
            TextField(
              controller: _outcomeController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '4. 预期成果与具体交付（想达成什么结果？）',
                hintText: '例如：总分 7.5（听力阅读 8.5/写作口语 6.5），刷完真题并整理错题集',
                helperText: '明确具体的交付物，AI 规划质量会显著提高',
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            Wrap(
              spacing: VeyraSpacing.s8,
              runSpacing: VeyraSpacing.s4,
              children: [
                _QuickTagChip(
                  label: '考试/考证通关',
                  onTap: () => setState(() => _outcomeController.text = '系统备考并顺利通过考证，刷完历年真题与错题'),
                ),
                _QuickTagChip(
                  label: '独立产品上线',
                  onTap: () => setState(() => _outcomeController.text = '独立完成 MVP 产品开发、测试并发布上线'),
                ),
                _QuickTagChip(
                  label: '掌握核心技能',
                  onTap: () => setState(() => _outcomeController.text = '系统掌握核心原理与工程实战，产出完整作品'),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s14),

            // 5. 更多个人想法与时间与节奏约束
            TextField(
              controller: _constraintsController,
              minLines: 1,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '5. 更多想法或特殊约束（时间与节奏约束，可选）',
                hintText: '例如：工作日只有晚间有空、第3周需外出减负、希望前期侧重网课后期实战...',
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            Wrap(
              spacing: VeyraSpacing.s8,
              runSpacing: VeyraSpacing.s4,
              children: [
                _QuickTagChip(
                  label: '8周冲刺',
                  onTap: () => _appendConstraint('8周冲刺'),
                ),
                _QuickTagChip(
                  label: '3个月稳扎稳打',
                  onTap: () => _appendConstraint('3个月周期'),
                ),
                _QuickTagChip(
                  label: '工作日每晚 1-2h',
                  onTap: () => _appendConstraint('工作日每晚 1-2 小时'),
                ),
                _QuickTagChip(
                  label: '零基础起步',
                  onTap: () => _appendBackground('零基础起步，需循序渐进'),
                ),
              ],
            ),
            const SizedBox(height: VeyraSpacing.s12),
            InkWell(
              borderRadius: BorderRadius.circular(VeyraRadius.small),
              onTap: () => setState(() => _weekly = !_weekly),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: VeyraSpacing.s4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _weekly,
                        onChanged: (v) => setState(() => _weekly = v ?? false),
                      ),
                    ),
                    const SizedBox(width: VeyraSpacing.s8),
                    const Expanded(
                      child: Text(
                        '同时加入周规划（将第一阶段行动排入每周重点）',
                        style: TextStyle(
                            fontSize: 13, color: VeyraColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_loadingAi) ...[
              const SizedBox(height: VeyraSpacing.s12),
              Container(
                padding: const EdgeInsets.all(VeyraSpacing.s16),
                decoration: BoxDecoration(
                  color: VeyraColors.selectedSurface(VeyraColors.accentDustyBlue),
                  borderRadius: BorderRadius.circular(VeyraRadius.medium),
                  border: Border.all(
                      color: VeyraColors.accentDustyBlue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: VeyraSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _aiLoadingMessage.isNotEmpty
                                ? _aiLoadingMessage
                                : '正在提炼「${_titleController.text.trim()}」阶段架构...',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: VeyraColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '提炼 2~4 个战术攻坚阶段与核心里程碑，供你在生成具体任务前确认。',
                            style: TextStyle(
                              fontSize: 12,
                              color: VeyraColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: VeyraSpacing.s12),
              Text(_error!,
                  style:
                      const TextStyle(color: VeyraColors.danger, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }

  void _addBlueprintPhase() {
    setState(() {
      _blueprintPhases.add(PlanPhaseDraft(
        title: '阶段 ${_blueprintPhases.length + 1}',
        goal: '设定该阶段核心产出目标',
        milestones: const ['阶段里程碑达成'],
        tasks: const [],
      ));
    });
  }

  Widget _stepAiBlueprint() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.65,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: VeyraSpacing.s12,
              vertical: VeyraSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: VeyraColors.selectedSurface(VeyraColors.accentDustyBlue),
              borderRadius: BorderRadius.circular(VeyraRadius.small),
              border: Border.all(
                  color: VeyraColors.accentDustyBlue.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined,
                    size: 16, color: VeyraColors.accentDustyBlue),
                const SizedBox(width: VeyraSpacing.s8),
                Expanded(
                  child: Text(
                    _uploadedFileName != null
                        ? '从文档「$_uploadedFileName」提炼的阶段架构 · 共 ${_blueprintPhases.length} 个阶段'
                        : '阶段架构对齐 · 共 ${_blueprintPhases.length} 个阶段',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: VeyraColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: VeyraSpacing.s12),
          const Text(
            '这是 AI 提炼的战略阶段架构。请确认或微调各阶段方向；确认后将为你细化各阶段的执行任务清单：',
            style: TextStyle(
                fontSize: 13, color: VeyraColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: VeyraSpacing.s12),
          for (var i = 0; i < _blueprintPhases.length; i++) ...[
            _buildPhaseBlueprintCard(i, _blueprintPhases[i]),
            const SizedBox(height: VeyraSpacing.s8),
          ],
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 14),
                label: const Text('添加阶段', style: TextStyle(fontSize: 12)),
                onPressed: _loadingAi ? null : _addBlueprintPhase,
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(VeyraRadius.small),
                onTap: _loadingAi
                    ? null
                    : () => setState(() => _weekly = !_weekly),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: VeyraSpacing.s8, vertical: VeyraSpacing.s4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _weekly
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 16,
                        color: _weekly
                            ? VeyraColors.accentDustyBlue
                            : VeyraColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _weekly ? '建议：加入周规划' : '仅项目内执行',
                        style: TextStyle(
                          fontSize: 12,
                          color: _weekly
                              ? VeyraColors.textPrimary
                              : VeyraColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_loadingAi) ...[
            const SizedBox(height: VeyraSpacing.s12),
            Container(
              padding: const EdgeInsets.all(VeyraSpacing.s16),
              decoration: BoxDecoration(
                color: VeyraColors.selectedSurface(VeyraColors.accentDustyBlue),
                borderRadius: BorderRadius.circular(VeyraRadius.medium),
                border: Border.all(
                    color: VeyraColors.accentDustyBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(width: VeyraSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _aiLoadingMessage.isNotEmpty
                              ? _aiLoadingMessage
                              : '已确认阶段架构，正在细化执行任务...',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: VeyraColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'AI 正在按已确认的阶段结构，拆解出高执行力、带优先级的子任务',
                          style: TextStyle(
                              fontSize: 12, color: VeyraColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: VeyraSpacing.s8),
            Container(
              padding: const EdgeInsets.all(VeyraSpacing.s12),
              decoration: BoxDecoration(
                color: VeyraColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(VeyraRadius.small),
                border: Border.all(
                    color: VeyraColors.danger.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      size: 16, color: VeyraColors.danger),
                  const SizedBox(width: VeyraSpacing.s8),
                  Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            fontSize: 12, color: VeyraColors.danger)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildPhaseBlueprintCard(int index, PlanPhaseDraft phase) {
    return Container(
      padding: const EdgeInsets.all(VeyraSpacing.s12),
      decoration: BoxDecoration(
        color: VeyraColors.surface,
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        border: Border.all(color: VeyraColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: VeyraColors.backgroundAlt,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '阶段 ${index + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: VeyraColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: VeyraSpacing.s8),
              Expanded(
                child: TextFormField(
                  key: ValueKey('phase_title_${index}_${phase.title}'),
                  initialValue: phase.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: VeyraColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                    hintText: '阶段名称',
                  ),
                  onChanged: (val) {
                    _blueprintPhases[index] =
                        phase.copyWith(title: val.trim());
                  },
                ),
              ),
              if (_blueprintPhases.length > 1) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 16, color: VeyraColors.textTertiary),
                  tooltip: '删除此阶段',
                  splashRadius: 16,
                  onPressed: _loadingAi
                      ? null
                      : () {
                          setState(() {
                            _blueprintPhases.removeAt(index);
                          });
                        },
                ),
              ],
            ],
          ),
          if (phase.goal != null && phase.goal!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '目标：${phase.goal}',
              style: const TextStyle(
                  fontSize: 12, color: VeyraColors.textSecondary),
            ),
          ],
          if (phase.milestones.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: phase.milestones
                  .map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: VeyraColors.dopamineMint.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flag_outlined,
                                size: 10, color: VeyraColors.dopamineMint),
                            const SizedBox(width: 4),
                            Text(m,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: VeyraColors.dopamineMint)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _step3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(VeyraRadius.medium),
          onTap: () => setState(() => _weekly = false),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(VeyraSpacing.s16),
            decoration: BoxDecoration(
              color: !_weekly
                  ? VeyraColors.selectedSurface(VeyraColors.accentDustyBlue)
                  : VeyraColors.surface,
              borderRadius: BorderRadius.circular(VeyraRadius.medium),
              border: Border.all(
                  color: !_weekly
                      ? VeyraColors.accentDustyBlue
                      : VeyraColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('仅项目内执行',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: VeyraColors.textPrimary)),
                SizedBox(height: VeyraSpacing.s4),
                Text('只存在这个项目内部。',
                    style: TextStyle(
                        fontSize: 13, color: VeyraColors.textSecondary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: VeyraSpacing.s8),
        InkWell(
          borderRadius: BorderRadius.circular(VeyraRadius.medium),
          onTap: () => setState(() => _weekly = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(VeyraSpacing.s16),
            decoration: BoxDecoration(
              color: _weekly
                  ? VeyraColors.selectedSurface(VeyraColors.accentDustyBlue)
                  : VeyraColors.surface,
              borderRadius: BorderRadius.circular(VeyraRadius.medium),
              border: Border.all(
                  color: _weekly
                      ? VeyraColors.accentDustyBlue
                      : VeyraColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('加入周规划',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: VeyraColors.textPrimary)),
                SizedBox(height: VeyraSpacing.s4),
                Text('让它进入每周重点。',
                    style: TextStyle(
                        fontSize: 13, color: VeyraColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _actions() {
    switch (_step) {
      case _NewProjectStep.title:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: _goStep2,
            child: const Text('继续'),
          ),
        ];
      case _NewProjectStep.startChoice:
        return [
          TextButton(
            onPressed: () => setState(() {
              _step = _NewProjectStep.title;
              _error = null;
            }),
            child: const Text('上一步'),
          ),
        ];
      case _NewProjectStep.aiDescribe:
        return [
          TextButton(
            onPressed: _loadingAi
                ? null
                : () => setState(() {
                      _step = _NewProjectStep.startChoice;
                      _error = null;
                    }),
            child: const Text('上一步'),
          ),
          FilledButton.icon(
            icon: _loadingAi
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.alt_route_rounded, size: 16),
            label: Text(_loadingAi ? '正在提炼...' : '下一步：生成阶段蓝图'),
            onPressed: _loadingAi ? null : _generateBlueprint,
          ),
        ];
      case _NewProjectStep.aiBlueprint:
        return [
          TextButton(
            onPressed: _loadingAi
                ? null
                : () => setState(() {
                      _step = _NewProjectStep.aiDescribe;
                      _error = null;
                    }),
            child: const Text('返回修改输入'),
          ),
          FilledButton.icon(
            icon: _loadingAi
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline, size: 16),
            label: Text(_loadingAi ? '正在细化任务...' : '确认阶段，细化任务'),
            onPressed: _loadingAi ? null : _confirmBlueprintAndGenerateTasks,
          ),
        ];
      case _NewProjectStep.execution:
        return [
          TextButton(
            onPressed: () => setState(() => _step = _NewProjectStep.startChoice),
            child: const Text('上一步'),
          ),
          FilledButton(
            onPressed: _createBlank,
            child: const Text('创建项目'),
          ),
        ];
    }
  }

  void _goStep2() {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _error = '请先填写项目名称。');
      return;
    }
    if (_outcomeController.text.trim().isEmpty) {
      _outcomeController.text = _titleController.text.trim();
    }
    setState(() {
      _step = _NewProjectStep.startChoice;
      _error = null;
    });
  }
}

/// Step 2 的选项行。
class _StartOption extends StatefulWidget {
  const _StartOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_StartOption> createState() => _StartOptionState();
}

class _StartOptionState extends State<_StartOption> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: VeyraMotion.fast,
          curve: VeyraMotion.curve,
          width: double.infinity,
          padding: const EdgeInsets.all(VeyraSpacing.s16),
          decoration: BoxDecoration(
            color: _hovering ? VeyraColors.sidebarSelected : VeyraColors.surface,
            borderRadius: BorderRadius.circular(VeyraRadius.medium),
            border: Border.all(
              color: _hovering
                  ? VeyraColors.dopamineIris.withValues(alpha: 0.3)
                  : VeyraColors.border,
            ),
            boxShadow: _hovering ? VeyraShadows.subtle : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon,
                  size: 20,
                  color: _hovering
                      ? VeyraColors.dopamineIris
                      : VeyraColors.textSecondary),
              const SizedBox(width: VeyraSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _hovering
                                ? VeyraColors.dopamineIris
                                : VeyraColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: VeyraColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: _hovering
                      ? VeyraColors.dopamineIris
                      : VeyraColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// 快捷标签 Chip
class _QuickTagChip extends StatelessWidget {
  const _QuickTagChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VeyraRadius.small),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: VeyraSpacing.s8,
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
            const Icon(Icons.add_rounded,
                size: 12, color: VeyraColors.accentDustyBlue),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11, color: VeyraColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// 引导式单选 Pill
class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VeyraRadius.small),
      child: AnimatedContainer(
        duration: VeyraMotion.fast,
        curve: VeyraMotion.curve,
        padding: const EdgeInsets.symmetric(
          horizontal: VeyraSpacing.s10,
          vertical: VeyraSpacing.s6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? VeyraColors.selectedSurface(VeyraColors.accentDustyBlue)
              : VeyraColors.backgroundAlt,
          borderRadius: BorderRadius.circular(VeyraRadius.small),
          border: Border.all(
            color: isSelected
                ? VeyraColors.accentDustyBlue
                : VeyraColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: isSelected
                    ? VeyraColors.accentDustyBlue
                    : VeyraColors.textTertiary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? VeyraColors.accentDustyBlue
                    : VeyraColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
