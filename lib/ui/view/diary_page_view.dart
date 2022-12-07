import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class BuildCalendar extends StatefulWidget {
  const BuildCalendar({Key? key}) : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  CalendarFormat format = CalendarFormat.twoWeeks;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String selectedTime = "";
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
              color: Color(0xffC2C2C2),
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              fontFamily: "Lato"),
          weekendStyle: TextStyle(
              color: Color(0xffC2C2C2),
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              fontFamily: "Lato")),
      weekendDays: const [7],
      locale: 'en_US',
      focusedDay: DateTime.now(),
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 15)),
      calendarFormat: format,
      onFormatChanged: (CalendarFormat format) {
        setState(() {
          format = format;
        });
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,

      //Day Changed
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(
          () {
            selectedTime = "";
            selectedDay = selectDay;
            focusedDay = focusDay;
          },
        );
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(selectedDay, date);
      },
      //To style the Calendar

      calendarStyle: CalendarStyle(
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        outsideTextStyle: const TextStyle(
            color: Color(0xffC2C2C2),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontFamily: "Lato"),
        disabledDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        disabledTextStyle: const TextStyle(
            color: Color(0xffffffff),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontFamily: "Lato"),
        outsideDaysVisible: false,
        weekendTextStyle: const TextStyle(
            color: Color(0xffC2C2C2),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontFamily: "Lato"),
        isTodayHighlighted: false,
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        selectedTextStyle: const TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontFamily: "Lato"),
        todayDecoration: BoxDecoration(
          color: Colors.purpleAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        defaultTextStyle: const TextStyle(
            color: Color(0xffC2C2C2),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontFamily: "Lato"),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
    );
  }
}
