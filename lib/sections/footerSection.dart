import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple[900]!,
            Colors.deepPurple[800]!,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return const DesktopFooter();
          } else {
            return const MobileFooter();
          }
        },
      ),
    );
  }
}

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '© 2025 Shandy Notes. All rights reserved.',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(
              width: 40,
            ),
            Row(
              children: [
                _buildSocialIcon(Icons.facebook_outlined),
                _buildSocialIcon(Icons.telegram_outlined),
                _buildSocialIcon(Icons.discord_outlined),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        // Copyright and Social Icons
        const Text(
          '© 2025 Shandy Notes',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.facebook_outlined),
            _buildSocialIcon(Icons.telegram_outlined),
            _buildSocialIcon(Icons.discord_outlined),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

Widget _buildFooterTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

Widget _buildFooterLink(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget _buildContactItem(IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Colors.deepPurple[100]),
      const SizedBox(width: 8),
      Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget _buildSocialIcon(IconData icon) {
  return Container(
    margin: const EdgeInsets.only(right: 16),
    child: InkWell(
      onTap: () {},
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}
