import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskee/app/theme/app_colors.dart';
import 'package:taskee/features/widget/glass_container.dart';

class DueAtPicker extends StatelessWidget {
  const DueAtPicker({super.key, required this.dueAt, required this.onChanged});

  final DateTime? dueAt;
  final ValueChanged<DateTime?> onChanged;
  String _weekday(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = MaterialLocalizations.of(context);
    final dateLabel = dueAt == null ? 'Select date' : '${_weekday(dueAt!.weekday)}, ${dueAt!.day}, ${dueAt!.year}';
    final timeLabel = dueAt == null ? 'Select time' : localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dueAt!), alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat);

    return Row(
      children: [
        Expanded(
          child: _PickerCard(
            icon: CupertinoIcons.calendar,
            label: 'Date',
            value: dateLabel,
            isPlaceholder: dueAt == null,
            isDark: isDark,
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final now = DateTime.now();
              final initial = dueAt ?? now;
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(initial.year, initial.month, initial.day),
                firstDate: DateTime(now.year - 10),
                lastDate: DateTime(now.year + 20),
              );
              if (picked == null) return;
              final currentTime = dueAt == null ? const TimeOfDay(hour: 9, minute: 0) : TimeOfDay.fromDateTime(dueAt!);
              onChanged(DateTime(picked.year, picked.month, picked.day, currentTime.hour, currentTime.minute));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PickerCard(
            icon: CupertinoIcons.clock,
            label: 'Time',
            value: timeLabel,
            isPlaceholder: dueAt == null,
            isDark: isDark,
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final initial = dueAt == null ? const TimeOfDay(hour: 9, minute: 0) : TimeOfDay.fromDateTime(dueAt!);
              final picked = await showTimePicker(context: context, initialTime: initial);
              if (picked == null) return;
              final base = dueAt ?? DateTime.now();
              onChanged(DateTime(base.year, base.month, base.day, picked.hour, picked.minute));
            },
          ),
        ),
      ],
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isPlaceholder,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isPlaceholder;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        borderRadius: 16,
        opacity: isDark ? 0.1 : 0.3,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white70 : Colors.black87,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isPlaceholder 
                          ? (isDark ? Colors.white38 : Colors.black38) 
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}