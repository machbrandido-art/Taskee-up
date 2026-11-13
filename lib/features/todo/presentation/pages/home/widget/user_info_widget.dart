import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/size_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/app/theme/app_assets.dart';
import 'package:taskee/app/theme/app_colors.dart';
import 'package:taskee/app/theme/app_typography.dart';
import 'package:taskee/features/shared/cubit/theme_cubit.dart';
import 'package:taskee/features/todo/presentation/bloc/user_cubit.dart';
import 'package:taskee/features/todo/presentation/pages/home/widget/edit_profile_sheet.dart';
import 'package:taskee/features/widget/glass_container.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan your Day !', 
          style: AppTypography.h2.copyWith(color: isDark ? Colors.white : Colors.black),
        ).paddingAll(20),
        
        GlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: state.imagePath != null
                          ? Image.file(File(state.imagePath!), fit: BoxFit.cover)
                          : Image.asset(AppAssets.profileImg, fit: BoxFit.cover),
                    ),
                  ),
                  14.kW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Good Morning',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.kgrey),
                        ),
                        Text(
                          state.name, 
                          style: AppTypography.h3.copyWith(color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  
                  // زر تغيير الثيم
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) {
                      return IconButton(
                        icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                        onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                      );
                    },
                  ),
                  8.kW,
                  
                  // زر تعديل الملف الشخصي (يفتح الآن في المنتصف)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<UserCubit>(),
                          child: const EditProfileSheet(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}