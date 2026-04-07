import 'package:flutter/material.dart';
import '../../internal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Default icon theme based on LucideIcons.
///
/// Used as the fallback when no custom icon theme is set via [fondeActiveIconThemeProvider].
const fondeDefaultIconTheme = FondeIconTheme(
  // Navigation related
  layers: LucideIcons.layers200,
  share2: LucideIcons.share2Weight200,
  search: LucideIcons.search200,
  bookmark: LucideIcons.bookmark200,
  database: LucideIcons.database200,
  terminal: LucideIcons.terminal200,
  settings: LucideIcons.settings200,
  keyboard: LucideIcons.keyboard200,
  // App-specific navigation and function icons
  stacks: LucideIcons.layers200,
  graphNavigation: LucideIcons.share2Weight200,
  bookmarks: LucideIcons.bookmark200,
  entityEditor: Icons.edit_note,
  metadataEditor: LucideIcons.tag200,
  commandPalette: LucideIcons.terminal200,
  // Panel operations
  panelLeft: LucideIcons.panelLeft200,
  panelLeftClose: LucideIcons.panelLeftClose200,
  panelRight: LucideIcons.panelRight200,
  panelRightClose: LucideIcons.panelRightClose200,
  // View types
  table: LucideIcons.table200,
  listTree: LucideIcons.listTree200,
  calendar: LucideIcons.calendar200,
  timeline: LucideIcons.clock200,
  // Actions
  save: LucideIcons.import200,
  rotateCcw: LucideIcons.rotateCcw200,
  plus: LucideIcons.plus200,
  x: LucideIcons.x200,
  ellipsis: LucideIcons.ellipsis200,
  // Arrows and directions
  arrowLeft: LucideIcons.arrowLeft200,
  arrowRight: LucideIcons.arrowRight200,
  arrowLeftRight: LucideIcons.arrowLeftRight200,
  arrowUpDown: LucideIcons.arrowUpDown200,
  chevronDown: LucideIcons.chevronDown200,
  chevronRight: LucideIcons.chevronRight200,
  // Check and selection
  check: LucideIcons.check600,
  checkIndeterminate: LucideIcons.minus600,
  checkboxIconSizeRatio: 0.7,
  // Actions (generic)
  minus: LucideIcons.minus200,
  // Entity and data
  circle: LucideIcons.circle200,
  link: LucideIcons.link200,
  tag: LucideIcons.tag200,
  stickyNote: LucideIcons.stickyNote200,
  // Filter and sort
  listFilter: LucideIcons.listFilter200,
  // Interaction
  mousePointerClick: LucideIcons.mousePointerClick200,
  gripVertical: LucideIcons.gripVertical200,
  separatorVertical: LucideIcons.separatorVertical200,
  // Import operations
  importAdd: LucideIcons.plus200,
  importUpdate: LucideIcons.refreshCw200,
  importReplace: LucideIcons.arrowLeftRight200,
  // Entity editor related
  info: LucideIcons.info200,
  id: LucideIcons.idCard200,
  properties: LucideIcons.braces200,
  connections: LucideIcons.circleArrowRight200,
  display: LucideIcons.glasses200,
  // File and document
  fileText: LucideIcons.fileText200,
  // List and display
  list: LucideIcons.list200,
  // Settings and tools
  settingsAdvanced: LucideIcons.settings2Weight200,
  download: LucideIcons.download200,
  import: LucideIcons.import200,
  appearance: LucideIcons.glasses200,
  globe: LucideIcons.globe200,
  accessibility: LucideIcons.personStanding200,
  add: LucideIcons.plus200,
  close: LucideIcons.x200,
  command: LucideIcons.terminal200,
  play: LucideIcons.play200,
  zoom: LucideIcons.zoomIn200,
  fit: LucideIcons.maximize200,
  roadmap: LucideIcons.route200,
  animation: LucideIcons.play200,
  error: LucideIcons.badgeAlert200,
  sun: LucideIcons.sun200,
  moon: LucideIcons.moon200,
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
