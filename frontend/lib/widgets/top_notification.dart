import 'package:frontend/app.dart';

class TopNotification {
  static void show(BuildContext context, String message, {bool success = true}) {
    final theme = Theme.of(context);
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 30,
        left: 20,
        right: 20,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(12),
          color: success ? theme.colorScheme.secondary : theme.colorScheme.error,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSecondary, fontSize: 15),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
