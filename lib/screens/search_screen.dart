import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for setting status bar color
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_recommendation_model.dart';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/screens/movie_datiled_screen.dart';
import 'package:netflix_clone/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  late Future<MovieRecommendationModel> popularMovies;
  SearchModel? searchModel;

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, 
        statusBarIconBrightness: Brightness.light, 
      ),
    );

    popularMovies = apiServices.getPopularMovies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Ensure background is black
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850], // Light gray background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoSearchTextField(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  controller: searchController,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.grey[850], // Match container color
                  onChanged: (value) {
                    if (value.isEmpty) {
                      // Do something when search is empty
                    } else {
                      search(searchController.text);
                    }
                  },
                ),
              ),
              searchController.text.isEmpty
                  ? FutureBuilder(
                      future: popularMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data?.results;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "Top Searches",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Ensure white text
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                itemCount: data!.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                            movieId: data[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 150,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.network(
                                              "$imageUrl${data[index].posterPath}"),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 260,
                                            child: Text(
                                              data[index].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white), // White text
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  : searchModel == null
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchModel?.results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 1.2 / 2),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                        movieId: searchModel!.results[index].id),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  searchModel!.results[index].backdropPath == null
                                      ? Image.asset(
                                          "assets/netflix.png",
                                          height: 170,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: "$imageUrl${searchModel!.results[index].backdropPath}",
                                          height: 170,
                                        ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      searchModel!.results[index].originalTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white), // White text
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}

