// Calendar & AI Meetings: month grid + agenda + voice scheduler.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _view = 'Month';
  int _selectedDay = 9;
  final _voiceCtl = TextEditingController(text: 'Schedule backend meeting tomorrow 5PM');

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Calendar & AI Meetings', subtitle: 'Month, week, agenda and day views — just say “Book sprint review Friday”.',
            actions: ['Month', 'Week', 'Agenda', 'Day'].map((v) => ChoiceChip(label: Text(v), selected: _view == v, onSelected: (_) => setState(() => _view = v))).toList()),
        const SizedBox(height: 16),
        // Voice scheduler banner
        GlassCard(
          color: AppColors.primary,
          child: Row(children: [
            Container(width: 46, height: 46, decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.mic_rounded, color: Colors.white)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Voice scheduler', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: TextField(controller: _voiceCtl, decoration: const InputDecoration(hintText: 'Try: Book sprint review Friday', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10))),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            _WhiteButton(label: 'Create meeting', onTap: _createMeeting),
          ]),
        ),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 7, child: _MonthGrid()),
          const SizedBox(width: 16),
          Expanded(flex: 5, child: _Agenda()),
        ]),
      ]),
    );
  }

  Widget _MonthGrid() {
    const weeks = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dots = {9: AppColors.primary, 10: AppColors.green, 12: const Color(0xFF7C5CFF), 15: const Color(0xFFFF8A3D)};
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('September 2026', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right_rounded)),
          const StatusChip(label: 'Today: Sep 9'),
        ]),
        const SizedBox(height: 10),
        Row(children: weeks.map((w) => Expanded(child: Center(child: Text(w, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textTertiary, fontSize: 12))))).toList()),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 64),
          itemCount: 35,
          itemBuilder: (_, i) {
            final day = i - 6; // Sep 1 starts offset
            if (day < 1 || day > 30) return const SizedBox.shrink();
            final sel = day == _selectedDay;
            final dot = dots[day];
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(color: sel ? AppColors.primary : (dot != null ? const Color(0xFFF8FAFF) : Colors.transparent), borderRadius: BorderRadius.circular(14), border: Border.all(color: sel ? AppColors.primary : AppColors.border)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('$day', style: TextStyle(fontWeight: FontWeight.w700, color: sel ? Colors.white : AppColors.textPrimary)),
                    if (dot != null) Container(margin: const EdgeInsets.only(top: 4), width: 7, height: 7, decoration: BoxDecoration(color: sel ? Colors.white : dot, shape: BoxShape.circle)),
                  ]),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Wrap(spacing: 8, children: [
          StatusChip(label: 'Work'),
          StatusChip(label: 'Team', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF)),
          StatusChip(label: 'Design', color: Color(0xFF7C5CFF), bg: Color(0xFFF0EBFF)),
          StatusChip(label: 'Personal', color: Color(0xFFB7791F), bg: Color(0xFFFFF4E3)),
        ]),
      ]),
    );
  }

  Widget _Agenda() {
    return Column(children: [
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text('Agenda — Sep $_selectedDay', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const Spacer(), const StatusChip(label: 'AI reminders ON')]),
          const SizedBox(height: 12),
          ...DummyData.meetings.map((m) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: m.color, width: 4), top: const BorderSide(color: AppColors.border), right: const BorderSide(color: AppColors.border), bottom: const BorderSide(color: AppColors.border))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 4),
                  Text('${m.time} • ${m.location}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(children: [
                    ...m.participants.map((p) => Container(margin: const EdgeInsets.only(right: 6), width: 26, height: 26, alignment: Alignment.center, decoration: BoxDecoration(color: m.color.withOpacity(0.14), shape: BoxShape.circle), child: Text(p[0], style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: m.color)))),
                    const Spacer(),
                    const StatusChip(label: 'Meet link ready'),
                  ]),
                ]),
              )),
        ]),
      ),
      const SizedBox(height: 12),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Meeting minutes integration', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('When Backend Sync ends, AI generates minutes + emails participants automatically.', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 10),
          GradientButton(label: 'Enable auto-minutes', icon: Icons.bolt_rounded, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto-minutes enabled ✓'), behavior: SnackBarBehavior.floating))),
        ]),
      ),
    ]);
  }

  void _createMeeting() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI created meeting from: "${_voiceCtl.text}" — invites + reminder + Meet link added ✓'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }
}

class _WhiteButton extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _WhiteButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13))),
      ),
    );
  }
}
