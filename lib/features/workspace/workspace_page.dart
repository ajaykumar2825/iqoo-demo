// Team Workspace: members, projects, tasks, broadcast, activity.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});
  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  String _team = 'Hackathon Squad';

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Team Workspace', subtitle: 'Members, projects, shared calendar, files and broadcast — startup OS for your crew.',
            actions: [DropdownButton<String>(
              value: _team,
              underline: const SizedBox.shrink(),
              items: const [DropdownMenuItem(value: 'Hackathon Squad', child: Text('Hackathon Squad')), DropdownMenuItem(value: 'Backend Team', child: Text('Backend Team')), DropdownMenuItem(value: 'Design Team', child: Text('Design Team'))],
              onChanged: (v) => setState(() => _team = v!),
            ), GradientButton(label: 'Invite', icon: Icons.person_add_outlined, onTap: () => _toast('Invite link copied ✓'))]),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 4, child: _MembersCard()),
          const SizedBox(width: 16),
          Expanded(flex: 5, child: _TasksCard()),
          const SizedBox(width: 16),
          Expanded(flex: 4, child: _ActivityCard()),
        ]),
        const SizedBox(height: 16),
        _BroadcastCard(),
      ]),
    );
  }

  Widget _MembersCard() {
    const roles = ['HR', 'Manager', 'Developer', 'Designer', 'Intern'];
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Members • $_teamPlaceholder', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 4),
        const Text('Roles & permissions', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        ...DummyData.members.map((m) => Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)),
              child: Row(children: [
                Stack(children: [
                  CircleAvatar(backgroundColor: m.color, child: Text(m.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                  if (m.online) Positioned(right: 0, bottom: 0, child: Container(width: 11, height: 11, decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
                ]),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text(m.role, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))])),
                StatusChip(label: m.role, color: m.color, bg: m.color.withOpacity(0.12)),
              ]),
            )),
        const SizedBox(height: 6),
        const Wrap(spacing: 7, runSpacing: 7, children: [StatusChip(label: 'Shared contacts ✓'), StatusChip(label: 'Shared folders ✓', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF))]),
        Text('Roles: ${roles.join(' • ')}', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
      ]),
    );
  }

  Widget _TasksCard() {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('Projects & tasks', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const Spacer(), TextButton(onPressed: () {}, child: const Text('Shared calendar'))]),
        ...DummyData.tasks.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.2))), StatusChip(label: t.project, color: t.color, bg: t.color.withOpacity(0.12))]),
                const SizedBox(height: 8),
                ProgressBar(value: t.progress, color: t.color),
                const SizedBox(height: 7),
                Row(children: [Text('Due ${t.due}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)), const Spacer(), Text(t.assignee, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)), const SizedBox(width: 6), Text('${(t.progress * 100).toInt()}%', style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w800))]),
              ]),
            )),
      ]),
    );
  }

  Widget _ActivityCard() {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Recent activity', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 12),
        ...DummyData.activity.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 34, height: 34, decoration: BoxDecoration(color: a.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(a.icon, size: 16, color: a.color)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a.text, style: const TextStyle(fontSize: 12.5, height: 1.45)), Text(a.time, style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary))])),
              ]),
            )),
      ]),
    );
  }

  Widget _BroadcastCard() {
    final ctl = TextEditingController();
    return GlassCard(
      child: Row(children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.campaign_outlined, color: AppColors.primary)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Broadcast Center', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 6),
            TextField(controller: ctl, decoration: const InputDecoration(hintText: 'Broadcast to Hackathon Squad — updates, links, reminders…')),
          ]),
        ),
        const SizedBox(width: 12),
        GradientButton(label: 'Broadcast', icon: Icons.send_rounded, onTap: () => _toast('Broadcast sent to 5 members ✓')),
      ]),
    );
  }

  void _toast(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));

  static const _teamPlaceholder = 'Hackathon Squad';
}
