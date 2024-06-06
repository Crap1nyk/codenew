import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({
    super.key,
    required this.onSelectedDayChange,
  });

  final void Function(DateTime) onSelectedDayChange;

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateNotifier>(context);

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020),
      lastDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) {
        var date = DateTime(day.year, day.month, day.day);
        return appState.documents[getDate(date)] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _selectedDay = selectedDay;
          widget.onSelectedDayChange(selectedDay);
        });
      },
    );
  }
}
