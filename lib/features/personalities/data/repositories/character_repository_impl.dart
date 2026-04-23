import '../../domain/entities/character.dart';
import '../../domain/entities/character_category.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterLocalDataSource _dataSource;

  const CharacterRepositoryImpl(this._dataSource);

  @override
  List<Character> getCharactersByCategory(CharacterCategory category) =>
      _dataSource.getByCategory(category);

  @override
  List<CharacterCategory> getAvailableCategories() =>
      _dataSource.getAvailableCategories();

  @override
  Character? getCharacterById(String id) => _dataSource.getById(id);
}
