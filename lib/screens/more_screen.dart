import 'package:flutter/material.dart';
import 'package:netflix_clone/widgets/coming_soon_movie_widget.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            title: const Text(
              "New & Hot",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              const Icon(
                Icons.cast,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  color: Colors.blue,
                  height: 27,
                  width: 27,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
            bottom: TabBar(
              dividerColor: Colors.black,
              isScrollable: false,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20), 
                color: Colors.white,
              ),
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(
                  text: "    🍿 Coming Soon     ",
                ),
                Tab(
                  text: "    🔥 Everyone's Watching      ",
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    ComingSoonMovieWidget(
                      imageUrl:
                          'https://i.pinimg.com/564x/6b/a0/fb/6ba0fb36033b682d862ddee8717aa62e.jpg',
                      overview:
                          'Years after a K-pop star saves her life, a fan learns of his death — but when she is suddenly transported to the past, she sets out to change their fate.',
                      logoUrl:
                          "https://occ-0-8407-2219.1.nflxso.net/dnm/api/v6/LmEnxtiAuzezXBjYXPuDgfZ4zZQ/AAAABc4uQiGzpcQR-pkqdsFFu1SttcjNGhhRQ-iiCIAOzRIDfg5GU0B78YBb_3tHUiA3_oyHJ4VtXZcsl64A_q8AH1LPJkpHWNiOyLDJhdqdcJe6.png?r=09b",
                      month: "Nov",
                      day: "23",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ComingSoonMovieWidget(
                      imageUrl:
                          'https://i.pinimg.com/564x/5e/84/a6/5e84a62bbd8478f42233e55dd07dde12.jpg',
                      overview:
                          'This romantic drama about an heiress and her small-town husband navigating marital strife amid a business crisis reached the top 10 TV in 46 countries.',
                      logoUrl:
                          "https://image.tmdb.org/t/p/original/rjvM1bzna0Pti7SjsKin6i6L0tf.png",
                      month: "Mar",
                      day: "09",
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: ComingSoonMovieWidget(
                  imageUrl:
                      'https://miro.medium.com/v2/resize:fit:1024/1*P_YU8dGinbCy6GHlgq5OQA.jpeg',
                  overview:
                      'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
                  logoUrl:
                      'https://s3.amazonaws.com/www-inside-design/uploads/2017/10/strangerthings_feature-983x740.jpg',
                  month: "Jan",
                  day: "16",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
