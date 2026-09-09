// ignore_for_file: public_member_api_docs
/// Realistic fake data so every screen feels functional offline.
import 'package:flutter/material.dart';
import '../models/models.dart';

class DummyData {
  static const device = ConnectedDevice(
    name: "Ajay's iQOO 15",
    model: 'iQOO 15 • Snapdragon 8 Elite • 16GB',
    connected: true,
    connectionType: 'WiFi 6',
    battery: 82,
    storageUsedGb: 96.4,
    storageTotalGb: 256,
    wifiName: 'HomeFiber_5G',
    transferSpeed: '84 MB/s',
    lastSeen: 'Active now',
  );

  static const recentDevices = [
    ConnectedDevice(name: "Ajay's iQOO 15", model: 'iQOO 15 • 16GB', connected: true, connectionType: 'WiFi 6', battery: 82, storageUsedGb: 96.4, storageTotalGb: 256, wifiName: 'HomeFiber_5G', transferSpeed: '84 MB/s', lastSeen: 'Active now'),
    ConnectedDevice(name: 'iQOO Neo 10', model: 'Neo 10 • 12GB', connected: false, connectionType: 'USB-C', battery: 64, storageUsedGb: 41.2, storageTotalGb: 256, wifiName: 'Office_Net', transferSpeed: '210 MB/s', lastSeen: '2h ago'),
    ConnectedDevice(name: 'iQOO Z10x', model: 'Z10x • 8GB', connected: false, connectionType: 'WiFi 6', battery: 91, storageUsedGb: 22.8, storageTotalGb: 128, wifiName: 'HomeFiber_5G', transferSpeed: '62 MB/s', lastSeen: 'Yesterday'),
  ];

  static const quickActions = [
    QuickAction(label: 'Scan Document', subtitle: 'OCR + summarize', icon: Icons.document_scanner_outlined, color: Color(0xFF246BFF), bg: Color(0xFFE8EFFF), route: '/vision'),
    QuickAction(label: 'Summarize Image', subtitle: 'AI Vision', icon: Icons.image_outlined, color: Color(0xFF7C5CFF), bg: Color(0xFFF0EBFF), route: '/vision'),
    QuickAction(label: 'Send Smart Email', subtitle: 'AI compose', icon: Icons.send_outlined, color: Color(0xFF21C87A), bg: Color(0xFFE6F9EF), route: '/mail'),
    QuickAction(label: 'Schedule Meeting', subtitle: 'Voice + AI', icon: Icons.video_call_outlined, color: Color(0xFFFF8A3D), bg: Color(0xFFFFF0E3), route: '/calendar'),
    QuickAction(label: 'WhatsApp Reminder', subtitle: 'Schedule', icon: Icons.schedule_send_outlined, color: Color(0xFF12A94B), bg: Color(0xFFE6F9EF), route: '/whatsapp'),
    QuickAction(label: 'AI Notes', subtitle: 'Rewrite & expand', icon: Icons.edit_note_outlined, color: Color(0xFFEF6C8A), bg: Color(0xFFFFEAF0), route: '/notes'),
    QuickAction(label: 'Voice Command', subtitle: 'Hey Office', icon: Icons.mic_outlined, color: Color(0xFF00B8D4), bg: Color(0xFFE3F9FD), route: '/tools'),
    QuickAction(label: 'Automation Builder', subtitle: 'If → Then', icon: Icons.account_tree_outlined, color: Color(0xFF6C63FF), bg: Color(0xFFEEEFFF), route: '/automation'),
  ];

  static const meetings = [
    MeetingItem(title: 'Backend Sync — Sprint 14', time: 'Today • 5:00 PM', dateLabel: 'SEP 09', color: Color(0xFF246BFF), participants: ['HR', 'TL', 'AK'], location: 'Meet • Design Room', aiReminder: true),
    MeetingItem(title: 'Sprint Review with Design Team', time: 'Fri • 11:30 AM', dateLabel: 'SEP 12', color: Color(0xFF7C5CFF), participants: ['DT', 'PM'], location: 'Meet • Studio', aiReminder: true),
    MeetingItem(title: '1:1 with Manager', time: 'Tomorrow • 10:00 AM', dateLabel: 'SEP 10', color: Color(0xFF21C87A), participants: ['MG'], location: 'Meet • Focus', aiReminder: false),
    MeetingItem(title: 'Investor Demo Prep', time: 'Mon • 4:00 PM', dateLabel: 'SEP 15', color: Color(0xFFFF8A3D), participants: ['CEO', 'HR'], location: 'Board Room', aiReminder: true),
  ];

  static const emails = [
    EmailItem(from: 'Meera Krishnan (HR)', nickname: 'HR', subject: 'Offer letter draft needs your review', preview: 'Hi Ajay, the revised CTC structure is attached. AI summary: 3 changes pending your approval...', time: '9:42 AM', unread: true, avatarColor: Color(0xFF246BFF), hasAttachment: true),
    EmailItem(from: 'Rahul Verma (Manager)', nickname: 'Manager', subject: 'Backend sprint demo moved to Friday', preview: 'Team, we are shifting the demo to Friday 11:30 AM. Please attach the latest performance report...', time: '8:15 AM', unread: true, avatarColor: Color(0xFF21C87A)),
    EmailItem(from: 'Design Team', nickname: 'Design Team', subject: 'New OriginOS card explorations', preview: 'Figma link inside + 6 new glass-card variants for the Files tab. Feedback by EOD?', time: 'Yesterday', unread: false, avatarColor: Color(0xFF7C5CFF), hasAttachment: true),
    EmailItem(from: 'Prof. Nair', nickname: 'Professor', subject: 'Hackathon evaluation rubric', preview: 'Dear team, evaluation will focus on originality, polish and live demo stability...', time: 'Yesterday', unread: false, avatarColor: Color(0xFFFF8A3D)),
    EmailItem(from: 'Finance Ops', nickname: 'Finance', subject: 'Invoice #2841 approved', preview: 'Your component reimbursement of ₹4,280 has been approved and will settle in 2 days.', time: 'Mon', unread: false, avatarColor: Color(0xFF00B8D4)),
  ];

  static const whatsapp = [
    WhatsMessage(to: 'Team Lead — Standup', body: 'Daily standup at 10 AM: share blockers + today\'s plan. (Recurring)', scheduledFor: 'Tomorrow • 9:00 AM', status: 'Scheduled', recurring: true, countdown: 'in 18h 12m'),
    WhatsMessage(to: 'Manager — Weekly report', body: 'Sprint 14 report PDF + AI summary attached. Auto-sent after build.', scheduledFor: 'Tomorrow • 9:00 PM', status: 'Scheduled', recurring: false, countdown: 'in 30h 5m'),
    WhatsMessage(to: 'Family — Birthday reminder', body: 'Wish Amma happy birthday 🎂 + send gift photo', scheduledFor: 'Sep 14 • 8:00 AM', status: 'Scheduled', recurring: false, countdown: 'in 4d 20h'),
    WhatsMessage(to: 'Design broadcast (6)', body: 'Figma v2 link + review checklist broadcast', scheduledFor: 'Sent • 9:02 AM', status: 'Sent', recurring: false, countdown: 'Delivered ✓✓'),
    WhatsMessage(to: 'HR — Offer follow-up', body: 'Following up on the offer letter draft', scheduledFor: 'Failed • retry', status: 'Failed', recurring: false, countdown: 'Tap to retry'),
  ];

  static const notes = [
    NoteItem(title: 'Hackathon Pitch — Office Kit AI+', snippet: 'Problem → AI companion that mails, schedules, mirrors phone. Demo flow: mirror → vision → mail...', updated: 'Edited 12m ago', tint: Color(0xFFE8EFFF), icon: Icons.rocket_launch_outlined, tags: ['Pitch', 'Demo']),
    NoteItem(title: 'Meeting Notes — Backend Sync', snippet: 'Decisions: move to Postgres pooling, add Redis cache. Action: Ajay ships report by Fri...', updated: 'Edited 2h ago', tint: Color(0xFFE6F9EF), icon: Icons.forum_outlined, tags: ['Meeting']),
    NoteItem(title: 'Study — OriginOS Design Language', snippet: 'Frosted cards, 24px radius, soft 24 blur shadow, blue #246BFF, generous whitespace...', updated: 'Yesterday', tint: Color(0xFFF0EBFF), icon: Icons.palette_outlined, tags: ['Study']),
    NoteItem(title: 'Checklist — Demo Day', snippet: '☐ Charge iQOO 15 ☐ Test USB mirror ☐ Pre-generate QR ☐ Backup slides to workspace', updated: '2d ago', tint: Color(0xFFFFF4E3), icon: Icons.checklist_rounded, tags: ['Checklist']),
  ];

  static const clips = [
    ClipItem(kind: 'Text', title: 'Team standup notes — Sep 9', detail: 'Shipped auth cache, pending: file-transfer resume. Blockers: none.', time: '2m ago', pinned: true, icon: Icons.text_fields_rounded),
    ClipItem(kind: 'Link', title: 'figma.com/design/office-kit-ai', detail: 'OriginOS glass-card explorations v2', time: '26m ago', pinned: true, icon: Icons.link_rounded),
    ClipItem(kind: 'Image', title: 'Chart — Sprint velocity.png', detail: 'From phone gallery • 2.4 MB • AI summary ready', time: '1h ago', pinned: false, icon: Icons.image_outlined),
    ClipItem(kind: 'File', title: 'Sprint14_Report.pdf', detail: '4.2 MB • Tagged: Report, Finance', time: '3h ago', pinned: false, icon: Icons.picture_as_pdf_outlined),
    ClipItem(kind: 'Text', title: 'HR email draft', detail: 'Subject auto-written: “Sprint 14 report + next steps”', time: '5h ago', pinned: false, icon: Icons.mail_outline_rounded),
  ];

  static const files = [
    FileItem(name: 'Sprint14_Report.pdf', meta: 'PDF • Modified today', size: '4.2 MB', tag: 'Report', tagColor: Color(0xFF246BFF), icon: Icons.picture_as_pdf_rounded, iconBg: Color(0xFFE8EFFF)),
    FileItem(name: 'Offer_Letter_v3.docx', meta: 'Doc • From HR', size: '88 KB', tag: 'HR', tagColor: Color(0xFF21C87A), icon: Icons.description_rounded, iconBg: Color(0xFFE6F9EF)),
    FileItem(name: 'Velocity_Chart.png', meta: 'Image • AI summarized', size: '2.4 MB', tag: 'Meeting', tagColor: Color(0xFF7C5CFF), icon: Icons.image_rounded, iconBg: Color(0xFFF0EBFF)),
    FileItem(name: 'Invoice_2841.pdf', meta: 'PDF • Finance', size: '312 KB', tag: 'Invoice', tagColor: Color(0xFFFF8A3D), icon: Icons.receipt_long_rounded, iconBg: Color(0xFFFFF0E3)),
    FileItem(name: 'Demo_Day_Checklist.md', meta: 'Note • Synced', size: '12 KB', tag: 'Study', tagColor: Color(0xFF00B8D4), icon: Icons.note_rounded, iconBg: Color(0xFFE3F9FD)),
    FileItem(name: 'Standup_Reminder.mp3', meta: 'Audio • Voice note', size: '1.1 MB', tag: 'Audio', tagColor: Color(0xFFEF6C8A), icon: Icons.audio_file_rounded, iconBg: Color(0xFFFFEAF0)),
    FileItem(name: 'Team_Photo.jpg', meta: 'Image • WhatsApp', size: '3.8 MB', tag: 'Teams', tagColor: Color(0xFF12A94B), icon: Icons.photo_rounded, iconBg: Color(0xFFE6F9EF)),
    FileItem(name: 'Resume_Ajay.pdf', meta: 'PDF • Smart tag', size: '240 KB', tag: 'Resume', tagColor: Color(0xFF246BFF), icon: Icons.badge_outlined, iconBg: Color(0xFFE8EFFF)),
  ];

  static const automations = [
    AutomationItem(title: 'Image scanned → Email HR', description: 'IF image scanned THEN summarize THEN email HR (Formal tone)', enabled: true, lastRun: 'Ran 2h ago • success', icon: Icons.document_scanner_outlined, color: Color(0xFF246BFF)),
    AutomationItem(title: 'Meeting ends → Minutes', description: 'IF meeting ends THEN generate minutes + email participants', enabled: true, lastRun: 'Ran yesterday • success', icon: Icons.forum_outlined, color: Color(0xFF7C5CFF)),
    AutomationItem(title: 'Report ready → WhatsApp Manager', description: 'IF report generated THEN WhatsApp manager tomorrow 9PM', enabled: true, lastRun: 'Scheduled • in 30h', icon: Icons.schedule_send_outlined, color: Color(0xFF21C87A)),
    AutomationItem(title: 'Clipboard PDF → Workspace', description: 'IF PDF copied THEN tag + save to Team Workspace/Reports', enabled: false, lastRun: 'Paused • 4d ago', icon: Icons.content_paste_outlined, color: Color(0xFFFF8A3D)),
  ];

  static const members = [
    TeamMember(name: 'Ajay Kumar', role: 'Developer', color: Color(0xFF246BFF), online: true),
    TeamMember(name: 'Meera K', role: 'HR', color: Color(0xFF21C87A), online: true),
    TeamMember(name: 'Rahul V', role: 'Manager', color: Color(0xFFFF8A3D), online: true),
    TeamMember(name: 'Sara D', role: 'Designer', color: Color(0xFF7C5CFF), online: false),
    TeamMember(name: 'Dev P', role: 'Intern', color: Color(0xFF00B8D4), online: true),
  ];

  static const tasks = [
    WorkspaceTask(title: 'Phone-mirror drag & drop', project: 'Mirror', due: 'Sep 10', assignee: 'Ajay', progress: 0.8, color: Color(0xFF246BFF)),
    WorkspaceTask(title: 'AI Vision table extraction', project: 'Vision', due: 'Sep 11', assignee: 'Sara', progress: 0.55, color: Color(0xFF7C5CFF)),
    WorkspaceTask(title: 'Smart Mail scheduler', project: 'Mail', due: 'Sep 12', assignee: 'Dev', progress: 0.35, color: Color(0xFF21C87A)),
    WorkspaceTask(title: 'Hackathon pitch deck', project: 'Demo', due: 'Sep 13', assignee: 'Meera', progress: 0.65, color: Color(0xFFFF8A3D)),
  ];

  static const activity = [
    ActivityItem(text: 'Ajay shared Sprint14_Report.pdf to Workspace/Reports', time: '12m ago', icon: Icons.upload_file_outlined, color: Color(0xFF246BFF)),
    ActivityItem(text: 'AI summarized Velocity_Chart.png → 5 key points', time: '1h ago', icon: Icons.auto_awesome_outlined, color: Color(0xFF7C5CFF)),
    ActivityItem(text: 'Rahul scheduled Sprint Review for Friday 11:30 AM', time: '2h ago', icon: Icons.calendar_month_outlined, color: Color(0xFF21C87A)),
    ActivityItem(text: 'Sara broadcast Figma v2 link to Design Team', time: '4h ago', icon: Icons.campaign_outlined, color: Color(0xFFFF8A3D)),
  ];

  static const sampleSummary = SummaryResult(
    summary: 'This sprint-velocity chart shows a 34% throughput gain across Sprint 14, driven by backend caching and parallel QA. Two blockers (file-resume, mirror latency) carry into Sprint 15.',
    points: ['Velocity rose from 32 → 43 story points (+34%).', 'Backend cache cut API p95 latency by 41%.', 'QA parallelization saved ~6 hours per cycle.', 'File-resume + mirror latency remain open risks.'],
    deadlines: ['Sprint Review — Fri, Sep 12, 11:30 AM', 'Sprint 14 report to Manager — Sep 10, 9:00 PM'],
    people: ['Ajay Kumar (Backend)', 'Rahul Verma (Manager)', 'Sara D (Design QA)'],
    tasks: ['Attach report PDF to Manager email', 'Schedule file-resume fix before Sep 11', 'Share chart summary to Team Workspace'],
  );
}
