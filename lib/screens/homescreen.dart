import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_model.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/screens/video_player_screen.dart';  // New screen to play trailers
import 'package:netflix_clone/services/api_services.dart';
import 'package:netflix_clone/widgets/custom_carousel.dart';
import 'package:netflix_clone/widgets/movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel> upcomingFuture;
  late Future<UpcomingMovieModel> nowPlayingFuture;
  late Future<TvSeriesModel> topRatedSeries;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Image.asset(
          "assets/logo.png",
          height: 50,
          width: 120,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: topRatedSeries,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomCarouselSlider(data: snapshot.data!);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Continue Watching for NiNi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Movie Poster 1 - Asset-based video (Wednesday)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoPlayerScreen(
                            videoUrl: 'assets/Wednesday.mp4', 
                            isAsset: true,  
                            title: "Wednesday's Child Is Full of Woe", // Title for Video 1
                            releaseYear: "2022", // Release year for Video 1
                            genres: "Horror, Mystery", // Genres for Video 1
                            description: "When a deliciously wicked prank gets Wednesday expelled, her parents ship her off to Nevermore Academy, the boarding school where they fell in love.", // Description for Video 1
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.network(
                          'https://m.media-amazon.com/images/I/71M8YFEakfL._AC_UF894,1000_QL80_.jpg',
                          height: 160,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),  // Added space between the posters

                  // Movie Poster 2 - Asset-based video (Taylor Swift)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideoPlayerScreen(
                            videoUrl: 'assets/miss_americana.mp4', 
                            isAsset: true, 
                            title: "Miss Americana: Taylor Swift", // Title for Video 2
                            releaseYear: "2020", // Release year for Video 2
                            genres: "language, mature themes", // Genres for Video 2
                            description: "In this revealing documentary, Taylor Swift embraces her role as a songwriter and performer — and as a woman harnessing the full power of her voice.", // Description for Video 2
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.network(
                          'https://s2.dmcdn.net/v/VQbuD1bN2QBFcWScj/x480',
                          height: 160,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: upcomingFuture, headLineText: "Now Playing"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: upcomingFuture, headLineText: "Upcoming Movies"),
            ),
          ],
        ),
      ),
    );
  }
}
