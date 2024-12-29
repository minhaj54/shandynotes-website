import 'package:flutter/material.dart';
import 'package:shandynotes/services/book_service.dart';

import '../widgets/appbarWidgets.dart';
import '../widgets/bookCard.dart';
import '../widgets/navigationDrawer.dart';
import 'bookDetails.dart';

class BooksByCategoryPage extends StatefulWidget {
  final String categoryName;
  final String bannerUrl;

  const BooksByCategoryPage(
      {super.key, required this.categoryName, required this.bannerUrl});

  @override
  _BooksByCategoryPageState createState() => _BooksByCategoryPageState();
}

class _BooksByCategoryPageState extends State<BooksByCategoryPage> {
  late Future<List<Map<String, dynamic>>> booksFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    booksFuture = BookService().fetchBooksByCategory(widget.categoryName);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom Sliver App Bar with parallax effect
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.bannerUrl),
                      ),
                    ),
                  ),
                  // Decorative pattern
                  CustomPaint(
                    painter: PatternPainter(),
                  ),
                ],
              ),
            ),
          ),

          // Books Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: FutureBuilder<List<Map<String, dynamic>>>(
              future: booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.library_books_outlined,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text('No Notes found for ${widget.categoryName}.'),
                        ],
                      ),
                    ),
                  );
                }

                final books = snapshot.data!;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: _calculateMaxCrossAxisExtent(context),
                    mainAxisExtent: 350,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final book = books[index];
                      return BookCard(
                        book: book,
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EbookDetailPage(book: book),
                        )),
                      );
                    },
                    childCount: books.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxCrossAxisExtent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1000) {
      return screenWidth / 7; // 6 items per row for very large screens
    } else if (screenWidth < 1000 && screenWidth > 810) {
      return screenWidth / 4; // 4 items per row for large screens
    } else if (screenWidth < 810 && screenWidth > 650) {
      return screenWidth / 3; // 3 items per row for medium screens
    } else {
      return screenWidth / 2; // 2 items per row for small screens
    }
  }
}

// Custom painter for decorative pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final spacing = size.width / 20;

    for (var i = 0; i < size.width; i += spacing.toInt()) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble() + spacing, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
