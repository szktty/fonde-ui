// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/fonde_ui_localizations.dart';
import '../../core/l10n/fonde_ui_localizations_en.dart';
import '../../core/models/fonde_localization_config.dart';

// ─── Shortcut helpers ─────────────────────────────────────────────────────────

SingleActivator _activator(
  LogicalKeyboardKey key, {
  bool shift = false,
  bool alt = false,
}) {
  final isMac = Platform.isMacOS;
  return SingleActivator(
    key,
    meta: isMac,
    control: !isMac,
    shift: shift,
    alt: alt,
  );
}

// ─── FondePlatformMenus ───────────────────────────────────────────────────────

/// Utility class for building platform menu bar items.
///
/// > **Highly experimental.** This API may change significantly in future
/// > releases. Platform menu support in Flutter itself is still evolving.
///
/// ## Usage
///
/// ```dart
/// final menus = FondePlatformMenus(context: context);
///
/// PlatformMenuBar(
///   menus: [
///     menus.appMenu(appName: 'MyApp', onPreferences: _showPrefs),
///     PlatformMenu(
///       label: 'Edit',
///       menus: [
///         PlatformMenuItemGroup(members: menus.editUndoItems(onUndo: _undo, onRedo: _redo)),
///         PlatformMenuItemGroup(members: menus.editClipboardItems()),
///       ],
///     ),
///     menus.windowMenu(),
///   ],
///   child: myApp,
/// );
/// ```
///
/// ## Localization
///
/// Localization is disabled by default to prevent unexpected language switches
/// in apps that have not set up full localization support. To opt in:
///
/// - **Globally** (recommended): set [FondeLocalizationConfig.enableLocalization]
///   to `true` before calling [runApp].
/// - **Per instance**: pass [enableLocalization] to this constructor.
///
/// ### Current scope
///
/// Localization currently applies to the following built-in labels:
///
/// - **App menu** — Preferences
/// - **Edit menu** — Undo, Redo, Cut, Copy, Paste, Select All, Find, Replace
/// - **File menu** — Save, Close Window, Page Setup, Print
/// - **View menu** — Zoom In, Zoom Out, Actual Size, Full Screen
/// - **Menu bar titles** — Window
///
/// > **Note:** In a future release, select UI components (e.g. dialogs,
/// > tooltips) will also respect [FondeLocalizationConfig.enableLocalization].
/// > The flag is intentionally global so that apps can control all built-in
/// > localization in one place.
///
/// ### Setup
///
/// When localization is enabled, add fonde_ui's delegate and supported locales
/// to your [MaterialApp]:
///
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     ...FondeUILocalizations.localizationsDelegates,
///   ],
///   supportedLocales: [
///     const Locale('en'),
///     const Locale('ja'),
///   ],
///   home: myApp,
/// );
/// ```
///
/// Supported locales: `en` (English), `ja` (Japanese).
class FondePlatformMenus {
  /// Creates a [FondePlatformMenus] instance.
  ///
  /// [context] is used to look up the current locale via [FondeUILocalizations].
  ///
  /// [enableLocalization] overrides [FondeLocalizationConfig.enableLocalization]
  /// for this instance only. When `null` (the default), the global setting is
  /// used.
  FondePlatformMenus({required BuildContext context, bool? enableLocalization})
    : _l =
          (enableLocalization ?? FondeLocalizationConfig.enableLocalization)
              ? FondeUILocalizations.of(context)
              : FondeUILocalizationsEn();

  final FondeUILocalizations _l;

  // ─── App menu ──────────────────────────────────────────────────────────────

  /// Builds the application menu (the leftmost menu on macOS).
  ///
  /// > **Highly experimental.**
  ///
  /// Includes standard macOS items such as Services, Hide, and Quit, guarded
  /// by [PlatformProvidedMenuItem.hasMenu]. Pass `false` to any `include*`
  /// parameter to omit the corresponding item.
  PlatformMenu appMenu({
    required String appName,
    VoidCallback? onAbout,
    VoidCallback? onPreferences,
    bool includeServices = true,
    bool includeHide = true,
    bool includeHideOthers = true,
    bool includeShowAll = true,
    bool includeQuit = true,
  }) {
    return PlatformMenu(
      label: _l.menuLabelApp,
      menus: <PlatformMenuItem>[
        PlatformMenuItem(label: 'About $appName', onSelected: onAbout),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformMenuItem(
              label: _l.menuAppPreferences,
              shortcut: _activator(LogicalKeyboardKey.comma),
              onSelected: onPreferences,
            ),
          ],
        ),
        if (includeServices &&
            PlatformProvidedMenuItem.hasMenu(
              PlatformProvidedMenuItemType.servicesSubmenu,
            ))
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.servicesSubmenu,
          ),
        if (includeHide &&
            PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.hide))
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.hide,
          ),
        if (includeHideOthers &&
            PlatformProvidedMenuItem.hasMenu(
              PlatformProvidedMenuItemType.hideOtherApplications,
            ))
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.hideOtherApplications,
          ),
        if (includeShowAll &&
            PlatformProvidedMenuItem.hasMenu(
              PlatformProvidedMenuItemType.showAllApplications,
            ))
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.showAllApplications,
          ),
        if (includeQuit &&
            PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.quit))
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.quit,
          ),
      ],
    );
  }

  // ─── Window menu ───────────────────────────────────────────────────────────

  /// Builds the Window menu with standard platform-provided items.
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to any `include*` parameter to omit the corresponding item.
  PlatformMenu windowMenu({
    bool includeMinimize = true,
    bool includeZoom = true,
    bool includeBringAllToFront = true,
  }) {
    return PlatformMenu(
      label: _l.menuLabelWindow,
      menus: <PlatformMenuItem>[
        if (includeMinimize)
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.minimizeWindow,
          ),
        if (includeZoom)
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.zoomWindow,
          ),
        if (includeBringAllToFront)
          const PlatformMenuItemGroup(
            members: <PlatformMenuItem>[
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
              ),
            ],
          ),
      ],
    );
  }

  // ─── Edit: individual items ────────────────────────────────────────────────

  /// Builds an Undo menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem undoItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditUndo,
    shortcut: _activator(LogicalKeyboardKey.keyZ),
    onSelected: onSelected,
  );

  /// Builds a Redo menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem redoItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditRedo,
    shortcut: _activator(LogicalKeyboardKey.keyZ, shift: true),
    onSelected: onSelected,
  );

  /// Builds a Cut menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem cutItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditCut,
    shortcut: _activator(LogicalKeyboardKey.keyX),
    onSelected: onSelected,
  );

  /// Builds a Copy menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem copyItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditCopy,
    shortcut: _activator(LogicalKeyboardKey.keyC),
    onSelected: onSelected,
  );

  /// Builds a Paste menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem pasteItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditPaste,
    shortcut: _activator(LogicalKeyboardKey.keyV),
    onSelected: onSelected,
  );

  /// Builds a Select All menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem selectAllItem({VoidCallback? onSelected}) =>
      PlatformMenuItem(
        label: _l.menuEditSelectAll,
        shortcut: _activator(LogicalKeyboardKey.keyA),
        onSelected: onSelected,
      );

  /// Builds a Find menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem findItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditFind,
    shortcut: _activator(LogicalKeyboardKey.keyF),
    onSelected: onSelected,
  );

  /// Builds a Replace menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem replaceItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuEditReplace,
    shortcut: _activator(LogicalKeyboardKey.keyF, alt: true),
    onSelected: onSelected,
  );

  // ─── Edit: group helpers ──────────────────────────────────────────────────

  /// Builds a list of Undo/Redo menu items.
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to [includeUndo] or [includeRedo] to omit the corresponding
  /// item. Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> editUndoItems({
    bool includeUndo = true,
    bool includeRedo = true,
    VoidCallback? onUndo,
    VoidCallback? onRedo,
  }) {
    return <PlatformMenuItem>[
      if (includeUndo) undoItem(onSelected: onUndo),
      if (includeRedo) redoItem(onSelected: onRedo),
    ];
  }

  /// Builds a list of clipboard-related menu items (Cut, Copy, Paste, Select All).
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to any `include*` parameter to omit the corresponding item.
  /// Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> editClipboardItems({
    bool includeCut = true,
    bool includeCopy = true,
    bool includePaste = true,
    bool includeSelectAll = true,
    VoidCallback? onCut,
    VoidCallback? onCopy,
    VoidCallback? onPaste,
    VoidCallback? onSelectAll,
  }) {
    return <PlatformMenuItem>[
      if (includeCut) cutItem(onSelected: onCut),
      if (includeCopy) copyItem(onSelected: onCopy),
      if (includePaste) pasteItem(onSelected: onPaste),
      if (includeSelectAll) selectAllItem(onSelected: onSelectAll),
    ];
  }

  /// Builds a list of Find/Replace menu items.
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to [includeFind] or [includeReplace] to omit the
  /// corresponding item. Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> editFindItems({
    bool includeFind = true,
    bool includeReplace = true,
    VoidCallback? onFind,
    VoidCallback? onReplace,
  }) {
    return <PlatformMenuItem>[
      if (includeFind) findItem(onSelected: onFind),
      if (includeReplace) replaceItem(onSelected: onReplace),
    ];
  }

  // ─── File: individual items ────────────────────────────────────────────────

  /// Builds a Save menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem saveItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuFileSave,
    shortcut: _activator(LogicalKeyboardKey.keyS),
    onSelected: onSelected,
  );

  /// Builds a Close Window menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem closeWindowItem({VoidCallback? onSelected}) =>
      PlatformMenuItem(
        label: _l.menuFileCloseWindow,
        shortcut: _activator(LogicalKeyboardKey.keyW),
        onSelected: onSelected,
      );

  /// Builds a Page Setup menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem pageSetupItem({VoidCallback? onSelected}) =>
      PlatformMenuItem(
        label: _l.menuFilePageSetup,
        shortcut: _activator(LogicalKeyboardKey.keyP, shift: true),
        onSelected: onSelected,
      );

  /// Builds a Print menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem printItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuFilePrint,
    shortcut: _activator(LogicalKeyboardKey.keyP),
    onSelected: onSelected,
  );

  // ─── File: group helpers ──────────────────────────────────────────────────

  /// Builds a list of save-related menu items (Save, Close Window).
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to [includeSave] or [includeCloseWindow] to omit the
  /// corresponding item. Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> fileSaveItems({
    bool includeSave = true,
    bool includeCloseWindow = true,
    VoidCallback? onSave,
    VoidCallback? onCloseWindow,
  }) {
    return <PlatformMenuItem>[
      if (includeSave) saveItem(onSelected: onSave),
      if (includeCloseWindow) closeWindowItem(onSelected: onCloseWindow),
    ];
  }

  /// Builds a list of print-related menu items (Page Setup, Print).
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to [includePageSetup] or [includePrint] to omit the
  /// corresponding item. Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> filePrintItems({
    bool includePageSetup = true,
    bool includePrint = true,
    VoidCallback? onPageSetup,
    VoidCallback? onPrint,
  }) {
    return <PlatformMenuItem>[
      if (includePageSetup) pageSetupItem(onSelected: onPageSetup),
      if (includePrint) printItem(onSelected: onPrint),
    ];
  }

  // ─── View: individual items ────────────────────────────────────────────────

  /// Builds a Zoom In menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem zoomInItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuViewZoomIn,
    shortcut: _activator(LogicalKeyboardKey.equal),
    onSelected: onSelected,
  );

  /// Builds a Zoom Out menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem zoomOutItem({VoidCallback? onSelected}) => PlatformMenuItem(
    label: _l.menuViewZoomOut,
    shortcut: _activator(LogicalKeyboardKey.minus),
    onSelected: onSelected,
  );

  /// Builds an Actual Size menu item.
  ///
  /// > **Highly experimental.**
  PlatformMenuItem actualSizeItem({VoidCallback? onSelected}) =>
      PlatformMenuItem(
        label: _l.menuViewActualSize,
        shortcut: _activator(LogicalKeyboardKey.digit0),
        onSelected: onSelected,
      );

  /// Builds a Full Screen menu item.
  ///
  /// > **Highly experimental.**
  ///
  /// On macOS, this uses ⌘⌃F. On other platforms, no shortcut is assigned
  /// as full-screen conventions differ significantly.
  PlatformMenuItem fullScreenItem({VoidCallback? onSelected}) =>
      PlatformMenuItem(
        label: _l.menuViewFullScreen,
        shortcut:
            Platform.isMacOS
                ? const SingleActivator(
                  LogicalKeyboardKey.keyF,
                  meta: true,
                  control: true,
                )
                : null,
        onSelected: onSelected,
      );

  // ─── View: group helpers ──────────────────────────────────────────────────

  /// Builds a list of zoom-related menu items (Zoom In, Zoom Out, Actual Size).
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to any `include*` parameter to omit the corresponding item.
  /// Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> viewZoomItems({
    bool includeZoomIn = true,
    bool includeZoomOut = true,
    bool includeActualSize = true,
    VoidCallback? onZoomIn,
    VoidCallback? onZoomOut,
    VoidCallback? onActualSize,
  }) {
    return <PlatformMenuItem>[
      if (includeZoomIn) zoomInItem(onSelected: onZoomIn),
      if (includeZoomOut) zoomOutItem(onSelected: onZoomOut),
      if (includeActualSize) actualSizeItem(onSelected: onActualSize),
    ];
  }

  /// Builds a list containing the Full Screen menu item.
  ///
  /// > **Highly experimental.**
  ///
  /// Pass `false` to [includeFullScreen] to omit the item.
  /// Intended to be placed inside a [PlatformMenuItemGroup].
  List<PlatformMenuItem> viewFullScreenItems({
    bool includeFullScreen = true,
    VoidCallback? onFullScreen,
  }) {
    return <PlatformMenuItem>[
      if (includeFullScreen) fullScreenItem(onSelected: onFullScreen),
    ];
  }
}
