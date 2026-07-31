import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool like = false;

  @override
  void initState() {
    super.initState();
    like = widget.movie.like;
  }

  Future<void> _toggleLike() async {
    final previousLike = like;

    setState(() {
      like = !like;
    });

    try {
      await widget.movie.reference?.update({'like': like});
    } catch (e) {
      if (!mounted) return;

      setState(() {
        like = previousLike;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('찜 상태를 저장하지 못했습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.movie.poster),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black.withValues(alpha: 0.1),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 45, 0, 10),
                              height: 300,
                              child: Image.network(
                                widget.movie.poster,
                                errorBuilder:
                                    (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 60,
                                        ),
                                      );
                                    },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(7),
                              child: Text(
                                '99% 일치 2019 15+ 시즌 1개',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(
                                widget.movie.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.play_arrow),
                                      Text('재생'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(widget.movie.toString()),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '출연: 현빈, 손예진, 서지혜\n'
                                  '제작자: 이정효, 박지은',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AppBar(backgroundColor: Colors.transparent, elevation: 0),
              ],
            ),
            Container(
              color: Colors.black26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: InkWell(
                      onTap: _toggleLike,
                      child: Column(
                        children: <Widget>[
                          Icon(like ? Icons.check : Icons.add),
                          const SizedBox(height: 10),
                          const Text(
                            '내가 찜한 콘텐츠',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.thumb_up),
                        SizedBox(height: 10),
                        Text(
                          '평가',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.send),
                        SizedBox(height: 10),
                        Text(
                          '공유',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
