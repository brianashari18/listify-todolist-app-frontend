import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal Indonesia

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({super.key});

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(123, 119, 148, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Pilih Tanggal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableCalendar(
            locale: 'id_ID',
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isBefore(DateTime.now())) {
                return;
              }
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.pop(context, _selectedDay);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.black),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
              titleCentered: true,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: const TextStyle(color: Colors.white),
              weekdayStyle: const TextStyle(color: Colors.white),
              dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date).toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}