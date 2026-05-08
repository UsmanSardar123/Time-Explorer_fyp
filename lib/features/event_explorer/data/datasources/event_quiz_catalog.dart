import '../../domain/entities/event_quiz_question.dart';

class EventQuizCatalog {
  static List<EventQuizQuestion> forEvent(String eventId) =>
      _byEvent[eventId] ?? const [];

  static bool hasQuiz(String eventId) =>
      (_byEvent[eventId]?.isNotEmpty ?? false);

  static const Map<String, List<EventQuizQuestion>> _byEvent = {
    // --- WARS & CONFLICTS ---
    'war_001': [
      EventQuizQuestion(
        id: 'war_001_q1',
        eventId: 'war_001',
        question: 'Who did the Athenians defeat at the Battle of Marathon?',
        options: ['The Romans', 'The Persians', 'The Spartans', 'The Egyptians'],
        correctIndex: 1,
        explanation: 'In 490 BC, Athens defeated the invading Persian army of Darius I.',
      ),
    ],
    'war_010': [
      EventQuizQuestion(
        id: 'war_010_q1',
        eventId: 'war_010',
        question: 'Which event triggered the start of World War II in Europe?',
        options: [
          'The assassination of Archduke Franz Ferdinand',
          'The invasion of Poland',
          'The bombing of Pearl Harbor',
          'The Battle of Britain'
        ],
        correctIndex: 1,
        explanation: 'The German invasion of Poland on Sept 1, 1939, led Britain and France to declare war.',
      ),
    ],

    // --- REVOLUTIONS ---
    'rev_001': [
      EventQuizQuestion(
        id: 'rev_001_q1',
        eventId: 'rev_001',
        question: 'What was the primary purpose of the Magna Carta?',
        options: [
          'To grant the King absolute power',
          'To establish a democracy',
          'To limit the power of the King and establish the rule of law',
          'To declare independence from France'
        ],
        correctIndex: 2,
        explanation: 'The Magna Carta (1215) established that everyone, including the king, was subject to the law.',
      ),
    ],
    'rev_004': [
      EventQuizQuestion(
        id: 'rev_004_q1',
        eventId: 'rev_004',
        question: 'Which event is considered the start of the French Revolution?',
        options: [
          'The execution of Louis XVI',
          'The storming of the Bastille',
          'The Reign of Terror',
          'The Battle of Waterloo'
        ],
        correctIndex: 1,
        explanation: 'The storming of the Bastille prison on July 14, 1789, is the symbolic start of the revolution.',
      ),
    ],

    // --- SCIENCE ---
    'sci_001': [
      EventQuizQuestion(
        id: 'sci_001_q1',
        eventId: 'sci_001',
        question: 'What was the first major book printed using Gutenberg\'s press?',
        options: ['The Canterbury Tales', 'The Gutenberg Bible', 'The Principia', 'The Odyssey'],
        correctIndex: 1,
        explanation: 'The Gutenberg Bible (c. 1455) was the first major book printed in the West using movable type.',
      ),
    ],
    'sci_003': [
      EventQuizQuestion(
        id: 'sci_003_q1',
        eventId: 'sci_003',
        question: 'Who published the "Principia Mathematica" in 1687?',
        options: ['Albert Einstein', 'Isaac Newton', 'Galileo Galilei', 'Charles Darwin'],
        correctIndex: 1,
        explanation: 'Sir Isaac Newton formalised the laws of motion and universal gravitation in this work.',
      ),
    ],
    'sci_005': [
      EventQuizQuestion(
        id: 'sci_005_q1',
        eventId: 'sci_005',
        question: 'Which book introduced the theory of evolution by natural selection?',
        options: [
          'The Descent of Man',
          'The Voyage of the Beagle',
          'On the Origin of Species',
          'The Selfish Gene'
        ],
        correctIndex: 2,
        explanation: 'Charles Darwin published "On the Origin of Species" in 1859.',
      ),
    ],

    // --- CULTURE ---
    'cul_001': [
      EventQuizQuestion(
        id: 'cul_001_q1',
        eventId: 'cul_001',
        question: 'The Great Pyramid of Giza was built as a tomb for which Pharaoh?',
        options: ['Tutankhamun', 'Khufu', 'Ramesses II', 'Akhenaten'],
        correctIndex: 1,
        explanation: 'The Great Pyramid was built for the Pharaoh Khufu (Cheops) around 2560 BC.',
      ),
    ],
    'cul_007': [
      EventQuizQuestion(
        id: 'cul_007_q1',
        eventId: 'cul_007',
        question: 'In which city did the Renaissance begin?',
        options: ['Rome', 'Venice', 'Florence', 'Paris'],
        correctIndex: 2,
        explanation: 'The Renaissance began in Florence, Italy, in the 14th century.',
      ),
    ],
    'cul_010': [
      EventQuizQuestion(
        id: 'cul_010_q1',
        eventId: 'cul_010',
        question: 'Which invention is most closely associated with the start of the Industrial Revolution?',
        options: ['The Printing Press', 'The Steam Engine', 'The Telegraph', 'The Automobile'],
        correctIndex: 1,
        explanation: 'James Watt\'s improvements to the steam engine (1769) powered the factories of the revolution.',
      ),
    ],
  };
}
