import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/base/base_utility.dart';
import 'package:diary_app/ui/model/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'diary_page_view.dart';

class CalendarPageView extends StatefulWidget {
  const CalendarPageView({Key? key}) : super(key: key);

  @override
  State<CalendarPageView> createState() => _CalendarPageViewState();
}

class _CalendarPageViewState extends State<CalendarPageView> {
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedTime = "";

  Future<QuerySnapshot<Map<String, dynamic>>> getDiaryData() {
    var db = FirebaseFirestore.instance;
    var collection = db.collection('diarys');
    return collection.get();
  }

  List<DiaryModel>? parseDiaryData(QuerySnapshot<Map<String, dynamic>>? data) {
    if (data != null) {
      List<DiaryModel> datas = [];
      for (var dataPiece in data.docs) {
        datas.add(DiaryModel.fromJson(dataPiece.data()));
      }
      return datas;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtility.backGroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DiaryPage(
                    selectedDay: _selectedDay,
                  )));
        },
        backgroundColor: ColorUtility.fabColor,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: getDiaryData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (!snapshot.hasData && snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return calendarView(context, parseDiaryData(snapshot.data));
            }
          }),
    );
  }

  Center calendarView(BuildContext context, List<DiaryModel>? diaryData) {
    return Center(
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
          lastDay: DateTime.now().add(const Duration(
            days: 31,
          )),
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
                _selectedTime = selectDay.toIso8601String();
                _selectedDay = selectDay;
                _focusedDay = focusDay;
              },
            );
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(_selectedDay, date);
          },
          eventLoader: (day) => getCalendarEvents(day, diaryData),
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
            disabledTextStyle: TextStyle(
                color: ColorUtility.calendarTextStyle.withOpacity(0.6),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "Lato"),
            outsideDaysVisible: false,
            weekendTextStyle: const TextStyle(
                color: ColorUtility.calendarTextStyle,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: "Lato"),
            isTodayHighlighted: true,
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
    );
  }

  getCalendarEvents(DateTime day, List<DiaryModel>? diaryData) {
    if (diaryData == null || diaryData.isEmpty) {
      return List.empty();
    } else {
      List dateList = [];
      for (var data in diaryData) {
        if (data.dateTime != null) {
          if (data.dateTime!.day == day.day &&
              data.dateTime!.month == day.month &&
              data.dateTime!.year == day.year) {
            dateList.add(data);
          }
        }
      }
      return dateList;
    }
  }
}
