import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz.dart';

final dummyDailyQuiz = Quiz(
  id: 'daily_quiz_001',
  title: 'Great Monuments of the World',
  date: DateTime.now(),
  questions: [
    QuizQuestion(
      id: 'q1',
      question: 'In which country is the Great Pyramid of Giza located?',
      options: ['Greece', 'Egypt', 'Mexico', 'Peru'],
      correctAnswerIndex: 1,
      explanation: 'The Great Pyramid of Giza is the largest of the Egyptian pyramids and is located in Giza, Egypt.',
      type: QuestionType.mcq,
    ),
    QuizQuestion(
      id: 'q2',
      question: 'The Colosseum is located in Rome, Italy.',
      options: ['True', 'False'],
      correctAnswerIndex: 0,
      explanation: 'The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy.',
      type: QuestionType.trueFalse,
    ),
    QuizQuestion(
      id: 'q3',
      question: 'Which of these was built by Emperor Shah Jahan as a tomb for his wife?',
      options: ['Qutub Minar', 'Red Fort', 'Taj Mahal', 'Humayun\'s Tomb'],
      correctAnswerIndex: 2,
      explanation: 'The Taj Mahal was commissioned by the Mughal emperor Shah Jahan in 1632 to house the tomb of his favourite wife, Mumtaz Mahal.',
      type: QuestionType.mcq,
    ),
  ],
);
