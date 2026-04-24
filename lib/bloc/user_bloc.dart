import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite/domain/repository/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Gagal memuat data: $e"));
      }
    });

    on<AddUserEvent>((event, emit) async {
      try {
        await repository.addUser(event.user);
        emit(UserLoading());
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Gagal menambahkan user: $e"));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      try {
        await repository.updateUser(event.user);
        emit(UserLoading());
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Gagal mengupdate user: $e"));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await repository.deleteUser(event.id);
        emit(UserLoading());
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Gagal menghapus user"));
      }
    });
  }
}
