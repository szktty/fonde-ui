import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'fonde_ui_localizations_en.dart';
import 'fonde_ui_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FondeUILocalizations
/// returned by `FondeUILocalizations.of(context)`.
///
/// Applications need to include `FondeUILocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/fonde_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FondeUILocalizations.localizationsDelegates,
///   supportedLocales: FondeUILocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FondeUILocalizations.supportedLocales
/// property.
abstract class FondeUILocalizations {
  FondeUILocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FondeUILocalizations of(BuildContext context) {
    return Localizations.of<FondeUILocalizations>(
      context,
      FondeUILocalizations,
    )!;
  }

  static const LocalizationsDelegate<FondeUILocalizations> delegate =
      _FondeUILocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// App menu: Preferences item label
  ///
  /// In en, this message translates to:
  /// **'Preferences...'**
  String get menuAppPreferences;

  /// Edit menu: Undo item label
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get menuEditUndo;

  /// Edit menu: Redo item label
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get menuEditRedo;

  /// Edit menu: Cut item label
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get menuEditCut;

  /// Edit menu: Copy item label
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get menuEditCopy;

  /// Edit menu: Paste item label
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get menuEditPaste;

  /// Edit menu: Select All item label
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get menuEditSelectAll;

  /// Edit menu: Find item label
  ///
  /// In en, this message translates to:
  /// **'Find...'**
  String get menuEditFind;

  /// Edit menu: Replace item label
  ///
  /// In en, this message translates to:
  /// **'Replace...'**
  String get menuEditReplace;

  /// File menu: Save item label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get menuFileSave;

  /// File menu: Close Window item label
  ///
  /// In en, this message translates to:
  /// **'Close Window'**
  String get menuFileCloseWindow;

  /// File menu: Page Setup item label
  ///
  /// In en, this message translates to:
  /// **'Page Setup...'**
  String get menuFilePageSetup;

  /// File menu: Print item label
  ///
  /// In en, this message translates to:
  /// **'Print...'**
  String get menuFilePrint;

  /// View menu: Zoom In item label
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get menuViewZoomIn;

  /// View menu: Zoom Out item label
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get menuViewZoomOut;

  /// View menu: Actual Size item label
  ///
  /// In en, this message translates to:
  /// **'Actual Size'**
  String get menuViewActualSize;

  /// View menu: Full Screen item label
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get menuViewFullScreen;

  /// Platform menu bar: App menu title
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get menuLabelApp;

  /// Platform menu bar: Window menu title
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get menuLabelWindow;
}

class _FondeUILocalizationsDelegate
    extends LocalizationsDelegate<FondeUILocalizations> {
  const _FondeUILocalizationsDelegate();

  @override
  Future<FondeUILocalizations> load(Locale locale) {
    return SynchronousFuture<FondeUILocalizations>(
      lookupFondeUILocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_FondeUILocalizationsDelegate old) => false;
}

FondeUILocalizations lookupFondeUILocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FondeUILocalizationsEn();
    case 'ja':
      return FondeUILocalizationsJa();
  }

  throw FlutterError(
    'FondeUILocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
