import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskee/features/todo/presentation/bloc/user_cubit.dart';
import 'package:taskee/features/widget/glass_container.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  String? _tempImagePath;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _tempImagePath = state.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() {
        _tempImagePath = savedImage.path;
      });
    }
  }

  void _save() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;
    context.read<UserCubit>().updateUser(name: newName, imagePath: _tempImagePath);
    Navigator.pop(context); // إغلاق النافذة
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassContainer(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24, // لمراعاة الكيبورد
          left: 24,
          right: 24,
          top: 24,
        ),
        borderRadius: 32,
        opacity: isDark ? 0.15 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تعديل الملف الشخصي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                backgroundImage: _tempImagePath != null ? FileImage(File(_tempImagePath!)) : null,
                child: _tempImagePath == null
                    ? Icon(Icons.camera_alt, color: isDark ? Colors.white : Colors.black, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'الاسم',
                labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: isDark ? Colors.white30 : Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('حفظ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}