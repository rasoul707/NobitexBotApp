import 'dart:async';
import 'package:nobibot/models/account.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future accountsDB() async {
  return openDatabase(
    join(await getDatabasesPath(), 'accounts_db.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE accounts(id INTEGER PRIMARY KEY, label TEXT, email TEXT, password TEXT, token TEXT, device TEXT, profileName TEXT, balance DOUBLE, ratio DOUBLE, ok BOOL)',
      );
    },
    version: 2,
  );
}

Future<int> insertAccount(Account account) async {
  final db = await accountsDB();
  return await db.insert(
    'accounts',
    account.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Account>> getAccountsList() async {
  final db = await accountsDB();
  final List<Map<String, dynamic>> maps = await db.query('accounts');
  return List.generate(
    maps.length,
    (i) => Account.fromJson(maps[i]),
  );
}

Future<Account?> getAccountByID(int id) async {
  if (id <= 0) return null;
  final db = await accountsDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'accounts',
    where: 'id = ?',
    whereArgs: [id],
  );
  return maps.isEmpty ? null : Account.fromJson(maps[0]);
}

Future<dynamic> getAccountByEmail(String email) async {
  if (email.isEmpty) return null;
  final db = await accountsDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'accounts',
    where: 'email = ?',
    whereArgs: [email],
  );
  return maps.isEmpty ? null : Account.fromJson(maps[0]);
}

Future<int?> getAccountCount() async {
  final db = await accountsDB();
  return Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM accounts'),
  );
}

Future<int?> getLastAccountID() async {
  final db = await accountsDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'accounts',
    orderBy: "id DESC",
    limit: 1,
  );
  return maps.isEmpty ? null : Account.fromJson(maps[0]).id;
}

Future<void> updateAccount(Account acc) async {
  final db = await accountsDB();
  await db.update(
    'accounts',
    acc.toJson(),
    where: 'id = ?',
    whereArgs: [acc.id],
  );
}

Future<void> deleteAccount(int id) async {
  final db = await accountsDB();
  await db.delete(
    'accounts',
    where: 'id = ?',
    whereArgs: [id],
  );
}
