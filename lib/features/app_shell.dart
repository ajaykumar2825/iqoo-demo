// ignore_for_file: public_member_api_docs
/// Desktop shell: collapsible sidebar + sticky top bar + content + voice FAB.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import 'shared/widgets/widgets.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(children: [
        AppSidebar(shell: widget.shell),
        Expanded(
          child: Column(children: [
            AppTopBar(onSearch: (v) => setState(() => _query = v)),
            Expanded(
              child: Stack(children: [
                // Animated page transition on branch switch.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.012, 0), end: Offset.zero).animate(anim), child: child),
                  ),
                  child: KeyedSubtree(key: ValueKey(widget.shell.currentIndex), child: widget.shell),
                ),
                // Global search hint toast.
                if (_query.isNotEmpty)
                  Positioned(
                    top: 12, left: 28, right: 28,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: Row(children: [
                          const Icon(Icons.search_rounded, size: 17, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(child: Text('Searching for "$_query" across notes, files, emails, contacts, tasks...', style: const TextStyle(fontSize: 13))),
                          TextButton(onPressed: () => setState(() => _query = ''), child: const Text('Clear')),
                        ]),
                      ),
                    ),
                  ),
                const Positioned(right: 26, bottom: 26, child: VoiceFab()),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

/// Scrollable page container enforcing the 1440×900 desktop rhythm.
class PageContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const PageContainer({super.key, required this.child, this.maxWidth = 1180});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 110),
      child: Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child)),
    );
  }
}
