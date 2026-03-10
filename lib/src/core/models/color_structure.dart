import 'package:flutter/material.dart';

/// Class defining base colors
/// Basic color definitions used throughout the application
class FondeBaseColors {
  /// Basic text color, icon color
  final Color foreground;

  /// Main background color
  final Color background;

  /// Background color for text selection, list item selection (no transparency)
  final Color selection;

  /// Basic border, frame color
  final Color border;

  /// Divider color for horizontal and vertical lines
  final Color divider;

  /// Drop shadow, elevation effect color
  final Color shadow;

  const FondeBaseColors({
    required this.foreground,
    required this.background,
    required this.selection,
    required this.border,
    required this.divider,
    required this.shadow,
  });

  FondeBaseColors copyWith({
    Color? foreground,
    Color? background,
    Color? selection,
    Color? border,
    Color? divider,
    Color? shadow,
  }) {
    return FondeBaseColors(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      selection: selection ?? this.selection,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeBaseColors &&
        other.foreground == foreground &&
        other.background == background &&
        other.selection == selection &&
        other.border == border &&
        other.divider == divider &&
        other.shadow == shadow;
  }

  @override
  int get hashCode {
    return Object.hash(
      foreground,
      background,
      selection,
      border,
      divider,
      shadow,
    );
  }
}

/// Class defining launch bar colors
class FondeLaunchBarColors {
  /// Launch bar overall background
  final Color background;

  /// Selected item background color
  final Color activeItemBackground;

  /// Selected icon color
  final Color activeItem;

  /// Unselected icon color
  final Color inactiveItem;

  /// Icon color on mouse hover
  final Color hoverItem;

  /// Notification badge background color
  final Color badgeBackground;

  const FondeLaunchBarColors({
    required this.background,
    required this.activeItemBackground,
    required this.activeItem,
    required this.inactiveItem,
    required this.hoverItem,
    required this.badgeBackground,
  });

  FondeLaunchBarColors copyWith({
    Color? background,
    Color? activeItemBackground,
    Color? activeItem,
    Color? inactiveItem,
    Color? hoverItem,
    Color? badgeBackground,
  }) {
    return FondeLaunchBarColors(
      background: background ?? this.background,
      activeItemBackground: activeItemBackground ?? this.activeItemBackground,
      activeItem: activeItem ?? this.activeItem,
      inactiveItem: inactiveItem ?? this.inactiveItem,
      hoverItem: hoverItem ?? this.hoverItem,
      badgeBackground: badgeBackground ?? this.badgeBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeLaunchBarColors &&
        other.background == background &&
        other.activeItemBackground == activeItemBackground &&
        other.activeItem == activeItem &&
        other.inactiveItem == inactiveItem &&
        other.hoverItem == hoverItem &&
        other.badgeBackground == badgeBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      activeItemBackground,
      activeItem,
      inactiveItem,
      hoverItem,
      badgeBackground,
    );
  }
}

/// Class defining sidebar colors
class FondeSideBarColors {
  /// Sidebar overall background
  final Color background;

  /// Divider between sections
  final Color divider;

  /// Section header color
  final Color groupHeader;

  /// Selected item background
  final Color activeItemBackground;

  /// Selected item text
  final Color activeItemText;

  /// Unselected item text
  final Color inactiveItemText;

  /// Background on mouse hover
  final Color hoverBackground;

  const FondeSideBarColors({
    required this.background,
    required this.divider,
    required this.groupHeader,
    required this.activeItemBackground,
    required this.activeItemText,
    required this.inactiveItemText,
    required this.hoverBackground,
  });

  FondeSideBarColors copyWith({
    Color? background,
    Color? divider,
    Color? groupHeader,
    Color? activeItemBackground,
    Color? activeItemText,
    Color? inactiveItemText,
    Color? hoverBackground,
  }) {
    return FondeSideBarColors(
      background: background ?? this.background,
      divider: divider ?? this.divider,
      groupHeader: groupHeader ?? this.groupHeader,
      activeItemBackground: activeItemBackground ?? this.activeItemBackground,
      activeItemText: activeItemText ?? this.activeItemText,
      inactiveItemText: inactiveItemText ?? this.inactiveItemText,
      hoverBackground: hoverBackground ?? this.hoverBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeSideBarColors &&
        other.background == background &&
        other.divider == divider &&
        other.groupHeader == groupHeader &&
        other.activeItemBackground == activeItemBackground &&
        other.activeItemText == activeItemText &&
        other.inactiveItemText == inactiveItemText &&
        other.hoverBackground == hoverBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      divider,
      groupHeader,
      activeItemBackground,
      activeItemText,
      inactiveItemText,
      hoverBackground,
    );
  }
}

/// Class defining status bar colors
class FondeStatusBarColors {
  /// Status bar background
  final Color background;

  /// Status text color
  final Color foreground;

  /// Status item background on hover
  final Color itemHoverBackground;

  /// Background for important status display (e.g., error)
  final Color prominentBackground;

  /// Text color for important status display
  final Color prominentForeground;

  const FondeStatusBarColors({
    required this.background,
    required this.foreground,
    required this.itemHoverBackground,
    required this.prominentBackground,
    required this.prominentForeground,
  });

  FondeStatusBarColors copyWith({
    Color? background,
    Color? foreground,
    Color? itemHoverBackground,
    Color? prominentBackground,
    Color? prominentForeground,
  }) {
    return FondeStatusBarColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      itemHoverBackground: itemHoverBackground ?? this.itemHoverBackground,
      prominentBackground: prominentBackground ?? this.prominentBackground,
      prominentForeground: prominentForeground ?? this.prominentForeground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeStatusBarColors &&
        other.background == background &&
        other.foreground == foreground &&
        other.itemHoverBackground == itemHoverBackground &&
        other.prominentBackground == prominentBackground &&
        other.prominentForeground == prominentForeground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      foreground,
      itemHoverBackground,
      prominentBackground,
      prominentForeground,
    );
  }
}

/// Class defining panel colors
class FondePanelColors {
  /// Panel background color
  final Color background;

  /// Panel border color
  final Color border;

  /// Panel text color
  final Color foreground;

  const FondePanelColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  FondePanelColors copyWith({
    Color? background,
    Color? border,
    Color? foreground,
  }) {
    return FondePanelColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondePanelColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, foreground);
  }
}

/// Class defining toolbar colors
class FondeToolbarColors {
  /// Title bar overall background color
  final Color background;

  /// Title bar border color (bottom)
  final Color border;

  /// Title bar text color
  final Color foreground;

  /// Title bar icon color
  final Color iconColor;

  /// Title bar button background on hover
  final Color buttonHoverBackground;

  /// Title bar button background when active
  final Color buttonActiveBackground;

  const FondeToolbarColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.iconColor,
    required this.buttonHoverBackground,
    required this.buttonActiveBackground,
  });

  FondeToolbarColors copyWith({
    Color? background,
    Color? border,
    Color? foreground,
    Color? iconColor,
    Color? buttonHoverBackground,
    Color? buttonActiveBackground,
  }) {
    return FondeToolbarColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      iconColor: iconColor ?? this.iconColor,
      buttonHoverBackground:
          buttonHoverBackground ?? this.buttonHoverBackground,
      buttonActiveBackground:
          buttonActiveBackground ?? this.buttonActiveBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeToolbarColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground &&
        other.iconColor == iconColor &&
        other.buttonHoverBackground == buttonHoverBackground &&
        other.buttonActiveBackground == buttonActiveBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      border,
      foreground,
      iconColor,
      buttonHoverBackground,
      buttonActiveBackground,
    );
  }
}

/// Class defining quick input colors
class FondeQuickInputColors {
  /// Input field background color
  final Color fieldBackground;

  /// Input field border color
  final Color fieldBorder;

  /// Border color when active
  final Color fieldActiveBorder;

  /// Placeholder text color
  final Color placeholderText;

  /// Input text color
  final Color inputText;

  /// Icon color
  final Color iconColor;

  /// Dropdown background color
  final Color dropdownBackground;

  /// Dropdown border color
  final Color dropdownBorder;

  /// Selected item background color
  final Color selectedItemBackground;

  /// Selected item text color
  final Color selectedItemText;

  /// Background color on hover
  final Color hoverBackground;

  /// Item text color
  final Color itemText;

  /// Item description text color
  final Color itemDescriptionText;

  const FondeQuickInputColors({
    required this.fieldBackground,
    required this.fieldBorder,
    required this.fieldActiveBorder,
    required this.placeholderText,
    required this.inputText,
    required this.iconColor,
    required this.dropdownBackground,
    required this.dropdownBorder,
    required this.selectedItemBackground,
    required this.selectedItemText,
    required this.hoverBackground,
    required this.itemText,
    required this.itemDescriptionText,
  });

  FondeQuickInputColors copyWith({
    Color? fieldBackground,
    Color? fieldBorder,
    Color? fieldActiveBorder,
    Color? placeholderText,
    Color? inputText,
    Color? iconColor,
    Color? dropdownBackground,
    Color? dropdownBorder,
    Color? selectedItemBackground,
    Color? selectedItemText,
    Color? hoverBackground,
    Color? itemText,
    Color? itemDescriptionText,
  }) {
    return FondeQuickInputColors(
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      fieldActiveBorder: fieldActiveBorder ?? this.fieldActiveBorder,
      placeholderText: placeholderText ?? this.placeholderText,
      inputText: inputText ?? this.inputText,
      iconColor: iconColor ?? this.iconColor,
      dropdownBackground: dropdownBackground ?? this.dropdownBackground,
      dropdownBorder: dropdownBorder ?? this.dropdownBorder,
      selectedItemBackground:
          selectedItemBackground ?? this.selectedItemBackground,
      selectedItemText: selectedItemText ?? this.selectedItemText,
      hoverBackground: hoverBackground ?? this.hoverBackground,
      itemText: itemText ?? this.itemText,
      itemDescriptionText: itemDescriptionText ?? this.itemDescriptionText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeQuickInputColors &&
        other.fieldBackground == fieldBackground &&
        other.fieldBorder == fieldBorder &&
        other.fieldActiveBorder == fieldActiveBorder &&
        other.placeholderText == placeholderText &&
        other.inputText == inputText &&
        other.iconColor == iconColor &&
        other.dropdownBackground == dropdownBackground &&
        other.dropdownBorder == dropdownBorder &&
        other.selectedItemBackground == selectedItemBackground &&
        other.selectedItemText == selectedItemText &&
        other.hoverBackground == hoverBackground &&
        other.itemText == itemText &&
        other.itemDescriptionText == itemDescriptionText;
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldBackground,
      fieldBorder,
      fieldActiveBorder,
      placeholderText,
      inputText,
      iconColor,
      dropdownBackground,
      dropdownBorder,
      selectedItemBackground,
      selectedItemText,
      hoverBackground,
      itemText,
      itemDescriptionText,
    );
  }
}

/// Class defining dialog colors
class FondeDialogColors {
  /// Dialog background color
  final Color background;

  /// Dialog border color
  final Color border;

  /// Dialog text color
  final Color foreground;

  /// Dialog shadow color
  final Color shadow;

  /// Dialog background barrier color
  final Color barrier;

  const FondeDialogColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
    required this.barrier,
  });

  FondeDialogColors copyWith({
    Color? background,
    Color? border,
    Color? foreground,
    Color? shadow,
    Color? barrier,
  }) {
    return FondeDialogColors(
      background: background ?? this.background,
      border: border ?? this.border,
      foreground: foreground ?? this.foreground,
      shadow: shadow ?? this.shadow,
      barrier: barrier ?? this.barrier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeDialogColors &&
        other.background == background &&
        other.border == border &&
        other.foreground == foreground &&
        other.shadow == shadow &&
        other.barrier == barrier;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, foreground, shadow, barrier);
  }
}

/// Class consolidating UI area colors
class FondeUiAreaColors {
  /// Icon bar on the left edge (launch bar)
  final FondeLaunchBarColors launchBar;

  /// File tree, search panel, etc.
  final FondeSideBarColors sideBar;

  /// Status display area (connection status, progress, etc.)
  final FondeStatusBarColors statusBar;

  /// Toolbar (cross-platform toolbar)
  final FondeToolbarColors toolbar;

  /// Floating panel, tool panel
  final FondePanelColors panel;

  /// Modal dialog, settings screen
  final FondeDialogColors dialog;

  const FondeUiAreaColors({
    required this.launchBar,
    required this.sideBar,
    required this.statusBar,
    required this.toolbar,
    required this.panel,
    required this.dialog,
  });

  FondeUiAreaColors copyWith({
    FondeLaunchBarColors? launchBar,
    FondeSideBarColors? sideBar,
    FondeStatusBarColors? statusBar,
    FondeToolbarColors? toolbar,
    FondePanelColors? panel,
    FondeDialogColors? dialog,
  }) {
    return FondeUiAreaColors(
      launchBar: launchBar ?? this.launchBar,
      sideBar: sideBar ?? this.sideBar,
      statusBar: statusBar ?? this.statusBar,
      toolbar: toolbar ?? this.toolbar,
      panel: panel ?? this.panel,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeUiAreaColors &&
        other.launchBar == launchBar &&
        other.sideBar == sideBar &&
        other.statusBar == statusBar &&
        other.toolbar == toolbar &&
        other.panel == panel &&
        other.dialog == dialog;
  }

  @override
  int get hashCode {
    return Object.hash(launchBar, sideBar, statusBar, toolbar, panel, dialog);
  }
}

/// Class defining state-based colors
class FondeStatefulColors {
  /// Default state
  final Color normal;

  /// On mouse hover
  final Color hover;

  /// On click, when selected
  final Color active;

  /// When disabled
  final Color disabled;

  /// On keyboard focus
  final Color focus;

  const FondeStatefulColors({
    required this.normal,
    required this.hover,
    required this.active,
    required this.disabled,
    required this.focus,
  });

  FondeStatefulColors copyWith({
    Color? normal,
    Color? hover,
    Color? active,
    Color? disabled,
    Color? focus,
  }) {
    return FondeStatefulColors(
      normal: normal ?? this.normal,
      hover: hover ?? this.hover,
      active: active ?? this.active,
      disabled: disabled ?? this.disabled,
      focus: focus ?? this.focus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeStatefulColors &&
        other.normal == normal &&
        other.hover == hover &&
        other.active == active &&
        other.disabled == disabled &&
        other.focus == focus;
  }

  @override
  int get hashCode {
    return Object.hash(normal, hover, active, disabled, focus);
  }
}

/// Class defining button colors
class FondeButtonColors {
  /// Button background color (state-based)
  final FondeStatefulColors background;

  /// Button text color (state-based)
  final FondeStatefulColors text;

  /// Button border color (state-based)
  final FondeStatefulColors border;

  /// Primary button background color
  final Color primaryBackground;

  /// Primary button text color
  final Color primaryText;

  /// Primary button background on press
  final Color primaryPressedBackground;

  /// Destructive action button background color
  final Color destructiveBackground;

  /// Destructive action button text color
  final Color destructiveText;

  /// Destructive action button background on press
  final Color destructivePressedBackground;

  const FondeButtonColors({
    required this.background,
    required this.text,
    required this.border,
    required this.primaryBackground,
    required this.primaryText,
    required this.primaryPressedBackground,
    required this.destructiveBackground,
    required this.destructiveText,
    required this.destructivePressedBackground,
  });

  FondeButtonColors copyWith({
    FondeStatefulColors? background,
    FondeStatefulColors? text,
    FondeStatefulColors? border,
    Color? primaryBackground,
    Color? primaryText,
    Color? primaryPressedBackground,
    Color? destructiveBackground,
    Color? destructiveText,
    Color? destructivePressedBackground,
  }) {
    return FondeButtonColors(
      background: background ?? this.background,
      text: text ?? this.text,
      border: border ?? this.border,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      primaryText: primaryText ?? this.primaryText,
      primaryPressedBackground:
          primaryPressedBackground ?? this.primaryPressedBackground,
      destructiveBackground:
          destructiveBackground ?? this.destructiveBackground,
      destructiveText: destructiveText ?? this.destructiveText,
      destructivePressedBackground:
          destructivePressedBackground ?? this.destructivePressedBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeButtonColors &&
        other.background == background &&
        other.text == text &&
        other.border == border &&
        other.primaryBackground == primaryBackground &&
        other.primaryText == primaryText &&
        other.primaryPressedBackground == primaryPressedBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      background,
      text,
      border,
      primaryBackground,
      primaryText,
      primaryPressedBackground,
    );
  }
}

/// Class defining input field colors
class FondeInputColors {
  /// Input field background color
  final Color background;

  /// Input field border color
  final Color border;

  /// Border color on focus
  final Color focusBorder;

  /// Placeholder text color
  final Color placeholder;

  /// Input text color
  final Color text;

  const FondeInputColors({
    required this.background,
    required this.border,
    required this.focusBorder,
    required this.placeholder,
    required this.text,
  });

  FondeInputColors copyWith({
    Color? background,
    Color? border,
    Color? focusBorder,
    Color? placeholder,
    Color? text,
  }) {
    return FondeInputColors(
      background: background ?? this.background,
      border: border ?? this.border,
      focusBorder: focusBorder ?? this.focusBorder,
      placeholder: placeholder ?? this.placeholder,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeInputColors &&
        other.background == background &&
        other.border == border &&
        other.focusBorder == focusBorder &&
        other.placeholder == placeholder &&
        other.text == text;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, focusBorder, placeholder, text);
  }
}

/// Class defining list colors
class FondeListColors {
  /// List item background color (state-based)
  final FondeStatefulColors itemBackground;

  /// List item text color (state-based)
  final FondeStatefulColors itemText;

  /// Selected state background color
  final Color selectedBackground;

  /// Selected state text color
  final Color selectedText;

  const FondeListColors({
    required this.itemBackground,
    required this.itemText,
    required this.selectedBackground,
    required this.selectedText,
  });

  FondeListColors copyWith({
    FondeStatefulColors? itemBackground,
    FondeStatefulColors? itemText,
    Color? selectedBackground,
    Color? selectedText,
  }) {
    return FondeListColors(
      itemBackground: itemBackground ?? this.itemBackground,
      itemText: itemText ?? this.itemText,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedText: selectedText ?? this.selectedText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeListColors &&
        other.itemBackground == itemBackground &&
        other.itemText == itemText &&
        other.selectedBackground == selectedBackground &&
        other.selectedText == selectedText;
  }

  @override
  int get hashCode {
    return Object.hash(
      itemBackground,
      itemText,
      selectedBackground,
      selectedText,
    );
  }
}

/// Class defining dropdown colors
class FondeDropdownColors {
  /// Dropdown menu background color
  final Color background;

  /// Dropdown menu border color
  final Color border;

  /// Menu item background color (state-based)
  final FondeStatefulColors itemBackground;

  /// Menu item text color
  final Color itemText;

  const FondeDropdownColors({
    required this.background,
    required this.border,
    required this.itemBackground,
    required this.itemText,
  });

  FondeDropdownColors copyWith({
    Color? background,
    Color? border,
    FondeStatefulColors? itemBackground,
    Color? itemText,
  }) {
    return FondeDropdownColors(
      background: background ?? this.background,
      border: border ?? this.border,
      itemBackground: itemBackground ?? this.itemBackground,
      itemText: itemText ?? this.itemText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeDropdownColors &&
        other.background == background &&
        other.border == border &&
        other.itemBackground == itemBackground &&
        other.itemText == itemText;
  }

  @override
  int get hashCode {
    return Object.hash(background, border, itemBackground, itemText);
  }
}

/// Class defining popover colors
class FondePopoverColors {
  /// Popover background color
  final Color background;

  /// Popover text color
  final Color text;

  /// Popover border color
  final Color border;

  /// Popover shadow color
  final Color shadow;

  /// Popover background barrier color
  final Color barrier;

  const FondePopoverColors({
    required this.background,
    required this.text,
    required this.border,
    required this.shadow,
    required this.barrier,
  });

  FondePopoverColors copyWith({
    Color? background,
    Color? text,
    Color? border,
    Color? shadow,
    Color? barrier,
  }) {
    return FondePopoverColors(
      background: background ?? this.background,
      text: text ?? this.text,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      barrier: barrier ?? this.barrier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondePopoverColors &&
        other.background == background &&
        other.text == text &&
        other.border == border &&
        other.shadow == shadow &&
        other.barrier == barrier;
  }

  @override
  int get hashCode {
    return Object.hash(background, text, border, shadow, barrier);
  }
}

/// Class defining action button colors
/// For overlay action buttons (e.g., ellipsis menu button in stack grid)
class FondeActionButtonColors {
  /// Action button background color
  final Color background;

  /// Action button icon color
  final Color iconColor;

  const FondeActionButtonColors({
    required this.background,
    required this.iconColor,
  });

  FondeActionButtonColors copyWith({Color? background, Color? iconColor}) {
    return FondeActionButtonColors(
      background: background ?? this.background,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeActionButtonColors &&
        other.background == background &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode {
    return Object.hash(background, iconColor);
  }
}

/// Class consolidating interactive element colors
class FondeInteractiveColors {
  /// Various buttons (primary, secondary, danger, etc.)
  final FondeButtonColors button;

  /// Text input, search box
  final FondeInputColors input;

  /// List item, tree item
  final FondeListColors list;

  /// Select box, menu
  final FondeDropdownColors dropdown;

  /// Tooltip, context menu
  final FondePopoverColors popover;

  /// Quick input (pathfinder, etc.)
  final FondeQuickInputColors quickInput;

  /// Overlay action button
  final FondeActionButtonColors actionButton;

  const FondeInteractiveColors({
    required this.button,
    required this.input,
    required this.list,
    required this.dropdown,
    required this.popover,
    required this.quickInput,
    required this.actionButton,
  });

  FondeInteractiveColors copyWith({
    FondeButtonColors? button,
    FondeInputColors? input,
    FondeListColors? list,
    FondeDropdownColors? dropdown,
    FondePopoverColors? popover,
    FondeQuickInputColors? quickInput,
    FondeActionButtonColors? actionButton,
  }) {
    return FondeInteractiveColors(
      button: button ?? this.button,
      input: input ?? this.input,
      list: list ?? this.list,
      dropdown: dropdown ?? this.dropdown,
      popover: popover ?? this.popover,
      quickInput: quickInput ?? this.quickInput,
      actionButton: actionButton ?? this.actionButton,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeInteractiveColors &&
        other.button == button &&
        other.input == input &&
        other.list == list &&
        other.dropdown == dropdown &&
        other.popover == popover &&
        other.quickInput == quickInput &&
        other.actionButton == actionButton;
  }

  @override
  int get hashCode {
    return Object.hash(
      button,
      input,
      list,
      dropdown,
      popover,
      quickInput,
      actionButton,
    );
  }
}

/// Class defining status display colors
class FondeStatusColors {
  /// Info message, help icon
  final Color info;

  /// Warning message, caution icon
  final Color warning;

  /// Error message, failure state
  final Color error;

  /// Success message, completion state
  final Color success;

  /// Progress bar, spinner
  final Color loading;

  /// Loading background color
  final Color loadingBackground;

  const FondeStatusColors({
    required this.info,
    required this.warning,
    required this.error,
    required this.success,
    required this.loading,
    required this.loadingBackground,
  });

  FondeStatusColors copyWith({
    Color? info,
    Color? warning,
    Color? error,
    Color? success,
    Color? loading,
    Color? loadingBackground,
  }) {
    return FondeStatusColors(
      info: info ?? this.info,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      success: success ?? this.success,
      loading: loading ?? this.loading,
      loadingBackground: loadingBackground ?? this.loadingBackground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeStatusColors &&
        other.info == info &&
        other.warning == warning &&
        other.error == error &&
        other.success == success &&
        other.loading == loading &&
        other.loadingBackground == loadingBackground;
  }

  @override
  int get hashCode {
    return Object.hash(
      info,
      warning,
      error,
      success,
      loading,
      loadingBackground,
    );
  }
}
