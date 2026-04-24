import 'package:sqlite/data/models/user_model.dart';
import 'package:sqlite/domain/entities/user_entity.dart';
import 'package:sqlite/domain/repository/user_repository.dart';
import 'package:sqlite/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserRepositoryImpl extends UserRepository {
  final DatabaseHelper dbHelper;
  UserRepositoryImpl(this.dbHelper);

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((userMap) => UserModel.fromMap(userMap)).toList();
  }

  @override
  Future<void> addUser(UserEntity user) async {
    final db = await dbHelper.database;
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      noTelpon: user.noTelpon,
      alamat: user.alamat,
    );
    await db.insert(
      'users', 
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final db = await dbHelper.database;
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      noTelpon: user.noTelpon,
      alamat: user.alamat,
    );

    await db.update(
      'users',
      userModel.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
