import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String title;
  final String keyword;
  final String poster;
  final bool like;
  final DocumentReference? reference;

  const Movie({
    required this.title,
    required this.keyword,
    required this.poster,
    required this.like,
    this.reference,
  });

  factory Movie.fromMap(
    Map<String, dynamic> map, {
    DocumentReference? reference,
  }) {
    return Movie(
      title: map['title'] as String? ?? '',
      keyword: map['keyword'] as String? ?? '',
      poster: map['poster'] as String? ?? '',
      like: map['like'] as bool? ?? false,
      reference: reference,
    );
  }

  factory Movie.fromSnapshot(
  DocumentSnapshot snapshot,
) {
  final data = snapshot.data() as Map<String, dynamic>;

  return Movie.fromMap(
    data,
    reference: snapshot.reference,
  );
}

  @override
  String toString() => 'Movie<$title:$keyword>';
}