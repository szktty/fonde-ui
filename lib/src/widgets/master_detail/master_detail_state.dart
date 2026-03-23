import 'package:flutter/foundation.dart';

/// Controller for managing selected item state in master-detail layout.
class FondeMasterDetailController extends ChangeNotifier {
  FondeMasterDetailController({
    String? initialSelectedId,
    double initialMasterWidth = 280.0,
    bool initialDetailVisible = false,
  }) : _selectedId = initialSelectedId,
       _masterWidth = initialMasterWidth,
       _detailVisible = initialDetailVisible;

  String? _selectedId;
  double _masterWidth;
  bool _detailVisible;

  String? get selectedId => _selectedId;
  double get masterWidth => _masterWidth;
  bool get detailVisible => _detailVisible;

  void setSelectedId(String? id) {
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  void setWidth(double width) {
    if (_masterWidth == width) return;
    _masterWidth = width;
    notifyListeners();
  }

  void setVisible(bool visible) {
    if (_detailVisible == visible) return;
    _detailVisible = visible;
    notifyListeners();
  }
}
