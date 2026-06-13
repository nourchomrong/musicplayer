import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: AppDrawer(
        username: 'User',
        isDarkMode: themeController.isDarkMode,
        onThemeToggle: (enabled) => themeController.setDarkMode(enabled),
        onProfileTap: () {
          Navigator.pop(context);
          // TODO: navigate to profile
        },
        onRecentTap: () {
          Navigator.pop(context);
          // TODO: navigate to recent
        },
        onSettingsTap: () {
          Navigator.pop(context);
          // TODO: navigate to settings
        },
        onLogoutTap: () async {
          Navigator.pop(context);
          await authController.logout();
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                HomeTopChips(onAvatarTap: _openDrawer),

                const SizedBox(height: 20),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    RadioCard(title: "Tep Piseth Radio"),
                    RadioCard(title: "Mann Doss Radio"),
                    RadioCard(title: "GMENGZ Radio"),
                    RadioCard(title: "Lofi Fruits Music"),
                    RadioCard(title: "Tena Radio"),
                    RadioCard(title: "KWAN Radio"),
                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  "It’s New Music Friday!",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      MusicCard(),
                      MusicCard(),
                      MusicCard(),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  "Recommended Stations",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      StationCard(),
                      StationCard(),
                      StationCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomSheet: const MiniPlayer(),

      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (index) {
          print("Tapped: $index");
        },
      ),
    );
  }
}