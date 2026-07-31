import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';
import 'package:netflix_clone/screen/detail_screen.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('movie')
          .where('like', isEqualTo: true)
          .snapshots(),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.hasError) {
              return const Expanded(
                child: Center(child: Text('찜한 콘텐츠를 불러오지 못했습니다.')),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final documents = snapshot.data?.docs ?? [];

            return _buildList(context, documents);
          },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1.5,
        padding: const EdgeInsets.all(3),
        children: documents
            .map((document) => _buildListItem(context, document))
            .toList(),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final movie = Movie.fromSnapshot(document);

    return InkWell(
      child: Image.network(movie.poster, fit: BoxFit.cover),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => DetailScreen(movie: movie),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 27, 20, 7),
          child: Row(
            children: <Widget>[
              Image.asset('images/logo.png', fit: BoxFit.contain, height: 25),
              const SizedBox(width: 30),
              const Text('내가 찜한 콘텐츠', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        _buildBody(context),
      ],
    );
  }
}
