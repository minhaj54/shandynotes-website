import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyNavigationDrawer extends StatelessWidget {
  final Function(String route)? onItemSelected;
  const MyNavigationDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/logo.jpg',
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shandy Notes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Shop'),
            onTap: () => context.go('/shop'),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Shandy AI'),
            onTap: () => context.go('/shandy-ai'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Blog'),
            onTap: () => context.go('/blog'),
          ),
        ],
      ),
    );
  }
}
