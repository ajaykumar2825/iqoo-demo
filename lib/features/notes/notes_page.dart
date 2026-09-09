// Notes AI: OriginOS-inspired list + rich editor + AI actions.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/services/ai_service.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int _sel = 0;
  final _title = TextEditingController(text: 'Hackathon Pitch — Office Kit AI+');
  final _body = TextEditingController(
      text: 'Problem → teams juggle phone + PC + mail + chat.\nOffice Kit AI+ unifies them: mirror the iQOO 15, scan anything with AI Vision, send via Smart Mail / WhatsApp, and automate the rest.\n\nDemo flow:\n1. Mirror phone live\n2. Summarize velocity chart\n3. Email summary to HR (Formal)\n4. Schedule WhatsApp to Manager\n\nThis is gonna change how we ship stuff.');
  bool _canvas = false;

  void _ai(String mode) {
    setState(() => _body.text = FakeAI.rewrite(_body.text, mode));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI $mode applied ✓'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Notes AI', subtitle: 'Markdown, voice notes, canvas mode and one-tap conversion to email, WhatsApp or PDF.',
            actions: [GradientButton(label: _canvas ? 'Editor mode' : 'Canvas mode', icon: Icons.draw_outlined, secondary: true, onTap: () => setState(() => _canvas = !_canvas)), GradientButton(label: 'New note', icon: Icons.add_rounded, onTap: () {})]),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 300,
            child: Column(
              children: DummyData.notes.asMap().entries.map((e) {
                final n = e.value;
                final sel = e.key == _sel;
                return GestureDetector(
                  onTap: () => setState(() => _sel = e.key),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: sel ? Colors.white : n.tint.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? AppColors.primary.withOpacity(0.45) : AppColors.border), boxShadow: sel ? AppShadows.card : []),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [Icon(n.icon, size: 17, color: AppColors.textPrimary), const SizedBox(width: 8), Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                        const SizedBox(height: 6),
                        Text(n.snippet, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(children: [...n.tags.map((t) => Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Text(t, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)))), const Spacer(), Text(n.updated, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary))]),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GlassCard(
              child: _canvas ? _CanvasMode() : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextField(controller: _title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800), decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title')),
                const Row(children: [StatusChip(label: 'Markdown'), SizedBox(width: 8), StatusChip(label: 'Auto-saved ✓', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF))]),
                const SizedBox(height: 10),
                // Toolbar
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _Tool(icon: Icons.format_bold_rounded, tip: 'Bold'),
                  _Tool(icon: Icons.format_italic_rounded, tip: 'Italic'),
                  _Tool(icon: Icons.checklist_rounded, tip: 'Checklist'),
                  _Tool(icon: Icons.image_outlined, tip: 'Insert device image'),
                  _Tool(icon: Icons.mic_outlined, tip: 'Voice note'),
                  _Tool(icon: Icons.draw_outlined, tip: 'Draw'),
                ]),
                const SizedBox(height: 10),
                TextField(controller: _body, maxLines: 12, decoration: const InputDecoration(hintText: 'Write…', border: InputBorder.none), style: const TextStyle(fontSize: 13.5, height: 1.65)),
                const Divider(height: 28),
                const Text('AI actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                const SizedBox(height: 10),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  GradientButton(label: 'Rewrite', icon: Icons.auto_fix_high_rounded, onTap: () => _ai('Professional')),
                  GradientButton(label: 'Summarize', icon: Icons.summarize_outlined, secondary: true, onTap: () => _ai('Summary')),
                  GradientButton(label: 'Expand', icon: Icons.expand_rounded, secondary: true, onTap: () => _ai('Expand')),
                  GradientButton(label: 'To Email', icon: Icons.send_outlined, secondary: true, onTap: () => _convert('email')),
                  GradientButton(label: 'To WhatsApp', icon: Icons.chat_bubble_outline_rounded, secondary: true, onTap: () => _convert('WhatsApp')),
                  GradientButton(label: 'To PDF', icon: Icons.picture_as_pdf_outlined, secondary: true, onTap: () => _convert('PDF')),
                ]),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _CanvasMode() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Text('Canvas — draw, checklist, meeting notes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), Spacer(), StatusChip(label: 'Drawing enabled')]),
      const SizedBox(height: 12),
      Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: const Color(0xFFF8FAFF), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
        child: CustomPaint(painter: _DoodlePainter(), child: const Center(child: Text('✏️  Sketch area — use mouse to doodle (demo stroke shown)', style: TextStyle(color: AppColors.textTertiary, fontSize: 12.5)))),
      ),
      const SizedBox(height: 12),
      ...['Charge iQOO 15 to 100%', 'Pre-generate Wi-Fi QR', 'Attach report PDF to workspace'].map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [const Icon(Icons.check_box_outline_blank_rounded, color: AppColors.textTertiary), const SizedBox(width: 10), Text(t, style: const TextStyle(fontSize: 13))])),
          ),
    ]);
  }

  void _convert(String where) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note converted to $where ✓'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
}

class _Tool extends StatelessWidget {
  final IconData icon; final String tip;
  const _Tool({required this.icon, required this.tip});
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tip,
      child: Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)), child: Icon(icon, size: 17, color: AppColors.textSecondary)),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.primary..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(40, size.height * 0.6)
      ..cubicTo(120, 40, 220, size.height - 40, 320, 120)
      ..cubicTo(400, 170, 460, 90, size.width - 60, 140);
    canvas.drawPath(path, p);
    final p2 = Paint()..color = AppColors.green..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width - 140, size.height - 70), 34, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
