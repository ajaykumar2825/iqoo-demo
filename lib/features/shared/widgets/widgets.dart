// ignore_for_file: public_member_api_docs
/// Reusable OriginOS-style widget kit for Office Kit AI+.
library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/theme/app_theme.dart';

// ─── GlassCard ──────────────────────────────────────────────
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.radius = AppRadius.card, this.onTap, this.color});
  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final card = AnimatedScale(
      scale: _hover ? 1.008 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: AppColors.border),
          boxShadow: _hover ? AppShadows.pop : AppShadows.card,
        ),
        child: widget.child,
      ),
    );
    if (widget.onTap == null) {
      return MouseRegion(onEnter: (_) => setState(() => _hover = true), onExit: (_) => setState(() => _hover = false), child: card);
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: widget.onTap, child: card),
    );
  }
}

// ─── GradientButton ─────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool secondary;
  const GradientButton({super.key, required this.label, this.icon, this.onTap, this.secondary = false});
  @override
  Widget build(BuildContext context) {
    if (secondary) {
      return OutlinedButton.icon(onPressed: onTap, icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17), label: Text(label));
    }
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.button), boxShadow: AppShadows.button,
          gradient: const LinearGradient(colors: [Color(0xFF246BFF), Color(0xFF4D8DFF)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button))),
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17),
        label: Text(label),
      ),
    );
  }
}

// ─── StatusChip ─────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? bg;
  final IconData? icon;
  const StatusChip({super.key, required this.label, this.color, this.bg, this.icon});
  factory StatusChip.dot(String label, {bool online = true}) => StatusChip(
        label: label,
        color: online ? const Color(0xFF0E9F6E) : AppColors.textSecondary,
        bg: online ? AppColors.greenSoft : const Color(0xFFF1F4F9),
        icon: Icons.circle,
      );
  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(color: bg ?? AppColors.primarySoft, borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        if (icon != null) ...[Icon(icon, size: icon == Icons.circle ? 8 : 13, color: c), const SizedBox(width: 6)],
        Flexible(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c), overflow: TextOverflow.ellipsis, maxLines: 1)),
      ]),
    );
  }
}

Color statusColor(String s) {
  switch (s) {
    case 'Sent': return const Color(0xFF0E9F6E);
    case 'Sending': return const Color(0xFFB7791F);
    case 'Failed': return AppColors.danger;
    default: return AppColors.primary;
  }
}

Color statusBg(String s) {
  switch (s) {
    case 'Sent': return AppColors.greenSoft;
    case 'Sending': return AppColors.amberSoft;
    case 'Failed': return AppColors.dangerSoft;
    default: return AppColors.primarySoft;
  }
}

// ─── SectionHeader ──────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17)),
      const Spacer(),
      if (action != null)
        TextButton(
          onPressed: onAction,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(action!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
            const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.primary),
          ]),
        ),
    ]);
  }
}

// ─── PageHeader ─────────────────────────────────────────────
class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actions;
  const PageHeader({super.key, required this.title, required this.subtitle, this.actions = const []});
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 27)),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13.5)),
        ]),
      ),
      ...actions.map((w) => Padding(padding: const EdgeInsets.only(left: 10), child: w)),
    ]);
  }
}

// ─── Sidebar ────────────────────────────────────────────────
class AppSidebar extends ConsumerWidget {
  final StatefulNavigationShell shell;
  const AppSidebar({super.key, required this.shell});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final width = collapsed ? 84.0 : 248.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: width,
      decoration: const BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: AppColors.border))),
      child: Column(children: [
        // Brand
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), gradient: const LinearGradient(colors: [Color(0xFF246BFF), Color(0xFF6AA1FF)], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: AppShadows.button),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21),
            ),
            if (!collapsed) ...[
              const SizedBox(width: 11),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Office Kit AI+', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, letterSpacing: -0.2)),
                  Text('OriginOS companion', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ]),
              ),
            ],
          ]),
        ),
        if (!collapsed)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Align(alignment: Alignment.centerLeft, child: StatusChip(label: '● Connected', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF))),
          ),
        const SizedBox(height: 6),
        // Nav list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: AppDestinations.all.length,
            itemBuilder: (context, i) {
              final d = AppDestinations.all[i];
              final selected = shell.currentIndex == i;
              return _SidebarItem(label: d.label, icon: selected ? d.selectedIcon : d.icon, selected: selected, collapsed: collapsed,
                  onTap: () => shell.goBranch(i, initialLocation: i == shell.currentIndex));
            },
          ),
        ),
        // Collapse + user
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            if (!collapsed)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF1F5FF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFDFE8FF))),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF7C5CFF), Color(0xFF246BFF)])),
                      alignment: Alignment.center, child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 10),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Ajay Kumar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text('Pro workspace', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ])),
                  const Icon(Icons.verified_rounded, color: AppColors.primary, size: 17),
                ]),
              ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => ref.read(sidebarCollapsedProvider.notifier).state = !collapsed,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Icon(collapsed ? Icons.menu_open_rounded : Icons.menu_rounded, size: 18, color: AppColors.textSecondary),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final String label; final IconData icon; final bool selected; final bool collapsed; final VoidCallback onTap;
  const _SidebarItem({required this.label, required this.icon, required this.selected, required this.collapsed, required this.onTap});
  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.symmetric(horizontal: widget.collapsed ? 0 : 13, vertical: 10.5),
            decoration: BoxDecoration(
              color: sel ? AppColors.primarySoft : (_hover ? AppColors.hoverBg : Colors.transparent),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              Stack(children: [
                if (sel && !widget.collapsed)
                  Positioned(left: -13, top: 2, bottom: 2, child: Container(width: 4, decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4))))),
                SizedBox(
                  width: widget.collapsed ? double.infinity : null,
                  child: Icon(widget.icon, size: 20, color: sel ? AppColors.primary : (_hover ? AppColors.textPrimary : AppColors.textSecondary)),
                ),
              ]),
              if (!widget.collapsed) ...[
                const SizedBox(width: 11),
                Expanded(child: Text(widget.label, style: TextStyle(fontSize: 13.2, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? AppColors.primary : AppColors.textPrimary))),
                if (sel) Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

// ─── TopBar ─────────────────────────────────────────────────
class AppTopBar extends ConsumerWidget {
  final void Function(String) onSearch;
  const AppTopBar({super.key, required this.onSearch});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 14),
      decoration: const BoxDecoration(color: AppColors.background),
      child: Row(children: [
        // Search
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 560),
            decoration: BoxDecoration(boxShadow: AppShadows.card),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.mic_rounded, size: 15, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text('Hey Office', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ]),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _TopIcon(icon: Icons.swap_vert_rounded, tooltip: 'Transfer History', badge: '4', onTap: () => _toast(context, 'Transfer history: 4 files synced today (84 MB/s)')),
        _TopIcon(icon: Icons.notifications_outlined, tooltip: 'Notifications', badge: '3', onTap: () => _toast(context, '3 notifications: meeting in 2h, email from HR, WhatsApp scheduled')),
        // AI avatar
        GestureDetector(
          onTap: () => ref.read(voiceProvider.notifier).toggle(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF246BFF), Color(0xFF7C5CFF)]), boxShadow: AppShadows.button),
              child: const CircleAvatar(radius: 17, backgroundColor: Colors.white, child: Icon(Icons.auto_awesome_rounded, size: 17, color: AppColors.primary)),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/settings'),
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CircleAvatar(radius: 18, backgroundColor: Color(0xFF246BFF), child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          ),
        ),
        const SizedBox(width: 6),
        _TopIcon(icon: Icons.settings_outlined, tooltip: 'Settings', onTap: () => context.go('/settings')),
      ]),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }
}

class _TopIcon extends StatefulWidget {
  final IconData icon; final String tooltip; final String? badge; final VoidCallback onTap;
  const _TopIcon({required this.icon, required this.tooltip, this.badge, required this.onTap});
  @override
  State<_TopIcon> createState() => _TopIconState();
}

class _TopIconState extends State<_TopIcon> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 42, height: 42,
            decoration: BoxDecoration(color: _hover ? AppColors.primarySoft : Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.border), boxShadow: AppShadows.card),
            child: Stack(children: [
              Center(child: Icon(widget.icon, size: 19, color: _hover ? AppColors.primary : AppColors.textSecondary)),
              if (widget.badge != null)
                Positioned(right: 6, top: 6, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                    child: Text(widget.badge!, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)))),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─── Voice FAB + overlay ────────────────────────────────────
class VoiceFab extends ConsumerWidget {
  const VoiceFab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(voiceProvider);
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: v.transcript.isEmpty
            ? const SizedBox.shrink()
            : Container(
                key: const ValueKey('t'),
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border), boxShadow: AppShadows.pop),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.auto_awesome_rounded, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text('Office Assistant', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                    const Spacer(),
                    InkWell(onTap: () => ref.read(voiceProvider.notifier).dismiss(), child: const Icon(Icons.close_rounded, size: 15, color: AppColors.textTertiary)),
                  ]),
                  const SizedBox(height: 8),
                  Text(v.transcript, style: const TextStyle(fontSize: 13)),
                  if (v.listening) ...[const SizedBox(height: 10), const VoiceWave()],
                ]),
              ),
      ),
      GestureDetector(
        onTap: () => ref.read(voiceProvider.notifier).toggle(),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60, height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF246BFF), Color(0xFF7C5CFF)], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: AppShadows.button),
            child: Icon(v.listening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 26),
          ),
        ),
      ),
    ]);
  }
}

class VoiceWave extends StatefulWidget {
  const VoiceWave({super.key});
  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(18, (i) {
          final h = 6 + (14 * (((i * 0.7 + _c.value * 6) % 3) / 3));
          return Container(margin: const EdgeInsets.symmetric(horizontal: 2), width: 4, height: h, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.35 + 0.5 * (h / 20)), borderRadius: BorderRadius.circular(4)));
        }),
      ),
    );
  }
}

// ─── AI thinking shimmer ────────────────────────────────────
class AiThinking extends StatefulWidget {
  final String label;
  const AiThinking({super.key, this.label = 'AI is thinking...'});
  @override
  State<AiThinking> createState() => _AiThinkingState();
}

class _AiThinkingState extends State<AiThinking> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors: [AppColors.primarySoft, Colors.white, const Color(0xFFF0EBFF)], stops: [0, _c.value, 1])),
        child: Row(children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.4)),
          const SizedBox(width: 12),
          Expanded(child: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}

// ─── TimelineTile ───────────────────────────────────────────
class TimelineTile extends StatelessWidget {
  final String title; final String subtitle; final String time; final IconData icon; final Color color; final String? chip;
  const TimelineTile({super.key, required this.title, required this.subtitle, required this.time, required this.icon, required this.color, this.chip});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontWeight: FontWeight.w600)),
          if (chip != null) ...[const SizedBox(height: 4), StatusChip(label: chip!, color: statusColor(chip!), bg: statusBg(chip!))],
        ]),
      ]),
    );
  }
}

// ─── QuickActionCard ────────────────────────────────────────
class QuickActionCard extends StatefulWidget {
  final String label; final String subtitle; final IconData icon; final Color color; final Color bg; final VoidCallback onTap;
  const QuickActionCard({super.key, required this.label, required this.subtitle, required this.icon, required this.color, required this.bg, required this.onTap});
  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: _hover ? widget.color.withOpacity(0.4) : AppColors.border), boxShadow: _hover ? AppShadows.pop : AppShadows.card),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: widget.bg, borderRadius: BorderRadius.circular(14)), child: Icon(widget.icon, color: widget.color, size: 22)),
            const Spacer(),
            Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            Text(widget.subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }
}

// ─── ProgressBar ────────────────────────────────────────────
class ProgressBar extends StatelessWidget {
  final double value; final Color color; final double height;
  const ProgressBar({super.key, required this.value, required this.color, this.height = 7});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(value: value, minHeight: height, backgroundColor: const Color(0xFFEDF1F7), valueColor: AlwaysStoppedAnimation(color)),
    );
  }
}
