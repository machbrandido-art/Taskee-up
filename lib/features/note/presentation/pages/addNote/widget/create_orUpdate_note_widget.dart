import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskee/app/extension/size_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/app/helper/title_field_validator.dart';
import 'package:taskee/app/theme/app_typography.dart';
import 'package:taskee/features/note/domain/entities/note.dart';
import 'package:taskee/features/note/presentation/bloc/note_bloc.dart';
import 'package:taskee/features/note/presentation/bloc/note_event.dart';
import 'package:taskee/features/widget/app_button.dart';
import 'package:taskee/features/widget/glass_container.dart';

class CreateOrUpdateNoteWidget extends StatefulWidget {
  final Note? note;
  const CreateOrUpdateNoteWidget({super.key, this.note});

  @override
  State<CreateOrUpdateNoteWidget> createState() => _CreateOrUpdateNoteWidgetState();
}

class _CreateOrUpdateNoteWidgetState extends State<CreateOrUpdateNoteWidget> {
  late TextEditingController _noteController;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note?.note ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = widget.note != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Write a Note', style: AppTypography.h4.copyWith(color: isDark ? Colors.white : Colors.black)),
              10.kH,
              TextFormField(
                controller: _noteController,
                maxLines: 5,
                validator: noteFieldValidator,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                ),
              ),
              30.kH,
              AppButton(
                text: isUpdating ? 'Update Note' : 'Create Note',
                onTap: () async {
                  if (_form.currentState!.validate()) {
                    if (isUpdating) {
                      _updateNote();
                    } else {
                      await _addNote();
                    }
                    if (context.mounted) context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addNote() async {
    final note = Note(id: 0, note: _noteController.text, createdAt: DateTime.now());
    context.read<NoteBloc>().add(NoteItemAddedEvent(note));
  }

  Future<void> _updateNote() async {
    final note = Note(id: widget.note!.id, note: _noteController.text, createdAt: DateTime.now());
    context.read<NoteBloc>().add(NoteItemUpdatedEvent(note));
  }
}