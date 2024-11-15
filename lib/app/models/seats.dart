enum SeatStatus {
  available,
  selected,
  unavailable,
  vip,
}

class Seat {
  final int row;
  final int number;
  final bool isVip;
  SeatStatus status;
  final double price;

  Seat({
    required this.row,
    required this.number,
    required this.status,
    this.isVip = false,
  }) : price = isVip ? 150.0 : 50.0;

  Seat copyWith({
    SeatStatus? status,
  }) {
    return Seat(
      row: row,
      number: number,
      isVip: isVip,
      status: status ?? this.status,
    );
  }
}