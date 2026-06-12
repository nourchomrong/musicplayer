import 'package:frontend/app.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      color: Colors.grey[850],
      child: const Column(
        children: [
          Expanded(child: Icon(Icons.image, size: 60, color: Colors.white)),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "New Music Friday",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}