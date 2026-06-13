import 'package:frontend/app.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Icon(
              Icons.image,
              size: 60,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "New Music Friday",
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          )
        ],
      ),
    );
  }
}