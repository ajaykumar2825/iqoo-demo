// ignore_for_file: public_member_api_docs
/// GoRouter with StatefulShellRoute — one branch per sidebar destination.
/// Phone Mirror (/mirror) is a fullscreen companion route launched from
/// Home / Connected Device.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/app_shell.dart';
import '../../features/home/home_page.dart';
import '../../features/connection/connection_page.dart';
import '../../features/mirror/mirror_page.dart';
import '../../features/ai_vision/ai_vision_page.dart';
import '../../features/smart_mail/smart_mail_page.dart';
import '../../features/calendar/calendar_page.dart';
import '../../features/whatsapp/whatsapp_page.dart';
import '../../features/notes/notes_page.dart';
import '../../features/clipboard/clipboard_page.dart';
import '../../features/files/file_manager_page.dart';
import '../../features/automation/automation_page.dart';
import '../../features/workspace/workspace_page.dart';
import '../../features/tools/tools_page.dart';
import '../../features/settings/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, __) => const HomePage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/device', builder: (_, __) => const ConnectionPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/vision', builder: (_, __) => const AiVisionPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/mail', builder: (_, __) => const SmartMailPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/calendar', builder: (_, __) => const CalendarPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/whatsapp', builder: (_, __) => const WhatsAppPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/notes', builder: (_, __) => const NotesPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/clipboard', builder: (_, __) => const ClipboardPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/files', builder: (_, __) => const FileManagerPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/automation', builder: (_, __) => const AutomationPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/workspace', builder: (_, __) => const WorkspacePage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/tools', builder: (_, __) => const ToolsPage())]),
        StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (_, __) => const SettingsPage())]),
      ],
    ),
    GoRoute(path: '/mirror', builder: (_, __) => const MirrorPage()),
  ],
);
