import 'package:frontend/app.dart';

class HomeTopChips extends StatelessWidget {
  final VoidCallback? onAvatarTap;

  const HomeTopChips({
    super.key,
    this.onAvatarTap,
  });

  Widget _chip(BuildContext context, String text, bool selected) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              "N",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _chip(context, "All", true),
        const SizedBox(width: 8),
        _chip(context, "Music", false),
        const SizedBox(width: 8),
        _chip(context, "Podcasts", false),
      ],
    );
  }
}