import '../../domain/entities/character.dart';
import '../../domain/entities/character_category.dart';

class CharacterLocalDataSource {
  static List<Character> get allCharacters => _characters;
  static const List<Character> _characters = [

    // ── Scientists ────────────────────────────────────────────────────────────

    Character(
      id: 'einstein',
      name: 'Albert Einstein',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Einstein_1921_by_F_Schmutzer_-_restoration.jpg',
      title: 'Theoretical Physicist',
      dob: 'March 14, 1879',
      dod: 'April 18, 1955',
      description:
          'Albert Einstein revolutionized physics with his theory of relativity. He developed '
          'E=mc², reshaping our understanding of space, time, and energy. A Nobel Prize laureate '
          'in 1921, he remains the archetype of scientific genius.',
      contributions: [
        'Special Theory of Relativity (1905)',
        'General Theory of Relativity (1915)',
        'Mass-energy equivalence: E = mc²',
        'Photoelectric effect (Nobel Prize, 1921)',
        'Brownian motion explanation',
      ],
      facts: [
        'Einstein failed his first university entrance exam.',
        'He was offered the presidency of Israel in 1952 but declined.',
        'He could play the violin and loved music deeply.',
      ],
      chatPrompt: 'I believe in the beauty of simplicity and the power of imagination.',
      tone: 'Curious, warm, and full of wonder',
      communicationStyle: 'Logical but friendly, uses thought experiments and physics analogies',
      domainKnowledge: 'Special and General Relativity, E=mc², nature of time, light, and the universe',
      bio: 'A theoretical physicist who developed the theory of relativity, one of the two pillars of modern physics. Known for his mass-energy equivalence formula E=mc².',
      era: '20th Century',
      origin: 'Germany',
      specialties: ['Theoretical Physics', 'Relativity', 'Quantum Mechanics'],
      quiz: [
        QuizQuestion(
          question: "What is Einstein's most famous equation expressing mass-energy equivalence?",
          options: ["E=mc²", "F=ma", "a²+b²=c²", "V=IR"],
          correctIndex: 0,
          explanation: "E=mc² describes how energy and mass are interchangeable.",
        ),
        QuizQuestion(
          question: "For which discovery did Einstein receive the Nobel Prize in Physics?",
          options: ["Theory of General Relativity", "Photoelectric Effect", "Brownian Motion", "Wormholes"],
          correctIndex: 1,
          explanation: "He won for his discovery of the law of the photoelectric effect, not relativity.",
        ),
        QuizQuestion(
          question: "Einstein was born in which country?",
          options: ["Austria", "Germany", "United States", "Switzerland"],
          correctIndex: 1,
          explanation: "Einstein was born in Ulm, Germany, before later becoming a Swiss and US citizen.",
        ),
        QuizQuestion(
          question: "What was Einstein's 'Miracle Year'?",
          options: ["1905", "1915", "1921", "1939"],
          correctIndex: 0,
          explanation: "In 1905, he published four ground-breaking papers that revolutionized physics.",
        ),
        QuizQuestion(
          question: "Which of these did Einstein famously reject in his 'God does not play dice' quote?",
          options: ["Gravity", "Thermodynamics", "Quantum Randomness", "Electromagnetism"],
          correctIndex: 2,
          explanation: "He was uncomfortable with the probabilistic nature of quantum mechanics.",
        ),
      ],
    ),

    Character(
      id: 'newton',
      name: 'Isaac Newton',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/39/GodfreyKneller-IsaacNewton-1689.jpg',
      title: 'Natural Philosopher & Mathematician',
      dob: 'January 4, 1643',
      dod: 'March 31, 1727',
      description:
          'Sir Isaac Newton laid the foundations of classical mechanics, optics, and calculus. '
          'His laws of motion and universal gravitation unified terrestrial and celestial physics. '
          'A deeply private and meticulous man who spent decades at Cambridge.',
      contributions: [
        'Three Laws of Motion',
        'Law of Universal Gravitation',
        'Development of calculus',
        'Decomposition of white light into a spectrum',
        'Principia Mathematica (1687)',
      ],
      facts: [
        'Newton spent more time on alchemy and theology than on physics.',
        'He remained a bachelor his entire life.',
        'The apple story partially inspired his gravity thoughts.',
      ],
      chatPrompt: 'If I have seen further, it is by standing on the shoulders of Giants.',
      tone: 'Measured, formal, and meticulously precise',
      communicationStyle: 'Scholarly, reserved, and logical. Reasons from first principles and observation.',
      domainKnowledge: 'Laws of Motion, Universal Gravitation, Calculus (Fluxions), Optics, and the Principia.',
      bio: 'An English mathematician, physicist, and astronomer who is widely recognized as one of the greatest scientists in history. Formulated the laws of motion and universal gravitation.',
      era: '17th-18th Century',
      origin: 'England',
      specialties: ['Classical Mechanics', 'Calculus', 'Optics'],
      quiz: [
        QuizQuestion(
          question: "How many laws of motion did Newton formulate?",
          options: ["One", "Two", "Three", "Four"],
          correctIndex: 2,
          explanation: "Newton's three laws of motion describe the relationship between a body and the forces acting upon it.",
        ),
        QuizQuestion(
          question: "Newton co-invented which branch of mathematics with Leibniz?",
          options: ["Algebra", "Geometry", "Calculus", "Statistics"],
          correctIndex: 2,
          explanation: "Newton and Leibniz independently developed the infinitesimal calculus.",
        ),
        QuizQuestion(
          question: "According to legend, what inspired Newton's theory of gravity?",
          options: ["A falling apple", "A swinging pendulum", "The tides", "Static electricity"],
          correctIndex: 0,
          explanation: "While the 'hitting his head' part is myth, observing an apple fall inspired his thoughts on gravity.",
        ),
        QuizQuestion(
          question: "What is the name of Newton's monumental work on physics published in 1687?",
          options: ["Principia Mathematica", "On the Revolutions", "Dialogue", "The Sceptical Chymist"],
          correctIndex: 0,
          explanation: "The Philosophiæ Naturalis Principia Mathematica laid the foundations of classical mechanics.",
        ),
        QuizQuestion(
          question: "What tool did Newton invent to solve the problem of chromatic aberration in telescopes?",
          options: ["Refracting telescope", "Reflecting telescope", "Prism", "Spectroscope"],
          correctIndex: 1,
          explanation: "The Newtonian telescope uses a curved mirror rather than lenses to avoid color distortion.",
        ),
      ],
    ),

    Character(
      id: 'tesla',
      name: 'Nikola Tesla',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/N.Tesla.JPG',
      title: 'Inventor & Electrical Engineer',
      dob: 'July 10, 1856',
      dod: 'January 7, 1943',
      description:
          'Nikola Tesla was a visionary inventor whose work on alternating current (AC) electricity '
          'laid the groundwork for modern electrical grids. He held over 300 patents and envisioned '
          'wireless energy transmission decades before it became reality.',
      contributions: [
        'Alternating Current (AC) electrical system',
        'Tesla coil invention',
        'Radio transmission (disputed with Marconi)',
        'Rotating magnetic field discovery',
        'Neon and fluorescent lighting advances',
      ],
      facts: [
        'Tesla had photographic memory and could memorize entire books.',
        'He had an intense fear of round objects and pearl jewelry.',
        'He once lit 200 lamps wirelessly from 40 km away.',
      ],
      chatPrompt: 'The present is theirs; the future, for which I really worked, is mine.',
      tone: 'Visionary, intense, and slightly eccentric',
      communicationStyle: 'Idealistic and passionate. References AC power, wireless energy, and the secrets of the universe.',
      domainKnowledge: 'Alternating Current, Tesla Coils, wireless transmission, and electrical engineering.',
      bio: 'A visionary inventor and electrical engineer who pioneered alternating current (AC) and dreamed of wireless energy. His work remains the foundation of modern electrical systems.',
      era: '19th-20th Century',
      origin: 'Serbian-American',
      specialties: ['Electrical Engineering', 'AC Power', 'Wireless Transmission'],
      quiz: [
        QuizQuestion(
          question: "Which electrical system did Tesla champion over Edison's Direct Current (DC)?",
          options: ["Microwave Power", "Alternating Current (AC)", "Static Electricity", "Battery Power"],
          correctIndex: 1,
          explanation: "Tesla's AC system eventually became the global standard for power distribution.",
        ),
        QuizQuestion(
          question: "Tesla was born in which modern-day country?",
          options: ["Serbia", "Croatia", "Austria", "Hungary"],
          correctIndex: 1,
          explanation: "He was born in Smiljan, which is in modern-day Croatia, but considered himself a Serb of the Austro-Hungarian Empire.",
        ),
        QuizQuestion(
          question: "What was the name of the high-frequency transformer invented by Tesla?",
          options: ["Tesla Coil", "Faraday cage", "Voltaic pile", "Edison bulb"],
          correctIndex: 0,
          explanation: "The Tesla Coil is used to produce high-voltage, low-current, high-frequency alternating-current electricity.",
        ),
        QuizQuestion(
          question: "Which of these did Tesla NOT actually invent or predict?",
          options: ["The Radio", "Remote Control", "Smartphone technology", "The Steam Engine"],
          correctIndex: 3,
          explanation: "The steam engine was developed long before Tesla, primarily by James Watt and others.",
        ),
        QuizQuestion(
          question: "Tesla's laboratory at Wardenclyffe was intended for what main purpose?",
          options: ["Weapon testing", "Wireless power transmission", "Gold mining", "Time travel"],
          correctIndex: 1,
          explanation: "Tesla envisioned the Wardenclyffe Tower as a system for worldwide wireless communication and energy.",
        ),
      ],
    ),

    Character(
      id: 'galileo',
      name: 'Galileo Galilei',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Justus_Sustermans_-_Portrait_of_Galileo_Galilei%2C_1636.jpg',
      title: 'Astronomer & Physicist',
      dob: 'February 15, 1564',
      dod: 'January 8, 1642',
      description:
          'Galileo Galilei pioneered the use of the telescope for astronomy and championed the '
          'heliocentric model of the solar system. His empirical approach laid the foundation '
          'of modern science, leading to direct conflict with the Roman Catholic Church.',
      contributions: [
        'Improvement of the telescope for astronomy',
        'Discovery of Jupiter\'s four largest moons',
        'Support for Copernican heliocentrism',
        'Laws of falling bodies',
        'Foundations of kinematics',
      ],
      facts: [
        'Galileo was placed under house arrest by the Inquisition.',
        'He dropped objects from the Leaning Tower of Pisa to test gravity.',
        '"And yet it moves" — his reported words after recanting heliocentrism.',
      ],
      chatPrompt: 'And yet it moves.',
      tone: 'Inquisitive, bold, and scientifically courageous',
      communicationStyle: 'Empirical and methodical. Defends observation over doctrine and references his telescope and the stars.',
      domainKnowledge: 'Astronomy, heliocentrism, Jupiter\'s moons, laws of falling bodies, and kinematics.',
      bio: 'An Italian astronomer, physicist and engineer who has been called the "father of observational astronomy" and the "father of modern physics".',
      era: '16th-17th Century',
      origin: 'Italy',
      specialties: ['Astronomy', 'Physics', 'Kinematics'],
      quiz: [
        QuizQuestion(
          question: "Which planet's moons did Galileo discover?",
          options: ["Mars", "Saturn", "Jupiter", "Venus"],
          correctIndex: 2,
          explanation: "He discovered the four largest moons of Jupiter: Io, Europa, Ganymede, and Callisto.",
        ),
        QuizQuestion(
          question: "What instrument did Galileo significantly improve for astronomical use?",
          options: ["Microscope", "Telescope", "Sextant", "Astrolabe"],
          correctIndex: 1,
          explanation: "Galileo improved the telescope, allowing him to observe the heavens in unprecedented detail.",
        ),
      ],
    ),

    Character(
      id: 'curie',
      name: 'Marie Curie',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7e/Marie_Curie_c1920.jpg',
      title: 'Physicist & Chemist',
      dob: 'November 7, 1867',
      dod: 'July 4, 1934',
      description:
          'Marie Curie was a Polish-French physicist and chemist who conducted pioneering '
          'research on radioactivity. She was the first woman to win a Nobel Prize and the only '
          'person to win Nobel Prizes in two different sciences — Physics and Chemistry.',
      contributions: [
        'Discovery of polonium and radium',
        'Nobel Prize in Physics (1903)',
        'Nobel Prize in Chemistry (1911)',
        'First woman professor at the University of Paris',
        'Development of mobile X-ray units in WWI',
      ],
      facts: [
        'Her notebooks are still radioactive and stored in lead-lined boxes.',
        'She was denied entry to the French Academy of Sciences due to her gender.',
        'She died from aplastic anaemia caused by radiation exposure.',
      ],
      chatPrompt: 'Nothing in life is to be feared, it is only to be understood.',
      tone: 'Quietly determined, disciplined, and pioneering',
      communicationStyle: 'Scientifically precise and focused. Speaks of radioactivity, Radium, and the pursuit of knowledge despite obstacles.',
      domainKnowledge: 'Radioactivity, Polonium, Radium, X-ray development, and Physics/Chemistry research.',
      bio: 'A Polish and naturalized-French physicist and chemist who conducted pioneering research on radioactivity. She was the first woman to win a Nobel Prize.',
      era: '19th-20th Century',
      origin: 'Poland / France',
      specialties: ['Physics', 'Chemistry', 'Radioactivity'],
      quiz: [
        QuizQuestion(
          question: "In which two scientific fields did Marie Curie win Nobel Prizes?",
          options: ["Physics and Biology", "Chemistry and Medicine", "Physics and Chemistry", "Chemistry and Peace"],
          correctIndex: 2,
          explanation: "She is the only person to win Nobel Prizes in two different scientific fields: Physics and Chemistry.",
        ),
        QuizQuestion(
          question: "Which radioactive element did Marie Curie discover and name after her home country?",
          options: ["Radium", "Polonium", "Uranium", "Thorium"],
          correctIndex: 1,
          explanation: "She named Polonium after her native land, Poland.",
        ),
      ],
    ),

    // ── Philosophers ──────────────────────────────────────────────────────────

    Character(
      id: 'socrates',
      name: 'Socrates',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Socrates_Louvre.jpg',
      title: 'Father of Western Philosophy',
      dob: '470 BC',
      dod: '399 BC',
      description:
          'Socrates is regarded as one of the founders of Western philosophy. His ideas survive '
          'through Plato\'s dialogues. He pioneered the Socratic method, believing self-knowledge '
          'was the highest wisdom. He was sentenced to death by Athens.',
      contributions: [
        'The Socratic Method (dialectical inquiry)',
        'Foundation of Western ethical philosophy',
        '"The unexamined life is not worth living"',
        'Influence on Plato and all of Western thought',
      ],
      facts: [
        'He chose death by hemlock over exile.',
        'He served as a hoplite soldier in three campaigns.',
        'He never wrote anything — all we know comes from Plato.',
      ],
      chatPrompt:
          'You are Socrates, ancient Athenian philosopher. Speak through questions rather than '
          'declarations — wisdom begins by admitting what you do not know. Use the Socratic method: '
          'probe assumptions and guide the questioner to their own insight. Keep replies 2-6 '
          'sentences. Stay in character as a 5th-century BC Athenian.',
      bio: 'A classical Greek philosopher credited as one of the founders of Western philosophy. Known for his method of inquiry and for valuing the "examined life" over life itself.',
      era: '5th Century BC',
      origin: 'Ancient Greece',
      specialties: ['Ethics', 'Epistemology', 'Socratic Method'],
      quiz: [
        QuizQuestion(
          question: "How did Socrates record his philosophical teachings?",
          options: ["In scrolls", "In books", "He didn't write anything", "On clay tablets"],
          correctIndex: 2,
          explanation: "Socrates left no writings; we know of him primarily through the dialogues of his student, Plato.",
        ),
        QuizQuestion(
          question: "What was the 'Socratic Method' primarily based on?",
          options: ["Lecturing", "Question and Answer", "Meditation", "Scientific experiments"],
          correctIndex: 1,
          explanation: "It involves a cooperative argumentative dialogue to stimulate critical thinking and illuminate ideas.",
        ),
        QuizQuestion(
          question: "What did Socrates famously claim about his own knowledge?",
          options: ["He knew everything", "He knew nothing", "Knowledge is an illusion", "Science is the only truth"],
          correctIndex: 1,
          explanation: "His claim 'I know that I know nothing' is a cornerstone of intellectual humility.",
        ),
        QuizQuestion(
          question: "Socrates was sentenced to death by drinking which poison?",
          options: ["Arsenic", "Cyanide", "Hemlock", "Belladonna"],
          correctIndex: 2,
          explanation: "He was convicted of corrupting the youth and impiety, and chose to drink hemlock.",
        ),
        QuizQuestion(
          question: "Who was Socrates' most famous student?",
          options: ["Aristotle", "Plato", "Alexander the Great", "Xenophon"],
          correctIndex: 1,
          explanation: "Plato was his most prominent student and recorded his dialogues.",
        ),
      ],
    ),

    Character(
      id: 'aristotle',
      name: 'Aristotle',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/ae/Aristotle_Altemps_Inv8575.jpg',
      title: 'Philosopher & Polymath',
      dob: '384 BC',
      dod: '322 BC',
      description:
          'Aristotle was a student of Plato and tutor to Alexander the Great. He wrote on '
          'virtually every subject — physics, biology, ethics, politics, and logic. His systematic '
          'approach made him the dominant intellectual authority for nearly two millennia.',
      contributions: [
        'Formal logic (syllogism)',
        'Classification of living organisms',
        'Nicomachean Ethics and virtue ethics',
        'Poetics and political theory',
      ],
      facts: [
        'Aristotle tutored Alexander the Great from age 13.',
        'He classified over 500 animal species.',
        'He believed the heart, not the brain, was the center of intelligence.',
      ],
      chatPrompt:
          'You are Aristotle, ancient Athenian philosopher and polymath. Speak with systematic '
          'clarity and authority. Categorize ideas, reason from observation, and reference ethics, '
          'logic, and natural philosophy. Be the methodical teacher. Keep replies 2-6 sentences. '
          'Stay in character as a 4th-century BC scholar.',
      bio: 'A student of Plato and tutor to Alexander the Great. He wrote on subjects ranging from biology and physics to ethics and politics, establishing the framework for Western science.',
      era: '4th Century BC',
      origin: 'Ancient Greece',
      specialties: ['Biology', 'Logic', 'Ethics'],
      quiz: [
        QuizQuestion(
          question: "Who was Aristotle's most famous pupil?",
          options: ["Plato", "Socrates", "Alexander the Great", "Julius Caesar"],
          correctIndex: 2,
          explanation: "Aristotle tutored Alexander the Great from the age of 13.",
        ),
        QuizQuestion(
          question: "Aristotle is often credited with founding which branch of science?",
          options: ["Chemistry", "Biology", "Quantum Physics", "Computer Science"],
          correctIndex: 1,
          explanation: "He was one of the first to classify and study living organisms systematically.",
        ),
        QuizQuestion(
          question: "What is the name of Aristotle's school in Athens?",
          options: ["The Academy", "The Lyceum", "The Stoa", "The Porch"],
          correctIndex: 1,
          explanation: "Plato founded the Academy, while Aristotle founded the Lyceum.",
        ),
        QuizQuestion(
          question: "In ethics, Aristotle emphasized which concept of virtue?",
          options: ["The Golden Mean", "Absolute Duty", "Utilitarianism", "Nihilism"],
          correctIndex: 0,
          explanation: "The Golden Mean is the desirable middle ground between two extremes.",
        ),
        QuizQuestion(
          question: "Aristotle believed that which organ was the center of intelligence?",
          options: ["The Brain", "The Lungs", "The Heart", "The Stomach"],
          correctIndex: 2,
          explanation: "He incorrectly believed the heart was the seat of the soul and intelligence.",
        ),
      ],
    ),

    Character(
      id: 'plato',
      name: 'Plato',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/88/Plato_Silanion_Musei_Capitolini_MC1377.jpg',
      title: 'Philosopher & Founder of the Academy',
      dob: '428 BC',
      dod: '348 BC',
      description:
          'Plato was an ancient Athenian philosopher and student of Socrates. He founded the '
          'Academy in Athens, one of the earliest institutions of higher learning. His theory '
          'of Forms shaped Western philosophy for over two millennia.',
      contributions: [
        'Theory of Forms (ideal reality)',
        'The Republic — theory of the ideal state',
        'Allegory of the Cave',
        'Founding the Academy in Athens',
      ],
      facts: [
        '"Plato" was a nickname meaning "broad-shouldered."',
        'He was a gifted wrestler in his youth.',
        'He travelled to Sicily three times, twice under duress.',
      ],
      chatPrompt:
          'You are Plato, ancient Athenian philosopher and student of Socrates. Speak through '
          'dialogue, reason, and the theory of ideal Forms. Reference the Republic and the allegory '
          'of the cave. Be calm and intellectually probing. Keep replies 2-6 sentences. Stay in '
          'character as a 4th-century BC Athenian philosopher.',
      bio: 'An ancient Athenian philosopher and student of Socrates. He founded the Academy and developed the Theory of Forms, which argues that the physical world is just a shadow of a higher, ideal reality.',
      era: '5th-4th Century BC',
      origin: 'Ancient Greece',
      specialties: ['Metaphysics', 'Political Philosophy', 'Education'],
      quiz: [
        QuizQuestion(
          question: "What is the name of Plato's most famous work on the ideal state?",
          options: ["The Laws", "The Republic", "The Apology", "The Symposium"],
          correctIndex: 1,
          explanation: "In 'The Republic', Plato describes his vision of a just city-state ruled by philosopher-kings.",
        ),
        QuizQuestion(
          question: "Plato founded which famous institution of learning in Athens?",
          options: ["The Lyceum", "The Stoa", "The Academy", "The Library"],
          correctIndex: 2,
          explanation: "The Academy is considered one of the earliest institutions of higher learning in the Western world.",
        ),
        QuizQuestion(
          question: "Which allegory did Plato use to describe the importance of education and true knowledge?",
          options: ["The Allegory of the Sun", "The Allegory of the Cave", "The Allegory of the Chariot", "The Allegory of the Ring"],
          correctIndex: 1,
          explanation: "The Allegory of the Cave illustrates how humans can mistake shadows for reality.",
        ),
        QuizQuestion(
          question: "In Plato's Theory of Forms, what are 'Forms'?",
          options: ["Geometric shapes", "Ideal, perfect realities", "Social classes", "Physical objects"],
          correctIndex: 1,
          explanation: "Forms are non-physical, eternal, and perfect essences of all things.",
        ),
        QuizQuestion(
          question: "Who was Plato's teacher?",
          options: ["Aristotle", "Socrates", "Epicurus", "Zeno"],
          correctIndex: 1,
          explanation: "Plato was the most famous student of Socrates.",
        ),
      ],
    ),

    Character(
      id: 'nietzsche',
      name: 'Friedrich Nietzsche',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Nietzsche187a.jpg',
      title: 'Philosopher & Cultural Critic',
      dob: 'October 15, 1844',
      dod: 'August 25, 1900',
      description:
          'Friedrich Nietzsche was a 19th-century German philosopher whose provocative ideas '
          'challenged morality, religion, and culture. Famous for "God is dead," he introduced '
          'the Übermensch, will to power, and eternal recurrence.',
      contributions: [
        'Concept of the Übermensch (Overman)',
        'Will to Power as a fundamental drive',
        'Critique of conventional morality',
        'Thus Spoke Zarathustra (1883-1885)',
      ],
      facts: [
        'He collapsed in Turin in 1889 and never recovered his sanity.',
        'He was a gifted musician and composed several pieces.',
        'His sister distorted his works to align with nationalism.',
      ],
      chatPrompt:
          'You are Friedrich Nietzsche, 19th-century German philosopher. Speak with aphoristic '
          'brilliance and passionate intensity. Challenge assumptions, question morality, and '
          'push beyond mediocrity. Reference the Ubermensch, eternal recurrence, and will to power. '
          'Keep replies 2-6 sentences. Stay in character.',
      bio: 'A 19th-century German philosopher whose work challenged the foundations of traditional morality and religion. He famously declared "God is dead" and introduced the concept of the Übermensch.',
      era: '19th Century',
      origin: 'Germany',
      specialties: ['Existentialism', 'Cultural Criticism', 'Nihilism'],
      quiz: [
        QuizQuestion(
          question: "Nietzsche famously declared the death of what?",
          options: ["Science", "Philosophy", "God", "The State"],
          correctIndex: 2,
          explanation: "He claimed 'God is dead' to signify the loss of a shared moral and spiritual foundation in the modern world.",
        ),
        QuizQuestion(
          question: "What is the name of Nietzsche's proposed ideal individual who creates their own values?",
          options: ["The Superman", "The Übermensch", "The Philosopher-King", "The Wise Man"],
          correctIndex: 1,
          explanation: "The Übermensch (Overman/Superman) is one who transcends conventional morality to achieve greatness.",
        ),
        QuizQuestion(
          question: "Nietzsche's 'Will to Power' describes what?",
          options: ["A desire for political office", "The fundamental drive of all living things", "A military strategy", "A psychological disorder"],
          correctIndex: 1,
          explanation: "He saw the 'Will to Power' as the basic force that drives life toward growth and mastery.",
        ),
        QuizQuestion(
          question: "Which work is considered one of Nietzsche's most famous and begins with the character descending from a mountain?",
          options: ["Beyond Good and Evil", "The Birth of Tragedy", "Thus Spoke Zarathustra", "The Antichrist"],
          correctIndex: 2,
          explanation: "Thus Spoke Zarathustra is a philosophical novel containing many of his key ideas.",
        ),
        QuizQuestion(
          question: "What concept describes the idea that the universe and all its events will occur again and again infinitely?",
          options: ["Eternal Recurrence", "Reincarnation", "Cyclic History", "Infinite Jest"],
          correctIndex: 0,
          explanation: "Eternal Recurrence is the hypothetical possibility that one's life will repeat exactly as it has been.",
        ),
      ],
    ),

    Character(
      id: 'confucius',
      name: 'Confucius',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4f/Confucius_Tang_Dynasty.jpg',
      title: 'Philosopher & Teacher',
      dob: '551 BC',
      dod: '479 BC',
      description:
          'Confucius was an ancient Chinese philosopher whose teachings on virtue, social harmony, '
          'and proper conduct shaped East Asian culture for over two thousand years. His ideas are '
          'preserved in the Analects, recorded by his disciples.',
      contributions: [
        'Confucianism — ethical and social philosophy',
        'The Analects (recorded by disciples)',
        'Concept of ren (benevolence) and li (ritual propriety)',
        'Five Relationships and social harmony',
      ],
      facts: [
        'Confucius had around 3,000 students over his lifetime.',
        'He spent years wandering China seeking a ruler to implement his ideas.',
        'He emphasized education as the path to moral improvement.',
      ],
      chatPrompt:
          'You are Confucius, ancient Chinese philosopher and teacher. Speak with gentle wisdom '
          'about virtue, proper conduct, and social harmony. Reference the Analects, ritual '
          'propriety, and the importance of self-cultivation. Be measured and warm. Keep replies '
          '2-6 sentences. Stay in character as a 6th-century BC teacher.',
      bio: 'An ancient Chinese philosopher whose teachings on ethics, social harmony, and filial piety became the foundation of East Asian culture. He emphasized the importance of family and education.',
      era: '6th-5th Century BC',
      origin: 'China',
      specialties: ['Ethics', 'Social Philosophy', 'Education'],
      quiz: [
        QuizQuestion(
          question: "Which collection contains the teachings and sayings of Confucius?",
          options: ["The Tao Te Ching", "The Analects", "The Art of War", "The Book of Changes"],
          correctIndex: 1,
          explanation: "The Analects (Lunyu) is the most important record of Confucius' teachings, compiled by his disciples.",
        ),
        QuizQuestion(
          question: "Confucius believed that social harmony depends on what?",
          options: ["Military power", "Proper relationships and conduct", "Scientific discovery", "Individual freedom"],
          correctIndex: 1,
          explanation: "He emphasized the 'Five Relationships' and the importance of ritual and virtue in society.",
        ),
        QuizQuestion(
          question: "What is the term for the respect and care for one's parents and ancestors in Confucianism?",
          options: ["Nirvana", "Karma", "Filial Piety", "Bushido"],
          correctIndex: 2,
          explanation: "Filial piety (xiao) is a central virtue in Confucian ethics.",
        ),
        QuizQuestion(
          question: "Confucius served as a government official in which ancient Chinese state?",
          options: ["Qin", "Han", "Lu", "Wei"],
          correctIndex: 2,
          explanation: "He was born and served in the State of Lu.",
        ),
        QuizQuestion(
          question: "Which of these is NOT one of the 'Five Constant Virtues' of Confucianism?",
          options: ["Benevolence (Ren)", "Righteousness (Yi)", "Bravery (Yong)", "Wisdom (Zhi)"],
          correctIndex: 2,
          explanation: "While bravery is valued, the five constants are Ren, Yi, Li, Zhi, and Xin (Integrity).",
        ),
      ],
    ),

    // ── Emperors ──────────────────────────────────────────────────────────────

    Character(
      id: 'caesar',
      name: 'Julius Caesar',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/Gaius_Iulius_Caesar_%28100-44_BC%29.jpg',
      title: 'Roman General & Statesman',
      dob: 'July 13, 100 BC',
      dod: 'March 15, 44 BC',
      description:
          'Julius Caesar was a Roman general and statesman who transformed the Roman Republic. '
          'His military campaigns conquered Gaul and sparked civil war. He was assassinated on '
          'the Ides of March by senators fearing his power.',
      contributions: [
        'Conquest of Gaul (58-50 BC)',
        'Crossing the Rubicon and civil war victory',
        'Julian Calendar reform',
        'Consolidation of Roman power',
      ],
      facts: [
        'Caesar was kidnapped by pirates and later had them crucified.',
        '"Veni, vidi, vici" — I came, I saw, I conquered.',
        'He was stabbed 23 times on the Ides of March, 44 BC.',
      ],
      chatPrompt: 'Veni, vidi, vici.',
      tone: 'Strategic, authoritative, and decisive',
      communicationStyle: 'Commanding and clinical. Speaks of conquest, Roman order, and political strategy.',
      domainKnowledge: 'Gallic Wars, Rubicon, Civil War, Roman Republic, and Julian Calendar.',
      bio: 'A Roman general and statesman who transformed the Roman Republic into the Roman Empire. He played a critical role in the events that led to the demise of the Republic and sparked a civil war.',
      era: '1st Century BC',
      origin: 'Rome',
      specialties: ['Military Strategy', 'Political Reform', 'Oratory'],
      quiz: [
        QuizQuestion(
          question: "What famous phrase did Caesar utter after a quick victory in Pontus?",
          options: ["Alea iacta est", "Veni, vidi, vici", "Et tu, Brute?", "Carpe Diem"],
          correctIndex: 1,
          explanation: "'Veni, vidi, vici' (I came, I saw, I conquered) describes his swift victory over Pharnaces II.",
        ),
        QuizQuestion(
          question: "Which river did Caesar cross in 49 BC, signifying an act of war against Rome?",
          options: ["The Tiber", "The Rubicon", "The Seine", "The Nile"],
          correctIndex: 1,
          explanation: "Crossing the Rubicon was a point of no return that started the Great Roman Civil War.",
        ),
        QuizQuestion(
          question: "What calendar reform did Caesar introduce in 46 BC?",
          options: ["Gregorian", "Lunar", "Julian", "Solar"],
          correctIndex: 2,
          explanation: "The Julian calendar replaced the Roman calendar and influenced the one we use today.",
        ),
        QuizQuestion(
          question: "On what day was Julius Caesar assassinated?",
          options: ["The Ides of March", "New Year's Eve", "The Calends of June", "Winter Solstice"],
          correctIndex: 0,
          explanation: "He was killed on March 15 (The Ides of March), 44 BC.",
        ),
        QuizQuestion(
          question: "Caesar famously had a relationship and political alliance with which Egyptian queen?",
          options: ["Nefertiti", "Cleopatra", "Hatshepsut", "Isis"],
          correctIndex: 1,
          explanation: "His alliance with Cleopatra VII was both personal and strategic for Rome's eastern interests.",
        ),
      ],
    ),

    Character(
      id: 'alexander',
      name: 'Alexander the Great',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/40/Alexander_the_Great_mosaic.jpg',
      title: 'King of Macedon & Conqueror',
      dob: 'July 20, 356 BC',
      dod: 'June 11, 323 BC',
      description:
          'Alexander the Great was a Macedonian king who created one of the largest empires in '
          'ancient history. Undefeated in battle and tutored by Aristotle, he spread Greek culture '
          'across Asia from Greece to northwestern India.',
      contributions: [
        'Conquest of the Persian Empire',
        'Spread of Hellenism across Asia',
        'Founding of Alexandria, Egypt',
        'Unification of Greece under Macedon',
      ],
      facts: [
        'Alexander never lost a battle in 13 years of conquest.',
        'He was tutored by Aristotle from age 13.',
        'He named over 70 cities after himself.',
      ],
      chatPrompt:
          'You are Alexander the Great, Macedonian king and the greatest conqueror of antiquity. '
          'Speak with bold ambition, warrior courage, and imperial vision. Reference your campaigns '
          'from Greece to Persia to India and your admiration for Achilles. Be passionate and '
          'commanding. Keep replies 2-6 sentences. Stay in character.',
      bio: 'A king of the ancient Greek kingdom of Macedon who created one of the largest empires in history, stretching from Greece to northwestern India. He remained undefeated in battle.',
      era: '4th Century BC',
      origin: 'Macedon (Ancient Greece)',
      specialties: ['Military Conquest', 'Statecraft', 'Hellenistic Culture'],
      quiz: [
        QuizQuestion(
          question: "Who was Alexander the Great's famous philosopher-tutor?",
          options: ["Socrates", "Plato", "Aristotle", "Diogenes"],
          correctIndex: 2,
          explanation: "Aristotle was hired by King Philip II to tutor the young Alexander.",
        ),
        QuizQuestion(
          question: "Alexander untied which legendary knot, prophesied to belong to the future king of Asia?",
          options: ["The Gordian Knot", "The Herculean Knot", "The Zeus Knot", "The Royal Knot"],
          correctIndex: 0,
          explanation: "Legend says he either cut it with his sword or pulled out the linchpin.",
        ),
        QuizQuestion(
          question: "What was the name of Alexander's beloved horse, which he named a city after?",
          options: ["Pegasus", "Bucephalus", "Incitatus", "Black Beauty"],
          correctIndex: 1,
          explanation: "Bucephalus was his companion throughout his campaigns until the horse's death in India.",
        ),
        QuizQuestion(
          question: "Alexander's empire stretched from Greece as far east as which modern-day country?",
          options: ["China", "India", "Russia", "Italy"],
          correctIndex: 1,
          explanation: "His campaigns reached the Punjab region of modern-day India and Pakistan.",
        ),
        QuizQuestion(
          question: "Which Egyptian city was founded by Alexander and became a center of learning?",
          options: ["Cairo", "Thebes", "Alexandria", "Luxor"],
          correctIndex: 2,
          explanation: "Alexandria in Egypt was the most famous of several cities he founded and named after himself.",
        ),
      ],
    ),

    Character(
      id: 'napoleon',
      name: 'Napoleon Bonaparte',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/50/Jacques-Louis_David_-_Napoleon_Crossing_the_Alps_-_Kunsthistorisches_Museum.jpg',
      title: 'Emperor of the French',
      dob: 'August 15, 1769',
      dod: 'May 5, 1821',
      description:
          'Napoleon Bonaparte was a French military commander who rose through the Revolution '
          'to become Emperor of France. He dominated European politics for over a decade through '
          'brilliant military campaigns before his defeat and exile.',
      contributions: [
        'Napoleonic Code — foundation of modern civil law',
        'Reorganisation of France\'s education and legal systems',
        'Military campaigns across Europe',
        'Spread of Revolutionary ideals',
      ],
      facts: [
        'Napoleon was of average height for his era — about 5\'7".',
        'He established the Baccalaureate exam system still used in France.',
        'He was exiled twice — to Elba, then to Saint Helena.',
      ],
      chatPrompt: 'My ambition is to leave a legacy of law and glory for France.',
      tone: 'Authoritative, strategic, and commanding',
      communicationStyle: 'Decisive, visionary, and sharp. Speaks with the weight of an emperor.',
      domainKnowledge: 'Tactical maneuvers, the Napoleonic Code, French Empire history, and European conquest.',
      bio: 'A French military commander and political leader who rose to prominence during the French Revolution and led several successful campaigns during the Revolutionary Wars. As Napoleon I, he was Emperor of the French.',
      era: '18th-19th Century',
      origin: 'France (Corsica)',
      specialties: ['Military Tactics', 'Civil Law', 'Political Reform'],
      quiz: [
        QuizQuestion(
          question: "What is the name of the comprehensive set of laws developed by Napoleon that still influences civil law today?",
          options: ["The Napoleonic Code", "The French Constitution", "The Law of Kings", "The Magna Carta"],
          correctIndex: 0,
          explanation: "The Napoleonic Code (Code Civil) prohibited privileges based on birth and allowed freedom of religion.",
        ),
        QuizQuestion(
          question: "Napoleon was famously defeated for the final time at which battle?",
          options: ["Battle of Austerlitz", "Battle of Trafalgar", "Battle of Waterloo", "Battle of Leipzig"],
          correctIndex: 2,
          explanation: "The Battle of Waterloo in 1815 ended his rule as Emperor of the French.",
        ),
        QuizQuestion(
          question: "Napoleon was born on which Mediterranean island?",
          options: ["Sardinia", "Malta", "Corsica", "Elba"],
          correctIndex: 2,
          explanation: "He was born in Ajaccio, Corsica, just after the island was ceded to France.",
        ),
        QuizQuestion(
          question: "To which island in the South Atlantic was Napoleon exiled after his final defeat?",
          options: ["Elba", "Saint Helena", "Madeira", "The Canary Islands"],
          correctIndex: 1,
          explanation: "He spent the last years of his life in exile on the remote island of Saint Helena.",
        ),
        QuizQuestion(
          question: "What was Napoleon's rank in the French military before he became First Consul?",
          options: ["General", "Colonel", "Captain", "Lieutenant"],
          correctIndex: 0,
          explanation: "He rose rapidly through the ranks, becoming a general at age 24.",
        ),
      ],
    ),

    Character(
      id: 'marcus_aurelius',
      name: 'Marcus Aurelius',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/ec/MSR-ra-1-1-150dpi.jpg',
      title: 'Roman Emperor & Stoic Philosopher',
      dob: 'April 26, 121 AD',
      dod: 'March 17, 180 AD',
      description:
          'Marcus Aurelius was Roman Emperor from 161 to 180 AD and a central Stoic philosopher. '
          'His private journal, the Meditations, remains one of the greatest philosophical works. '
          'He ruled wisely during plagues and wars, embodying the philosopher-king ideal.',
      contributions: [
        'The Meditations — Stoic philosophical journal',
        'Stable governance during the Antonine Plague',
        'Defense of northern frontiers',
        'Model of philosopher-king leadership',
      ],
      facts: [
        'He wrote his Meditations in Greek, not Latin.',
        'He ruled during one of Rome\'s most severe plagues.',
        'He is called the last of the "Five Good Emperors."',
      ],
      chatPrompt: 'Waste no more time arguing what a good man should be. Be one.',
      tone: 'Calm, principled, and deeply reflective',
      communicationStyle: 'Stoic and measured. Speaks of duty, self-discipline, and the transitory nature of existence.',
      domainKnowledge: 'The Meditations, Stoic principles, Roman leadership, and the philosopher-king ideal.',
      bio: 'A Roman Emperor and Stoic philosopher. Best known for his private journal "Meditations," which outlines his philosophical reflections on duty, mortality, and virtue.',
      era: '2nd Century AD',
      origin: 'Rome',
      specialties: ['Stoicism', 'Philosophy', 'Imperial Governance'],
      quiz: [
        QuizQuestion(
          question: "What is the name of the collection of personal writings by Marcus Aurelius?",
          options: ["The Republic", "The Meditations", "Letters from a Stoic", "The Enchiridion"],
          correctIndex: 1,
          explanation: "The Meditations is a series of personal reflections and notes on Stoic philosophy.",
        ),
        QuizQuestion(
          question: "Marcus Aurelius is considered the last of which group of emperors?",
          options: ["The Flavian Dynasty", "The Five Good Emperors", "The Julio-Claudians", "The Severans"],
          correctIndex: 1,
          explanation: "He was the last of the rulers known as the 'Five Good Emperors' who presided over a period of relative peace.",
        ),
        QuizQuestion(
          question: "Which school of philosophy did Marcus Aurelius follow and contribute to?",
          options: ["Epicureanism", "Stoicism", "Skepticism", "Cynicism"],
          correctIndex: 1,
          explanation: "He is one of the most famous proponents of Stoic philosophy.",
        ),
        QuizQuestion(
          question: "Much of Marcus Aurelius's reign was spent defending the empire's borders against which groups?",
          options: ["Persians", "Germanic tribes", "Carthaginians", "Greeks"],
          correctIndex: 1,
          explanation: "He spent a significant portion of his reign on military campaigns against the Marcomanni and other tribes.",
        ),
        QuizQuestion(
          question: "In his writings, Marcus Aurelius often emphasizes the importance of living in accordance with what?",
          options: ["Pure emotion", "Nature and reason", "Wealth and power", "Fate alone"],
          correctIndex: 1,
          explanation: "Stoicism emphasizes living in harmony with the natural order of the universe through reason.",
        ),
      ],
    ),

    Character(
      id: 'genghis',
      name: 'Genghis Khan',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/YuanEmperorAlbumGenghisPortrait.jpg',
      title: 'Founder of the Mongol Empire',
      dob: 'c. 1162',
      dod: 'August 18, 1227',
      description:
          'Genghis Khan united the Mongol tribes and founded the largest contiguous land empire '
          'in history. His campaigns swept across Asia into Europe, reshaping trade routes, '
          'politics, and populations across the known world.',
      contributions: [
        'Unification of Mongol tribes (1206)',
        'Largest contiguous land empire in history',
        'Silk Road safety and trade expansion',
        'Religious tolerance across the empire',
      ],
      facts: [
        'Genghis Khan means "universal ruler."',
        'His empire covered 24 million square kilometres.',
        'He established one of the world\'s first international postal systems.',
      ],
      chatPrompt:
          'You are Genghis Khan, founder and ruler of the Mongol Empire. Speak with raw authority, '
          'warrior pragmatism, and strategic cunning. Reference unifying the tribes, your conquests, '
          'and your code of law. Value loyalty, strength, and adaptability above all. Keep replies '
          '2-6 sentences. Stay in character.',
      bio: 'The founder and first Great Khan of the Mongol Empire, which became the largest contiguous empire in history after his death. He came to power by uniting many of the nomadic tribes of Northeast Asia.',
      era: '12th-13th Century',
      origin: 'Mongolia',
      specialties: ['Empire Building', 'Military Strategy', 'Trade & Diplomacy'],
      quiz: [
        QuizQuestion(
          question: "Genghis Khan founded which massive empire?",
          options: ["The Roman Empire", "The Mongol Empire", "The Ottoman Empire", "The Persian Empire"],
          correctIndex: 1,
          explanation: "He united nomadic tribes to form the Mongol Empire, the largest contiguous land empire in history.",
        ),
        QuizQuestion(
          question: "What was Genghis Khan's birth name?",
          options: ["Kublai", "Temujin", "Batu", "Ogedei"],
          correctIndex: 1,
          explanation: "He was born Temujin before taking the title 'Genghis Khan' (Universal Ruler).",
        ),
        QuizQuestion(
          question: "Genghis Khan's empire significantly improved safety and trade along which famous route?",
          options: ["The Spice Route", "The Silk Road", "The Amber Road", "The Northwest Passage"],
          correctIndex: 1,
          explanation: "Under the 'Pax Mongolica,' trade flourished along the Silk Road connecting East and West.",
        ),
        QuizQuestion(
          question: "What was the name of the law code established by Genghis Khan?",
          options: ["The Magna Carta", "The Yassa", "The Justinian Code", "The Hammurabi Code"],
          correctIndex: 1,
          explanation: "The Yassa was the secret code of laws he established to govern the Mongol Empire.",
        ),
        QuizQuestion(
          question: "What innovative communication system did Genghis Khan establish across his empire?",
          options: ["Optical telegraph", "The Yam (Postal system)", "Smoke signals", "Carrier pigeons"],
          correctIndex: 1,
          explanation: "The Yam was a highly efficient relay system for messages and intelligence.",
        ),
      ],
    ),

    // ── Poets ─────────────────────────────────────────────────────────────────

    Character(
      id: 'shakespeare',
      name: 'William Shakespeare',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Shakespeare.jpg',
      title: 'Playwright & Poet',
      dob: 'April 26, 1564',
      dod: 'April 23, 1616',
      description:
          'William Shakespeare is widely regarded as the greatest writer in the English language. '
          'He wrote 37 plays and 154 sonnets, exploring love, power, jealousy, and mortality. '
          'His works have shaped literature and the English language for four centuries.',
      contributions: [
        '37 plays including Hamlet, Othello, and King Lear',
        '154 Sonnets',
        'Invented over 1,700 English words still in use',
        'Profound influence on world literature and drama',
      ],
      facts: [
        'Shakespeare retired to Stratford-upon-Avon in 1613.',
        'His Globe Theatre held up to 3,000 spectators.',
        'He left his wife his "second-best bed" in his will.',
      ],
      chatPrompt: 'All the world\'s a stage, and all the men and women merely players.',
      tone: 'Eloquent, witty, and deeply insightful',
      communicationStyle: 'Vivid and dramatic. Draws from plays and sonnets to explore love, mortality, and human nature.',
      domainKnowledge: 'Hamlet, Macbeth, Othello, Sonnets, Elizabethan drama, and the human condition.',
      bio: 'An English playwright, poet, and actor, widely regarded as the greatest writer in the English language and the world\'s greatest dramatist. Occupies a unique position in world literature.',
      era: '16th-17th Century',
      origin: 'England',
      specialties: ['Drama', 'Poetry', 'Linguistics'],
      quiz: [
        QuizQuestion(
          question: "How many plays is Shakespeare generally credited with writing?",
          options: ["12", "25", "37", "52"],
          correctIndex: 2,
          explanation: "He wrote 37 plays, categorized into histories, tragedies, and comedies.",
        ),
        QuizQuestion(
          question: "What was the name of the theater company Shakespeare was a part-owner of?",
          options: ["The Royal Theatre", "The Globe", "The Rose", "The Swan"],
          correctIndex: 1,
          explanation: "The Globe Theatre was built in 1599 by Shakespeare's playing company.",
        ),
        QuizQuestion(
          question: "To be, or not to be, that is the question' is a famous line from which play?",
          options: ["Macbeth", "Othello", "Hamlet", "Romeo and Juliet"],
          correctIndex: 2,
          explanation: "This soliloquy is spoken by Prince Hamlet in the 'Nunnery Scene'.",
        ),
        QuizQuestion(
          question: "Shakespeare is famous for writing 154 of which type of poem?",
          options: ["Haiku", "Sonnets", "Limericks", "Ballads"],
          correctIndex: 1,
          explanation: "A Shakespearean sonnet consists of 14 lines with a specific rhyme scheme.",
        ),
        QuizQuestion(
          question: "Shakespeare was born in which English town?",
          options: ["London", "Oxford", "Stratford-upon-Avon", "Cambridge"],
          correctIndex: 2,
          explanation: "He was born and eventually died in Stratford-upon-Avon.",
        ),
      ],
    ),

    Character(
      id: 'rumi',
      name: 'Rumi',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/57/Mevlana.jpg',
      title: 'Sufi Mystic & Poet',
      dob: 'September 30, 1207',
      dod: 'December 17, 1273',
      description:
          'Jalal ad-Din Rumi was a 13th-century Persian poet, Sufi mystic, and Islamic scholar. '
          'His poetry on love, longing, and the divine transcends religion and culture. The Masnavi '
          'is considered one of the greatest works of Persian literature.',
      contributions: [
        'The Masnavi — six-volume poem on spiritual truth',
        'Divan-e Shams-e Tabrizi — lyric poetry collection',
        'Founding of the Mevlevi Order (whirling dervishes)',
        'Profound influence on Sufi mysticism',
      ],
      facts: [
        'Rumi was born in present-day Afghanistan.',
        'His works sell more copies in the US than any other poet.',
        'His friendship with Shams of Tabriz transformed his poetry.',
      ],
      chatPrompt: 'The wound is the place where the Light enters you.',
      tone: 'Poetic, soulful, and deeply mystical',
      communicationStyle: 'Metaphorical, compassionate, and focused on divine love and inner peace.',
      domainKnowledge: 'The Masnavi, Sufi mysticism, the language of the heart, and the search for the Beloved.',
      bio: 'A 13th-century Persian poet, Islamic scholar, and Sufi mystic whose influence transcends national borders and ethnic divisions. His poetry focuses on spiritual growth and the power of love.',
      era: '13th Century',
      origin: 'Persia (Balkh/Konya)',
      specialties: ['Sufism', 'Mysticism', 'Persian Poetry'],
      quiz: [
        QuizQuestion(
          question: "Rumi is the central figure and inspiration for which mystical order?",
          options: ["The Jesuits", "The Whirling Dervishes", "The Franciscans", "The Templars"],
          correctIndex: 1,
          explanation: "The Mevlevi Order for the 'Whirling Dervishes' was founded by his followers.",
        ),
        QuizQuestion(
          question: "What is the name of Rumi's vast six-volume masterpiece of spiritual poetry?",
          options: ["The Shahnameh", "The Masnavi", "The Rubaiyat", "The Divan of Hafiz"],
          correctIndex: 1,
          explanation: "The Masnavi is often called 'the Quran in the Persian tongue' due to its depth.",
        ),
        QuizQuestion(
          question: "Rumi wrote his poetry primarily in which language?",
          options: ["Arabic", "Turkish", "Persian", "Urdu"],
          correctIndex: 2,
          explanation: "While he lived in several regions, his literary language was Persian.",
        ),
        QuizQuestion(
          question: "Which mystical friend and teacher was the primary influence on Rumi's spiritual transformation?",
          options: ["Shams of Tabriz", "Al-Ghazali", "Ibn Arabi", "Omar Khayyam"],
          correctIndex: 0,
          explanation: "The disappearance of Shams of Tabriz inspired much of Rumi's most emotional poetry.",
        ),
        QuizQuestion(
          question: "The town of Konya, where Rumi spent most of his life and is buried, is in which modern-day country?",
          options: ["Iran", "Iraq", "Turkey", "Afghanistan"],
          correctIndex: 2,
          explanation: "Konya is a major city in central Turkey.",
        ),
      ],
    ),

    Character(
      id: 'byron',
      name: 'Lord Byron',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1a/George_Gordon_Byron%2C_6th_Baron_Byron_by_Richard_Westall_%282%29.jpg',
      title: 'Romantic Poet',
      dob: 'January 22, 1788',
      dod: 'April 19, 1824',
      description:
          'George Gordon Byron, 6th Baron Byron, was a leading Romantic poet known for Childe '
          'Harold\'s Pilgrimage and Don Juan. He was as famous for his tempestuous personal life '
          'as for his verse and died fighting for Greek independence.',
      contributions: [
        'Childe Harold\'s Pilgrimage',
        'Don Juan — epic satirical poem',
        'Created the archetype of the "Byronic hero"',
        'Champion of Greek independence',
      ],
      facts: [
        'Byron died in Greece fighting for independence from the Ottomans.',
        'He kept a pet bear at Cambridge University.',
        'Ada Lovelace, the first computer programmer, was his daughter.',
      ],
      chatPrompt:
          'You are Lord Byron, Romantic-era English poet and celebrated rebel. Speak with '
          'passionate intensity, wit, and brooding charm. Reference your poetry, your travels, '
          'and your life as the original Romantic hero. Be expressive and vivid. Keep replies '
          '2-6 sentences. Stay in character as a 19th-century Romantic.',
      bio: 'One of the greatest British poets and a leading figure in the Romantic movement. Famous for his epic satires and for creating the "Byronic hero" archetype.',
      era: '18th-19th Century',
      origin: 'England',
      specialties: ['Romantic Poetry', 'Satire', 'Political Activism'],
      quiz: [
        QuizQuestion(
          question: "What is the name of Lord Byron's famous satirical epic poem about a Spanish boy?",
          options: ["Don Juan", "Childe Harold", "The Corsair", "Manfred"],
          correctIndex: 0,
          explanation: "Don Juan is Byron's masterpiece, a satirical poem reversing the legend of Don Juan.",
        ),
        QuizQuestion(
          question: "Byron is credited with creating which literary archetype?",
          options: ["The Tragic Hero", "The Byronic Hero", "The Star-Crossed Lover", "The Anti-Hero"],
          correctIndex: 1,
          explanation: "The Byronic hero is a brooding, isolated, and rebellious figure often seen in his works.",
        ),
        QuizQuestion(
          question: "Lord Byron died in which country while supporting their war for independence?",
          options: ["Italy", "France", "Greece", "Spain"],
          correctIndex: 2,
          explanation: "He is regarded as a national hero in Greece for his support against the Ottoman Empire.",
        ),
        QuizQuestion(
          question: "Which famous 19th-century figure was Lord Byron's daughter?",
          options: ["Mary Shelley", "Ada Lovelace", "Florence Nightingale", "Jane Austen"],
          correctIndex: 1,
          explanation: "Ada Lovelace was a brilliant mathematician and is often called the first computer programmer.",
        ),
        QuizQuestion(
          question: "Byron was famously described by Lady Caroline Lamb as 'mad, bad, and...' what?",
          options: ["Sad to know", "Glad to know", "Dangerous to know", "Wild to know"],
          correctIndex: 2,
          explanation: "The phrase 'Mad, bad, and dangerous to know' became the definitive description of Byron.",
        ),
      ],
    ),

    Character(
      id: 'dickinson',
      name: 'Emily Dickinson',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6e/BlackDaguerreotype.jpg',
      title: 'Poet',
      dob: 'December 10, 1830',
      dod: 'May 15, 1886',
      description:
          'Emily Dickinson was an American poet known for her unconventional style — slant rhyme '
          'and compressed language. Largely unknown in her lifetime, she wrote nearly 1,800 poems '
          'about death, nature, immortality, and inner life.',
      contributions: [
        'Nearly 1,800 poems, most published posthumously',
        'Revolutionary poetic style with dashes and slant rhyme',
        'Deep exploration of death, nature, and the divine',
        'Major influence on American poetry',
      ],
      facts: [
        'Only 10 of her poems were published during her lifetime.',
        'She rarely left her home in Amherst, Massachusetts.',
        'Her poems have no titles — identified by first lines.',
      ],
      chatPrompt: 'Hope is the thing with feathers that perches in the soul.',
      tone: 'Introspective, lyrical, and slightly mysterious',
      communicationStyle: 'Piercingly deep and compressed. Speaks of death, nature, and the inner life with precise language.',
      domainKnowledge: 'Nature, mortality, immortality, the inner soul, and 19th-century American poetry.',
      bio: 'An American poet who, despite being little-known during her lifetime, is now regarded as one of the most important figures in American poetry. Her unique style features short lines and unconventional punctuation.',
      era: '19th Century',
      origin: 'United States (Massachusetts)',
      specialties: ['Lyrical Poetry', 'Modernist Style', 'Metaphysical Themes'],
      quiz: [
        QuizQuestion(
          question: "How many of Emily Dickinson's roughly 1,800 poems were published while she was alive?",
          options: ["Over 500", "About 100", "Fewer than 12", "None"],
          correctIndex: 2,
          explanation: "Only about 10 or 11 of her poems were published during her lifetime.",
        ),
        QuizQuestion(
          question: "Dickinson is famous for her extensive and unique use of which punctuation mark?",
          options: ["Semicolons", "Exclamation points", "Dashes", "Ellipses"],
          correctIndex: 2,
          explanation: "Her use of dashes is a signature characteristic of her poetic style.",
        ),
        QuizQuestion(
          question: "Emily Dickinson spent most of her life in which town?",
          options: ["Boston", "Amherst", "Salem", "Plymouth"],
          correctIndex: 1,
          explanation: "She lived as a recluse in her family home in Amherst, Massachusetts.",
        ),
        QuizQuestion(
          question: "Because Dickinson didn't title most of her poems, what are they usually identified by?",
          options: ["The date written", "Their first line", "Random numbers", "Single words"],
          correctIndex: 1,
          explanation: "Poems like 'Because I could not stop for Death' are known by their opening lines.",
        ),
        QuizQuestion(
          question: "Which of these is a major theme throughout Dickinson's poetry?",
          options: ["Urban life", "Nature and Immortality", "Political revolution", "Industrial progress"],
          correctIndex: 1,
          explanation: "She wrote extensively about the natural world, death, and the soul.",
        ),
      ],
    ),

    Character(
      id: 'neruda',
      name: 'Pablo Neruda',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/ef/Pablo_Neruda_1963.jpg',
      title: 'Poet & Nobel Laureate',
      dob: 'July 12, 1904',
      dod: 'September 23, 1973',
      description:
          'Pablo Neruda was a Chilean poet and diplomat who won the Nobel Prize in Literature '
          'in 1971. Known for passionate love poetry and odes to everyday objects, he is one '
          'of the most-read poets in the Spanish language.',
      contributions: [
        'Twenty Love Poems and a Song of Despair',
        'Canto General — epic poem of Latin America',
        'Odes to Common Things',
        'Nobel Prize in Literature (1971)',
      ],
      facts: [
        'Neruda collected everything from ships\' figureheads to butterfly specimens.',
        'He served as Chilean consul in Spain during the Civil War.',
        'He died just days after Pinochet\'s coup in Chile.',
      ],
      chatPrompt:
          'You are Pablo Neruda, Chilean poet and Nobel laureate. Speak with passionate lyricism '
          'about love, nature, and the beauty of ordinary things. Reference your odes and love '
          'poems. Be sensuous, vivid, and heartfelt. Keep replies 2-6 sentences. '
          'Stay in character.',
      bio: 'A Chilean poet-diplomat and politician who won the Nobel Prize in Literature in 1971. He is famous for his love poems and his "Odes to Common Things".',
      era: '20th Century',
      origin: 'Chile',
      specialties: ['Poetry', 'Diplomacy', 'Surrealism'],
      quiz: [
        QuizQuestion(
          question: "In which year did Pablo Neruda win the Nobel Prize in Literature?",
          options: ["1950", "1971", "1964", "1982"],
          correctIndex: 1,
          explanation: "Neruda was awarded the Nobel Prize in 1971 'for a poetry that with the action of an elemental force brings alive a continent's destiny and dreams'.",
        ),
      ],
    ),

    // ── Explorers ─────────────────────────────────────────────────────────────

    Character(
      id: 'ibn_battuta',
      name: 'Ibn Battuta',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Battuta.png',
      title: 'Explorer & Travel Writer',
      dob: 'February 25, 1304',
      dod: 'c. 1368',
      description:
          'Ibn Battuta was a Moroccan explorer who traveled over 117,000 kilometres across the '
          'known world. His account, the Rihla, documents 44 modern countries and 30 years of '
          'travel across Africa, Asia, and Europe.',
      contributions: [
        'The Rihla — record of 30 years of global travel',
        'Documentation of 44 countries across three continents',
        'Diplomatic missions across the Islamic world',
        'Invaluable record of 14th-century civilizations',
      ],
      facts: [
        'He started his journeys at age 21 on a hajj to Mecca.',
        'He traveled over 117,000 km — three times more than Marco Polo.',
        'He spent several years in the Mali Empire in West Africa.',
      ],
      chatPrompt: 'Travel leaves you speechless, then turns you into a storyteller.',
      tone: 'Adventurous, culturally curious, and observational',
      communicationStyle: 'Vivid and detailed. Speaks of the Rihla, the courts of the East, and the vast journeys across the Islamic world.',
      domainKnowledge: 'The Rihla, 14th-century global travel, Islamic civilizations, trade routes, and international courts.',
      bio: 'A Moroccan explorer who traveled more than any other explorer in history, totaling around 117,000 km, surpassing even Marco Polo.',
      era: '14th Century',
      origin: 'Morocco',
      specialties: ['Exploration', 'Travel Writing', 'Islamic Law'],
      quiz: [
        QuizQuestion(
          question: "What is the name of the famous book documenting Ibn Battuta's travels?",
          options: ["The Travels", "The Rihla", "The Odyssey", "The Million"],
          correctIndex: 1,
          explanation: "The Rihla (The Journey) is the classic account of his 30 years of travel.",
        ),
      ],
    ),

    Character(
      id: 'marco_polo',
      name: 'Marco Polo',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/81/Marco_Polo_portrait.jpg',
      title: 'Venetian Merchant & Explorer',
      dob: 'c. September 15, 1254',
      dod: 'January 8, 1324',
      description:
          'Marco Polo was a Venetian merchant who traveled to China and spent 17 years in the '
          'court of Kublai Khan. His book, The Travels of Marco Polo, introduced Europeans to '
          'the wealth and culture of Asia.',
      contributions: [
        'The Travels of Marco Polo — introducing Asia to Europe',
        '17 years in Kublai Khan\'s court in China',
        'Documentation of the Silk Road trade routes',
        'Influence on Columbus and later explorers',
      ],
      facts: [
        'Columbus carried a copy of Marco Polo\'s book on his voyage.',
        'He dictated his famous book while in a Genoese prison.',
        'He returned to Venice after 24 years away.',
      ],
      chatPrompt: 'I have not told half of what I saw.',
      tone: 'Practical, observational, and merchant-minded',
      communicationStyle: 'Detailed and business-like. Speaks of the Silk Road, Kublai Khan\'s court, and the wealth and customs of the East.',
      domainKnowledge: 'Silk Road, Kublai Khan, Cathay (China), Venetian trade, and the travels through Asia.',
      bio: 'A Venetian merchant, explorer and writer who travelled through Asia along the Silk Road between 1271 and 1295.',
      era: '13th-14th Century',
      origin: 'Venice',
      specialties: ['Merchandising', 'Exploration', 'Diplomacy'],
      quiz: [
        QuizQuestion(
          question: "Which Mongol ruler did Marco Polo serve for 17 years?",
          options: ["Genghis Khan", "Kublai Khan", "Batu Khan", "Ogedei Khan"],
          correctIndex: 1,
          explanation: "Marco Polo became a confidant of Kublai Khan and traveled extensively through his empire.",
        ),
      ],
    ),

    Character(
      id: 'columbus',
      name: 'Christopher Columbus',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/50/Christopher_Columbus_in_a_painting_of_Spanish_School.jpg',
      title: 'Explorer & Navigator',
      dob: 'October 31, 1451',
      dod: 'May 20, 1506',
      description:
          'Christopher Columbus was a Genoese explorer who completed four voyages across the '
          'Atlantic, opening permanent contact between Europe and the Americas. Sailing under '
          'Spanish patronage in 1492, he reached the Caribbean.',
      contributions: [
        'First European contact with the Caribbean (1492)',
        'Opened permanent European-American exchange',
        'Four Atlantic voyages under Spanish patronage',
        'Mapping of Caribbean and Central American coasts',
      ],
      facts: [
        'Columbus never knew he had reached an unknown continent.',
        'He made four voyages but never set foot on mainland North America.',
        'He died believing he had reached the coast of Asia.',
      ],
      chatPrompt: 'By prevailing over all obstacles and distractions, one may unfailingly arrive at his chosen goal or destination.',
      tone: 'Ambitious, confident, and determined',
      communicationStyle: 'Navigational and visionary. Speaks of the Atlantic voyages, the quest for a western route to Asia, and the discovery of new lands.',
      domainKnowledge: 'Atlantic navigation, 1492 voyage, Caribbean geography, Spanish patronage, and the Age of Discovery.',
      bio: 'An Italian explorer and navigator who completed four voyages across the Atlantic Ocean, opening the way for the widespread European exploration and colonization of the Americas.',
      era: '15th-16th Century',
      origin: 'Genoa (Republic of Genoa)',
      specialties: ['Navigation', 'Exploration', 'Cartography'],
      quiz: [
        QuizQuestion(
          question: "In which year did Columbus first reach the Americas?",
          options: ["1492", "1498", "1502", "1488"],
          correctIndex: 0,
          explanation: "Columbus's first voyage reached the Bahamas in October 1492.",
        ),
      ],
    ),

    Character(
      id: 'magellan',
      name: 'Ferdinand Magellan',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b3/Ferdinand_Magellan.jpg',
      title: 'Explorer & Circumnavigator',
      dob: 'c. 1480',
      dod: 'April 27, 1521',
      description:
          'Ferdinand Magellan was a Portuguese explorer who organized the first circumnavigation '
          'of the Earth. He discovered the strait bearing his name and crossed the Pacific Ocean, '
          'though he was killed in the Philippines before completing the voyage.',
      contributions: [
        'Organisation of the first circumnavigation of the Earth',
        'Discovery of the Strait of Magellan',
        'First European crossing of the Pacific Ocean',
        'Proof of Earth\'s circumference by sea',
      ],
      facts: [
        'Magellan died in the Philippines in 1521 — his crew completed the voyage.',
        'The voyage took nearly three years.',
        'Only 18 of the original 270 crew returned to Spain.',
      ],
      chatPrompt: 'The church says the earth is flat, but I know that it is round, for I have seen the shadow on the moon.',
      tone: 'Determined, masterful, and dedicated',
      communicationStyle: 'Navigational and intense. Speaks of his circumnavigation, the Pacific crossing, and the strait that bears his name.',
      domainKnowledge: 'Circumnavigation, Strait of Magellan, Pacific crossing, Portuguese/Spanish history, and sea endurance.',
      bio: 'A Portuguese explorer who organised the Spanish expedition to the East Indies from 1519 to 1522, resulting in the first circumnavigation of the Earth.',
      era: '15th-16th Century',
      origin: 'Portugal',
      specialties: ['Navigation', 'Exploration', 'Circumnavigation'],
      quiz: [
        QuizQuestion(
          question: "What is Ferdinand Magellan most famous for?",
          options: ["Discovering Australia", "The first circumnavigation of the Earth", "Finding a route to India", "Conquering the Aztecs"],
          correctIndex: 1,
          explanation: "His expedition was the first to sail around the world, proving it was possible to reach the East by sailing West.",
        ),
      ],
    ),

    Character(
      id: 'cook',
      name: 'James Cook',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/45/James_Cook_by_Nathaniel_Dance.jpg',
      title: 'Royal Navy Captain & Explorer',
      dob: 'November 7, 1728',
      dod: 'February 14, 1779',
      description:
          'James Cook was a British Royal Navy officer who made three voyages into the Pacific '
          'Ocean. He mapped the coastlines of New Zealand and Australia, charted the Hawaiian '
          'Islands, and became one of the greatest navigators in history.',
      contributions: [
        'Mapping of New Zealand and Australian coastlines',
        'First European contact with Hawaii',
        'Crossing the Antarctic Circle',
        'Precise navigation and charting of the Pacific',
      ],
      facts: [
        'Cook was killed in Hawaii during a dispute in 1779.',
        'He was among the first to prevent scurvy with a proper diet.',
        'He rose from humble farmhand origins to Royal Navy Captain.',
      ],
      chatPrompt:
          'You are James Cook, 18th-century British Royal Navy captain and Pacific explorer. '
          'Speak with naval discipline, scientific curiosity, and methodical precision. Reference '
          'your three voyages, mapping the Pacific, and your encounters with new peoples and lands. '
          'Keep replies 2-6 sentences. Stay in character.',
      bio: 'A British explorer, navigator, cartographer, and captain in the British Royal Navy, famous for his three voyages to the Pacific Ocean.',
      era: '18th Century',
      origin: 'Great Britain',
      specialties: ['Navigation', 'Cartography', 'Astronomy'],
      quiz: [
        QuizQuestion(
          question: "Which islands did James Cook 'discover' and name the Sandwich Islands?",
          options: ["New Zealand", "Fiji", "Hawaii", "Tahiti"],
          correctIndex: 2,
          explanation: "He reached the Hawaiian Islands in 1778 and named them in honor of the Earl of Sandwich.",
        ),
      ],
    ),
  ];

  List<Character> getAll() => _characters;

  List<Character> getByCategory(CharacterCategory category) =>
      _characters.where((c) => c.category == category).toList();

  Character? getById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CharacterCategory> getAvailableCategories() {
    final seen = <CharacterCategory>{};
    return _characters.map((c) => c.category).where(seen.add).toList();
  }
}
