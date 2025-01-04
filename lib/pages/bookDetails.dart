import 'package:flutter/material.dart';
import 'package:shandynotes/pages/payment_page.dart';
import 'package:shandynotes/widgets/appbarWidgets.dart';

import '../sections/relatedBook.dart';
import '../widgets/navigationDrawer.dart';
import '../widgets/share_button.dart';

class EbookDetailPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const EbookDetailPage({
    super.key,
    required this.book,
  });

  @override
  State<EbookDetailPage> createState() => _EbookDetailPageState();
}

class _EbookDetailPageState extends State<EbookDetailPage> {
  int selectedFormat = 0;
  int selectedCoverIndex = 0;
  final PageController _pageController = PageController();

  // Get cover images from the book map
  List<String> getCoverImages() {
    final coverImageUrls = widget.book['coverImages'] as List<dynamic>;
    return coverImageUrls.map((image) => image as String).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String formatPrice(dynamic price) {
    if (price == null) return '₹0.00';
    if (price is String) return price;
    if (price is num) {
      return '₹${price.toStringAsFixed(2)}';
    }
    return '₹0.00';
  }

  double calculateDiscountedPrice(
      {required double actualPrice, required double discountPercent}) {
    if (discountPercent < 0 || discountPercent > 100) {
      throw ArgumentError('Discount percent must be between 0 and 100');
    }

    double discountAmount = (actualPrice * discountPercent) / 100;
    return actualPrice - discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 970) {
            return _buildDesktopLayout(context);
          } else if (constraints.maxWidth > 700) {
            return _buildTabletLayout(context);
          }
          return _buildMobileLayout(context);
        },
      ),
    );
  }

  Widget _buildBookCoverSection(BuildContext context,
      {required bool isDesktop}) {
    final coverImages = getCoverImages();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment:
              isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Container(
              width: isDesktop ? 300 : 200,
              height: isDesktop ? 450 : 300,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent),
                  // borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(blurRadius: 2, color: Colors.deepPurpleAccent)
                  ]),
              child: Image.network(
                coverImages[selectedCoverIndex] == true
                    ? coverImages[0]
                    : coverImages[selectedCoverIndex],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, size: 80),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: coverImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCoverIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 2),
                    width: isDesktop ? 60 : 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedCoverIndex == index
                            ? Colors.deepPurpleAccent
                            : Colors.grey[300]!,
                        width: selectedCoverIndex == index ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.network(
                      coverImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.book, size: 24),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.book['Title'] ?? 'Unknown Title',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ShareButton(
              bookTitle: widget.book['Title'] ?? 'Unknown Title',
              bookAuthor: widget.book['Author'] ?? 'Shandy Notes',
              bookUrl:
                  'https://shandynotes.com/book/${widget.book['Title']}', // Adjust URL as needed
              price: double.parse(widget.book['Price'].toString()),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          children: [
            Text(
              'By ${widget.book['Author'] ?? 'Shandy Notes'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(width: 16),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(798 reviews)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                formatPrice(calculateDiscountedPrice(
                    actualPrice: widget.book['comparedPrice'],
                    discountPercent: widget.book['discountPercent'])),
                // "₹${widget.book['Price']}",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 16),
              Text(
                "₹${widget.book['comparedPrice'] ?? 199}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${widget.book['discountPercent']}% Off",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          pdfUrl: widget.book['pdfFileId'],
                          //  amount: widget.book['Price'],
                        ),
                      )),
                  // onPressed: () => context.go('/payment'),
                  icon: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                  ),
                  label: const Text('Buy Now'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          widget.book['Description'] ?? 'No description available.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context, {required int crossAxisCount}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1100;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: isMobile ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildInfoTile(context, 'Pages',
                  '${widget.book['Pages'] ?? 'Unknown'}', Icons.book),
              _buildInfoTile(context, 'Language',
                  widget.book['Language'] ?? 'Unknown', Icons.language),
              _buildInfoTile(context, 'Publisher',
                  widget.book['Publisher'] ?? 'Unknown', Icons.business),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedBooksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Notes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        RelatedBookMainScreen(
          category: widget.book['Category'],
          selectedBookTitle: widget.book['Title'],
        ),
      ],
    );
  }

  Widget _buildInfoTile(
      BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildBookCoverSection(context, isDesktop: true),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBookHeader(context),
                          //const SizedBox(height: 24),
                          // _buildPriceSection(context),
                          const SizedBox(height: 24),
                          _buildBuySection(context),
                          const SizedBox(height: 32),
                          _buildDescriptionSection(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                _buildInfoGrid(context, crossAxisCount: 4),
                const SizedBox(height: 48),
                _buildRelatedBooksSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildBookCoverSection(context, isDesktop: false),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookHeader(context),
                      const SizedBox(height: 24),
                      _buildBuySection(context),
                      const SizedBox(height: 24),
                      //_buildPriceSection(context),
                      _buildDescriptionSection(context),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoGrid(context, crossAxisCount: 3),
            const SizedBox(height: 32),
            _buildRelatedBooksSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildBookCoverSection(context, isDesktop: false),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookHeader(context),
                const SizedBox(height: 24),
                //_buildPriceSection(context),
                const SizedBox(height: 24),
                _buildBuySection(context),
                const SizedBox(height: 32),
                _buildDescriptionSection(context),
                const SizedBox(height: 32),
                _buildInfoGrid(context, crossAxisCount: 2),
                const SizedBox(height: 32),
                _buildRelatedBooksSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
