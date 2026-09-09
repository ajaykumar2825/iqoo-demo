// AI Vision flagship: upload → OCR/caption/tables → summary cards → actions.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ai_service.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class AiVisionPage extends ConsumerWidget {
  const AiVisionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(visionProvider);
    final notifier = ref.read(visionProvider.notifier);
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'AI Vision', subtitle: 'Drop any image — OCR, captions, tables, deadlines, tasks and instant summaries.',
            actions: [GradientButton(label: 'Voice: “Summarize this image”', icon: Icons.mic_rounded, secondary: true, onTap: () => ref.read(voiceProvider.notifier).toggle())]),
        const SizedBox(height: 18),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Upload area
          Expanded(
            flex: 5,
            child: GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Upload', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => notifier.pickSample(),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 1.5), color: const Color(0xFFF8FAFF)),
                      child: v.hasImage ? _PreviewImage() : _DropHint(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: GradientButton(label: 'Camera', icon: Icons.camera_alt_outlined, secondary: true, onTap: () => notifier.pickSample())),
                  const SizedBox(width: 10),
                  Expanded(child: GradientButton(label: 'Drag Image', icon: Icons.upload_file_outlined, secondary: true, onTap: () => notifier.pickSample())),
                  const SizedBox(width: 10),
                  Expanded(child: GradientButton(label: 'Screen Capture', icon: Icons.screenshot_monitor_outlined, secondary: true, onTap: () => notifier.pickSample())),
                ]),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: GradientButton(label: v.status == VisionStatus.analyzing ? 'Analyzing… ${(v.progress * 100).toInt()}%' : 'Analyze with AI', icon: Icons.auto_awesome_rounded, onTap: () => notifier.analyzeImage())),
                if (v.status == VisionStatus.analyzing) ...[const SizedBox(height: 12), ProgressBar(value: v.progress, color: AppColors.primary), const SizedBox(height: 8), const Text('OCR → captioning → diagram + table extraction → summary…', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))],
                const SizedBox(height: 12),
                const Wrap(spacing: 8, runSpacing: 8, children: [
                  StatusChip(label: 'OCR'),
                  StatusChip(label: 'Captions', color: Color(0xFF7C5CFF), bg: Color(0xFFF0EBFF)),
                  StatusChip(label: 'Documents', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF)),
                  StatusChip(label: 'Diagrams', color: Color(0xFFB7791F), bg: Color(0xFFFFF4E3)),
                  StatusChip(label: 'Tables', color: Color(0xFF00B8D4), bg: Color(0xFFE3F9FD)),
                ]),
              ]),
            ),
          ),
          const SizedBox(width: 18),
          // Output
          Expanded(
            flex: 6,
            child: v.status == VisionStatus.done && v.result != null
                ? _ResultCards()
                : GlassCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('AI output', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 12),
                      if (v.status == VisionStatus.analyzing) const AiThinking(label: 'Reading pixels — extracting text, tables and meaning…')
                      else Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
                        child: const Column(children: [
                          Icon(Icons.image_search_rounded, size: 44, color: AppColors.textTertiary),
                          SizedBox(height: 10),
                          Text('Upload an image to see Summary, Key Points, Deadlines,\nPeople, Tasks, Translation and Student Mode.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      const Text('Try voice commands', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 8),
                      ...['Summarize this image', 'Explain this chart', 'Send summary to HR'].map((c) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            child: Row(children: [const Icon(Icons.mic_rounded, size: 15, color: AppColors.primary), const SizedBox(width: 9), Text('“$c”', style: const TextStyle(fontSize: 12.8))])),
                          ),
                    ]),
                  ),
          ),
        ]),
      ]),
    );
  }
}

class _DropHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.cloud_upload_outlined, size: 46, color: AppColors.primary),
        SizedBox(height: 8),
        Text('Drag & drop an image here', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        Text('or click to load the sample sprint chart', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
      ]),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Stylized chart preview (no external assets needed).
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: Container(
        color: const Color(0xFF0E2A7A),
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Velocity_Chart.png', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              const Text('Sprint 12–14 • 2.4 MB', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
              const SizedBox(height: 14),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: const [
                _Bar(h: 48, label: 'S12'),
                _Bar(h: 64, label: 'S13'),
                _Bar(h: 96, label: 'S14', hot: true),
              ]),
            ]),
          ),
          const StatusChip(label: 'Sample loaded ✓', color: Colors.white, bg: Color(0x33FFFFFF)),
        ]),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double h; final String label; final bool hot;
  const _Bar({required this.h, required this.label, this.hot = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(children: [
        Container(width: 44, height: h, decoration: BoxDecoration(color: hot ? AppColors.green : Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ]),
    );
  }
}

class _ResultCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(visionProvider).result!;
    void toast(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
    Widget card(String title, IconData icon, Color color, List<String> items) => GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(icon, size: 17, color: color), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5))]),
              const SizedBox(height: 10),
              for (final t in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(margin: const EdgeInsets.only(top: 6), width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 9),
                      Expanded(child: Text(t, style: const TextStyle(fontSize: 12.8, height: 1.5))),
                    ],
                  ),
                ),
            ],
          ),
        );
    return Column(children: [
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 18), SizedBox(width: 8), Text('Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), Spacer(), StatusChip(label: '98% confident')]),
          const SizedBox(height: 10),
          Text(r.summary, style: const TextStyle(fontSize: 13.5, height: 1.65)),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: [
            GradientButton(label: 'Email Summary', icon: Icons.send_outlined, onTap: () => toast('Summary emailed with Sprint14_Report.pdf attached ✓')),
            GradientButton(label: 'WhatsApp', icon: Icons.chat_bubble_outline_rounded, secondary: true, onTap: () => toast('Summary queued for WhatsApp ✓')),
            GradientButton(label: 'Add to Notes', icon: Icons.note_add_outlined, secondary: true, onTap: () => toast('Saved to Notes AI ✓')),
            GradientButton(label: 'Workspace', icon: Icons.groups_outlined, secondary: true, onTap: () => toast('Saved to Team Workspace ✓')),
            GradientButton(label: 'Export PDF', icon: Icons.picture_as_pdf_outlined, secondary: true, onTap: () => toast('Exported as AI_Summary.pdf ✓')),
          ]),
        ]),
      ),
      const SizedBox(height: 12),
      GridView(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 210),
        children: [
          card('Important Points', Icons.star_outline_rounded, AppColors.primary, r.points),
          card('Deadlines', Icons.alarm_outlined, const Color(0xFFFF8A3D), r.deadlines),
          card('People Mentioned', Icons.people_outline_rounded, const Color(0xFF7C5CFF), r.people),
          card('Tasks', Icons.checklist_rounded, AppColors.green, r.tasks),
        ],
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: GradientButton(label: 'Translate', icon: Icons.translate_rounded, secondary: true, onTap: () => toast('Translated to Hindi + Hinglish ✓'))),
        const SizedBox(width: 10),
        Expanded(child: GradientButton(label: 'Explain Like a Student', icon: Icons.school_outlined, secondary: true, onTap: () => toast('Student-mode explanation generated ✓'))),
        const SizedBox(width: 10),
        Expanded(child: GradientButton(label: 'Scan Another', icon: Icons.refresh_rounded, onTap: () => ref.read(visionProvider.notifier).reset())),
      ]),
    ]);
  }
}
