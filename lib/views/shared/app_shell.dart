import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';

const _kNavBarColor = Color(0xFF1C1C1E);

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    _PlaceholderPage(label: 'Chat'),
    _PlaceholderPage(label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _kNavBarColor,
        border: null,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/logo.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                CupertinoColors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Chambi',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: () {},
          child: const Icon(
            CupertinoIcons.bell,
            color: CupertinoColors.white,
            size: 22,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(child: _pages[_currentIndex]),
          _BottomNav(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ColoredBox(
      color: _kNavBarColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: _kNavBarColor,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textTertiary,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.house),
              activeIcon: const Icon(CupertinoIcons.house_fill),
              title: const Text('Inicio'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.chat_bubble),
              activeIcon: const Icon(CupertinoIcons.chat_bubble_fill),
              title: const Text('Chat'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person),
              activeIcon: const Icon(CupertinoIcons.person_fill),
              title: const Text('Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Placeholder pages ─────────────────────────────────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
      ),
    );
  }
}
