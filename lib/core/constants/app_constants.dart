import 'package:flutter/material.dart';

/// Sidebar destination definition (icon + label + route).
class NavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  const NavDestination(this.label, this.icon, this.selectedIcon, this.route);
}

class AppDestinations {
  static const List<NavDestination> all = [
    NavDestination('Home', Icons.home_outlined, Icons.home_rounded, '/home'),
    NavDestination('Connected Device', Icons.smartphone_outlined, Icons.smartphone_rounded, '/device'),
    NavDestination('AI Vision', Icons.visibility_outlined, Icons.visibility_rounded, '/vision'),
    NavDestination('Smart Mail', Icons.mail_outline_rounded, Icons.mail_rounded, '/mail'),
    NavDestination('Calendar & Meetings', Icons.calendar_month_outlined, Icons.calendar_month_rounded, '/calendar'),
    NavDestination('WhatsApp Scheduler', Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, '/whatsapp'),
    NavDestination('Notes AI', Icons.note_alt_outlined, Icons.note_alt_rounded, '/notes'),
    NavDestination('Clipboard AI', Icons.content_paste_outlined, Icons.content_paste_rounded, '/clipboard'),
    NavDestination('File Manager AI', Icons.folder_outlined, Icons.folder_rounded, '/files'),
    NavDestination('Automation Center', Icons.bolt_outlined, Icons.bolt_rounded, '/automation'),
    NavDestination('Team Workspace', Icons.groups_outlined, Icons.groups_rounded, '/workspace'),
    NavDestination('Tools', Icons.grid_view_outlined, Icons.grid_view_rounded, '/tools'),
    NavDestination('Settings', Icons.settings_outlined, Icons.settings_rounded, '/settings'),
  ];
}

class AppStrings {
  static const appName = 'Office Kit AI+';
  static const tagline = 'Your AI-powered desktop companion';
  static const searchHint = 'Search notes, files, emails, contacts, tasks...';
  static const voiceHints = [
    'Summarize this image',
    'Explain this chart',
    'Send summary to HR',
    'Send this report to HR tomorrow morning',
    'Schedule backend meeting tomorrow 5PM',
    'Book sprint review Friday',
    'Send report tomorrow 9PM',
  ];
}
