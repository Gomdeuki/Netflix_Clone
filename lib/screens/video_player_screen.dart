import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_recommendation_model.dart';
import 'package:netflix_clone/services/api_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final bool isAsset; // Whether the video is from an asset or a network source
  final String title; // Title of the video
  final String releaseYear; // Release year of the video
  final String genres; // Genres of the video
  final String description; // Description of the video

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.isAsset = false,
    required this.title,
    required this.releaseYear,
    required this.genres,
    required this.description,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late Future<MovieRecommendationModel> movieRecommendations;
  ApiServices apiServices = ApiServices();

  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    if (widget.isAsset) {
      _controller = VideoPlayerController.asset(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Ensure the UI updates when the video initializes
        });
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Ensure the UI updates when the video initializes
        });
    }

    _controller.setLooping(true); // Make the video loop

    // Fetch recommendations
    movieRecommendations = apiServices.getMovieRecommendations(1); // Dummy movieId for recommendations
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the video controller to free resources
    super.dispose();
  }

  // Toggle Play and Pause
  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Video Player
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  color: Colors.black,
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),

                // Play/Pause Button Overlay
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    color: Colors.transparent,
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  ),
                ),

                // Back button positioned at the top left corner
                Positioned(
                  left: 10, // Adjust position from the left
                  top: 10, // Adjust position from the top
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Go back when tapped
                    },
                  ),
                ),
              ],
            ),

            // Video Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.releaseYear} • ${widget.genres}",
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Recommendations Section
            // FutureBuilder<MovieRecommendationModel>(
            //   future: movieRecommendations,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     } else if (snapshot.hasError) {
            //       return Center(child: Text("Error: ${snapshot.error}"));
            //     } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
            //       return const Center(child: Text("No recommendations available."));
            //     } else {
            //       // Render recommendations here (e.g., a list of recommended videos)
            //       return Column(
            //         children: snapshot.data!.results.map((recommendation) {
            //           return ListTile(
            //             leading: CachedNetworkImage(
            //               imageUrl: recommendation.posterPath,
            //               placeholder: (context, url) => const CircularProgressIndicator(),
            //             ),
            //             title: Text(recommendation.title, style: const TextStyle(color: Colors.white)),
            //           );
            //         }).toList(),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
