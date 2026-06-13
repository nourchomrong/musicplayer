import 'package:frontend/app.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          Icon(Icons.music_note, color: theme.colorScheme.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "1Out1 - La Cima",
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          Icon(Icons.play_arrow, color: theme.colorScheme.onSurface),
        ],
      ),
    );
  }
}