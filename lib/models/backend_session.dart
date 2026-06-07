import 'backend_user.dart';

class BackendSession {
  final String token;
  final BackendUser? user;

  const BackendSession({required this.token, this.user});

  BackendSession copyWith({String? token, BackendUser? user}) {
    return BackendSession(token: token ?? this.token, user: user ?? this.user);
  }
}
