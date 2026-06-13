import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.loadToken();

    // show splash for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    final routeName = authController.isAuthenticated ? AppRoutes.home : AppRoutes.login;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logoicon,
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.music_note,
                  color: Colors.greenAccent,
                  size: 120,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Music App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}