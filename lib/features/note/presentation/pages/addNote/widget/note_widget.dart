import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/context_extension.dart';
import 'package:taskee/features/note/presentation/bloc/note_bloc.dart';
import 'package:taskee/features/note/presentation/bloc/note_state.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:taskee/features/note/presentation/pages/addNote/widget/note_card.dart';
import 'package:taskee/features/todo/presentation/pages/add/create_taskOrNote_screen.dart';
import 'package:taskee/features/widget/empty_state_widget.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoteLoadedState) {
          final notes = state.noteModel.noteList;

          // إذا كانت القائمة فارغة، اعرض الشاشة الزجاجية الفارغة
          if (notes.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Notes Yet',
              subtitle: 'Your mind is clear.\nCapture a thought by tapping +.',
              icon: Icons.edit_note_rounded,
            );
          }

          final size = MediaQuery.of(context).size;
          // إرجاع الأحجام الأصلية ليظهر التراص (Stack)
          final cardW = size.width * 0.5;
          final cardH = size.height * 0.4;

          return CardSwiper(
            controller: _controller,
            cardsCount: notes.length,
            isLoop: true, // إرجاع التكرار الأصلي
            numberOfCardsDisplayed: notes.length.clamp(1, 3),
            maxAngle: 50,
            threshold: 50,
            padding: const EdgeInsets.only(left: 40, bottom: 130, right: 40, top: 30),
            cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
              // منع خطأ الخروج عن النطاق
              final note = notes[index % notes.length];

              return GestureDetector(
                onTap: () => context.gotTo(
                  CreateTaskOrNoteScreen(note: note, isUpdateTaskscreen: true),
                ),
                child: NoteCard(
                  note: note,
                  cardW: cardW,
                  cardH: cardH,
                  onDelete: () {},
                ),
              );
            },
            // إجبار البطاقة على الرجوع لمكانها إذا حاول المستخدم سحبها (بدون حذف)
            onSwipe: (previousIndex, currentIndex, direction) {
              return false; 
            },
          );
        }

        return const Text('Something went wrong!');
      },
    );
  }
}