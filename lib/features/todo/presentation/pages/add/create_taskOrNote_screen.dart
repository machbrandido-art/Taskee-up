import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/size_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/app/theme/app_colors.dart';
import 'package:taskee/app/theme/app_typography.dart';
import 'package:taskee/features/note/domain/entities/note.dart';
import 'package:taskee/features/note/presentation/bloc/note_bloc.dart';
import 'package:taskee/features/note/presentation/bloc/note_event.dart';
import 'package:taskee/features/note/presentation/pages/addNote/widget/create_orUpdate_note_widget.dart';
import 'package:taskee/features/shared/cubit/tab_cubit.dart';
import 'package:taskee/features/todo/domain/entities/todo.dart';
import 'package:taskee/features/widget/glass_container.dart';

import 'widgets/create_orUpdate_task_widget.dart';

class CreateTaskOrNoteScreen extends StatefulWidget {
  final bool isUpdateTaskscreen;
  final Todo? todo;
  final Note? note;
  const CreateTaskOrNoteScreen({
    super.key,
    this.isUpdateTaskscreen = false,
    this.todo,
    this.note,
  });

  @override
  State<CreateTaskOrNoteScreen> createState() => _CreateTaskOrNoteScreenState();
}

class _CreateTaskOrNoteScreenState extends State<CreateTaskOrNoteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final currentTab = context.read<TabCubit>().state;
    _tabController = TabController(length: 2, vsync: this, initialIndex: currentTab);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<TabCubit>().changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg_map.png', fit: BoxFit.cover),
          ),
          if (!isDark)
            Positioned.fill(
              child: Container(color: Colors.white.withValues(alpha: 0.7)),
            ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton().paddingOnly(left: 20),
                    Text(
                      widget.isUpdateTaskscreen ? 'Update' : 'Create',
                      style: AppTypography.h2.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    widget.isUpdateTaskscreen
                        ? IconButton(
                            onPressed: () => _showDeleteDialog(context),
                            icon: const Icon(CupertinoIcons.delete, color: AppColors.error),
                          ).paddingOnly(right: 20)
                        : const SizedBox(width: 48 + 20),
                  ],
                ),
                25.kH,
                if (!widget.isUpdateTaskscreen) ...[
                  _buildTabBar(_tabController).paddingOnly(left: 20),
                  15.kH,
                ],
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CreateOrUpdateTaskWidget(todo: widget.todo),
                      CreateOrUpdateNoteWidget(note: widget.note),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(TabController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: 30,
      opacity: 0.2,
      child: IntrinsicWidth(
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          labelStyle: AppTypography.labelLg.copyWith(fontSize: 13.5),
          labelColor: isDark ? Colors.white : Colors.black,
          unselectedLabelColor: isDark ? Colors.white38 : Colors.black45,
          tabs: [
            Tab(text: 'TASK').paddingSymmetric(horizontal: 10),
            Tab(text: 'NOTE'),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E).withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: .1)),
        ),
        title: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Text('This action cannot be undone.', style: AppTypography.bodyLg.copyWith(color: Colors.white54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TabCubit>().changeTab(1);
              context.read<NoteBloc>().add(NoteItemDeletedEvent(widget.note!.id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}