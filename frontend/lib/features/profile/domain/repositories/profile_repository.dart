import '../../../../core/resources/data_state.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<DataState<void>> createProfile(Profile profile);
}
