import 'package:flutter/material.dart';
import 'package:taskee/app/extension/capital_firstletter_extension.dart';
import 'package:taskee/features/note/domain/entities/note.dart';
import 'package:taskee/features/widget/glass_container.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final double cardW;
  final double cardH;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.cardW,
    required this.cardH,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassContainer(
      width: cardW, // need to add width/height to GlassContainer
      height: cardH,
      borderRadius: 28,
      opacity: isDark ? 0.15 : 0.4,
      child: _CardContent(
        note: note,
        textColor: isDark ? Colors.white : Colors.black,
        tagBg: isDark ? Colors.white12 : Colors.black12,
        tagText: isDark ? Colors.white70 : Colors.black87,
        onDelete: onDelete,
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final Note note;
  final Color textColor;
  final Color tagBg;
  final Color tagText;
  final VoidCallback onDelete;

  const _CardContent({
    required this.note,
    required this.textColor,
    required this.tagBg,
    required this.tagText,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.sticky_note_2_outlined, color: textColor.withValues(alpha: 0.6), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Text(
              note.note.capitalizeFirst(),
              style: TextStyle(
                fontSize: 18,
                height: 1.55,
                color: textColor,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
              maxLines: 7,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          if (_extractTags(note.note).isNotEmpty)
            Wrap(
              spacing: 6,
              children: _extractTags(note.note)
                  .map((t) => _Tag(label: t, bg: tagBg, textColor: tagText))
                  .toList(),
            ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(note.createdAt),
                style: TextStyle(
                  fontSize: 14, // تصغير الخط ليتناسب مع التصميم
                  color: textColor.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: textColor.withValues(alpha: .2)),
                  color: textColor.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe_left_alt_rounded, size: 14, color: textColor),
                    const SizedBox(width: 4),
                    Text(
                      'swipe',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _extractTags(String text) {
    final regex = RegExp(r'#\w+');
    final matches = regex.allMatches(text).map((m) => m.group(0)!).toList();
    if (matches.isNotEmpty) return matches.take(2).toList();
    return [];
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Today';
    final now = DateTime.now();
    if (dt.day == now.day) return 'Today';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const _Tag({required this.label, required this.bg, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12, // كان 24، تم تصغيره
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}