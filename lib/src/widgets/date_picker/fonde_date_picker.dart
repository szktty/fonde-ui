import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../styling/fonde_border_radius.dart';
import '../icons/lucide_icons.dart';

/// A date picker widget backed by table_calendar.
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
  final StartingDayOfWeek startingDayOfWeek;

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
    this.startingDayOfWeek = StartingDayOfWeek.monday,
    this.disableZoom = false,
  });

  @override
  State<FondeDatePicker> createState() => _FondeDatePickerState();
}

class _FondeDatePickerState extends State<FondeDatePicker> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _focusedDay = widget.initialDate ?? today;
    _selectedDay = widget.selectedDate;
    _rangeStart = widget.rangeStart;
    _rangeEnd = widget.rangeEnd;
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

    final cellDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );
    final selectedDecoration = BoxDecoration(
      color: selectedBg,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );
    final todayDecoration = BoxDecoration(
      color: todayBg,
      borderRadius: FondeBorderRadiusValues.smallRadius,
    );

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: FondeBorderRadiusValues.mediumRadius,
        border: Border.all(color: borderColor),
      ),
      child: TableCalendar(
        firstDay: widget.firstDate,
        lastDay: widget.lastDate,
        focusedDay: _focusedDay,
        locale: widget.locale,
        startingDayOfWeek: widget.startingDayOfWeek,
        rowHeight: rowHeight,
        daysOfWeekHeight: dowHeight,
        pageAnimationEnabled: false,
        // pageAnimationEnabled: false alone does not suppress the chevron-button
        // month transition animation. As a workaround, set duration to 1 ms
        // (Duration.zero triggers an assertion in Flutter's scroll internals).
        pageAnimationDuration: const Duration(milliseconds: 1),
        availableGestures: AvailableGestures.none,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 13.0 * zoomScale,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
          leftChevronIcon: Icon(
            LucideIcons.chevronLeft,
            size: 16.0 * zoomScale,
            color: muted,
          ),
          rightChevronIcon: Icon(
            LucideIcons.chevronRight,
            size: 16.0 * zoomScale,
            color: muted,
          ),
          leftChevronPadding: EdgeInsets.all(6.0 * zoomScale),
          rightChevronPadding: EdgeInsets.all(6.0 * zoomScale),
          leftChevronMargin: EdgeInsets.only(left: 4.0 * zoomScale),
          rightChevronMargin: EdgeInsets.only(right: 4.0 * zoomScale),
          headerPadding: EdgeInsets.symmetric(vertical: 8.0 * zoomScale),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: dowStyle,
          weekendStyle: dowStyle,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          defaultDecoration: cellDecoration,
          weekendDecoration: cellDecoration,
          outsideDecoration: cellDecoration,
          todayDecoration: todayDecoration,
          selectedDecoration: selectedDecoration,
          rangeStartDecoration: selectedDecoration,
          rangeEndDecoration: selectedDecoration,
          withinRangeDecoration: BoxDecoration(
            color: rangeHighlight,
            borderRadius: FondeBorderRadiusValues.smallRadius,
          ),
          rangeHighlightColor: rangeHighlight,
          defaultTextStyle: textStyle,
          weekendTextStyle: textStyle,
          outsideTextStyle: mutedStyle,
          disabledTextStyle: mutedStyle.copyWith(
            color: muted.withValues(alpha: 0.3),
          ),
          todayTextStyle: todayStyle,
          selectedTextStyle: selectedStyle,
          rangeStartTextStyle: selectedStyle,
          rangeEndTextStyle: selectedStyle,
          withinRangeTextStyle: textStyle.copyWith(color: accent),
          markerDecoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
          ),
          markerSize: 4.0 * zoomScale,
          markersMaxCount: 3,
          cellPadding: EdgeInsets.all(2.0 * zoomScale),
        ),
        calendarBuilders: CalendarBuilders(
          // Use plain Container instead of AnimatedContainer to remove selection animation
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: EdgeInsets.all(2.0 * zoomScale),
              decoration: selectedDecoration,
              alignment: Alignment.center,
              child: Text('${day.day}', style: selectedStyle),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Container(
              margin: EdgeInsets.all(2.0 * zoomScale),
              decoration: todayDecoration,
              alignment: Alignment.center,
              child: Text('${day.day}', style: todayStyle),
            );
          },
          rangeStartBuilder: (context, day, focusedDay) {
            return Container(
              margin: EdgeInsets.all(2.0 * zoomScale),
              decoration: selectedDecoration,
              alignment: Alignment.center,
              child: Text('${day.day}', style: selectedStyle),
            );
          },
          rangeEndBuilder: (context, day, focusedDay) {
            return Container(
              margin: EdgeInsets.all(2.0 * zoomScale),
              decoration: selectedDecoration,
              alignment: Alignment.center,
              child: Text('${day.day}', style: selectedStyle),
            );
          },
        ),
        selectedDayPredicate:
            widget.rangeSelectionMode
                ? null
                : (day) => _selectedDay != null && isSameDay(_selectedDay, day),
        rangeStartDay: widget.rangeSelectionMode ? _rangeStart : null,
        rangeEndDay: widget.rangeSelectionMode ? _rangeEnd : null,
        rangeSelectionMode:
            widget.rangeSelectionMode
                ? RangeSelectionMode.enforced
                : RangeSelectionMode.disabled,
        eventLoader: widget.eventLoader,
        enabledDayPredicate: widget.enabledDayPredicate,
        onDaySelected:
            widget.rangeSelectionMode
                ? null
                : (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                  widget.onDaySelected?.call(selected);
                },
        onRangeSelected:
            widget.rangeSelectionMode
                ? (start, end, focused) {
                  setState(() {
                    _rangeStart = start;
                    _rangeEnd = end;
                    _focusedDay = focused;
                  });
                  widget.onRangeSelected?.call(start, end);
                }
                : null,
        onPageChanged: (focused) {
          setState(() => _focusedDay = focused);
        },
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
  StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.monday,
  bool Function(DateTime)? enabledDayPredicate,
  List<Object?> Function(DateTime)? eventLoader,
}) async {
  DateTime? result = selectedDate;
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      DateTime? picked = selectedDate;
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
              picked = date;
              result = picked;
              Navigator.of(ctx).pop();
            },
          ),
        ),
      );
    },
  );
  return result;
}
