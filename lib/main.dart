import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shandynotes/mobile_app/yt_channel.dart';
import 'package:shandynotes/pages/blog_page.dart';
import 'package:shandynotes/pages/bookDetails.dart';
import 'package:shandynotes/pages/categoryPage.dart';
import 'package:shandynotes/pages/homePage.dart';
import 'package:shandynotes/pages/shop_page.dart';
import 'package:shandynotes/pages/url_error_page.dart';
import 'package:shandynotes/sHandy_ai/shandy_ai.dart';
import 'package:shandynotes/services/book_service.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Map<String, dynamic>>>(
          create: (_) => BookService().streamBooks(),
          initialData: const [],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shandy Notes',
      theme: _buildTheme(),
      routerConfig: _buildRouter(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      primaryColor: Colors.deepPurpleAccent,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(fontSize: 16),
        bodyMedium: GoogleFonts.inter(fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: _buildRoutes(),
      errorBuilder: (context, state) => const UrlErrorPage(),
    );
  }

  List<GoRoute> _buildRoutes() {
    return [
      GoRoute(
        path: '/',
        builder: (context, state) => const Homepage(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const ShopPage(),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) => const BlogPage(),
      ),
      GoRoute(
        path: '/shandy-ai',
        builder: (context, state) => const SHandyNoteAiLandingPage(),
      ),
      GoRoute(
        path: '/book/:bookTitle',
        builder: (context, state) {
          final bookTitle = state.pathParameters['bookTitle'] ?? 'Unknown Note';
          return Consumer<List<Map<String, dynamic>>>(
            builder: (context, books, _) {
              final book = books.firstWhere(
                (b) => b['Title'] == bookTitle,
                orElse: () => {'Title': 'Unknown Book', 'error': true},
              );
              if (book['error'] == true) {
                return const Center(child: CircularProgressIndicator());
              }
              return EbookDetailPage(book: book);
            },
          );
        },
      ),
      GoRoute(
        path: '/yt-channel',
        builder: (context, state) => const ChannelHomePage(),
      ),
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          final categoryName =
              state.pathParameters['categoryName'] ?? 'Unknown';
          final bannerUrl = state.uri.queryParameters['bannerUrl'] ??
              'https://static.vecteezy.com/system/resources/thumbnails/044/303/796/small/abstract-wrapping-paper-rolling-on-a-black-background-concept-of-gifts-and-celebrations-design-two-rolls-of-decorative-gift-paper-in-motion-video.jpg';
          return BooksByCategoryPage(
            categoryName: categoryName,
            bannerUrl: bannerUrl,
          );
        },
      ),
    ];
  }
}
