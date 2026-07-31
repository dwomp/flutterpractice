import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';
import 'package:netflix_clone/screen/detail_screen.dart';

class CarouselImage extends StatefulWidget {
  final List<Movie> movies;

  const CarouselImage({
    super.key,
    required this.movies,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  late final List<Movie> movies;
  late final List<Widget> images;
  late final List<String> keywords;
  late final List<bool> likes;

  int _currentPage = 0;
  String _currentKeyword = '';

  @override
  void initState() {
    super.initState();

    movies = widget.movies;

    images = movies
        .map(
          (movie) => Image.network(
            movie.poster,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                ),
              );
            },
          ),
        )
        .toList();

    keywords = movies.map((movie) => movie.keyword).toList();
    likes = movies.map((movie) => movie.like).toList();

    if (keywords.isNotEmpty) {
      _currentKeyword = keywords.first;
    }
  }

  Future<void> _toggleLike() async {
    if (movies.isEmpty) return;

    final bool previousValue = likes[_currentPage];

    setState(() {
      likes[_currentPage] = !likes[_currentPage];
    });

    try {
      await movies[_currentPage].reference?.update({
        'like': likes[_currentPage],
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        likes[_currentPage] = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('찜 상태를 저장하지 못했습니다.'),
        ),
      );
    }
  }

  void _openDetail() {
    if (movies.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return DetailScreen(
            movie: movies[_currentPage],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text('등록된 영화가 없습니다.'),
        ),
      );
    }

    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        CarouselSlider(
          items: images,
          options: CarouselOptions(
            height: 400,
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: movies.length > 1,
            autoPlay: movies.length > 1,
            onPageChanged: (
              int index,
              CarouselPageChangedReason reason,
            ) {
              setState(() {
                _currentPage = index;
                _currentKeyword = keywords[index];
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
          child: Text(
            _currentKeyword,
            style: const TextStyle(fontSize: 11),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    likes[_currentPage]
                        ? Icons.check
                        : Icons.add,
                  ),
                  onPressed: _toggleLike,
                ),
                const Text(
                  '내가 찜한 콘텐츠',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.play_arrow),
                    SizedBox(width: 3),
                    Text('재생'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: _openDetail,
                  ),
                  const Text(
                    '정보',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: makeIndicator(
            movies.length,
            _currentPage,
          ),
        ),
      ],
    );
  }
}

List<Widget> makeIndicator(
  int itemCount,
  int currentPage,
) {
  final List<Widget> results = [];

  for (int i = 0; i < itemCount; i++) {
    results.add(
      Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentPage == i
              ? const Color.fromRGBO(255, 255, 255, 0.9)
              : const Color.fromRGBO(255, 255, 255, 0.4),
        ),
      ),
    );
  }

  return results;
}