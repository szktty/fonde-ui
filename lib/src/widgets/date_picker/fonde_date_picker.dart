import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../styling/fonde_border_radius.dart';
import '../icons/lucide_icons.dart';

/// First day of the week.
enum FondeDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Converts to ISO weekday (1 = Monday, 7 = Sunday).
  int get isoWeekday {
    switch (this) {
      case FondeDayOfWeek.monday:
        return 1;
      case FondeDayOfWeek.tuesday:
        return 2;
      case FondeDayOfWeek.wednesday:
        return 3;
      case FondeDayOfWeek.thursday:
        return 4;
      case FondeDayOfWeek.friday:
        return 5;
      case FondeDayOfWeek.saturday:
        return 6;
      case FondeDayOfWeek.sunday:
        return 7;
    }
  }
}

/// Returns true if [a] and [b] fall on the same calendar day.
bool fondeSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// A date picker widget with a monthly calendar grid.
///
/// Displays a monthly calendar grid. Supports single-day and range selection.
/// Styling is automatically derived from the active fonde-ui theme.
///
/// ```dart
/// FondeDatePicker(
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
///   onDaySelected: (date) => print(date),
/// )
/// ```
class FondeDatePicker extends StatefulWidget {
  /// The earliest selectable date.
  final DateTime firstDate;

  /// The latest selectable date.
  final DateTime lastDate;

  /// The initially focused date (defaults to today).
  final DateTime? initialDate;

  /// Initially selected date (single selection mode).
  final DateTime? selectedDate;

  /// Callback when a day is tapped (single selection mode).
  final ValueChanged<DateTime>? onDaySelected;

  /// Initial range start (range selection mode).
  final DateTime? rangeStart;

  /// Initial range end (range selection mode).
  final DateTime? rangeEnd;

  /// Callback when a range is selected.
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;

  /// If true, enables range selection mode.
  final bool rangeSelectionMode;

  /// Supplies event dots for a given day.
  final List<Object?> Function(DateTime day)? eventLoader;

  /// Returns true for days that should be disabled.
  final bool Function(DateTime day)? enabledDayPredicate;

  /// Locale for date formatting (e.g. 'ja', 'en_US').
  final dynamic locale;

  /// First day of the week (defaults to Monday).
  final FondeDayOfWeek startingDayOfWeek;

  /// Whether to disable zoom scaling.
  final bool disableZoom;

  const FondeDatePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.selectedDate,
    this.onDaySelected,
    this.rangeStart,
    this.rangeEnd,
    this.onRangeSelected,
    this.rangeSelectionMode = false,
    this.eventLoader,
    this.enabledDayPredicate,
    this.locale,
    this.startingDayOfWeek = FondeDayOfWeek.monday,
    this.disableZoom = false,
  });

  @override
  State<FondeDatePicker> createState() => _FondeDatePickerState();
}

class _FondeDatePickerState extends State<FondeDatePicker> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final initial = widget.initialDate ?? today;
    _focusedMonth = DateTime(initial.year, initial.month);
    _selectedDay = widget.selectedDate;
    _rangeStart = widget.rangeStart;
    _rangeEnd = widget.rangeEnd;
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  bool _canGoPrev() {
    final prev = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    final firstMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    return !prev.isBefore(firstMonth);
  }

  bool _canGoNext() {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month);
    return !next.isAfter(lastMonth);
  }

  void _onDayTapped(DateTime day) {
    if (widget.rangeSelectionMode) {
      setState(() {
        if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = day;
          _rangeEnd = null;
        } else {
          if (day.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = day;
          } else {
            _rangeEnd = day;
          }
        }
      });
      widget.onRangeSelected?.call(_rangeStart, _rangeEnd);
    } else {
      setState(() => _selectedDay = day);
      widget.onDaySelected?.call(day);
    }
  }

  /// Returns the days to display in the calendar grid (42 cells = 6 rows × 7 cols).
  List<DateTime?> _buildCalendarDays() {
    final firstOfMonth = _focusedMonth;
    final daysInMonth =
        DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0).day;

    // Offset: how many blank cells before the 1st
    final firstWeekday = firstOfMonth.weekday; // 1=Mon, 7=Sun
    final startOffset =
        (firstWeekday - widget.startingDayOfWeek.isoWeekday + 7) % 7;

    final days = <DateTime?>[];
    // Leading blanks from previous month
    final prevMonth = DateTime(firstOfMonth.year, firstOfMonth.month - 1);
    final daysInPrevMonth =
        DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
    for (int i = startOffset - 1; i >= 0; i--) {
      days.add(DateTime(prevMonth.year, prevMonth.month, daysInPrevMonth - i));
    }
    // Current month
    for (int d = 1; d <= daysInMonth; d++) {
      days.add(DateTime(firstOfMonth.year, firstOfMonth.month, d));
    }
    // Trailing days from next month to fill the grid
    final nextMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1);
    int nextDay = 1;
    while (days.length < 42) {
      days.add(DateTime(nextMonth.year, nextMonth.month, nextDay++));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = widget.disableZoom ? 1.0 : context.fondeZoomScale;

    final bg = appColorScheme.base.background;
    final fg = appColorScheme.base.foreground;
    final accent = appColorScheme.theme.primaryColor;
    final muted = fg.withValues(alpha: 0.45);
    final selectedBg = accent;
    final selectedFg = Colors.white;
    final todayBg = accent.withValues(alpha: 0.12);
    final rangeHighlight = accent.withValues(alpha: 0.12);
    final borderColor = appColorScheme.base.border;
    final rowHeight = 36.0 * zoomScale;
    final dowHeight = 28.0 * zoomScale;

    final textStyle = TextStyle(fontSize: 13.0 * zoomScale, color: fg);
    final mutedStyle = textStyle.copyWith(color: muted);
    final selectedStyle = textStyle.copyWith(
      color: selectedFg,
      fontWeight: FontWeight.w600,
    );
    final todayStyle = textStyle.copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
    );
    final dowStyle = TextStyle(
      fontSize: 11.0 * zoomScale,
      color: muted,
      fontWeight: FontWeight.w500,
    );

    final selectedDecoration = BoxDecoration(
      color: selectedBg,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );
    final todayDecoration = BoxDecoration(
      color: todayBg,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );
    final rangeDecoration = BoxDecoration(
      color: rangeHighlight,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );

    final calendarDays = _buildCalendarDays();
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final currentMonth = _focusedMonth.month;

    // Day-of-week header labels, ordered by startingDayOfWeek
    final dowLabels = _buildDowLabels(context);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: FondeBorderRadiusValues.mediumRadius,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context, zoomScale, fg, muted, textStyle),
          // Day-of-week row
          SizedBox(
            height: dowHeight,
            child: Row(
              children: List.generate(7, (i) {
                return Expanded(
                  child: Center(child: Text(dowLabels[i], style: dowStyle)),
                );
              }),
            ),
          ),
          // Calendar grid (6 rows)
          for (int row = 0; row < 6; row++)
            SizedBox(
              height: rowHeight,
              child: Row(
                children: List.generate(7, (col) {
                  final day = calendarDays[row * 7 + col];
                  if (day == null) return const Expanded(child: SizedBox());
                  final isCurrentMonth = day.month == currentMonth;
                  final dayNormalized = DateTime(day.year, day.month, day.day);
                  final isToday = fondeSameDay(dayNormalized, todayNormalized);
                  final isSelected =
                      !widget.rangeSelectionMode &&
                      fondeSameDay(day, _selectedDay);
                  final isRangeStart =
                      widget.rangeSelectionMode &&
                      fondeSameDay(day, _rangeStart);
                  final isRangeEnd =
                      widget.rangeSelectionMode && fondeSameDay(day, _rangeEnd);
                  final isInRange =
                      widget.rangeSelectionMode &&
                      _rangeStart != null &&
                      _rangeEnd != null &&
                      dayNormalized.isAfter(_rangeStart!) &&
                      dayNormalized.isBefore(_rangeEnd!);
                  final isBeforeFirst = day.isBefore(widget.firstDate);
                  final isAfterLast = day.isAfter(widget.lastDate);
                  final isDisabledByPredicate =
                      widget.enabledDayPredicate != null &&
                      !widget.enabledDayPredicate!(day);
                  final isDisabled =
                      isBeforeFirst || isAfterLast || isDisabledByPredicate;

                  BoxDecoration? decoration;
                  TextStyle style;

                  if (isSelected || isRangeStart || isRangeEnd) {
                    decoration = selectedDecoration;
                    style = selectedStyle;
                  } else if (isInRange) {
                    decoration = rangeDecoration;
                    style = textStyle.copyWith(color: accent);
                  } else if (isToday) {
                    decoration = todayDecoration;
                    style = todayStyle;
                  } else if (isDisabled || !isCurrentMonth) {
                    style =
                        isDisabled
                            ? mutedStyle.copyWith(
                              color: muted.withValues(alpha: 0.3),
                            )
                            : mutedStyle;
                    decoration = null;
                  } else {
                    style = textStyle;
                    decoration = null;
                  }

                  final events = widget.eventLoader?.call(day) ?? [];
                  final hasEvents = events.isNotEmpty;

                  Widget cell = Container(
                    margin: EdgeInsets.all(2.0 * zoomScale),
                    decoration: decoration,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${day.day}', style: style),
                        if (hasEvents)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < events.length && i < 3; i++)
                                Container(
                                  width: 4.0 * zoomScale,
                                  height: 4.0 * zoomScale,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 1.0 * zoomScale,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  );

                  if (!isDisabled) {
                    cell = GestureDetector(
                      onTap: () => _onDayTapped(day),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: cell,
                      ),
                    );
                  }

                  return Expanded(child: cell);
                }),
              ),
            ),
          SizedBox(height: 4.0 * zoomScale),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double zoomScale,
    Color fg,
    Color muted,
    TextStyle textStyle,
  ) {
    final titleStyle = TextStyle(
      fontSize: 13.0 * zoomScale,
      fontWeight: FontWeight.w600,
      color: fg,
    );
    final title = _formatMonthYear(context, _focusedMonth);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0 * zoomScale,
        horizontal: 4.0 * zoomScale,
      ),
      child: Row(
        children: [
          _ChevronButton(
            icon: LucideIcons.chevronLeft,
            size: 16.0 * zoomScale,
            color: muted,
            padding: EdgeInsets.all(6.0 * zoomScale),
            margin: EdgeInsets.only(left: 4.0 * zoomScale),
            enabled: _canGoPrev(),
            onTap: _prevMonth,
          ),
          Expanded(child: Center(child: Text(title, style: titleStyle))),
          _ChevronButton(
            icon: LucideIcons.chevronRight,
            size: 16.0 * zoomScale,
            color: muted,
            padding: EdgeInsets.all(6.0 * zoomScale),
            margin: EdgeInsets.only(right: 4.0 * zoomScale),
            enabled: _canGoNext(),
            onTap: _nextMonth,
          ),
        ],
      ),
    );
  }

  /// Returns 7 day-of-week abbreviations starting from [startingDayOfWeek].
  List<String> _buildDowLabels(BuildContext context) {
    // ISO weekday names Mon..Sun
    final all = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final start = widget.startingDayOfWeek.isoWeekday - 1; // 0-based index
    return List.generate(7, (i) => all[(start + i) % 7]);
  }

  /// Formats "April 2025" / "2025年4月" etc. using MaterialLocalizations.
  String _formatMonthYear(BuildContext context, DateTime date) {
    try {
      final loc = MaterialLocalizations.of(context);
      // formatMonthYear returns locale-appropriate string
      return loc.formatMonthYear(date);
    } catch (_) {
      // Fallback: English
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.year}';
    }
  }
}

class _ChevronButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool enabled;
  final VoidCallback onTap;

  const _ChevronButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.padding,
    required this.margin,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: Container(
          margin: margin,
          padding: padding,
          child: Icon(
            icon,
            size: size,
            color: enabled ? color : color.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

/// Shows a [FondeDatePicker] inside a [showFondeDialog]-style dialog.
///
/// Returns the selected [DateTime], or null if dismissed.
Future<DateTime?> showFondeDatePickerDialog({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? initialDate,
  DateTime? selectedDate,
  dynamic locale,
  FondeDayOfWeek startingDayOfWeek = FondeDayOfWeek.monday,
  bool Function(DateTime)? enabledDayPredicate,
  List<Object?> Function(DateTime)? eventLoader,
}) async {
  DateTime? result = selectedDate;
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: FondeDatePicker(
            firstDate: firstDate,
            lastDate: lastDate,
            initialDate: initialDate,
            selectedDate: selectedDate,
            locale: locale,
            startingDayOfWeek: startingDayOfWeek,
            enabledDayPredicate: enabledDayPredicate,
            eventLoader: eventLoader,
            onDaySelected: (date) {
              result = date;
              Navigator.of(ctx).pop();
            },
          ),
        ),
      );
    },
  );
  return result;
}
