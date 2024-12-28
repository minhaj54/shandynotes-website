import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';
import '../widgets/categorySectionWidget.dart';

class LatestSectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const LatestSectionPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 600 ? 7 : 2; // Responsive columns
        return Center(
          child: GridView.builder(
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
              if (book["isLatest"] == true) {
                return BookCard(
                  book: book,
                  onTap: () => context.go('/book/${book['Title']}'),
                );
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class LatestMainScreen extends StatefulWidget {
  const LatestMainScreen({super.key});

  @override
  _FeaturedMainScreen createState() => _FeaturedMainScreen();
}

class _FeaturedMainScreen extends State<LatestMainScreen> {
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
          return Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: const Wrap(
                    children: [
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                    ],
                  )));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Notes found.'));
        }
        return Center(child: LatestSectionPage(books: snapshot.data!));
      },
    );
  }
}
