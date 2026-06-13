import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authController = AuthController();
  await authController.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeatFlow',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.lightBackground,
          surface: AppColors.lightSurface,
          onBackground: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.darkBackground,
          surface: AppColors.darkSurface,
          onBackground: AppColors.lightBackground,
          onSurface: AppColors.lightBackground,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      themeMode: themeController.themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
