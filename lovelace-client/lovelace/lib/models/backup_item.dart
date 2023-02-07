import 'package:lit_backup_service/lit_backup_service.dart';

class BackUpItem implements BackupModel {
  final String name;
  final String data;
  final String backUpDate;

  const BackUpItem(
      {required this.name, required this.data, required this.backUpDate});

  factory BackUpItem.fromJson(Map<String, dynamic> json) {
    return BackUpItem(
        name: json['name'], data: json['name'], backUpDate: json['backUpDate']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'data': data, 'backUpDate': backUpDate};
  }
}
