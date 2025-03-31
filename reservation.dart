import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Café Reservation',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ReservationPage(),
    );
  }
}

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _numberOfPeople = 1;
  DateTime? _hoveredDate;//time and date to reserve table

  // Time Picker
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Submit the Reservation
  void _submitReservation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reservation Confirmed'),
          content: Text(
            'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}\n'
            'Time: ${_selectedTime.format(context)}\n'
            'Number of People: $_numberOfPeople',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Reservation'),
        backgroundColor: const Color.fromARGB(230, 142, 173, 69),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),//appbar
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
        child: ListView(
          children: <Widget>[
            const Text(
              'Select Reservation Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.now(),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  bool isHovered = _hoveredDate != null && isSameDay(date, _hoveredDate!);
                  bool isSelected = isSameDay(_selectedDate, date);//callender
                  
                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _hoveredDate = date;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _hoveredDate = null;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green.withOpacity(0.8)
                            : isHovered
                                ? Colors.green.withOpacity(0.3)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isSelected
                              ? Colors.green
                              : isHovered
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isHovered
                                  ? Colors.green.shade900
                                  : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Reservation Time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],//reservation time
            ),
            const SizedBox(height: 20),
            const Text(
              'Number of People:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),// number people
            Slider(
              value: _numberOfPeople.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_numberOfPeople',
              onChanged: (double value) {
                setState(() {
                  _numberOfPeople = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _submitReservation,
                child: const Text('Submit Reservation'),//submit button
              ),
            ),
          ],
        ),
      ),
    );
  }
}