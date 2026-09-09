// Smart Mail: Gmail-like tri-pane with nicknames, AI compose, scheduling.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/services/ai_service.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class SmartMailPage extends StatefulWidget {
  const SmartMailPage({super.key});
  @override
  State<SmartMailPage> createState() => _SmartMailPageState();
}

class _SmartMailPageState extends State<SmartMailPage> {
  int _folder = 0;
  int _selected = 0;
  String _tone = 'Formal';
  bool _composing = false;
  String _to = 'HR';
  String _body = '';
  bool _generating = false;

  static const folders = ['Inbox', 'Contacts', 'Drafts', 'Scheduled', 'Sent', 'Templates'];
  static const folderIcons = [Icons.inbox_outlined, Icons.contacts_outlined, Icons.drafts_outlined, Icons.schedule_outlined, Icons.send_outlined, Icons.dashboard_customize_outlined];
  static const nicknames = ['HR', 'Manager', 'Team Lead', 'Design Team', 'Professor', 'Finance'];
  static const tones = ['Friendly', 'Formal', 'HR', 'Startup', 'Academic'];

  Future<void> _generate() async {
    setState(() => _generating = true);
    final out = await FakeAI.composeEmail(to: _to, tone: _tone, prompt: 'Sharing the Sprint 14 performance report for your review.');
    if (mounted) setState(() { _body = out; _generating = false; _composing = true; });
  }

  @override
  Widget build(BuildContext context) {
    final mail = DummyData.emails[_selected % DummyData.emails.length];
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Smart Mail', subtitle: 'Nicknames, AI subjects, tone control and scheduled sends — “Send this report to HR tomorrow morning.”',
            actions: [GradientButton(label: 'Compose with AI', icon: Icons.edit_outlined, onTap: () => setState(() => _composing = true))]),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Folders + nicknames
          SizedBox(
            width: 220,
            child: GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ...List.generate(folders.length, (i) => InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _folder = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(color: _folder == i ? AppColors.primarySoft : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          Icon(folderIcons[i], size: 17, color: _folder == i ? AppColors.primary : AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Expanded(child: Text(folders[i], style: TextStyle(fontWeight: _folder == i ? FontWeight.w700 : FontWeight.w500, fontSize: 13, color: _folder == i ? AppColors.primary : AppColors.textPrimary))),
                          if (i == 0) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)), child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
                        ]),
                      ),
                    )),
                const Divider(height: 24),
                const Text('Nickname contacts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                const SizedBox(height: 4),
                const Text('AI remembers who “HR” is', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: nicknames.map((n) => GestureDetector(
                        onTap: () => setState(() { _to = n; _composing = true; }),
                        child: MouseRegion(cursor: SystemMouseCursors.click, child: StatusChip(label: n, color: _to == n ? Colors.white : AppColors.primary, bg: _to == n ? AppColors.primary : AppColors.primarySoft)),
                      )).toList(),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 16),
          // List
          SizedBox(
            width: 330,
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Padding(padding: const EdgeInsets.all(6), child: Row(children: [Text('${folders[_folder]}  •  ${DummyData.emails.length}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), const Spacer(), const Icon(Icons.filter_list_rounded, color: AppColors.textSecondary, size: 19)])),
                ...List.generate(DummyData.emails.length, (i) {
                  final e = DummyData.emails[i];
                  final sel = i == _selected;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(color: sel ? AppColors.primarySoft : const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(16), border: Border.all(color: sel ? AppColors.primary.withOpacity(0.4) : AppColors.border)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          CircleAvatar(radius: 19, backgroundColor: e.avatarColor, child: Text(e.nickname[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [Expanded(child: Text(e.from, style: TextStyle(fontWeight: e.unread ? FontWeight.w800 : FontWeight.w600, fontSize: 12.5))), Text(e.time, style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary))]),
                            Text(e.subject, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(e.preview, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                            if (e.hasAttachment) const Row(children: [Icon(Icons.attach_file_rounded, size: 12, color: AppColors.textTertiary), Text('Attachment', style: TextStyle(fontSize: 10.5, color: AppColors.textTertiary))]),
                          ])),
                          if (e.unread) Container(margin: const EdgeInsets.only(left: 6, top: 4), width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        ]),
                      ),
                    ),
                  );
                }),
              ]),
            ),
          ),
          const SizedBox(width: 16),
          // Preview / compose
          Expanded(
            child: _composing ? _ComposeCard(onClose: () => setState(() => _composing = false)) : _PreviewCard(mail: mail, onReply: () => setState(() => _composing = true)),
          ),
        ]),
      ]),
    );
  }

  Widget _PreviewCard({required dynamic mail, required VoidCallback onReply}) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(backgroundColor: (mail.avatarColor as Color), child: Text((mail.nickname as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(mail.from as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), Text('To me • ${mail.time}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))])),
          const StatusChip(label: 'AI summarized'),
        ]),
        const SizedBox(height: 12),
        Text(mail.subject as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(mail.preview as String, style: const TextStyle(fontSize: 13.5, height: 1.65)),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
            child: const Row(children: [Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16), SizedBox(width: 9), Expanded(child: Text('AI: email asks for approval on 3 CTC changes — suggested reply drafted in Formal tone.', style: TextStyle(fontSize: 12.5)))])),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10, children: [
          GradientButton(label: 'Reply with AI', icon: Icons.reply_rounded, onTap: onReply),
          GradientButton(label: 'Translate', icon: Icons.translate_rounded, secondary: true, onTap: () {}),
          GradientButton(label: 'Attach latest file', icon: Icons.attach_file_rounded, secondary: true, onTap: () {}),
          GradientButton(label: 'Schedule send', icon: Icons.schedule_rounded, secondary: true, onTap: () => _scheduleDialog()),
        ]),
      ]),
    );
  }

  Widget _ComposeCard({required VoidCallback onClose}) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('New message', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const Spacer(), IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded))]),
        const SizedBox(height: 6),
        Row(children: [
          const Text('To  ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Expanded(
            child: Wrap(spacing: 8, children: nicknames.map((n) => ChoiceChip(label: Text(n), selected: _to == n, onSelected: (_) => setState(() => _to = n))).toList()),
          ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          const Text('Tone  ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: tones.map((t) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(t), selected: _tone == t, onSelected: (_) => setState(() => _tone = t)))).toList()))),
        ]),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)),
            child: const Row(children: [Icon(Icons.auto_awesome_rounded, size: 15, color: AppColors.primary), SizedBox(width: 8), Expanded(child: Text('Subject (AI): Sprint 14 report + next steps for approval', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))])),
        const SizedBox(height: 10),
        Container(
          height: 190,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: _generating
              ? AiThinking(label: 'Writing email body in $_tone tone…')
              : SingleChildScrollView(child: Text(_body.isEmpty ? 'AI will write the body here. Attach the latest file or an AI summary, then schedule it.' : _body, style: const TextStyle(fontSize: 13.2, height: 1.6, color: AppColors.textPrimary))),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: [
          GradientButton(label: 'Generate with AI', icon: Icons.auto_awesome_rounded, onTap: _generate),
          GradientButton(label: 'Attach AI summary', icon: Icons.image_outlined, secondary: true, onTap: () => setState(() => _body += '\n\n[Attached: AI summary of Velocity_Chart.png — 5 points]')),
          GradientButton(label: 'Send now', icon: Icons.send_rounded, onTap: () { setState(() => _composing = false); _sent(); }),
          GradientButton(label: 'Schedule…', icon: Icons.schedule_rounded, secondary: true, onTap: _scheduleDialog),
        ]),
      ]),
    );
  }

  void _sent() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email to $_to ($_tone tone) sent ✓'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));

  void _scheduleDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Schedule send'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('“Send this report to HR tomorrow morning” — understood as Sep 10, 9:00 AM.'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: ['Tomorrow 9 AM', 'Fri 11 AM', 'Mon 10 AM', 'Recurring weekly'].map((t) => Chip(label: Text(t))).toList()),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { Navigator.pop(context); _sent(); }, child: const Text('Schedule'))],
      ),
    );
  }
}
