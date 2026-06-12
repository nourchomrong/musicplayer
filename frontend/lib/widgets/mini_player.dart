import 'package:frontend/app.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF1E1E1E),
      child: const Row(
        children: [
          Icon(Icons.music_note, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "1Out1 - La Cima",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(Icons.play_arrow, color: Colors.white),
        ],
      ),
    );
  }
}