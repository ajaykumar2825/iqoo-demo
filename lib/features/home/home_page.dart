// Home dashboard: hero + device + quick actions + productivity.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Hero (responsive: stacks on narrow) ──
        GlassCard(
          padding: const EdgeInsets.all(28),
          color: const Color(0xFF0E2A7A),
          child: LayoutBuilder(builder: (_, c) {
            final narrow = c.maxWidth < 860;
            final left = Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const StatusChip(label: '✨ AI workspace online', color: Colors.white, bg: Color(0x33FFFFFF)),
                const SizedBox(height: 14),
                const Text('Good morning, Ajay 👋', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('2 meetings • 3 scheduled messages • 1 automation due today.\nYour iQOO 15 is connected and clipboard is in sync.',
                    style: TextStyle(color: Colors.white.withOpacity(0.78), fontSize: 13.5, height: 1.55)),
                const SizedBox(height: 18),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  _HeroBtn(label: 'Mirror Phone', icon: Icons.smartphone_rounded, primary: true, onTap: () => context.go('/mirror')),
                  _HeroBtn(label: 'Summarize Image', icon: Icons.auto_awesome_rounded, primary: false, onTap: () => context.go('/vision')),
                  _HeroBtn(label: 'Send Email', icon: Icons.send_rounded, primary: false, onTap: () => context.go('/mail')),
                ]),
              ]),
            );
            final right = Container(
              width: narrow ? double.infinity : 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: AppShadows.pop),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 19)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('AI suggestion', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5))),
                  const StatusChip(label: 'New'),
                ]),
                const SizedBox(height: 10),
                const Text('Backend Sync ends at 6 PM. I can generate minutes and email participants automatically.',
                    style: TextStyle(fontSize: 12.8, color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: GradientButton(label: 'Enable', onTap: () => context.go('/automation'))),
                  const SizedBox(width: 8),
                  Expanded(child: GradientButton(label: 'Dismiss', secondary: true, onTap: () {})),
                ]),
              ]),
            );
            if (narrow) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 18), right]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(width: 24), right]);
          }),
        ),
        const SizedBox(height: 18),
        // ── Device + stats (responsive) ──
        LayoutBuilder(builder: (_, c) {
          if (c.maxWidth < 860) {
            return Column(children: [_DeviceCard(), const SizedBox(height: 14), _TodayStats(text)]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: _DeviceCard()),
            const SizedBox(width: 18),
            Expanded(flex: 2, child: _TodayStats(text)),
          ]);
        }),
        const SizedBox(height: 22),
        const SectionHeader(title: 'AI Quick Actions', action: 'View all',),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (_, c) {
          final cols = c.maxWidth < 700 ? 2 : 4;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 148),
            itemCount: DummyData.quickActions.length,
            itemBuilder: (_, i) {
              final q = DummyData.quickActions[i];
              return QuickActionCard(label: q.label, subtitle: q.subtitle, icon: q.icon, color: q.color, bg: q.bg, onTap: () => context.go(q.route));
            },
          );
        }),
        const SizedBox(height: 22),
        const SectionHeader(title: "Today's Productivity"),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (_, c) {
          final w = (c.maxWidth - 28) / 3;
          return Wrap(
            spacing: 14, runSpacing: 14,
            children: [
              SizedBox(width: w, child: _MeetingsCard()),
              SizedBox(width: w, child: _ScheduledCard()),
              SizedBox(width: w, child: _FilesCard()),
            ],
          );
        }),
      ]),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  final String label; final IconData icon; final bool primary; final VoidCallback onTap;
  const _HeroBtn({required this.label, required this.icon, required this.primary, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: primary ? Colors.white : Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(primary ? 1 : 0.3)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: primary ? AppColors.primary : Colors.white),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: primary ? AppColors.primary : Colors.white)),
          ]),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = DummyData.device;
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          // Phone illustration (no proprietary assets — original CSS-style phone).
          Container(
            width: 86, height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF101B3C), Color(0xFF246BFF)], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: AppShadows.pop),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 30, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 10),
              const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              const Text('iQOO 15', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              const Text('OriginOS', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ]),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Expanded(child: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))), StatusChip.dot(d.lastSeen)]),
              Text(d.model, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _Stat(icon: Icons.battery_full_rounded, label: '${d.battery}%', color: AppColors.green),
                _Stat(icon: Icons.wifi_rounded, label: d.wifiName, color: AppColors.primary),
                _Stat(icon: Icons.bolt_rounded, label: d.transferSpeed, color: const Color(0xFFFF8A3D)),
                _Stat(icon: Icons.usb_rounded, label: d.connectionType, color: const Color(0xFF7C5CFF)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text('Storage', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const Spacer(),
                Text('${d.storageUsedGb.toStringAsFixed(1)} / ${d.storageTotalGb.toStringAsFixed(0)} GB', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              ProgressBar(value: d.storagePct, color: AppColors.primary),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Builder(builder: (context) => Row(children: [
          Expanded(child: GradientButton(label: 'Phone Mirror', icon: Icons.smartphone_rounded, onTap: () => context.go('/mirror'))),
          const SizedBox(width: 10),
          Expanded(child: GradientButton(label: 'AI Vision', icon: Icons.visibility_rounded, secondary: true, onTap: () => context.go('/vision'))),
          const SizedBox(width: 10),
          Expanded(child: GradientButton(label: 'Files', icon: Icons.folder_rounded, secondary: true, onTap: () => context.go('/files'))),
          const SizedBox(width: 10),
          Expanded(child: GradientButton(label: 'Clipboard', icon: Icons.content_paste_rounded, secondary: true, onTap: () => context.go('/clipboard'))),
        ])),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _Stat({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color))]),
    );
  }
}

class _TodayStats extends StatelessWidget {
  final TextTheme text;
  const _TodayStats(this.text);
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Meetings', '2 today', Icons.video_call_outlined, AppColors.primary),
      ('Messages', '3 queued', Icons.schedule_send_outlined, AppColors.green),
      ('Automations', '3 active', Icons.bolt_outlined, const Color(0xFF7C5CFF)),
      ('Files synced', '12 • 84 MB/s', Icons.sync_rounded, const Color(0xFFFF8A3D)),
    ];
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Today at a glance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 4),
        const Text('Tuesday, Sep 9 • AI keeps this updated live', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 84),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final (t, s, ic, c) = items[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(ic, color: c as Color, size: 19),
                const Spacer(),
                Text(t, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                Text(s as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
            );
          },
        ),
      ]),
    );
  }
}

class _MeetingsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Flexible(child: Text('Upcoming meetings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14), overflow: TextOverflow.ellipsis)), const Spacer(), TextButton(style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(48, 32)), onPressed: () => context.go('/calendar'), child: const Text('Open'))]),
        ...DummyData.meetings.take(2).map((m) => TimelineTile(title: m.title, subtitle: '${m.time} • ${m.location}', time: m.dateLabel, icon: Icons.video_call_outlined, color: m.color)),
        const AiThinking(label: 'AI drafted agenda for Backend Sync ✓'),
      ]),
    );
  }
}

class _ScheduledCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Flexible(child: Text('Scheduled messages', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14), overflow: TextOverflow.ellipsis)), const Spacer(), TextButton(style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(48, 32)), onPressed: () => context.go('/whatsapp'), child: const Text('Open'))]),
        ...DummyData.whatsapp.take(2).map((w) => TimelineTile(title: w.to, subtitle: w.body, time: w.countdown, icon: Icons.chat_bubble_outline_rounded, color: AppColors.green, chip: w.status)),
        TimelineTile(title: 'Pending automations', subtitle: 'Image → Email HR • runs after scan', time: 'Auto', icon: Icons.bolt_outlined, color: const Color(0xFF7C5CFF), chip: 'Scheduled'),
      ]),
    );
  }
}

class _FilesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Flexible(child: Text('Recent files & AI summaries', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14), overflow: TextOverflow.ellipsis)), const Spacer(), TextButton(style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(48, 32)), onPressed: () => context.go('/files'), child: const Text('Open'))]),
        ...DummyData.files.take(3).map((f) => TimelineTile(title: f.name, subtitle: '${f.meta} • ${f.size}', time: f.tag, icon: f.icon, color: f.tagColor)),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
          child: const Row(children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 17),
            SizedBox(width: 9),
            Expanded(child: Text('AI summarized Velocity_Chart.png into 5 points — ready to email.', style: TextStyle(fontSize: 12.5, height: 1.45))),
          ]),
        ),
      ]),
    );
  }
}
