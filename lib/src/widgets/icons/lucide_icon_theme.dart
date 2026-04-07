import 'package:flutter/material.dart';
import '../../internal.dart';
import 'lucide_icons.dart';

/// Default icon theme based on LucideIcons.
///
/// Used as the fallback when no custom icon theme is set via [fondeActiveIconThemeProvider].
const fondeDefaultIconTheme = FondeIconTheme(
  // Navigation related
  layers: LucideIcons.layers,
  share2: LucideIcons.share2,
  search: LucideIcons.search,
  bookmark: LucideIcons.bookmark,
  database: LucideIcons.database,
  terminal: LucideIcons.terminal,
  settings: LucideIcons.settings,
  keyboard: LucideIcons.keyboard,
  // App-specific navigation and function icons
  stacks: LucideIcons.layers,
  graphNavigation: LucideIcons.share2,
  bookmarks: LucideIcons.bookmark,
  entityEditor: Icons.edit_note,
  metadataEditor: LucideIcons.tag,
  commandPalette: LucideIcons.terminal,
  // Panel operations
  panelLeft: LucideIcons.panelLeft,
  panelLeftClose: LucideIcons.panelLeftClose,
  panelRight: LucideIcons.panelRight,
  panelRightClose: LucideIcons.panelRightClose,
  // View types
  table: LucideIcons.table,
  listTree: LucideIcons.listTree,
  calendar: LucideIcons.calendar,
  timeline: LucideIcons.clock,
  // Actions
  save: LucideIcons.import,
  rotateCcw: LucideIcons.rotateCcw,
  plus: LucideIcons.plus,
  x: LucideIcons.x,
  ellipsis: LucideIcons.ellipsis,
  // Arrows and directions
  arrowLeft: LucideIcons.arrowLeft,
  arrowRight: LucideIcons.arrowRight,
  arrowLeftRight: LucideIcons.arrowLeftRight,
  arrowUpDown: LucideIcons.arrowUpDown,
  chevronDown: LucideIcons.chevronDown,
  chevronRight: LucideIcons.chevronRight,
  // Check and selection
  check: LucideIcons.check,
  checkIndeterminate: LucideIcons.minus,
  checkboxIconSizeRatio: 0.7,
  // Actions (generic)
  minus: LucideIcons.minus,
  // Entity and data
  circle: LucideIcons.circle,
  link: LucideIcons.link,
  tag: LucideIcons.tag,
  stickyNote: LucideIcons.stickyNote,
  // Filter and sort
  listFilter: LucideIcons.listFilter,
  // Interaction
  mousePointerClick: LucideIcons.mousePointerClick,
  gripVertical: LucideIcons.gripVertical,
  separatorVertical: LucideIcons.separatorVertical,
  // Import operations
  importAdd: LucideIcons.plus,
  importUpdate: LucideIcons.refreshCw,
  importReplace: LucideIcons.arrowLeftRight,
  // Entity editor related
  info: LucideIcons.info,
  id: LucideIcons.idCard,
  properties: LucideIcons.braces,
  connections: LucideIcons.circleArrowRight,
  display: LucideIcons.glasses,
  // File and document
  fileText: LucideIcons.fileText,
  // List and display
  list: LucideIcons.list,
  // Settings and tools
  settingsAdvanced: LucideIcons.settings2,
  download: LucideIcons.download,
  import: LucideIcons.import,
  appearance: LucideIcons.glasses,
  globe: LucideIcons.globe,
  accessibility: LucideIcons.personStanding,
  add: LucideIcons.plus,
  close: LucideIcons.x,
  command: LucideIcons.terminal,
  play: LucideIcons.play,
  zoom: LucideIcons.zoomIn,
  fit: LucideIcons.maximize,
  roadmap: LucideIcons.route,
  animation: LucideIcons.play,
  error: LucideIcons.badgeAlert,
  sun: LucideIcons.sun,
  moon: LucideIcons.moon,
  // Material Icons (Flutter standard)
  editNote: Icons.edit_note,
  barChart: Icons.bar_chart,
  helpOutline: Icons.help_outline,
  moreVert: Icons.more_vert,
  clear: Icons.clear,
  folderOpen: Icons.folder_open,
  star: Icons.star,
  starBorder: Icons.star_border,
  pushPinOutlined: Icons.push_pin_outlined,
  edit: Icons.edit,
  copy: Icons.copy,
  uploadFile: Icons.upload_file,
  folder: Icons.folder,
  archiveOutlined: Icons.archive_outlined,
  deleteOutline: Icons.delete_outline,
);
