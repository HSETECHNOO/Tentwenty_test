import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/core/utils/navigations.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/seats_selection/sears_selection_view.dart';

class SeatsBookingScreen extends StatelessWidget {
  const SeatsBookingScreen({super.key, required this.movieDetails});
  final MovieModel movieDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var date in _dateOptions)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(date),
                          selected: date == "5 Mar",
                          selectedColor: const Color(0xff61C3F2),
                          onSelected: (bool selected) {},
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color:
                                date == "5 Mar" ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var timeSlot in _timeSlotOptions)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildTimeSlotCard(timeSlot),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    navigateToNextSelection(
                        context, SeatSelectionScreen(movieShow: movieDetails));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff61C3F2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Select Seats",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            movieDetails.title.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            "In Theaters December 22, 2021",
            style: TextStyle(color: Color(0xff61C3F2), fontSize: 12),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildTimeSlotCard(Map<String, String> timeSlot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(timeSlot['time']!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Text(timeSlot['hall']!, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Container(
          width: 220,
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Center(
            child: Image.asset('assets/map.png'),
          ),
        ),
        Text("From ${timeSlot['price']} or ${timeSlot['bonus']}",
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

const List<String> _dateOptions = ["5 Mar", "6 Mar", "7 Mar"];
const List<Map<String, String>> _timeSlotOptions = [
  {
    "time": "12:30",
    "hall": "Cinetech + Hall 1",
    "price": "50\$",
    "bonus": "2500 bonus"
  },
  {"time": "13:30", "hall": "Cinetech", "price": "75\$", "bonus": "3000 bonus"},
  {"time": "15:30", "hall": "Cinetech", "price": "60\$", "bonus": "2000 bonus"},
];
