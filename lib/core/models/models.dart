// ignore_for_file: public_member_api_docs
/// Lightweight domain models — intentionally UI-friendly so a future
/// Supabase/FastAPI backend can map 1:1 onto these classes.
import 'package:flutter/material.dart';

class ConnectedDevice {
  final String name;
  final String model;
  final bool connected;
  final String connectionType; // WiFi / USB
  final int battery; // %
  final double storageUsedGb;
  final double storageTotalGb;
  final String wifiName;
  final String transferSpeed;
  final String lastSeen;
  const ConnectedDevice({
    required this.name,
    required this.model,
    required this.connected,
    required this.connectionType,
    required this.battery,
    required this.storageUsedGb,
    required this.storageTotalGb,
    required this.wifiName,
    required this.transferSpeed,
    required this.lastSeen,
  });
  double get storagePct => storageUsedGb / storageTotalGb;
}

class MeetingItem {
  final String title;
  final String time;
  final String dateLabel;
  final Color color;
  final List<String> participants;
  final String location;
  final bool aiReminder;
  const MeetingItem({required this.title, required this.time, required this.dateLabel, required this.color, required this.participants, required this.location, this.aiReminder = true});
}

class EmailItem {
  final String from;
  final String nickname;
  final String subject;
  final String preview;
  final String time;
  final bool unread;
  final Color avatarColor;
  final bool hasAttachment;
  const EmailItem({required this.from, required this.nickname, required this.subject, required this.preview, required this.time, this.unread = false, required this.avatarColor, this.hasAttachment = false});
}

class WhatsMessage {
  final String to;
  final String body;
  final String scheduledFor;
  final String status; // Scheduled | Sending | Sent | Failed
  final bool recurring;
  final String countdown;
  const WhatsMessage({required this.to, required this.body, required this.scheduledFor, required this.status, this.recurring = false, required this.countdown});
}

class NoteItem {
  final String title;
  final String snippet;
  final String updated;
  final Color tint;
  final IconData icon;
  final List<String> tags;
  const NoteItem({required this.title, required this.snippet, required this.updated, required this.tint, required this.icon, required this.tags});
}

class ClipItem {
  final String kind; // Text | Link | Image | File
  final String title;
  final String detail;
  final String time;
  final bool pinned;
  final IconData icon;
  const ClipItem({required this.kind, required this.title, required this.detail, required this.time, this.pinned = false, required this.icon});
}

class FileItem {
  final String name;
  final String meta;
  final String size;
  final String tag;
  final Color tagColor;
  final IconData icon;
  final Color iconBg;
  const FileItem({required this.name, required this.meta, required this.size, required this.tag, required this.tagColor, required this.icon, required this.iconBg});
}

class AutomationItem {
  final String title;
  final String description;
  final bool enabled;
  final String lastRun;
  final IconData icon;
  final Color color;
  const AutomationItem({required this.title, required this.description, required this.enabled, required this.lastRun, required this.icon, required this.color});
}

class TeamMember {
  final String name;
  final String role;
  final Color color;
  final bool online;
  const TeamMember({required this.name, required this.role, required this.color, required this.online});
}

class WorkspaceTask {
  final String title;
  final String project;
  final String due;
  final String assignee;
  final double progress;
  final Color color;
  const WorkspaceTask({required this.title, required this.project, required this.due, required this.assignee, required this.progress, required this.color});
}

class ActivityItem {
  final String text;
  final String time;
  final IconData icon;
  final Color color;
  const ActivityItem({required this.text, required this.time, required this.icon, required this.color});
}

class QuickAction {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bg;
  final String route;
  const QuickAction({required this.label, required this.subtitle, required this.icon, required this.color, required this.bg, required this.route});
}

class SummaryResult {
  final String summary;
  final List<String> points;
  final List<String> deadlines;
  final List<String> people;
  final List<String> tasks;
  const SummaryResult({required this.summary, required this.points, required this.deadlines, required this.people, required this.tasks});
}
