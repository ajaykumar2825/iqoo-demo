// Phone Mirror: resizable floating phone, controls, gesture bar.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../shared/widgets/widgets.dart';

class MirrorPage extends StatefulWidget {
  const MirrorPage({super.key});
  @override
  State<MirrorPage> createState() => _MirrorPageState();
}

class _MirrorPageState extends State<MirrorPage> {
  bool landscape = false;
  double phoneW = 300;
  bool recording = false;
  int volume = 60;
  String status = 'Mouse controls phone • drag files to transfer';

  void _flash(String s) {
    setState(() => status = s);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(children: [
        // Mini back rail
        Container(
          width: 76,
          decoration: const BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: AppColors.border))),
          child: Column(children: [
            const SizedBox(height: 18),
            Container(width: 42, height: 42, decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), gradient: const LinearGradient(colors: [Color(0xFF246BFF), Color(0xFF6AA1FF)])),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white)),
            const SizedBox(height: 18),
            IconButton(tooltip: 'Back', onPressed: () => context.go('/device'), icon: const Icon(Icons.arrow_back_rounded)),
            IconButton(tooltip: 'Home', onPressed: () => context.go('/home'), icon: const Icon(Icons.home_outlined)),
            const Spacer(),
            const StatusChip(label: '● Live'),
            const SizedBox(height: 16),
          ]),
        ),
        Expanded(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(children: [
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Phone Mirror — Ajay\'s iQOO 15', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                  Text('Wi-Fi 6 • 84 MB/s • 32ms latency • clipboard sync ON', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                ]),
                const Spacer(),
                GradientButton(label: landscape ? 'Portrait' : 'Landscape', icon: Icons.screen_rotation_outlined, secondary: true, onTap: () => setState(() => landscape = !landscape)),
                const SizedBox(width: 10),
                GradientButton(label: recording ? 'Stop Recording' : 'Record', icon: recording ? Icons.stop_rounded : Icons.fiber_manual_record_rounded, onTap: () { setState(() => recording = !recording); _flash(recording ? 'Screen recording started ●' : 'Recording saved to Files/Videos ✓'); }),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Controls column
                  SizedBox(
                    width: 240,
                    child: Column(children: [
                      GlassCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Controls', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(height: 12),
                          _Ctl(icon: Icons.camera_alt_outlined, label: 'Screenshot', onTap: () => _flash('Screenshot saved to Files/Images ✓')),
                          _Ctl(icon: Icons.volume_up_outlined, label: 'Volume  $volume%', trailing: SizedBox(width: 90, child: Slider(value: volume.toDouble(), min: 0, max: 100, onChanged: (v) => setState(() => volume = v.toInt())))),
                          _Ctl(icon: Icons.screen_rotation_outlined, label: 'Rotate', onTap: () => setState(() => landscape = !landscape)),
                          _Ctl(icon: Icons.content_paste_outlined, label: 'Clipboard', onTap: () => context.go('/clipboard')),
                          _Ctl(icon: Icons.keyboard_outlined, label: 'Keyboard input', sub: 'Enabled', onTap: () => _flash('Keyboard input routed to phone ✓')),
                          _Ctl(icon: Icons.folder_open_outlined, label: 'Drag files', sub: 'Drop anywhere', onTap: () => _flash('Drop files onto the phone to transfer @ 84 MB/s')),
                          _Ctl(icon: Icons.mic_outlined, label: 'Voice input', onTap: () => _flash('Listening on phone mic… "open camera"')),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Resize phone', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          Slider(value: phoneW, min: 220, max: 420, onChanged: (v) => setState(() => phoneW = v)),
                          Text('${phoneW.toInt()} px wide', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 20),
                  // Phone
                  Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        width: landscape ? phoneW + 150 : phoneW,
                        height: landscape ? 320 : 600,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(36), gradient: const LinearGradient(colors: [Color(0xFF0B1633), Color(0xFF1B3AA0)], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: AppShadows.pop, border: Border.all(color: Colors.black, width: 6)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(children: [
                            // Fake OriginOS home
                            Container(
                              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2743B8), Color(0xFF0B1633)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                              padding: const EdgeInsets.all(18),
                              child: Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('9:41', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), Icon(Icons.signal_cellular_alt_rounded, color: Colors.white70, size: 15)]),
                                const SizedBox(height: 14),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
                                    child: const Row(children: [Icon(Icons.search_rounded, color: Colors.white70, size: 15), SizedBox(width: 8), Text('Search apps…', style: TextStyle(color: Colors.white70, fontSize: 11))])),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: landscape ? 6 : 4,
                                    mainAxisSpacing: 14, crossAxisSpacing: 12,
                                    children: const [
                                      _AppIcon(icon: Icons.camera_alt_rounded, label: 'Camera', c: Color(0xFF21C87A)),
                                      _AppIcon(icon: Icons.chat_bubble_rounded, label: 'WhatsApp', c: Color(0xFF12A94B)),
                                      _AppIcon(icon: Icons.mail_rounded, label: 'Mail', c: Color(0xFF246BFF)),
                                      _AppIcon(icon: Icons.calendar_month_rounded, label: 'Calendar', c: Color(0xFFFF8A3D)),
                                      _AppIcon(icon: Icons.note_rounded, label: 'Notes', c: Color(0xFFEF6C8A)),
                                      _AppIcon(icon: Icons.folder_rounded, label: 'Files', c: Color(0xFFFFC531)),
                                      _AppIcon(icon: Icons.image_rounded, label: 'Gallery', c: Color(0xFF7C5CFF)),
                                      _AppIcon(icon: Icons.settings_rounded, label: 'Settings', c: Color(0xFF6B7280)),
                                    ],
                                  ),
                                ),
                                // Gesture bar
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), borderRadius: BorderRadius.circular(18)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    _Gesture(icon: Icons.arrow_back_rounded, label: 'Back', onTap: () => _flash('Back gesture sent')),
                                    _Gesture(icon: Icons.circle_outlined, label: 'Home', onTap: () => _flash('Home gesture sent')),
                                    _Gesture(icon: Icons.crop_square_rounded, label: 'Recents', onTap: () => _flash('Recents opened on phone')),
                                  ]),
                                ),
                              ]),
                            ),
                            if (recording)
                              Positioned(top: 14, right: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: const Text('● REC', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)))),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Transfer column
                  SizedBox(
                    width: 250,
                    child: Column(children: [
                      GlassCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Live transfer', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(height: 10),
                          const Text('Sprint14_Report.pdf', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 8),
                          const ProgressBar(value: 0.72, color: AppColors.primary),
                          const SizedBox(height: 6),
                          const Text('72% • 84 MB/s • 3s left', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          GradientButton(label: 'Open File Manager', onTap: () => context.go('/files')),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Status', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(status, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
                        ]),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Ctl extends StatelessWidget {
  final IconData icon; final String label; final String? sub; final Widget? trailing; final VoidCallback? onTap;
  const _Ctl({required this.icon, required this.label, this.sub, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFFF1F5FF), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 17, color: AppColors.primary)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.8)), if (sub != null) Text(sub!, style: const TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w700))])),
          if (trailing != null) trailing!,
        ]),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final IconData icon; final String label; final Color c;
  const _AppIcon({required this.icon, required this.label, required this.c});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: Colors.white, size: 22)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 9.5)),
    ]);
  }
}

class _Gesture extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Gesture({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
