// Automation Center: visual If→Then builder + cards.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});
  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  final _if = TextEditingController(text: 'IF image scanned');
  final _then = TextEditingController(text: 'THEN summarize, THEN email HR');
  late List<bool> _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = DummyData.automations.map((a) => a.enabled).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Automation Center', subtitle: 'Build If → Then workflows with voice — “when meeting ends, email minutes”.',
            actions: [GradientButton(label: 'New automation', icon: Icons.add_rounded, onTap: _builderDialog)]),
        const SizedBox(height: 16),
        // Visual builder
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Icon(Icons.account_tree_outlined, color: AppColors.primary), SizedBox(width: 9), Text('Visual workflow builder', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), Spacer(), StatusChip(label: 'Voice builder ON')]),
            const SizedBox(height: 14),
            LayoutBuilder(builder: (_, c) {
              return Row(children: [
                Expanded(child: _Node(color: AppColors.primary, icon: Icons.help_outline_rounded, title: 'TRIGGER', child: TextField(controller: _if, decoration: const InputDecoration(hintText: 'IF…')))),
                _Arrow(),
                Expanded(child: _Node(color: const Color(0xFF7C5CFF), icon: Icons.auto_awesome_rounded, title: 'AI STEP', child: TextField(controller: _then, decoration: const InputDecoration(hintText: 'THEN…')))),
                _Arrow(),
                Expanded(child: _Node(color: AppColors.green, icon: Icons.send_outlined, title: 'ACTION', child: const Text('Email / WhatsApp / Workspace', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))),
              ]);
            }),
            const SizedBox(height: 12),
            const Wrap(spacing: 8, runSpacing: 8, children: [
              StatusChip(label: 'IF image scanned → summarize → email HR'),
              StatusChip(label: 'IF meeting ends → minutes → email all', color: Color(0xFF7C5CFF), bg: Color(0xFFF0EBFF)),
              StatusChip(label: 'IF report ready → WhatsApp manager 9PM', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: GradientButton(label: 'Save automation', icon: Icons.save_outlined, onTap: () => _toast('Automation saved & enabled ✓'))),
              const SizedBox(width: 10),
              Expanded(child: GradientButton(label: 'Create with voice', icon: Icons.mic_rounded, secondary: true, onTap: () => _toast('Listening… “when report is ready, WhatsApp manager” ✓'))),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Your automations'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 190),
          itemCount: DummyData.automations.length,
          itemBuilder: (_, i) {
            final a = DummyData.automations[i];
            final on = _enabled[i];
            return GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 42, height: 42, decoration: BoxDecoration(color: (a.color).withOpacity(0.12), borderRadius: BorderRadius.circular(13)), child: Icon(a.icon, color: a.color, size: 20)),
                  const SizedBox(width: 11),
                  Expanded(child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5))),
                  Switch(value: on, onChanged: (v) => setState(() => _enabled[i] = v)),
                ]),
                const SizedBox(height: 8),
                Text(a.description, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
                const Spacer(),
                Row(children: [
                  StatusChip(label: on ? 'Enabled' : 'Disabled', color: on ? const Color(0xFF0E9F6E) : AppColors.textSecondary, bg: on ? AppColors.greenSoft : const Color(0xFFF1F4F9)),
                  const SizedBox(width: 8),
                  Text(a.lastRun, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                  const Spacer(),
                  TextButton(onPressed: () => _builderDialog(), child: const Text('Edit')),
                  TextButton(onPressed: () => _toast('Automation deleted'), child: const Text('Delete', style: TextStyle(color: AppColors.danger))),
                ]),
              ]),
            );
          },
        ),
      ]),
    );
  }

  Widget _Node({required Color color, required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.4)), color: color.withOpacity(0.05)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 7), Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: color, letterSpacing: 0.6))]),
        const SizedBox(height: 10),
        child,
      ]),
    );
  }

  Widget _Arrow() => const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward_rounded, color: AppColors.primary));

  void _builderDialog() => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Edit automation'),
          content: const SizedBox(width: 400, child: Text('IF meeting ends → generate minutes → email participants.\nRuns on-device triggers, AI steps run in FakeAI today and FastAPI tomorrow.')),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')), FilledButton(onPressed: () { Navigator.pop(context); _toast('Automation updated ✓'); }, child: const Text('Save'))],
        ),
      );

  void _toast(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
}
