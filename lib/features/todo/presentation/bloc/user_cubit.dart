import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState extends Equatable {
  final String name;
  final String? imagePath;

  const UserState({
    this.name = 'Jacobe',
    this.imagePath,
  });

  UserState copyWith({String? name, String? imagePath}) {
    return UserState(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [name, imagePath];
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final savedImage = prefs.getString('user_image');

    emit(state.copyWith(
      name: savedName ?? 'Jacobe',
      imagePath: savedImage,
    ));
  }

  Future<void> updateUser({required String name, String? imagePath}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    
    if (imagePath != null) {
      // حذف الصورة القديمة إذا وجدت لتوفير المساحة
      if (state.imagePath != null && File(state.imagePath!).existsSync()) {
        await File(state.imagePath!).delete();
      }
      await prefs.setString('user_image', imagePath);
    }

    emit(UserState(name: name, imagePath: imagePath ?? state.imagePath));
  }
}