// Clipboard AI: history cards + AI suggestions + phone sync.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class ClipboardPage extends StatefulWidget {
  const ClipboardPage({super.key});
  @override
  State<ClipboardPage> createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {
  String _filter = 'All';
  bool _sync = true;

  @override
  Widget build(BuildContext context) {
    final items = DummyData.clips.where((c) => _filter == 'All' || c.kind == _filter).toList();
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Clipboard AI', subtitle: 'Everything you copy — text, links, images, files — with AI actions and phone ↔ PC sync.',
            actions: [Row(children: [const Text('Sync phone ↔ PC', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(width: 8), Switch(value: _sync, onChanged: (v) => setState(() => _sync = v))])]),
        const SizedBox(height: 16),
        Row(children: ['All', 'Text', 'Link', 'Image', 'File'].map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(f), selected: _filter == f, onSelected: (_) => setState(() => _filter = f)))).toList()),
        const SizedBox(height: 14),
        ...items.map((c) => GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(13)), child: Icon(c.icon, color: AppColors.primary, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)), Text('${c.kind} • ${c.time} • ${_sync ? 'synced from iQOO 15 ✓' : 'local only'}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))])),
                  if (c.pinned) const StatusChip(label: 'Pinned', color: Color(0xFFB7791F), bg: Color(0xFFFFF4E3)),
                  IconButton(onPressed: () => _toast('Pinned ✓'), icon: const Icon(Icons.push_pin_outlined, size: 18, color: AppColors.textTertiary)),
                  IconButton(onPressed: () => _toast('Copied to clipboard ✓'), icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textTertiary)),
                ]),
                const SizedBox(height: 8),
                Text(c.detail, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.55)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _AiBtn('Summarize', Icons.summarize_outlined, c),
                  _AiBtn('Translate', Icons.translate_rounded, c),
                  _AiBtn('Rewrite', Icons.auto_fix_high_rounded, c),
                  _AiBtn('Extract tasks', Icons.checklist_rounded, c),
                  _AiBtn('Create event', Icons.event_outlined, c),
                ]),
              ]),
            )).map((w) => Padding(padding: const EdgeInsets.only(bottom: 12), child: w)),
      ]),
    );
  }

  Widget _AiBtn(String label, IconData icon, dynamic c) {
    return GestureDetector(
      onTap: () => _toast('AI: $label applied to "${(c.title as String).split('—').first.trim()}" ✓'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 13, color: AppColors.primary), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))])),
      ),
    );
  }

  void _toast(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }
}
