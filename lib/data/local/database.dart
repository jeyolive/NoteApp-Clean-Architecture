import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:note_app/common/constants.dart';
import 'package:note_app/common/exception.dart';
import 'package:note_app/domain/database/database.dart';

@LazySingleton(as: Database)
class DatabaseImplementing implements Database {
  @override
  Box get box => Hive.box(databaseBox);

  @override
  Future<T> get<T>(String id) async {
    try {
      final data = await box.get(id);
      if (data == null) {
        throw NoteAppException.noRecords();
      }
      return data;
    } catch (_) {
      rethrow;
    }
  }

  @override
  List<T> getAll<T>() {
    try {
      final data = box.toMap().values;
      if (data.isEmpty) {
        throw NoteAppException.noRecords();
      }

      return data.toList().cast<T>();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future delete(String id) async {
    try {
      await box.delete(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addUpdate<T>(String id, T item) async {
    try {
      await box.put(id, item);
    } catch (_) {
      rethrow;
    }
  }
}
