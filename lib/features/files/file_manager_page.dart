// File Manager AI: folders + grid/list + AI sidebar.
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});
  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  String _folder = 'All';
  bool _grid = true;
  String _query = '';

  static const folders = ['All', 'Images', 'Videos', 'Documents', 'Downloads', 'WhatsApp', 'Audio', 'AI Collections'];

  @override
  Widget build(BuildContext context) {
    final files = DummyData.files.where((f) => _query.isEmpty || f.name.toLowerCase().contains(_query.toLowerCase())).toList();
    return PageContainer(
      maxWidth: 1240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'File Manager AI', subtitle: 'Search everything, smart tags, AI collections and one-click organize.',
            actions: [GradientButton(label: _grid ? 'List view' : 'Grid view', icon: _grid ? Icons.view_list_rounded : Icons.grid_view_rounded, secondary: true, onTap: () => setState(() => _grid = !_grid)), GradientButton(label: 'Import', icon: Icons.add_rounded, onTap: () => _toast('Import from computer — picker opened'))]),
        const SizedBox(height: 14),
        SizedBox(
          height: 48,
          child: TextField(onChanged: (v) => setState(() => _query = v), decoration: const InputDecoration(hintText: 'Search everything — try “invoice”, “report”, “chart”…', prefixIcon: Icon(Icons.search_rounded))),
        ),
        const SizedBox(height: 14),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 200,
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: folders.map((f) => InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _folder = f),
                      child: Container(margin: const EdgeInsets.only(bottom: 3), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: _folder == f ? AppColors.primarySoft : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [Icon(_folderIcon(f), size: 17, color: _folder == f ? AppColors.primary : AppColors.textSecondary), const SizedBox(width: 10), Expanded(child: Text(f, style: TextStyle(fontWeight: _folder == f ? FontWeight.w700 : FontWeight.w500, fontSize: 13, color: _folder == f ? AppColors.primary : AppColors.textPrimary)))])),
                    )).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 7,
            child: _grid
                ? GridView.builder(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 172),
                    itemCount: files.length,
                    itemBuilder: (_, i) => _FileCard(file: files[i], onTap: () => _preview(files[i].name)),
                  )
                : Column(
                    children: files
                        .map(
                          (f) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: GlassCard(
                              padding: const EdgeInsets.all(13),
                              onTap: () => _preview(f.name),
                              child: Row(
                                children: [
                                  Container(width: 42, height: 42, decoration: BoxDecoration(color: f.iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(f.icon, color: f.tagColor)),
                                  const SizedBox(width: 12),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)), Text('${f.meta} • ${f.size}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))])),
                                  StatusChip(label: f.tag, color: f.tagColor, bg: f.tagColor.withOpacity(0.12)),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: _AiSidebar()),
        ]),
      ]),
    );
  }

  Widget _FileCard({required dynamic file, required VoidCallback onTap}) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: (file.iconBg as Color), borderRadius: BorderRadius.circular(13)), child: Icon(file.icon as IconData, color: file.tagColor as Color, size: 22)), const Spacer(), StatusChip(label: file.tag as String, color: file.tagColor as Color, bg: (file.tagColor as Color).withOpacity(0.12))]),
        const Spacer(),
        Text(file.name as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text('${file.meta} • ${file.size}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _AiSidebar() {
    const actions = [
      ('Summarize PDF', Icons.summarize_outlined, AppColors.primary),
      ('Extract Text (OCR)', Icons.document_scanner_outlined, Color(0xFF7C5CFF)),
      ('Image → PDF', Icons.picture_as_pdf_outlined, Color(0xFFFF8A3D)),
      ('Organize Automatically', Icons.auto_awesome_rounded, AppColors.green),
      ('Generate Folder', Icons.create_new_folder_outlined, Color(0xFF00B8D4)),
    ];
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 17), SizedBox(width: 8), Text('AI Sidebar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14))]),
        const SizedBox(height: 12),
        ...actions.map((a) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _toast('${(a.$1 as String)} — done ✓'),
              child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border), color: const Color(0xFFF8FAFF)),
                  child: Row(children: [Icon(a.$2 as IconData, size: 17, color: a.$3 as Color), const SizedBox(width: 10), Expanded(child: Text(a.$1 as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)))])),
            )),
        const SizedBox(height: 6),
        const Text('Smart tags', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
        const SizedBox(height: 8),
        const Wrap(spacing: 7, runSpacing: 7, children: [StatusChip(label: 'Resume'), StatusChip(label: 'Invoice', color: Color(0xFFB7791F), bg: Color(0xFFFFF4E3)), StatusChip(label: 'Meeting', color: Color(0xFF7C5CFF), bg: Color(0xFFF0EBFF)), StatusChip(label: 'Study', color: Color(0xFF00B8D4), bg: Color(0xFFE3F9FD)), StatusChip(label: 'Finance', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF))]),
      ]),
    );
  }

  IconData _folderIcon(String f) {
    switch (f) {
      case 'Images': return Icons.image_outlined;
      case 'Videos': return Icons.movie_outlined;
      case 'Documents': return Icons.description_outlined;
      case 'Downloads': return Icons.download_outlined;
      case 'WhatsApp': return Icons.chat_bubble_outline_rounded;
      case 'Audio': return Icons.audio_file_outlined;
      case 'AI Collections': return Icons.auto_awesome_outlined;
      default: return Icons.folder_outlined;
    }
  }

  void _preview(String name) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Text(name),
          content: const SizedBox(width: 380, child: Text('Preview with drag-and-drop import, AI summary and smart tags. In the full build this streams directly from your iQOO 15 at 84 MB/s.')),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')), FilledButton(onPressed: () { Navigator.pop(context); _toast('Shared to workspace ✓'); }, child: const Text('Share'))],
        ),
      );

  void _toast(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
}
