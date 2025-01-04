import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class RelatedBookScreen extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final String category;
  final String selectedBookTitle;

  const RelatedBookScreen({
    super.key,
    required this.books,
    required this.category,
    required this.selectedBookTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Filter books to exclude the selected book and match the given category
    final relatedBooks = books
        .where((book) =>
            book["Category"] == category && book["Title"] != selectedBookTitle)
        .toList();

    if (relatedBooks.isEmpty) {
      return const Center(
        child: Text('No related books found.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 730
            ? 2
            : constraints.maxWidth > 730 && constraints.maxWidth < 1000
                ? 4
                : 5; // Responsive columns

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: relatedBooks.length,
          itemBuilder: (context, index) {
            final book = relatedBooks[index];
            return BookCard(
              book: book,
              onTap: () => context.go('/book/${book['Title']}'),
            );
          },
        );
      },
    );
  }
}

class RelatedBookMainScreen extends StatefulWidget {
  final String category;
  final String selectedBookTitle;

  const RelatedBookMainScreen({
    super.key,
    required this.category,
    required this.selectedBookTitle,
  });

  @override
  _RelatedBookMainScreenState createState() => _RelatedBookMainScreenState();
}

class _RelatedBookMainScreenState extends State<RelatedBookMainScreen> {
  late Stream<List<Map<String, dynamic>>> booksStream;

  @override
  void initState() {
    super.initState();
    booksStream = BookService().streamBooks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: booksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found.'));
        }
        return RelatedBookScreen(
          books: snapshot.data!,
          category: widget.category,
          selectedBookTitle: widget.selectedBookTitle,
        );
      },
    );
  }
}
