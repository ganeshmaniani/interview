import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/views/booking_history_model.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<BookingHistoryModel> bookingListHistory = [];

  @override
  void initState() {
    super.initState();
    getBookingHistory();
  }

  Future<void> getBookingHistory() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
      var response = await http.get(url);
      log(response.body);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as List;
        List<BookingHistoryModel> bookingHistoryList = responseJson
            .map((json) => BookingHistoryModel.fromJson(json))
            .toList();
        setState(() {
          bookingListHistory = bookingHistoryList;
        });
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.lightBlue),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: const Text(
                'Booking History',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bookingListHistory.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                  itemBuilder: (context, index) {
                    var booking = bookingListHistory[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 1),
                                spreadRadius: 1)
                          ]),
                      child: Column(
                        children: [
                          rowText(key: 'Name', value: booking.name ?? ""),
                          const Divider(),
                          rowText(key: "Email", value: booking.email ?? ""),
                          const Divider(),
                          rowText(
                              key: "City", value: booking.address!.city ?? ''),
                          const Divider(),
                          rowText(key: "Phone", value: booking.phone ?? ""),
                          const Divider(),
                          rowText(key: "Website", value: booking.website ?? "")
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  rowText({required String key, required String value}) {
    return Row(
      children: [
        Text(
          key,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Container()),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
