import 'package:frontend/app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const HomeTopChips(),

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

                const Text(
                  "It’s New Music Friday!",
                  style: TextStyle(
                    color: Colors.white,
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

                const Text(
                  "Recommended Stations",
                  style: TextStyle(
                    color: Colors.white,
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