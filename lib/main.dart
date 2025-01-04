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

void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: Colors.deepPurpleAccent,
        useMaterial3: true,

        // Primary font for headings
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          // Body text
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          // Labels and small text
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),

        // Apply the fonts to AppBar
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // For buttons and interactive elements
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      routerConfig: _buildRouter(),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
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
            final bookTitle =
                state.pathParameters['bookTitle'] ?? 'Unknown Note';
            final books = Provider.of<List<Map<String, dynamic>>>(context);
            if (books.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final book = books.firstWhere(
              (b) => b['Title'] == bookTitle,
              orElse: () {
                return {'Title': 'Unknown Book', 'error': true};
              },
            );
            if (book['error'] == true) {
              return const UrlErrorPage();
            }
            return EbookDetailPage(book: book);
          },
        ),
        // GoRoute(
        //   path: '/payment',
        //   builder: (context, state) => const PaymentPage(),
        // ),
        GoRoute(
          path: '/yt-channel',
          builder: (context, state) => const ChannelHomePage(),
        ),
        GoRoute(
          path: '/category/:categoryName',
          builder: (context, state) {
            final categoryName =
                state.pathParameters['categoryName'] ?? 'Unknown Category';
            final bannerUrl = state.pathParameters['bannerUrl'] ??
                'https://static.vecteezy.com/system/resources/thumbnails/044/303/796/small/abstract-wrapping-paper-rolling-on-a-black-background-concept-of-gifts-and-celebrations-design-two-rolls-of-decorative-gift-paper-in-motion-video.jpg'; // Replace with actual URL or logic to fetch it
            return BooksByCategoryPage(
              categoryName: categoryName,
              bannerUrl: bannerUrl,
            );
          },
        ),
      ],
      errorPageBuilder: (context, state) => const MaterialPage(
        child: UrlErrorPage(),
      ),
    );
  }
}
