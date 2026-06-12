import 'package:frontend/app.dart';

class StationCard extends StatelessWidget {
  const StationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      color: Colors.orange,
      child: const Center(
        child: Text(
          "RADIO",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}