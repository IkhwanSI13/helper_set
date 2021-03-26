import 'DropdownModel.dart';

class LocalIdNameModel extends DropdownModel {
  final String id;
  final String name;

  @override
  String getText() => name;

  LocalIdNameModel(this.id, this.name);
}
