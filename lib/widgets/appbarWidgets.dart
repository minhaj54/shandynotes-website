import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernNavBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
      backgroundColor: Colors.white,
      elevation: 0, // Removed elevation for modern flat design
      shadowColor: Colors.black12, // Subtle shadow
      surfaceTintColor: Colors.white,
      title: InkWell(
        onTap: () => context.go('/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/logo.jpg',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2)),
            ),
            const SizedBox(width: 7),
            Text(
              "Shandy Notes",
              style: GoogleFonts.kalam(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Navigation Items for Desktop
        if (!isMobile) ...[
          _buildNavButton(
            icon: Icons.home,
            label: 'Home',
            onPressed: () => context.go('/'),
          ),
          _buildNavButton(
            icon: Icons.shopping_bag,
            label: 'Shop',
            onPressed: () => context.go('/shop'),
          ),
          _buildNavButton(
            icon: Icons.auto_awesome,
            label: 'Shandy AI',
            onPressed: () => context.go('/shandy-ai'),
          ),
          _buildNavButton(
            icon: Icons.menu_book_outlined,
            label: 'Blog',
            onPressed: () => context.go('/blog'),
          ),
          const SizedBox(width: 16),
        ],

        // Login Button with enhanced styling
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: const LinearGradient(
        //         colors: [Color(0xFF7E57C2), Color(0xFF673AB7)],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //       borderRadius: BorderRadius.circular(24),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.deepPurple.withOpacity(0.2),
        //           blurRadius: 8,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //     child: ElevatedButton.icon(
        //       onPressed: () => Navigator.pushNamed(context, "login"),
        //       icon: const Icon(Icons.person, size: 20),
        //       label: Text(isMobile ? '' : 'Login'),
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.transparent,
        //         foregroundColor: Colors.white,
        //         elevation: 0,
        //         padding: EdgeInsets.symmetric(
        //           horizontal: isMobile ? 12 : 20,
        //           vertical: 12,
        //         ),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(24),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        // Menu button for mobile with enhanced styling
        if (isMobile)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.deepPurple),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),

        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.deepPurpleAccent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.deepPurpleAccent,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
