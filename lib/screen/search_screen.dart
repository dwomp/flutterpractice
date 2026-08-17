import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';
import 'package:netflix_clone/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _filter.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Expanded(
            child: Center(
              child: Text("데이터를 불러오지 못했습니다."),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        return _buildList(context, docs);
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final searchResults = docs.where((doc) {
      final data = doc.data();

      final title =
          (data['title'] ?? '').toString().toLowerCase();

      final keyword =
          (data['keyword'] ?? '').toString().toLowerCase();

      if (_searchText.isEmpty) {
        return true;
      }

      return title.contains(_searchText) ||
          keyword.contains(_searchText);
    }).toList();

    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1.5,
        padding: const EdgeInsets.all(3),
        children: searchResults
            .map((doc) => _buildListItem(context, doc))
            .toList(),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final movie = Movie.fromSnapshot(doc);

    return InkWell(
      child: Image.network(
        movie.poster,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
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
      children: [
        const SizedBox(height: 30),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _filter,
                  focusNode: focusNode,
                  autofocus: true,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    hintText: '검색',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white60,
                    ),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              _filter.clear();
                            },
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              focusNode.hasFocus
                  ? Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _filter.clear();
                          focusNode.unfocus();
                        },
                        child: const Text('취소'),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        _buildBody(context),
      ],
    );
  }
}