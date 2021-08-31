import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/repositories.dart';
import '../repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(UserState());

  final UserRepository _userRepository;

  List<User> filteredList = [];

  Future<void> fetchUsers() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      final users = await _userRepository.getUsers();

      filteredList = users;

      emit(state.copyWith(users: users, status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(users: this.filteredList));
    }

    final lowCaseQuery = query.toLowerCase();

    final filteredList = state.users
        .where((user) => user.name!.toLowerCase().contains(lowCaseQuery))
        .toList();

    emit(state.copyWith(users: filteredList));
  }
}
