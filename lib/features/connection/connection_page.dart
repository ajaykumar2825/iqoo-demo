// Connect Device: WiFi QR + USB onboarding with animated states.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/data/dummy_data.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});
  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> with SingleTickerProviderStateMixin {
  int _step = 0; // 0 generate, 1 scan, 2 verify, 3 connected
  bool _usbDetecting = false;
  bool _usbConnected = true;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  void _nextStep() {
    if (_step < 3) { setState(() => _step++); if (_step == 3) _celebrate(); }
  }

  void _celebrate() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Connected to Ajay's iQOO 15 over WiFi 6 ✓"), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader(title: 'Connect Your iQOO Device', subtitle: 'Two fast ways to link your phone — scan a QR on the same Wi-Fi, or plug in USB-C.',
            actions: [GradientButton(label: 'Phone Mirror', icon: Icons.smartphone_rounded, onTap: () => context.go('/mirror'))]),
        const SizedBox(height: 18),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _WifiCard()),
          const SizedBox(width: 18),
          Expanded(child: _UsbCard()),
        ]),
        const SizedBox(height: 18),
        const SectionHeader(title: 'Recent devices'),
        const SizedBox(height: 12),
        ...DummyData.recentDevices.map((d) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(width: 46, height: 46, decoration: BoxDecoration(color: d.connected ? AppColors.greenSoft : const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(15)),
                      child: Icon(Icons.smartphone_rounded, color: d.connected ? AppColors.green : AppColors.textSecondary)),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('${d.model} • ${d.connectionType} • ${d.lastSeen}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  StatusChip.dot(d.connected ? 'Connected' : 'Offline', online: d.connected),
                  const SizedBox(width: 10),
                  GradientButton(label: d.connected ? 'Mirror' : 'Reconnect', secondary: !d.connected, onTap: () => context.go('/mirror')),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                    onSelected: (v) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$v applied'), behavior: SnackBarBehavior.floating)),
                    itemBuilder: (_) => const [PopupMenuItem(value: 'Rename device', child: Text('Rename device')), PopupMenuItem(value: 'Pair multiple', child: Text('Pair multiple')), PopupMenuItem(value: 'Disconnect', child: Text('Disconnect'))],
                  ),
                ]),
              ),
            )),
      ]),
    );
  }

  Widget _WifiCard() {
    const steps = ['Generate QR', 'Scan QR', 'Verify Device', 'Connected'];
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Option A — Same Wi-Fi QR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            Text('Laptop shows QR • phone scans it', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          const StatusChip(label: 'Recommended'),
        ]),
        const SizedBox(height: 16),
        // Stepper
        Row(children: List.generate(4, (i) {
          final done = i < _step || _step == 3;
          final active = i == _step;
          return Expanded(
            child: Row(children: [
              Container(width: 26, height: 26, alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: done ? AppColors.green : (active ? AppColors.primary : const Color(0xFFEDF1F7))),
                  child: done
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: active ? Colors.white : AppColors.textSecondary))),
              if (i < 3) Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 6), color: done ? AppColors.green : AppColors.border)),
            ]),
          );
        })),
        const SizedBox(height: 6),
        Row(children: steps.map((s) => Expanded(child: Text(s, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)))).toList()),
        const SizedBox(height: 18),
        Center(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.primary.withOpacity(0.25 + 0.35 * _pulse.value), width: 2),
                boxShadow: AppShadows.card, color: Colors.white,
              ),
              child: QrImageView(data: 'officekit-ai-plus://pair?device=Windows-Desktop&user=ajay&ts=2026', version: QrVersions.auto, size: 190, eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.textPrimary), dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.textPrimary)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (_step < 3)
          const AiThinking(label: 'Waiting for scan — point your iQOO camera at the QR…')
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Icon(Icons.check_circle_rounded, color: AppColors.green), SizedBox(width: 10), Expanded(child: Text('Connected over Wi-Fi 6 • auto-reconnect ON • 84 MB/s', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
          ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: GradientButton(label: _step >= 3 ? 'Connected ✓' : 'Simulate: ${_step == 0 ? 'Scan QR' : _step == 1 ? 'Verify' : 'Finish'}', icon: Icons.qr_code_scanner_rounded, onTap: _step >= 3 ? null : _nextStep)),
          const SizedBox(width: 10),
          Expanded(child: GradientButton(label: 'Reset', secondary: true, onTap: () => setState(() => _step = 0))),
        ]),
      ]),
    );
  }

  Widget _UsbCard() {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.usb_rounded, color: AppColors.green)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Option B — USB Data Cable', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            Text('Fastest transfers • auto-detect', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          const StatusChip(label: '210 MB/s', color: Color(0xFF0E9F6E), bg: Color(0xFFE6F9EF)),
        ]),
        const SizedBox(height: 16),
        // Illustration: laptop + phone + cable
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 120, height: 78, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border), boxShadow: AppShadows.card),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.laptop_mac_rounded, size: 30, color: AppColors.primary), Text('This PC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))])),
            SizedBox(width: 18, child: CustomPaint(painter: _CablePainter())),
            Container(width: 62, height: 110, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF101B3C), Color(0xFF246BFF)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.smartphone_rounded, color: Colors.white, size: 24), Text('iQOO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))])),
          ]),
        ),
        const SizedBox(height: 14),
        if (_usbDetecting) ...[
          const Row(children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2)), SizedBox(width: 10), Text('Detecting device… checking permissions…', style: TextStyle(fontSize: 13))]),
          const SizedBox(height: 10),
          const ProgressBar(value: 0.65, color: AppColors.green),
        ] else if (_usbConnected)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Icon(Icons.check_circle_rounded, color: AppColors.green), SizedBox(width: 10), Expanded(child: Text('Connected over USB • Trust this computer ✓ • auto-reconnect ON', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Icon(Icons.usb_off_rounded, color: AppColors.textSecondary), SizedBox(width: 10), Expanded(child: Text('No device detected — plug in USB-C and tap “Trust this computer” on your phone.', style: TextStyle(fontSize: 13)))]),
          ),
        const SizedBox(height: 14),
        // Trust popup simulation
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            const Icon(Icons.verified_user_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            const Expanded(child: Text('“Trust this computer?” — approve on your iQOO to enable mirroring + files.', style: TextStyle(fontSize: 12.5))),
            TextButton(onPressed: () async {
              setState(() => _usbDetecting = true);
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) setState(() { _usbDetecting = false; _usbConnected = true; });
            }, child: const Text('Trust')),
          ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: GradientButton(label: 'Detect Device', icon: Icons.search_rounded, secondary: true, onTap: () async {
            setState(() => _usbDetecting = true);
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) setState(() { _usbDetecting = false; _usbConnected = true; });
          })),
          const SizedBox(width: 10),
          Expanded(child: GradientButton(label: 'Mirror via USB', icon: Icons.smartphone_rounded, onTap: () => context.go('/mirror'))),
        ]),
      ]),
    );
  }
}

class _CablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.green..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(0, 8, 18, 22), 1.4, 3.4, false, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
