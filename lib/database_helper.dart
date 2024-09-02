import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart'; // إذا كان الكود الرئيسي في main.dart

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'associations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE associations (
        id INTEGER PRIMARY KEY,
        name TEXT,
        members INTEGER,
        days INTEGER,
        subscriptionAmount REAL,
        startTime TEXT,
        pausedTime TEXT,
        elapsedTime TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY,
        associationId INTEGER,
        name TEXT,
        contribution REAL,
        shares TEXT,
        phoneNumber TEXT,
        FOREIGN KEY (associationId) REFERENCES associations (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE deliveryDates (
        id INTEGER PRIMARY KEY,
        associationId INTEGER,
        date TEXT,
        FOREIGN KEY (associationId) REFERENCES associations (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE withdrawnMembers (
        id INTEGER PRIMARY KEY,
        associationId INTEGER,
        name TEXT,
        contribution REAL,
        shares TEXT,
        phoneNumber TEXT,
        FOREIGN KEY (associationId) REFERENCES associations (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertAssociation(Association association) async {
    final db = await database;
    int id = await db.insert('associations', {
      'name': association.name,
      'members': association.members,
      'days': association.days,
      'subscriptionAmount': association.subscriptionAmount,
      'startTime': association.startTime?.toIso8601String(),
      'pausedTime': association.pausedTime?.toIso8601String(),
      'elapsedTime': association.elapsedTime,
    });

    for (Member member in association.memberDetails) {
      await db.insert('members', {
        'associationId': id,
        'name': member.name,
        'contribution': member.contribution,
        'shares': member.shares,
        'phoneNumber': member.phoneNumber,
      });
    }

    for (DateTime date in association.deliveryDates) {
      await db.insert('deliveryDates', {
        'associationId': id,
        'date': date.toIso8601String(),
      });
    }

    for (Member member in association.withdrawnMembers) {
      await db.insert('withdrawnMembers', {
        'associationId': id,
        'name': member.name,
        'contribution': member.contribution,
        'shares': member.shares,
        'phoneNumber': member.phoneNumber,
      });
    }

    return id;
  }

  Future<List<Association>> getAssociations() async {
    final db = await database;
    List<Map<String, dynamic>> associationsMap = await db.query('associations');
    List<Association> associations = [];

    for (Map<String, dynamic> map in associationsMap) {
      int associationId = map['id'];
      List<Member> members = await _getMembers(associationId);
      List<DateTime> deliveryDates = await _getDeliveryDates(associationId);
      List<Member> withdrawnMembers = await _getWithdrawnMembers(associationId);

      associations.add(Association(
        name: map['name'],
        members: map['members'],
        days: map['days'],
        subscriptionAmount: map['subscriptionAmount'],
        memberDetails: members,
        deliveryDates: deliveryDates,
        startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
        pausedTime: map['pausedTime'] != null ? DateTime.parse(map['pausedTime']) : null,
        elapsedTime: map['elapsedTime'],
        withdrawnMembers: withdrawnMembers,
      ));
    }

    return associations;
  }

  Future<List<Member>> _getMembers(int associationId) async {
    final db = await DatabaseHelper._instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'members',
      where: 'associationId = ?',
      whereArgs: [associationId],
    );

    return List.generate(maps.length, (i) {
      return Member.fromMap(maps[i]);
    });
  }

  Future<List<DateTime>> _getDeliveryDates(int associationId) async {
    final db = await database;
    List<Map<String, dynamic>> datesMap = await db.query('deliveryDates', where: 'associationId = ?', whereArgs: [associationId]);
    return datesMap.map((map) => DateTime.parse(map['date'])).toList();
  }

  Future<List<Member>> _getWithdrawnMembers(int associationId) async {
    final db = await DatabaseHelper._instance.database;
    final List<Map<String, dynamic>> maps = await db.query('withdrawn_members');

    return List.generate(maps.length, (i) {
      return Member.fromMap(maps[i]);
    });
  }


  Future<int> deleteAssociation(int id) async {
    final db = await database;
    return await db.delete('associations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAssociation(int id, Association association) async {
    final db = await database;

    await db.delete('members', where: 'associationId = ?', whereArgs: [id]);
    await db.delete(
        'deliveryDates', where: 'associationId = ?', whereArgs: [id]);
    await db.delete(
        'withdrawnMembers', where: 'associationId = ?', whereArgs: [id]);

    for (Member member in association.memberDetails) {
      await db.insert('members', {
        'associationId': id,
        'name': member.name,
        'contribution': member.contribution,
        'shares': member.shares,
        'phoneNumber': member.phoneNumber,
      });
    }

    for (DateTime date in association.deliveryDates) {
      await db.insert('deliveryDates', {
        'associationId': id,
        'date': date.toIso8601String(),
      });
    }

    for (Member member in association.withdrawnMembers) {
      await db.insert('withdrawnMembers', {
        'associationId': id,
        'name': member.name,
        'contribution': member.contribution,
        'shares': member.shares,
        'phoneNumber': member.phoneNumber,
      });
    }

    return await db.update('associations', {
      'name': association.name,
      'members': association.members,
      'days': association.days,
      'subscriptionAmount': association.subscriptionAmount,
      'startTime': association.startTime?.toIso8601String(),
      'pausedTime': association.pausedTime?.toIso8601String(),
      'elapsedTime': association.elapsedTime,
    }, where: 'id = ?', whereArgs: [id]);
  }}
