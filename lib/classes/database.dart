import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/journal.json');
  }

  Future<String> readJournals() async {
    try {
      final file = await _localFile;

      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("error readJournal: $e");
      return "";
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;

    return file.writeAsString('$json');
  }
}

Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class Database {
  List<Journal> journal;

  Database({this.journal});

  factory Database.fromJson(Map<String, dynamic> json) => Database(
      journal:
          List<Journal>.from(json["journals"].map((x) => Journal.fromJson(x))));

  Map<String, dynamic> toJson() =>
      {"journals": List<dynamic>.from(journal.map((x) => x.toJson()))};
}

class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal({
    this.id,
    this.date,
    this.mood,
    this.note,
  });

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json["id"],
        date: json['date'],
        mood: json['mood'],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "mood": mood,
        "note": note,
      };
}

class JournalEdit {
  String action;

  Journal journal;

  JournalEdit({this.action, this.journal});
}
