// Tools: gallery of every mini-utility + voice command reference.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/ai_service.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class ToolsPage extends ConsumerWidget {
  const ToolsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = [
      ('Screen Capture', 'Grab + analyze anything', Icons.screenshot_monitor_outlined, AppColors.primary, '/vision'),
      ('OCR Extractor', 'Text from any image', Icons.document_scanner_outlined, const Color(0xFF7C5CFF), '/vision'),
      ('Voice Commands', 'Hey Office…', Icons.mic_rounded, const Color(0xFF00B8D4), '/calendar'),
      ('PDF Exporter', 'Notes/summaries → PDF', Icons.picture_as_pdf_outlined, const Color(0xFFFF8A3D), '/notes'),
      ('Translator', '12 languages + Hinglish', Icons.translate_rounded, AppColors.green, '/vision'),
      ('Clipboard Sync', 'Phone ↔ PC live', Icons.sync_rounded, const Color(0xFFEF6C8A), '/clipboard'),
      ('Transfer History', 'Every file, every speed', Icons.swap_vert_rounded, const Color(0xFF6C63FF), '/files'),
      ('Backup & Storage', '2.1 GB of 15 GB used', Icons.cloud_outlined, const Color(0xFFB7791F), '/settings'),
    ];
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Tools', subtitle: 'Every utility in one shelf — each tile deep-links into the workspace.',
            actions: [GradientButton(label: 'Try voice', icon: Icons.mic_rounded, onTap: () => ref.read(voiceProvider.notifier).toggle())]),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 150),
          itemCount: tools.length,
          itemBuilder: (_, i) {
            final t = tools[i];
            return QuickActionCard(label: t.$1, subtitle: t.$2, icon: t.$3, color: t.$4, bg: (t.$4 as Color).withOpacity(0.1), onTap: () => context.go(t.$5 as String));
          },
        ),
        const SizedBox(height: 18),
        GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Voice command cheat-sheet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 4),
            const Text('Wake words: “Hey Office” • “Hello Office Kit”', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 9, runSpacing: 9,
              children: AppStrings.voiceHints.map((h) => GestureDetector(
                    onTap: () => ref.read(voiceProvider.notifier).toggle(),
                    child: MouseRegion(cursor: SystemMouseCursors.click, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.mic_rounded, size: 13, color: AppColors.primary), const SizedBox(width: 7), Text('“$h”', style: const TextStyle(fontSize: 12.5))]))),
                  )).toList(),
            ),
            const SizedBox(height: 12),
            const VoiceWave(),
          ]),
        ),
      ]),
    );
  }
}
