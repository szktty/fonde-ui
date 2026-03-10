import 'package:flutter/material.dart';
import 'fonde_text.dart';

/// Shortcut widgets for text elements.
///
/// Provides shortcut widgets for frequently used FondeTextVariants.
/// This simplifies the specification of variants and improves code readability.

// Content text related shortcuts

/// Large heading (content area)
class FondeHeading1Text extends StatelessWidget {
  const FondeHeading1Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.textHeading1,
      color: color,
    );
  }
}

/// Medium heading (content area)
class FondeHeading2Text extends StatelessWidget {
  const FondeHeading2Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.textHeading2,
      color: color,
    );
  }
}

/// Small heading (content area)
class FondeHeading3Text extends StatelessWidget {
  const FondeHeading3Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.textHeading3,
      color: color,
    );
  }
}

/// Body (content area)
class FondeBodyText extends StatelessWidget {
  const FondeBodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.textBody, color: color);
  }
}

/// Caption (content area)
class FondeCaptionText extends StatelessWidget {
  const FondeCaptionText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.textCaption, color: color);
  }
}

/// Supplementary text (content area)
class FondeSmallText extends StatelessWidget {
  const FondeSmallText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.textSmall, color: color);
  }
}

// UI related shortcuts

/// Large heading (UI component)
class FondeUiHeading1Text extends StatelessWidget {
  const FondeUiHeading1Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.pageTitle, color: color);
  }
}

/// Medium heading (UI component)
class FondeUiHeading2Text extends StatelessWidget {
  const FondeUiHeading2Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.sectionTitlePrimary,
      color: color,
    );
  }
}

/// Small heading (UI component)
class FondeUiHeading3Text extends StatelessWidget {
  const FondeUiHeading3Text(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.itemTitle, color: color);
  }
}

/// Body text (UI component)
class FondeUiBodyText extends StatelessWidget {
  const FondeUiBodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.bodyText, color: color);
  }
}

/// Caption (UI component)
class FondeUiCaptionText extends StatelessWidget {
  const FondeUiCaptionText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.captionText, color: color);
  }
}

/// Small text (UI component)
class FondeUiSmallText extends StatelessWidget {
  const FondeUiSmallText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.smallText, color: color);
  }
}

// Code block related shortcuts

/// Code block body
class FondeCodeBlockText extends StatelessWidget {
  const FondeCodeBlockText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.codeBlock, color: color);
  }
}

/// Inline code
class FondeCodeInlineText extends StatelessWidget {
  const FondeCodeInlineText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.codeInline, color: color);
  }
}

// Table related shortcuts

/// Table header
class FondeTableHeaderText extends StatelessWidget {
  const FondeTableHeaderText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.tableHeader, color: color);
  }
}

/// Table body
class FondeTableBodyText extends StatelessWidget {
  const FondeTableBodyText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.tableBody, color: color);
  }
}

/// Table footer
class FondeTableFooterText extends StatelessWidget {
  const FondeTableFooterText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(text, variant: FondeTextVariant.tableFooter, color: color);
  }
}

// Label related shortcuts (class name and variant name changed)

/// Primary label (graph node)
class FondeEntityLabelPrimaryText extends StatelessWidget {
  const FondeEntityLabelPrimaryText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.entityLabelPrimary,
      color: color,
    );
  }
}

/// Secondary label (graph edge)
class FondeEntityLabelSecondaryText extends StatelessWidget {
  const FondeEntityLabelSecondaryText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.entityLabelSecondary,
      color: color,
    );
  }
}

/// Metadata label
class FondeEntityLabelMetaText extends StatelessWidget {
  const FondeEntityLabelMetaText(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FondeText(
      text,
      variant: FondeTextVariant.entityLabelMeta,
      color: color,
    );
  }
}
