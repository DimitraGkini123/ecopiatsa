import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  DateTime today= DateTime.now();

  void _onDayselected (DateTime day,DateTime FocusedDay) {
    setState(() {
        today = day;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Calendar',
        style: TextStyle(
        color: Color(0xFF4d7c0f),),
    ),
    backgroundColor: const Color(0xffffecfccc),
    ),
      body: content(),
    );
  }
  Widget content () {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(' '+today.toString().split(" ")[0]),
            Container(
              child: TableCalendar(focusedDay: today,
                  firstDay: DateTime.utc(2008,1,1),
                  lastDay: DateTime.utc(2040,12,31),
                locale: "en_US",
                rowHeight: 100,
                headerStyle: const HeaderStyle(formatButtonVisible: false,
                titleCentered: true,
                decoration: BoxDecoration(color: Color(0xFF4d7c0f) ),
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay ( day , today),
                onDaySelected: _onDayselected,
              ),

            )
          ],
        ),
      ),
    );
  }
}




