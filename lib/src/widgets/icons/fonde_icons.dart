import 'package:flutter/material.dart';
import 'lucide_icon_theme.dart';

/// Centralized management class for icons used throughout the App application.
///
/// This class manages all icons used in the app in one place,
/// promoting consistent icon usage.
///
/// For runtime icon theme switching, use [activeIconThemeProvider] with
/// [fondeDefaultIconTheme] as the default fallback.
class FondeIcons {
  FondeIcons._(); // Private constructor

  // Navigation related
  // TODO: The following icons are left for backward compatibility, but consider deleting them in the future.
  // Use app-specific names (stacks, graphNavigation, etc.) instead.
  static IconData get layers => fondeDefaultIconTheme.layers;
  static IconData get share2 => fondeDefaultIconTheme.share2;
  static IconData get search => fondeDefaultIconTheme.search;
  static IconData get bookmark => fondeDefaultIconTheme.bookmark;
  static IconData get database => fondeDefaultIconTheme.database;
  static IconData get terminal => fondeDefaultIconTheme.terminal;
  static IconData get settings => fondeDefaultIconTheme.settings;
  static IconData get keyboard => fondeDefaultIconTheme.keyboard;

  // App-specific navigation and function icons
  // Recommendation: Use these icon names in new code.
  static IconData get stacks => fondeDefaultIconTheme.stacks;
  static IconData get graphNavigation => fondeDefaultIconTheme.graphNavigation;
  static IconData get bookmarks => fondeDefaultIconTheme.bookmarks;
  static IconData get entityEditor => fondeDefaultIconTheme.entityEditor;
  static IconData get metadataEditor => fondeDefaultIconTheme.metadataEditor;
  static IconData get commandPalette => fondeDefaultIconTheme.commandPalette;

  // Panel operations
  static IconData get panelLeft => fondeDefaultIconTheme.panelLeft;
  static IconData get panelLeftClose => fondeDefaultIconTheme.panelLeftClose;
  static IconData get panelRight => fondeDefaultIconTheme.panelRight;
  static IconData get panelRightClose => fondeDefaultIconTheme.panelRightClose;

  // View types
  static IconData get table => fondeDefaultIconTheme.table;
  static IconData get listTree => fondeDefaultIconTheme.listTree;
  static IconData get calendar => fondeDefaultIconTheme.calendar;
  static IconData get timeline => fondeDefaultIconTheme.timeline;

  // Actions
  static IconData get save => fondeDefaultIconTheme.save;
  static IconData get rotateCcw => fondeDefaultIconTheme.rotateCcw;
  static IconData get plus => fondeDefaultIconTheme.plus;
  static IconData get x => fondeDefaultIconTheme.x;
  static IconData get ellipsis => fondeDefaultIconTheme.ellipsis;

  // Arrows and directions
  static IconData get arrowLeft => fondeDefaultIconTheme.arrowLeft;
  static IconData get arrowRight => fondeDefaultIconTheme.arrowRight;
  static IconData get arrowLeftRight => fondeDefaultIconTheme.arrowLeftRight;
  static IconData get arrowUpDown => fondeDefaultIconTheme.arrowUpDown;
  static IconData get chevronDown => fondeDefaultIconTheme.chevronDown;
  static IconData get chevronRight => fondeDefaultIconTheme.chevronRight;

  // Check and selection
  static IconData get check => fondeDefaultIconTheme.check;

  // Entity and data
  static IconData get circle => fondeDefaultIconTheme.circle;
  static IconData get link => fondeDefaultIconTheme.link;
  static IconData get tag => fondeDefaultIconTheme.tag;
  static IconData get stickyNote => fondeDefaultIconTheme.stickyNote;

  // Filter and sort
  static IconData get listFilter => fondeDefaultIconTheme.listFilter;

  // Interaction
  static IconData get mousePointerClick =>
      fondeDefaultIconTheme.mousePointerClick;
  static IconData get gripVertical => fondeDefaultIconTheme.gripVertical;
  static IconData get separatorVertical =>
      fondeDefaultIconTheme.separatorVertical;

  // Import operations
  static IconData get importAdd => fondeDefaultIconTheme.importAdd;
  static IconData get importUpdate => fondeDefaultIconTheme.importUpdate;
  static IconData get importReplace => fondeDefaultIconTheme.importReplace;

  // Entity editor related
  static IconData get info => fondeDefaultIconTheme.info;
  static IconData get id => fondeDefaultIconTheme.id;
  static IconData get properties => fondeDefaultIconTheme.properties;
  static IconData get connections => fondeDefaultIconTheme.connections;
  static IconData get display => fondeDefaultIconTheme.display;

  // File and document
  static IconData get fileText => fondeDefaultIconTheme.fileText;

  // List and display
  static IconData get list => fondeDefaultIconTheme.list;

  // Settings and tools
  static IconData get settingsAdvanced =>
      fondeDefaultIconTheme.settingsAdvanced;
  static IconData get download => fondeDefaultIconTheme.download;
  static IconData get import => fondeDefaultIconTheme.import;
  static IconData get appearance => fondeDefaultIconTheme.appearance;
  static IconData get globe => fondeDefaultIconTheme.globe;
  static IconData get accessibility => fondeDefaultIconTheme.accessibility;
  static IconData get add => fondeDefaultIconTheme.add;
  static IconData get close => fondeDefaultIconTheme.close;
  static IconData get command => fondeDefaultIconTheme.command;
  static IconData get play => fondeDefaultIconTheme.play;
  static IconData get zoom => fondeDefaultIconTheme.zoom;
  static IconData get fit => fondeDefaultIconTheme.fit;
  static IconData get roadmap => fondeDefaultIconTheme.roadmap;
  static IconData get animation => fondeDefaultIconTheme.animation;
  static IconData get error => fondeDefaultIconTheme.error;
  static IconData get sun => fondeDefaultIconTheme.sun;
  static IconData get moon => fondeDefaultIconTheme.moon;

  // Material Icons (Flutter standard)
  // TODO: The following icons are left for backward compatibility, but consider deleting them in the future.
  static IconData get editNote => fondeDefaultIconTheme.editNote;
  static IconData get barChart => fondeDefaultIconTheme.barChart;
  static IconData get helpOutline => fondeDefaultIconTheme.helpOutline;
  static IconData get moreVert => fondeDefaultIconTheme.moreVert;
  static IconData get clear => fondeDefaultIconTheme.clear;
  static IconData get folderOpen => fondeDefaultIconTheme.folderOpen;
  static IconData get star => fondeDefaultIconTheme.star;
  static IconData get starBorder => fondeDefaultIconTheme.starBorder;
  static IconData get pushPinOutlined => fondeDefaultIconTheme.pushPinOutlined;
  static IconData get edit => fondeDefaultIconTheme.edit;
  static IconData get copy => fondeDefaultIconTheme.copy;
  static IconData get uploadFile => fondeDefaultIconTheme.uploadFile;
  static IconData get folder => fondeDefaultIconTheme.folder;
  static IconData get archiveOutlined => fondeDefaultIconTheme.archiveOutlined;
  static IconData get deleteOutline => fondeDefaultIconTheme.deleteOutline;
}
