import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';

/// Label tag editing field
///
/// Provides a tag input field for editing entity labels and more.
/// Supports desktop-native keyboard navigation (macOS NSTokenField conventions):
/// - `Enter` / `,` / `Space`: confirm tag
/// - `Backspace` (empty input): select last tag (first step of 2-step delete)
/// - `Backspace` (tag selected): delete selected tag
/// - `Delete`: delete selected tag immediately
/// - `←` / `→`: navigate between tags when input is empty
/// - `Escape`: deselect tag
class FondeTagsField extends StatefulWidget {
  /// Constructor
  const FondeTagsField({
    super.key,
    this.initialTags = const [],
    this.onTagsChanged,
    this.hintText = 'Enter a tag...',
    this.validator,
    this.textSeparators = const [' ', ','],
    this.maxTagLength = 50,
    this.minTagLength = 1,
    this.maxTags,
    this.tagBackgroundColor,
    this.tagTextColor,
    this.enabled = true,
    this.disableZoom = false,
  });

  /// Initial list of tags.
  final List<String> initialTags;

  /// Callback for when tags are changed.
  final void Function(List<String> tags)? onTagsChanged;

  /// Hint text.
  final String hintText;

  /// Validator function. Returns an error message string, or null if valid.
  final String? Function(String tag)? validator;

  /// Characters that trigger tag confirmation when typed.
  final List<String> textSeparators;

  /// Maximum tag length.
  final int maxTagLength;

  /// Minimum tag length.
  final int minTagLength;

  /// Maximum number of tags.
  final int? maxTags;

  /// Background color of the tag.
  final Color? tagBackgroundColor;

  /// Text color of the tag.
  final Color? tagTextColor;

  /// Whether it is enabled.
  final bool enabled;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  State<FondeTagsField> createState() => _FondeTagsFieldState();
}

class _FondeTagsFieldState extends State<FondeTagsField> {
  late List<String> _tags;

  /// Index of the currently selected tag (for keyboard delete). null = none.
  int? _selectedTagIndex;

  String? _errorMessage;

  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _tags = List<String>.from(widget.initialTags);
    _textController = TextEditingController();
    _focusNode = FocusNode(onKeyEvent: _handleKeyEvent);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Commit any pending text when focus leaves
        _commitCurrentText();
        setState(() {
          _selectedTagIndex = null;
        });
      } else {
        setState(() {}); // Repaint border when focused
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onTagsChanged?.call(List<String>.unmodifiable(_tags));
  }

  /// Attempt to add a tag from the current text input.
  void _commitCurrentText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _tryAddTag(text);
  }

  void _tryAddTag(String raw) {
    final tag = raw.trim();
    if (tag.length < widget.minTagLength) return;
    if (tag.length > widget.maxTagLength) {
      setState(() {
        _errorMessage = 'Tag is too long (max ${widget.maxTagLength} chars)';
      });
      return;
    }
    if (_tags.contains(tag)) {
      setState(() {
        _errorMessage = 'Tag "$tag" already exists';
      });
      return;
    }
    if (widget.maxTags != null && _tags.length >= widget.maxTags!) {
      setState(() {
        _errorMessage = 'Maximum ${widget.maxTags} tags allowed';
      });
      return;
    }
    if (widget.validator != null) {
      final error = widget.validator!(tag);
      if (error != null) {
        setState(() {
          _errorMessage = error;
        });
        return;
      }
    }
    setState(() {
      _tags.add(tag);
      _errorMessage = null;
      _selectedTagIndex = null;
    });
    _textController.clear();
    _notifyChanged();
  }

  void _removeTagAt(int index) {
    if (index < 0 || index >= _tags.length) return;
    setState(() {
      _tags.removeAt(index);
      _selectedTagIndex = null;
      _errorMessage = null;
    });
    _notifyChanged();
  }

  void _removeTag(String tag) {
    final index = _tags.indexOf(tag);
    if (index >= 0) _removeTagAt(index);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final logical = event.logicalKey;
    final inputText = _textController.text;

    // Separator characters → commit tag
    if (event is KeyDownEvent) {
      for (final sep in widget.textSeparators) {
        if (sep.length == 1) {
          final char = sep;
          if (logical == LogicalKeyboardKey.space && char == ' ') {
            if (inputText.isNotEmpty) {
              _commitCurrentText();
              return KeyEventResult.handled;
            }
          } else if (logical == LogicalKeyboardKey.comma && char == ',') {
            if (inputText.isNotEmpty) {
              _commitCurrentText();
              return KeyEventResult.handled;
            }
          }
        }
      }
    }

    // Enter → commit tag
    if (logical == LogicalKeyboardKey.enter ||
        logical == LogicalKeyboardKey.numpadEnter) {
      if (inputText.isNotEmpty) {
        _commitCurrentText();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // Backspace
    if (logical == LogicalKeyboardKey.backspace) {
      if (inputText.isEmpty && _tags.isNotEmpty) {
        if (_selectedTagIndex == null) {
          // Step 1: select the last tag
          setState(() {
            _selectedTagIndex = _tags.length - 1;
          });
        } else {
          // Step 2: delete the selected tag
          _removeTagAt(_selectedTagIndex!);
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // Delete → delete selected tag immediately
    if (logical == LogicalKeyboardKey.delete) {
      if (_selectedTagIndex != null) {
        _removeTagAt(_selectedTagIndex!);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // ArrowLeft → move selection left (or select last tag when input is empty)
    if (logical == LogicalKeyboardKey.arrowLeft) {
      if (inputText.isEmpty && _tags.isNotEmpty) {
        setState(() {
          if (_selectedTagIndex == null) {
            _selectedTagIndex = _tags.length - 1;
          } else if (_selectedTagIndex! > 0) {
            _selectedTagIndex = _selectedTagIndex! - 1;
          }
        });
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // ArrowRight → move selection right; deselect when reaching input end
    if (logical == LogicalKeyboardKey.arrowRight) {
      if (_selectedTagIndex != null) {
        setState(() {
          if (_selectedTagIndex! < _tags.length - 1) {
            _selectedTagIndex = _selectedTagIndex! + 1;
          } else {
            _selectedTagIndex = null;
          }
        });
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // Escape → deselect
    if (logical == LogicalKeyboardKey.escape) {
      if (_selectedTagIndex != null) {
        setState(() {
          _selectedTagIndex = null;
        });
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // Any other key → deselect tag so the user can type normally
    if (_selectedTagIndex != null) {
      setState(() {
        _selectedTagIndex = null;
      });
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final iconTheme = context.fondeIconTheme;
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

    final hasFocus = _focusNode.hasFocus;
    final borderColor =
        hasFocus ? appColorScheme.base.background : const Color(0x00000000);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        decoration: ShapeDecoration(
          color: appColorScheme.uiAreas.sideBar.background,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 8 * zoomScale,
              cornerSmoothing: 0.6,
            ),
            side: BorderSide(color: borderColor, width: 1.0 * borderScale),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag display area
            if (_tags.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0 * zoomScale,
                  right: 8.0 * zoomScale,
                  top: 8.0 * zoomScale,
                  bottom: 4.0 * zoomScale,
                ),
                child: Wrap(
                  spacing: 8.0 * zoomScale,
                  runSpacing: 4.0 * zoomScale,
                  children: [
                    for (int i = 0; i < _tags.length; i++)
                      _buildTag(
                        context,
                        _tags[i],
                        i,
                        appColorScheme,
                        iconTheme,
                        zoomScale,
                        borderScale,
                      ),
                  ],
                ),
              ),

            // Input field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0 * zoomScale),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                enabled: widget.enabled,
                onChanged: (_) {
                  // Deselect tag when the user starts typing
                  if (_selectedTagIndex != null) {
                    setState(() {
                      _selectedTagIndex = null;
                    });
                  }
                  // Clear error when user edits
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: _tags.isEmpty ? widget.hintText : '+ Add tag',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0 * zoomScale,
                    horizontal: 8.0 * zoomScale,
                  ),
                  isDense: true,
                ),
              ),
            ),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0 * zoomScale,
                  bottom: 8.0 * zoomScale,
                  right: 16.0 * zoomScale,
                ),
                child: Text(_errorMessage!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(
    BuildContext context,
    String tag,
    int index,
    FondeColorScheme appColorScheme,
    FondeIconTheme iconTheme,
    double zoomScale,
    double borderScale,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedTagIndex == index;

    // TODO: Prepare an appropriate theme color
    final actualTagColor =
        widget.tagBackgroundColor ?? appColorScheme.base.foreground;
    final actualTextColor = widget.tagTextColor ?? theme.colorScheme.onPrimary;

    final bgAlpha = isSelected ? 0.4 : 0.2;
    final borderAlpha = isSelected ? 0.6 : 0.3;

    return FondeGestureDetector(
      onTap:
          widget.enabled
              ? () {
                setState(() {
                  _selectedTagIndex = isSelected ? null : index;
                });
                _focusNode.requestFocus();
              }
              : null,
      child: Semantics(
        label: tag,
        button: widget.enabled,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0 * zoomScale,
            vertical: 4.0 * zoomScale,
          ),
          decoration: ShapeDecoration(
            color: actualTagColor.withValues(alpha: bgAlpha),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 16 * zoomScale,
                cornerSmoothing: 0.6,
              ),
              side: BorderSide(
                color: actualTagColor.withValues(alpha: borderAlpha),
                width: 1.0 * borderScale,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: actualTextColor,
                ),
              ),
              if (widget.enabled)
                FondeGestureDetector(
                  onTap: () => _removeTag(tag),
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0 * zoomScale),
                    child: Icon(
                      iconTheme.x,
                      size: 14.0 * zoomScale,
                      color: actualTagColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
