/// Desktop-first Flutter UI component library.
///
/// Import this library to access all fonde_ui components and theme utilities.
library;

// ─── Core: Models ─────────────────────────────────────────────────────────────
export 'src/core/models/fonde_color_scheme.dart';
export 'src/core/models/fonde_theme_data.dart';
export 'src/core/models/fonde_typography_config.dart';
export 'src/core/models/fonde_font_config.dart';
export 'src/core/models/fonde_accessibility_config.dart';
export 'src/core/models/fonde_icon_theme.dart';
export 'src/core/models/color_structure.dart';
export 'src/core/models/theme_color_scheme.dart';
export 'src/core/models/fonde_localization_config.dart';

// ─── Core: Localization ───────────────────────────────────────────────────────
export 'src/core/l10n/fonde_ui_localizations.dart';

// ─── Core: Presets & Utilities ────────────────────────────────────────────────
export 'src/core/presets.dart';
export 'src/core/color_extensions.dart';

// ─── Core: Color Scope ────────────────────────────────────────────────────────
export 'src/core/color_scope.dart'
    hide
        fondeThemeModeProvider,
        fondeIsDarkModeProvider,
        fondeColorSchemeProvider,
        fondeDefaultColorScopeProvider,
        fondeLaunchBarColorScopeProvider,
        fondeSideBarColorScopeProvider,
        fondeMainContentColorScopeProvider,
        fondeDialogColorScopeProvider,
        fondeColorScopeProvider;

// ─── Core: App ────────────────────────────────────────────────────────────────
export 'src/core/fonde_app.dart';

// ─── Layout ───────────────────────────────────────────────────────────────────
export 'src/widgets/layout/fonde_scaffold.dart';
export 'src/widgets/layout/launch_bar_wrapper.dart';
export 'src/widgets/layout/collapsed_sidebar_layout.dart';
export 'src/widgets/layout/primary_side.dart';
export 'src/widgets/layout/sidebar_pane.dart';
export 'src/widgets/layout/main_content_area.dart';
export 'src/widgets/layout/form_components.dart'
    show FondeFormItemRow, FondeFormItemColumn, FondeFormList;

// ─── Launch Bar ───────────────────────────────────────────────────────────────
export 'src/widgets/launch_bar/launch_bar.dart';

// ─── Toolbar ──────────────────────────────────────────────────────────────────
export 'src/widgets/toolbar/toolbar.dart';
export 'src/widgets/toolbar/main_toolbar.dart';
export 'src/widgets/toolbar/primary_sidebar_toolbar.dart';
export 'src/widgets/toolbar/secondary_sidebar_toolbar.dart';

// ─── Navigation ───────────────────────────────────────────────────────────────
export 'src/widgets/navigation/navigation_exports.dart';
export 'src/widgets/navigation/sidebar.dart';

// ─── Tab View ─────────────────────────────────────────────────────────────────
export 'src/widgets/tab_view/tab_view_exports.dart';

// ─── Outline ──────────────────────────────────────────────────────────────────
export 'src/widgets/outline/index.dart';

// ─── Master Detail ────────────────────────────────────────────────────────────
export 'src/widgets/master_detail/master_detail_layout.dart';

// ─── List & Grid ─────────────────────────────────────────────────────────────
export 'src/widgets/list_tiles/fonde_list_tile.dart'
    hide
        effectiveAppColorSchemeForListTile,
        effectiveAppColorSchemeForListTileProvider,
        EffectiveAppColorSchemeForListTileProvider;

// ─── Section ──────────────────────────────────────────────────────────────────
export 'src/widgets/section/section.dart';

// ─── Buttons ──────────────────────────────────────────────────────────────────
export 'src/widgets/widgets/fonde_button.dart';
export 'src/widgets/widgets/fonde_icon_button.dart';
export 'src/widgets/widgets/fonde_segmented_button.dart';
export 'src/widgets/widgets/fonde_split_button.dart';
export 'src/widgets/button_group/button_group.dart';
export 'src/widgets/icon_label_button/icon_label_button.dart';
export 'src/widgets/overflow_menu/overflow_menu.dart';
export 'src/widgets/context_menu/fonde_context_menu.dart';

// ─── Input ────────────────────────────────────────────────────────────────────
export 'src/widgets/text_field/fonde_text_field.dart';
export 'src/widgets/search_field/fonde_search_field.dart';
export 'src/widgets/tags_field/fonde_tags_field.dart';
export 'src/widgets/number_field/fonde_number_field.dart';
export 'src/widgets/widgets/fonde_checkbox.dart';
export 'src/widgets/widgets/fonde_radio_button.dart';
export 'src/widgets/widgets/fonde_switch.dart';
export 'src/widgets/widgets/fonde_dropdown_menu.dart';
export 'src/widgets/widgets/fonde_popup_menu.dart';
export 'src/widgets/widgets/fonde_expansion_tile.dart';

// ─── Date Picker ──────────────────────────────────────────────────────────────
export 'src/widgets/date_picker/fonde_date_picker.dart';
export 'package:table_calendar/table_calendar.dart' show StartingDayOfWeek;

// ─── Dialogs & Overlays ───────────────────────────────────────────────────────
export 'src/widgets/widgets/fonde_dialog.dart';
export 'src/widgets/widgets/fonde_popover.dart' hide appPopoverConfigProvider;
export 'src/widgets/widgets/fonde_toast.dart';
export 'src/widgets/widgets/fonde_snack_bar.dart';
export 'src/widgets/dialogs/confirmation_dialog.dart';

// ─── Panel ────────────────────────────────────────────────────────────────────
export 'src/widgets/widgets/fonde_panel.dart';

// ─── Decorators ───────────────────────────────────────────────────────────────
export 'src/widgets/decorators/selectable.dart';

// ─── Gesture ──────────────────────────────────────────────────────────────────
export 'src/widgets/widgets/fonde_gesture_detector.dart';

// ─── Scroll View ─────────────────────────────────────────────────────────────
export 'src/widgets/scroll_view/index.dart';

// ─── Page Indicator ───────────────────────────────────────────────────────────
export 'src/widgets/page_indicator/fonde_page_indicator.dart';
export 'src/widgets/pagination/fonde_pagination.dart';

// ─── Typography ───────────────────────────────────────────────────────────────
export 'src/widgets/typography/fonde_text.dart';
export 'src/widgets/typography/fonde_text_style_builder.dart';
export 'src/widgets/typography/typography_shortcuts.dart';

// ─── Icons ────────────────────────────────────────────────────────────────────
export 'src/widgets/icons/fonde_icons.dart';
export 'src/widgets/icons/lucide_icon_theme.dart';
export 'src/widgets/widgets/fonde_icon.dart';

// ─── Visual ───────────────────────────────────────────────────────────────────
export 'src/widgets/widgets/fonde_container.dart'
    hide
        fondeContainerPadding,
        fondeContainerPaddingProvider,
        FondeContainerPaddingProvider,
        fondeContainerLeadingWidth,
        fondeContainerLeadingWidthProvider,
        FondeContainerLeadingWidthProvider;
export 'src/widgets/widgets/fonde_divider.dart'
    hide
        effectiveAppColorSchemeForDivider,
        effectiveAppColorSchemeForDividerProvider,
        EffectiveAppColorSchemeForDividerProvider,
        fondeDividerColor,
        fondeDividerColorProvider,
        FondeDividerColorProvider,
        fondeVerticalDividerColor,
        fondeVerticalDividerColorProvider,
        FondeVerticalDividerColorProvider;
export 'src/widgets/widgets/fonde_physical_model.dart';
export 'src/widgets/widgets/fonde_rectangle_border.dart'
    hide
        fondeRectangleBorder,
        fondeRectangleBorderProvider,
        FondeRectangleBorderProvider,
        fondeShapeDecoration,
        fondeShapeDecorationProvider,
        FondeShapeDecorationFamily,
        FondeShapeDecorationProvider,
        fondeBorderRadius,
        fondeBorderRadiusProvider,
        FondeBorderRadiusProvider,
        fondeBorderSide,
        fondeBorderSideProvider,
        FondeBorderSideProvider;
export 'src/widgets/widgets/tag.dart';

// ─── Progress ─────────────────────────────────────────────────────────────────
export 'src/widgets/progress/fonde_progress_indicator.dart';

// ─── Table View ───────────────────────────────────────────────────────────────
export 'src/widgets/table_view/fonde_table_view.dart';

// ─── Status Bar ───────────────────────────────────────────────────────────────
export 'src/widgets/status_bar/fonde_status_bar.dart';

// ─── Shortcut Scope ───────────────────────────────────────────────────────────
export 'src/widgets/shortcut_scope/fonde_shortcut_scope.dart';

// ─── Tooltip ──────────────────────────────────────────────────────────────────
export 'src/widgets/tooltip/fonde_tooltip.dart';

// ─── Draggable ────────────────────────────────────────────────────────────────
export 'src/widgets/draggable/fonde_draggable.dart';

// ─── Split Pane ───────────────────────────────────────────────────────────────
export 'src/widgets/split_pane/fonde_split_pane.dart';

// ─── Slider ───────────────────────────────────────────────────────────────────
export 'src/widgets/slider/fonde_slider.dart';

// ─── Notification Overlay ─────────────────────────────────────────────────────
export 'src/widgets/notification_overlay/fonde_notification_overlay.dart';

// ─── Color Picker ─────────────────────────────────────────────────────────────
export 'src/widgets/color_picker/fonde_color_picker.dart';
export 'src/widgets/color_picker/fonde_eye_dropper.dart';

// ─── Platform Menus ───────────────────────────────────────────────────────────
export 'src/widgets/platform_menus/fonde_platform_menus.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
export 'src/widgets/spacing/fonde_spacing.dart';
export 'src/widgets/spacing/fonde_padding.dart';
export 'src/widgets/styling/fonde_border_radius.dart'
    show FondeBorderRadiusValues;
