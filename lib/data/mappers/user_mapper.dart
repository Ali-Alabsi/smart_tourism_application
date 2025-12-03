import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/data/models/user_model.dart';

class UserMapper {
  static User toEntity(UserModel model) {
    return User(
      id: model.id,
      name: model.name,
      email: model.email,
      phoneNumber: model.phoneNumber,
    );
  }

  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
    );
  }
}