import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/size_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/app/theme/app_assets.dart';
import 'package:taskee/app/theme/app_colors.dart';
import 'package:taskee/app/theme/app_typography.dart';
import 'package:taskee/features/todo/presentation/bloc/user_cubit.dart';
import 'package:taskee/features/todo/presentation/pages/home/widget/edit_profile_sheet.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plan your Day !', style: AppTypography.h2).paddingAll(20),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(12),
                    ),
                    child: state.imagePath != null
                        ? Image.file(
                            File(state.imagePath!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(AppAssets.profileImg, fit: BoxFit.cover),
                  ),
                ),
                14.kW,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Good Morning',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.kgrey),
                    ),
                    Text(state.name, style: AppTypography.h2),
                  ],
                ),
                const Spacer(),
                // الزر الذي يفتح نافذة التعديل
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1E1E1E), // لون داكن يناسب الثيم
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      isScrollControlled: true,
                      builder: (_) => BlocProvider.value(
                        value: context.read<UserCubit>(),
                        child: const EditProfileSheet(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.edit, // غيرت الأيقونة لـ قلم بدلاً من سهم ليتناسب مع التعديل
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ).paddingOnly(left: 20, right: 20); // أضفت right: 20 لتوازن المسافة
          },
        ),
      ],
    );
  }
}