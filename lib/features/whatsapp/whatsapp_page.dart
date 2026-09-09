// WhatsApp Scheduler: queue timeline, composer, templates, countdowns.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class WhatsAppPage extends StatefulWidget {
  const WhatsAppPage({super.key});
  @override
  State<WhatsAppPage> createState() => _WhatsAppPageState();
}

class _WhatsAppPageState extends State<WhatsAppPage> {
  final _to = TextEditingController(text: 'Manager');
  final _msg = TextEditingController(text: 'Sprint 14 report + AI summary attached 📄');
  bool _recurring = false;
  String _when = 'Tomorrow • 9:00 PM';

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'WhatsApp Scheduler', subtitle: 'Scheduled, recurring and broadcast messages with delivery confirmations.',
            actions: [GradientButton(label: 'New scheduled message', icon: Icons.add_rounded, onTap: _schedule)]),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 4, child: _Composer()),
          const SizedBox(width: 16),
          Expanded(flex: 6, child: _Queue()),
        ]),
      ]),
    );
  }

  Widget _Composer() {
    const templates = ['Daily standup reminder', 'Weekly meeting reminder', 'Birthday reminder', 'Send report tomorrow 9PM'];
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Compose', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 12),
        const Text('To / Group', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        const SizedBox(height: 6),
        TextField(controller: _to, decoration: const InputDecoration(hintText: 'Manager, Team Lead, Family…')),
        const SizedBox(height: 12),
        const Text('Message', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        const SizedBox(height: 6),
        TextField(controller: _msg, maxLines: 4, decoration: const InputDecoration(hintText: 'Type message… (voice scheduling supported)')),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.mic_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          const Expanded(child: Text('“Send report tomorrow 9PM”', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          Switch(value: _recurring, onChanged: (v) => setState(() => _recurring = v)),
          const Text('Recurring', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: ['Tomorrow • 9:00 PM', 'Daily 10:00 AM', 'Weekly Fri 11:30 AM', 'Sep 14 • 8:00 AM'].map((t) => ChoiceChip(label: Text(t, style: const TextStyle(fontSize: 12)), selected: _when == t, onSelected: (_) => setState(() => _when = t))).toList()),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: GradientButton(label: 'Attach', icon: Icons.attach_file_rounded, secondary: true, onTap: () {})),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: GradientButton(label: 'Schedule message', icon: Icons.schedule_send_rounded, onTap: _schedule)),
        ]),
        const SizedBox(height: 14),
        const Text('Templates', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 8),
        ...templates.map((t) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _msg.text = t),
              child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)), child: Row(children: [Expanded(child: Text(t, style: const TextStyle(fontSize: 12.8))), const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.textTertiary)])),
            )),
      ]),
    );
  }

  Widget _Queue() {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Message queue timeline', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const Spacer(),
          ...['Scheduled', 'Sending', 'Sent', 'Failed'].map((s) => Padding(padding: const EdgeInsets.only(left: 6), child: StatusChip(label: s, color: statusColor(s == 'Scheduled' ? 'Scheduled' : s), bg: statusBg(s == 'Scheduled' ? 'Scheduled' : s)))),
        ]),
        const SizedBox(height: 12),
        ...DummyData.whatsapp.map((w) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFE6F9EF), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF12A94B), size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Expanded(child: Text(w.to, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))), StatusChip(label: w.status, color: statusColor(w.status), bg: statusBg(w.status))]),
                  const SizedBox(height: 4),
                  Text(w.body, style: const TextStyle(fontSize: 12.8, height: 1.5)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 5),
                    Text(w.scheduledFor, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(w.countdown, style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w700)),
                    if (w.recurring) ...[const SizedBox(width: 12), const StatusChip(label: 'Recurring')],
                  ]),
                ])),
              ]),
            )),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [Icon(Icons.verified_rounded, color: AppColors.primary, size: 16), SizedBox(width: 9), Expanded(child: Text('Delivery confirmations sync from your phone — Scheduled → Sending → Sent ✓✓ in real time.', style: TextStyle(fontSize: 12.5)))]),
        ),
      ]),
    );
  }

  void _schedule() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scheduled to ${_to.text} • $_when ${_recurring ? '(recurring)' : ''} ✓'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
}
