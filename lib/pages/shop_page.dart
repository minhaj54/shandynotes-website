import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../services/book_service.dart';
import '../widgets/appbarWidgets.dart';
import '../widgets/bookCard.dart';
import 'bookDetails.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final BookService _bookService = BookService();
  String? selectedCategory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>>? categories;
  Stream<List<Map<String, dynamic>>>? booksStream;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initBooksStream();
  }

  void _loadCategories() async {
    categories = await _bookService.fetchCategories();
    if (mounted) setState(() {});
  }

  void _initBooksStream() {
    booksStream = _bookService.streamBooks();
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      if (category != null) {
        // Convert the Future to Stream for consistency
        booksStream = _bookService.fetchBooksByCategory(category).asStream();
      } else {
        _initBooksStream();
      }
    });
    // Close drawer on mobile when category is selected
    if (MediaQuery.of(context).size.width < 900) {
      Navigator.pop(context);
    }
  }

  Widget _buildSidebar(
      BuildContext context, List<Map<String, dynamic>> categories) {
    return Container(
      width: 250,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            color: Colors.deepPurpleAccent,
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            title: const Text('All Notes'),
            selectedColor: Colors.deepPurpleAccent,
            selected: selectedCategory == null,
            onTap: () => _filterByCategory(null),
            leading: const Icon(Iconsax.note),
            selectedTileColor: Colors.deepPurpleAccent,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryName = category['category-name'] ??
                    category['category-name'] ??
                    '';
                return ListTile(
                  selectedColor: Colors.deepPurpleAccent,
                  title: Text(categoryName),
                  selected: selectedCategory == categoryName,
                  selectedTileColor: Colors.deepPurpleAccent,
                  onTap: () => _filterByCategory(categoryName),
                  leading: const Icon(Iconsax.book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      key: _scaffoldKey,
      appBar: const ModernNavBar(),
      endDrawer: !isDesktop && categories != null
          ? Drawer(
              shape: const RoundedRectangleBorder(),
              child: _buildSidebar(context, categories!),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop && categories != null)
            _buildSidebar(context, categories!),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedCategory ?? 'All Notes',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: booksStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.library_books_outlined,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('Coming soon...'),
                                ],
                              ),
                            ),
                          );
                        }

                        final books = snapshot.data!;
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 350,
                            maxCrossAxisExtent:
                                _calculateMaxCrossAxisExtent(context),
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            //childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final book = books[index];
                              return BookCard(
                                book: book,
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      EbookDetailPage(book: book),
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
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxCrossAxisExtent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 200; // Adjust for smaller screens
    } else if (screenWidth < 900) {
      // Tablet
      return 220; // Adjust for tablet screens
    } else {
      // Desktop
      return 250; // Adjust for larger screens
    }
  }
}
