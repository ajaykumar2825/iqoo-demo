// ignore_for_file: public_member_api_docs
/// Fake AI backend. Every method simulates latency and returns
/// deterministic results so the UI feels real. Swap with FastAPI /
/// Supabase calls later without touching UI code.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';

/// Simulated AI Vision analysis state.
enum VisionStatus { idle, analyzing, done }

class VisionState {
  final VisionStatus status;
  final double progress;
  final bool hasImage;
  final SummaryResult? result;
  const VisionState({this.status = VisionStatus.idle, this.progress = 0, this.hasImage = false, this.result});
  VisionState copyWith({VisionStatus? status, double? progress, bool? hasImage, SummaryResult? result}) =>
      VisionState(status: status ?? this.status, progress: progress ?? this.progress, hasImage: hasImage ?? this.hasImage, result: result ?? this.result);
}

class VisionNotifier extends StateNotifier<VisionState> {
  VisionNotifier() : super(const VisionState());
  Future<void> analyzeImage() async {
    state = state.copyWith(hasImage: true, status: VisionStatus.analyzing, progress: 0);
    // Fake staged progress: OCR -> caption -> tables -> summary.
    for (var i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 160));
      if (!mounted) return;
      state = state.copyWith(progress: i / 10);
    }
    state = state.copyWith(status: VisionStatus.done, progress: 1, result: DummyData.sampleSummary);
  }

  void reset() => state = const VisionState();
  void pickSample() => state = state.copyWith(hasImage: true);
}

final visionProvider = StateNotifierProvider<VisionNotifier, VisionState>((ref) => VisionNotifier());

/// Voice assistant state (floating mic).
class VoiceState {
  final bool listening;
  final String transcript;
  const VoiceState({this.listening = false, this.transcript = ''});
}

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier() : super(const VoiceState());
  Future<void> toggle() async {
    if (state.listening) {
      state = const VoiceState(listening: false, transcript: 'Scheduled backend meeting tomorrow 5PM ✓');
      return;
    }
    state = const VoiceState(listening: true, transcript: 'Listening... "schedule backend meeting tomorrow 5PM"');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    state = const VoiceState(listening: false, transcript: 'Done — Backend Sync created for tomorrow 5:00 PM ✓');
  }

  void dismiss() => state = const VoiceState();
}

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) => VoiceNotifier());

/// Global app settings (theme, accent, notifications, ...).
class AppSettings {
  final ThemeMode themeMode;
  final Color accent;
  final bool notifications;
  final bool clipboardSync;
  final bool autoReconnect;
  final String voiceLang;
  const AppSettings({this.themeMode = ThemeMode.light, this.accent = const Color(0xFF246BFF), this.notifications = true, this.clipboardSync = true, this.autoReconnect = true, this.voiceLang = 'English (India)'});
  AppSettings copyWith({ThemeMode? themeMode, Color? accent, bool? notifications, bool? clipboardSync, bool? autoReconnect, String? voiceLang}) =>
      AppSettings(themeMode: themeMode ?? this.themeMode, accent: accent ?? this.accent, notifications: notifications ?? this.notifications, clipboardSync: clipboardSync ?? this.clipboardSync, autoReconnect: autoReconnect ?? this.autoReconnect, voiceLang: voiceLang ?? this.voiceLang);
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());
  void update(AppSettings s) => state = s;
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) => SettingsNotifier());

/// Sidebar collapsed state.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// Fake AI helpers — deterministic, offline, demo-safe.
class FakeAI {
  static Future<String> composeEmail({required String to, required String tone, required String prompt}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return 'Hi $to,\n\n$prompt\n\nKey highlights from Sprint 14: velocity +34%, p95 latency −41%, and QA cycle saved ~6h. The full report is attached for your review.\n\n${tone == 'Formal' ? 'Kind regards,\nAjay Kumar\nBackend Team' : tone == 'HR' ? 'Warm regards,\nAjay (requesting your approval 🙏)' : 'Cheers,\nAjay 🚀'}';
  }

  static String rewrite(String text, String mode) {
    if (mode == 'Professional') return text.replaceAll('gonna', 'going to').replaceAll('stuff', 'deliverables');
    if (mode == 'Expand') return '$text\n\nExpanded context: this ties into Sprint 14 goals (velocity, latency, QA parallelism) with owners and deadlines attached.';
    return 'TL;DR — $text';
  }
}
