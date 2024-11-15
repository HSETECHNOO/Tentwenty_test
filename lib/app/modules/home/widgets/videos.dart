// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/commons/error_message_widget.dart';
import 'package:tentwenty_test/app/core/utils/api_exceptions.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/home/widgets/video_player.dart';
import 'package:tentwenty_test/app/services/movie_videos_service.dart';

class MovieVideoScreen extends StatefulWidget {
  final MovieModel movieDetails;
  const MovieVideoScreen({super.key, required this.movieDetails});

  @override
  State<MovieVideoScreen> createState() => _MovieVideoScreenState();
}

class _MovieVideoScreenState extends State<MovieVideoScreen> {
  @override
  void initState() {
    super.initState();
  }

  int indexselected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: MoviesVideosApiService()
                .fetchMovieVideos(widget.movieDetails.id ?? 0),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error is ApiException) {
                  return SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ErrorMessageWidget(
                              message: (snapshot.error as ApiException)
                                  .message
                                  .toString(),
                              onRetry: () {
                                setState(() {});
                              }),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text(snapshot.error.toString(),
                      textAlign: TextAlign.center),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Container();
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: widget.movieDetails.title.toString(),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                  Colors.black,
                                ],
                                stops: const [0.3, 0.7, 1.0],
                              ),
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: VideoPlayerWidget(
                              key: Key(indexselected.toString()),
                              videoUrl:
                                  'https://www.youtube.com/watch?v=${snapshot.data!.results![indexselected].key.toString()}',
                            ),
                          ),
                        ),

                        // Content
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top Bar with Back Button
                              SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          color: Colors.white,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.bookmark_border,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12, top: 12),
                        child: Text(
                          'More clips',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TrailorClipsWidget(
                      ontap: (i) {
                        indexselected = i;
                        setState(() {});
                      },
                      snapshot: snapshot,
                      selectedIndex: indexselected,
                    )
                  ],
                ),
              );
            }));
  }
}

class TrailorClipsWidget extends StatelessWidget {
  const TrailorClipsWidget({
    super.key,
    required this.ontap,
    required this.snapshot,
    required this.selectedIndex,
  });

  final void Function(int i) ontap;
  final AsyncSnapshot snapshot;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final results = snapshot.data?.results ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final clip = results[index];
        final isSelected = index == selectedIndex;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => ontap(index),
            child: ClipItem(
              isSelected: isSelected,
              index: index,
              clipName: clip.name.toString(),
            ),
          ),
        );
      },
    );
  }
}

class ClipItem extends StatelessWidget {
  const ClipItem({
    super.key,
    required this.isSelected,
    required this.index,
    required this.clipName,
  });

  final bool isSelected;
  final int index;
  final String clipName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            isSelected
                ? const Icon(Icons.play_circle_outline)
                : CircleAvatar(
                    backgroundColor: const Color(0xff61C3F2),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(clipName),
            ),
          ],
        ),
      ),
    );
  }
}
