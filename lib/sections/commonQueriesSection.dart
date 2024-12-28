import 'package:flutter/material.dart';

class CommonQueries extends StatefulWidget {
  const CommonQueries({super.key});

  @override
  State<CommonQueries> createState() => _CommonQueriesState();
}

class _CommonQueriesState extends State<CommonQueries> {
  // Track which query is expanded
  int? expandedIndex;

  // Sample queries data - you can replace with your actual data
  final List<Map<String, String>> queries = [
    {
      'question': 'What is your return policy?',
      'answer':
          'We accept returns within 30 days of purchase, provided the book is in its original condition and accompanied by the receipt. Refunds will be issued in the original form of payment. Please note that certain items, like discounted or final sale items, may not be eligible for return.',
    },
    {
      'question': 'How long does shipping take?',
      'answer':
          'Standard shipping typically takes 3-5 business days within the continental US. International shipping times vary by location, usually taking 7-14 business days.',
    },
    {
      'question': 'Do you offer international shipping?',
      'answer':
          'Yes, we ship to most countries worldwide. International shipping rates and delivery times vary by location. Please check the shipping calculator at checkout for specific rates.',
    },
    {
      'question': 'Are digital versions available?',
      'answer':
          'Yes, many of our books are available in digital format. Look for the e-book option on the product page of your desired title.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : screenWidth * 0.1,
        vertical: 32,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header Section
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side content
                Expanded(
                  flex: isMobile ? 1 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Common Inquiries',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Find quick answers to common questions about our books, services and policies.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Queries List
                      ...List.generate(
                        queries.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ExpansionTile(
                              initiallyExpanded: index == expandedIndex,
                              onExpansionChanged: (isExpanded) {
                                setState(() {
                                  expandedIndex = isExpanded ? index : null;
                                });
                              },
                              title: Text(
                                queries[index]['question']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                expandedIndex == index
                                    ? Icons.remove
                                    : Icons.add,
                                color: Colors.deepPurple,
                              ),
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              childrenPadding: const EdgeInsets.all(16),
                              children: [
                                Text(
                                  queries[index]['answer']!,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side image (hidden on mobile)
                if (!isMobile) ...[
                  const SizedBox(width: 64),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Decorative shapes
                            Positioned(
                              right: 0,
                              top: 20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              top: 0,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://static.vecteezy.com/system/resources/thumbnails/044/245/414/small_2x/confident-young-businessman-writing-on-a-clipboard-png.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
