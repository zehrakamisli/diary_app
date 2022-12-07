import 'package:diary_app/base/base_utility.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarPageView extends StatefulWidget {
  const CalendarPageView({Key? key}) : super(key: key);

  @override
  State<CalendarPageView> createState() => _CalendarPageViewState();
}

class _CalendarPageViewState extends State<CalendarPageView> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String selectedTime = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtility.backGroundColor,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.width * 9 / 10,
          width: MediaQuery.of(context).size.width * 4 / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.white.withOpacity(0.8),
          ),
          child: TableCalendar(
            daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: ColorUtility.calendarTextStyle,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Lato"),
                weekendStyle: TextStyle(
                    color: ColorUtility.calendarTextStyle,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Lato")),
            weekendDays: const [7],
            locale: 'en_US',
            focusedDay: DateTime.now(),
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
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
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Lato"),
              disabledDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
              ),
              disabledTextStyle: const TextStyle(
                  color: ColorUtility.calendarTextStyle,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Lato"),
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(
                  color: ColorUtility.calendarTextStyle,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Lato"),
              isTodayHighlighted: false,
              selectedDecoration: BoxDecoration(
                color: ColorUtility.backGroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
              ),
              selectedTextStyle: const TextStyle(
                  color: ColorUtility.calendarTextStyle,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Lato"),
              todayDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
              ),
              defaultTextStyle: const TextStyle(
                  color: ColorUtility.calendarTextStyle,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
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
            headerStyle: const HeaderStyle(
                titleTextStyle:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                formatButtonVisible: false,
                titleCentered: true),
          ),
        ),
      ),
    );
  }
}
