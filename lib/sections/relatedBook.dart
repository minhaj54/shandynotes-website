import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/bookDetails.dart';
import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class RelatedBookScreen extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const RelatedBookScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 600 ? 5 : 2; // Responsive columns

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
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              if (book["isFeatured"] == false) {
                return BookCard(
                  book: book,
                  onTap: () => context.go('/book/${book['Title']}'),
                );
              }
              return null;
            });
      },
    );
  }
}

class RelatedBookMainScreen extends StatefulWidget {
  const RelatedBookMainScreen({super.key});

  @override
  _RelatedBookMainScreen createState() => _RelatedBookMainScreen();
}

class _RelatedBookMainScreen extends State<RelatedBookMainScreen> {
  late Stream<List<Map<String, dynamic>>> booksStream;

  @override
  void initState() {
    super.initState();
    booksStream = BookService()
        .streamBooks(); // {{ edit_1 }} Use a stream instead of a future
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
        return RelatedBookScreen(books: snapshot.data!);
      },
    );
  }
}
