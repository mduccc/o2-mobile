import 'package:o2_mobile/models/LoginModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  String _path = 'O2_DB.db';
  Database _database;
  Map _tableName = {'token': 'token_tbl'};

  Future openOrCreate() async {
    this._database = await openDatabase(this._path, version: 1,
        onCreate: (Database db, version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS ' +
          this._tableName['token'] +
          ' (token_id integer primary key autoincrement, token text)');
    }).whenComplete(() {
      print('DB and Table are created');
    });
  }

  /* Handler token_table*/
  Future<bool> tokenTableIsEmpty() async {
    List<Map<String, dynamic>> queryResult =
        await this._database.query(this._tableName['token']);
    return queryResult.length == 0 || queryResult == null ? true : false;
  }

  Future makeEmptyTokenTable() async {
    if (await tokenTableIsEmpty() == false)
      return await this
          ._database
          .delete(this._tableName['token'], where: null, whereArgs: null);
  }

  Future insertToken(LoginModel loginModel) async {
    if (await tokenTableIsEmpty() == false) await makeEmptyTokenTable();
    return await this._database.insert(_tableName['token'], loginModel.toMap());
  }

  Future<String> getToken() async {
    if (await tokenTableIsEmpty()) return null;
    List<Map<String, dynamic>> queryResult =
        await this._database.query(this._tableName['token']);
    String token = queryResult.first['token'];
    return token.isEmpty || token == null ? null : token;
  }
}

final databaseProvider = DatabaseProvider();
