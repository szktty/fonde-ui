import 'package:flutter/material.dart' show DropdownMenuEntry;
import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class DropdownMenuPage extends StatefulWidget {
  const DropdownMenuPage({super.key});

  @override
  State<DropdownMenuPage> createState() => _DropdownMenuPageState();
}

class _DropdownMenuPageState extends State<DropdownMenuPage> {
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Dropdown Menu',
          description: 'Dropdown menu',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FondeDropdownMenu<String>(
                  initialSelection: _dropdownValue,
                  width: 200,
                  hintText: 'Select an option',
                  onSelected: (v) => setState(() => _dropdownValue = v),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'apple', label: 'Apple'),
                    DropdownMenuEntry(value: 'banana', label: 'Banana'),
                    DropdownMenuEntry(value: 'cherry', label: 'Cherry'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
