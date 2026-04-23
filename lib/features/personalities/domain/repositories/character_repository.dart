import '../entities/character.dart';
import '../entities/character_category.dart';

abstract class CharacterRepository {
  List<Character> getCharactersByCategory(CharacterCategory category);
  List<CharacterCategory> getAvailableCategories();
  Character? getCharacterById(String id);
}
