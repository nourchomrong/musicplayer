import 'package:frontend/app.dart';

class HomeTopChips extends StatelessWidget {
  const HomeTopChips({super.key});

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.green : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(child: Text("N")),
        const SizedBox(width: 10),
        _chip("All", true),
        const SizedBox(width: 8),
        _chip("Music", false),
        const SizedBox(width: 8),
        _chip("Podcasts", false),
      ],
    );
  }
}