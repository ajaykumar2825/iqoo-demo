// Settings: OriginOS-style appearance, devices, storage, about.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ai_service.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';
import '../shared/widgets/widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    void upd(AppSettings v) => n.update(v);

    return PageContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PageHeader(title: 'Settings', subtitle: 'OriginOS-style preferences — appearance, voice, devices, storage and backup.'),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(children: [
              _Section(title: 'Appearance', children: [
                const Text('Theme', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [ThemeMode.light, ThemeMode.dark, ThemeMode.system].map((m) {
                  final label = m == ThemeMode.light ? 'Light' : m == ThemeMode.dark ? 'Dark' : 'Auto';
                  final sel = s.themeMode == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(label: Text(label), selected: sel, onSelected: (_) => upd(s.copyWith(themeMode: m))),
                  );
                }).toList()),
                const SizedBox(height: 12),
                const Text('Accent color', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [AppColors.primary, const Color(0xFF7C5CFF), AppColors.green, const Color(0xFFFF8A3D), const Color(0xFFEF6C8A)].map((c) => GestureDetector(
                      onTap: () => upd(s.copyWith(accent: c)),
                      child: Container(margin: const EdgeInsets.only(right: 10), width: 34, height: 34, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: s.accent == c ? Colors.black : Colors.transparent, width: 2))),
                    )).toList()),
              ]),
              _Section(title: 'Voice assistant', children: [
                _Row(label: 'Language', value: s.voiceLang, onTap: () => upd(s.copyWith(voiceLang: s.voiceLang.startsWith('English') ? 'Hindi' : 'English (India)'))),
                _Row(label: 'Wake words', value: 'Hey Office ✓'),
                _Row(label: 'Voice history', value: '12 commands'),
              ]),
              _Section(title: 'Notifications', children: [
                _SwitchRow(label: 'Desktop notifications', value: s.notifications, onChanged: (v) => upd(s.copyWith(notifications: v))),
                _SwitchRow(label: 'Meeting reminders (AI)', value: true, onChanged: (_) {}),
                _SwitchRow(label: 'WhatsApp delivery alerts', value: true, onChanged: (_) {}),
              ]),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(children: [
              _Section(title: 'Connected devices', children: [
                _Row(label: "Ajay's iQOO 15", value: 'WiFi 6 • Connected', green: true),
                _Row(label: 'iQOO Neo 10', value: 'USB-C • Tap to reconnect'),
                _SwitchRow(label: 'Automatic reconnect', value: s.autoReconnect, onChanged: (v) => upd(s.copyWith(autoReconnect: v))),
                _SwitchRow(label: 'Clipboard sync phone ↔ PC', value: s.clipboardSync, onChanged: (v) => upd(s.copyWith(clipboardSync: v))),
              ]),
              _Section(title: 'Storage & backup', children: [
                const Row(children: [Text('2.1 GB of 15 GB used', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Spacer(), StatusChip(label: 'Healthy')]),
                const SizedBox(height: 8),
                const ProgressBar(value: 0.14, color: AppColors.primary),
                const SizedBox(height: 10),
                Row(children: [Expanded(child: GradientButton(label: 'Back up now', icon: Icons.cloud_upload_outlined, secondary: true, onTap: () {})), const SizedBox(width: 10), Expanded(child: GradientButton(label: 'Manage', icon: Icons.settings_outlined, secondary: true, onTap: () {}))]),
              ]),
              _Section(title: 'About Office Kit AI+', children: const [
                _Row(label: 'Version', value: '1.0.0 (hackathon)'),
                _Row(label: 'Design', value: 'OriginOS-inspired • original assets'),
                _Row(label: 'Backend', value: 'FakeAI today → Supabase/FastAPI ready'),
              ]),
            ]),
          ),
        ]),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final List<Widget> children;
  const _Section({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          ...children,
        ]),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label; final String value; final bool green; final VoidCallback? onTap;
  const _Row({required this.label, required this.value, this.green = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13.2, fontWeight: FontWeight.w500))),
          Text(value, style: TextStyle(fontSize: 12.5, color: green ? AppColors.green : AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const Icon(Icons.chevron_right_rounded, size: 17, color: AppColors.textTertiary),
        ]),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label; final bool value; final ValueChanged<bool> onChanged;
  const _SwitchRow({required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 13.2))), Switch(value: value, onChanged: onChanged)]),
    );
  }
}
