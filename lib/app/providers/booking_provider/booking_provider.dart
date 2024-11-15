import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/models/seats.dart';

class SeatSelectionProvider with ChangeNotifier {
  final int rows;
  final int seatsPerRow;
  late List<List<Seat>> seatLayout;
  final Set<String> selectedSeatIds = {};

  SeatSelectionProvider({
    required this.rows,
    required this.seatsPerRow,
  }) {
    _initializeSeats();
  }

  void _initializeSeats() {
    seatLayout = List.generate(rows, (row) {
      return List.generate(seatsPerRow, (seatNumber) {
        bool isVip = row >= rows - 2;
        bool isUnavailable = row < rows - 2 && seatNumber % 5 == 0;
        return Seat(
          row: row,
          number: seatNumber,
          isVip: isVip,
          status: isUnavailable
              ? SeatStatus.unavailable
              : (isVip ? SeatStatus.vip : SeatStatus.available),
        );
      });
    });
  }

  String _getSeatId(int row, int number) => '${row}_$number';

  void toggleSeat(int row, int seatNumber) {
    if (row < 0 || row >= rows || seatNumber < 0 || seatNumber >= seatsPerRow) {
      return;
    }

    final seat = seatLayout[row][seatNumber];
    if (seat.status == SeatStatus.unavailable) return;

    final seatId = _getSeatId(row, seatNumber);

    if (selectedSeatIds.contains(seatId)) {
      selectedSeatIds.remove(seatId);
      seatLayout[row][seatNumber] = seat.copyWith(
        status: seat.isVip ? SeatStatus.vip : SeatStatus.available,
      );
    } else {
      selectedSeatIds.add(seatId);
      seatLayout[row][seatNumber] = seat.copyWith(status: SeatStatus.selected);
    }

    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var row = 0; row < rows; row++) {
      for (var seatNumber = 0; seatNumber < seatsPerRow; seatNumber++) {
        final seatId = _getSeatId(row, seatNumber);
        if (selectedSeatIds.contains(seatId)) {
          total += seatLayout[row][seatNumber].price;
        }
      }
    }
    return total;
  }

  int get selectedSeatsCount => selectedSeatIds.length;
}
