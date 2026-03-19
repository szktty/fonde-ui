import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? _selectedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  static final _firstDate = DateTime(2020);
  static final _lastDate = DateTime(2030, 12, 31);

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Date Picker',
          description:
              'Calendar-based date picker backed by table_calendar. '
              'Supports single-day and range selection.',
          children: [
            CatalogDemo(
              label: 'Single day',
              description:
                  _selectedDate != null
                      ? '${_selectedDate!.year}-'
                          '${_selectedDate!.month.toString().padLeft(2, '0')}-'
                          '${_selectedDate!.day.toString().padLeft(2, '0')}'
                      : 'No date selected',
              child: SizedBox(
                width: 320,
                child: FondeDatePicker(
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  selectedDate: _selectedDate,
                  onDaySelected: (date) => setState(() => _selectedDate = date),
                ),
              ),
            ),
            CatalogDemo(
              label: 'Range selection',
              description: () {
                if (_rangeStart == null) return 'No range selected';
                final s =
                    '${_rangeStart!.year}-'
                    '${_rangeStart!.month.toString().padLeft(2, '0')}-'
                    '${_rangeStart!.day.toString().padLeft(2, '0')}';
                if (_rangeEnd == null) return '$s →';
                final e =
                    '${_rangeEnd!.year}-'
                    '${_rangeEnd!.month.toString().padLeft(2, '0')}-'
                    '${_rangeEnd!.day.toString().padLeft(2, '0')}';
                return '$s → $e';
              }(),
              child: SizedBox(
                width: 320,
                child: FondeDatePicker(
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  rangeSelectionMode: true,
                  rangeStart: _rangeStart,
                  rangeEnd: _rangeEnd,
                  onRangeSelected:
                      (start, end) => setState(() {
                        _rangeStart = start;
                        _rangeEnd = end;
                      }),
                ),
              ),
            ),
            CatalogDemo(
              label: 'With events',
              description: 'Dots below days with events',
              child: SizedBox(
                width: 320,
                child: FondeDatePicker(
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  eventLoader: (day) {
                    // Show dots on the 5th, 10th, 15th, 20th of every month
                    if ([5, 10, 15, 20].contains(day.day)) {
                      return [Object()];
                    }
                    return [];
                  },
                  onDaySelected: (_) {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
