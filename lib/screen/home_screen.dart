import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';
import 'package:netflix_clone/widget/box_slider.dart';
import 'package:netflix_clone/widget/carousel_slider.dart';
import 'package:netflix_clone/widget/circle_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> movieStream =
      FirebaseFirestore.instance.collection('movie').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: movieStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('영화 정보를 불러오지 못했습니다.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        final movies = documents
            .map((document) => Movie.fromSnapshot(document))
            .toList();

        if (movies.isEmpty) {
          return const Center(
            child: Text('등록된 영화가 없습니다.'),
          );
        }

        return ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CarouselImage(movies: movies),
                const TopBar(),
              ],
            ),
            CircleSlider(movies: movies),
            BoxSlider(movies: movies),
          ],
        );
      },
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
          const Text(
            'TV 프로그램',
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            '영화',
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            '내가 찜한 콘텐츠',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}