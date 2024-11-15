import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/models/seats.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/providers/booking_provider/booking_provider.dart';

class SeatSelectionScreen extends StatelessWidget {
  final MovieModel movieShow;

  const SeatSelectionScreen({super.key, required this.movieShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieShow.title.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${movieShow.releaseDate} | 22 May - 6',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade300),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const SizedBox(
            height: 400,
            child: SeatGrid(),
          ),
          const Spacer(),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Consumer<SeatSelectionProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LegendItem(label: 'Selected', color: Colors.amber),
                  LegendItem(
                      label: 'Not available', color: Colors.grey.shade200),
                  LegendItem(
                      label: 'VIP (150\$)', color: Colors.deepPurple.shade200),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '\$ ${provider.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: provider.selectedSeatsCount > 0
                          ? () => _proceedToPayment(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff61C3F2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Proceed to pay',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Implement payment flow
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class SeatGrid extends StatelessWidget {
  final double seatSize;
  final double seatGap;

  const SeatGrid({
    super.key,
    this.seatSize = 24.0,
    this.seatGap = 4.0,
  });

  Color _getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Colors.grey.shade300;
      case SeatStatus.selected:
        return Colors.amber;
      case SeatStatus.unavailable:
        return Colors.grey.shade200;
      case SeatStatus.vip:
        return Colors.deepPurple.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SeatSelectionProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const CurvedScreenLine(),
              ...List.generate(provider.rows, (row) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(provider.seatsPerRow, (seat) {
                      final currentSeat = provider.seatLayout[row][seat];
                      return GestureDetector(
                        onTap: () => provider.toggleSeat(row, seat),
                        child: Container(
                          margin: EdgeInsets.all(seatGap),
                          width: seatSize,
                          height: seatSize,
                          decoration: BoxDecoration(
                            color: _getSeatColor(currentSeat.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ]),
          ),
        );
      },
    );
  }
}

class CurvedScreenLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const CurvedScreenLine({
    super.key,
    this.width = double.infinity,
    this.height = 30,
    this.color = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: CustomPaint(
        painter: ScreenLinePainter(color: color),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'SCREEN',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenLinePainter extends CustomPainter {
  final Color color;

  ScreenLinePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    // Define curve points
    final startPoint = Offset(0, size.height * 0.3);
    final endPoint = Offset(size.width, size.height * 0.3);
    final controlPoint = Offset(size.width / 2, 0);

    // Draw the curve
    path.moveTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
