part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String phone;
  final bool isEditing;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.phone,
    required this.isEditing,
  });

  ProfileLoaded copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isEditing,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class ProfileDeleted extends ProfileState {}
