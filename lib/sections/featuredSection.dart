import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../pages/bookDetails.dart';
import '../services/book_service.dart';
import '../widgets/bookCard.dart';
import '../widgets/categorySectionWidget.dart';

class FeaturedSectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const FeaturedSectionPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 730
            ? 2
            : constraints.maxWidth > 730 && constraints.maxWidth < 1100
                ? 4
                : 7; // Responsive columns

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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EbookDetailPage(book: book),
                  )),
                );
              }
              return null;
            });
      },
    );
  }
}

class FeaturedMainScreen extends StatefulWidget {
  const FeaturedMainScreen({super.key});

  @override
  _FeaturedMainScreen createState() => _FeaturedMainScreen();
}

class _FeaturedMainScreen extends State<FeaturedMainScreen> {
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
          return const Center(child: Text('No books found.'));
        }
        return FeaturedSectionPage(books: snapshot.data!);
      },
    );
  }
}
