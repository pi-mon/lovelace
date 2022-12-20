import 'package:lit_backup_service/model/models.dart';

class Backup implements BackupModel {
  final String name;
  final String data;
  final String backupDate;

  const Backup(
      {required this.name, required this.data, required this.backupDate});

  factory Backup.fromJson(Map<String, dynamic> json) {
    return Backup(
      name: json['name'] as String,
      data: json['data'] as String,
      backupDate: json['backupDate'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'data': data, 'backupDate': backupDate};
  }
}
