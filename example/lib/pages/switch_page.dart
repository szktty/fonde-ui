import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool _compact = false;
  bool _wide = false;
  bool _compactOn = true;
  bool _wideOn = true;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Switch',
          description: 'Toggle switch for boolean settings.',
          children: [
            CatalogDemo(
              label: 'compact (default)',
              child: Wrap(
                spacing: 24,
                children: [
                  _LabeledSwitch(
                    label: 'OFF',
                    value: _compact,
                    style: FondeSwitchStyle.compact,
                    onChanged: (v) => setState(() => _compact = v),
                  ),
                  _LabeledSwitch(
                    label: 'ON',
                    value: _compactOn,
                    style: FondeSwitchStyle.compact,
                    onChanged: (v) => setState(() => _compactOn = v),
                  ),
                  _LabeledSwitch(
                    label: 'disabled',
                    value: false,
                    style: FondeSwitchStyle.compact,
                    onChanged: null,
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'wide',
              child: Wrap(
                spacing: 24,
                children: [
                  _LabeledSwitch(
                    label: 'OFF',
                    value: _wide,
                    style: FondeSwitchStyle.wide,
                    onChanged: (v) => setState(() => _wide = v),
                  ),
                  _LabeledSwitch(
                    label: 'ON',
                    value: _wideOn,
                    style: FondeSwitchStyle.wide,
                    onChanged: (v) => setState(() => _wideOn = v),
                  ),
                  _LabeledSwitch(
                    label: 'disabled',
                    value: false,
                    style: FondeSwitchStyle.wide,
                    onChanged: null,
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'In a form row',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormRow(
                    label: 'Enable notifications',
                    value: _compact,
                    onChanged: (v) => setState(() => _compact = v),
                  ),
                  const SizedBox(height: 8),
                  _FormRow(
                    label: 'Auto-save',
                    value: _compactOn,
                    onChanged: (v) => setState(() => _compactOn = v),
                  ),
                  const SizedBox(height: 8),
                  _FormRow(
                    label: 'Sync (disabled)',
                    value: false,
                    onChanged: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LabeledSwitch extends StatelessWidget {
  const _LabeledSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
    this.style = FondeSwitchStyle.compact,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final FondeSwitchStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FondeSwitch(value: value, onChanged: onChanged, style: style),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        FondeSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
