import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/context_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/app/theme/app_typography.dart';
import 'package:taskee/features/shared/cubit/tab_cubit.dart';
import 'package:taskee/features/todo/presentation/pages/add/create_taskOrNote_screen.dart';
import 'package:taskee/features/note/presentation/pages/addNote/widget/note_widget.dart';
import 'package:taskee/features/todo/presentation/pages/home/widget/task_widget.dart';
import 'package:taskee/features/todo/presentation/pages/home/widget/user_info_widget.dart';
import 'package:taskee/features/widget/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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

    return BlocListener<TabCubit, int>(
      listener: (context, tabIndex) {
        if (_tabController.index != tabIndex) {
          _tabController.animateTo(tabIndex, duration: Duration.zero);
        }
      },
      child: Scaffold(
        extendBody: true, // لتمتد الواجهة خلف شريط التنقل السفلي
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.gotTo(const CreateTaskOrNoteScreen()),
          child: const Icon(Icons.add),
        ),
        body: Stack(
          children: [
            // 1. الصورة الأساسية
            Positioned.fill(
              child: Image.asset(
                'assets/bg_map.png',
                fit: BoxFit.cover,
              ),
            ),
            // 2. طبقة تعتيم للوضع الفاتح (لتفتيح الخريطة الداكنة)
            if (!isDark)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.7)),
              ),
            
            // 3. محتوى التطبيق
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserInfoWidget(),
                  _buildTabBar(_tabController).paddingAll(20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [TaskWidget(), NoteWidget()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(TabController controller) {
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: 30,
      opacity: 0.2, // شفافية الزجاج
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white.withValues(alpha: 0.2) 
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        labelStyle: AppTypography.labelLg.copyWith(fontSize: 13.5),
        labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black45,
        tabs: [
          Tab(text: 'TASKS').paddingSymmetric(horizontal: 10),
          Tab(text: 'NOTES'),
        ],
      ),
    );
  }
}