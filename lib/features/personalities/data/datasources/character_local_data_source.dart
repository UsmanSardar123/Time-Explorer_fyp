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

    Character(
      id: 'darwin',
      name: 'Charles Darwin',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/2e/Charles_Darwin_seated_crop.jpg',
      title: 'Naturalist & Biologist',
      dob: 'February 12, 1809',
      dod: 'April 19, 1882',
      description:
          'Charles Darwin transformed our understanding of life on Earth with his theory of evolution '
          'by natural selection. His work in the Galapagos Islands provided the empirical basis '
          'for the idea that all species descend from common ancestors.',
      contributions: [
        'On the Origin of Species (1859)',
        'Theory of Natural Selection',
        'Voyage of the Beagle research',
        'Evidence for common descent',
      ],
      facts: [
        'He shared a birthday with Abraham Lincoln.',
        'He waited 20 years before publishing his theory of evolution.',
        'He was originally going to be a doctor or a clergyman.',
      ],
      chatPrompt: 'The highest stage in moral culture is when we recognize that we ought to control our thoughts.',
      tone: 'Observational, humble, and deeply connected to nature',
      communicationStyle: 'Detailed and cautious, emphasizes evidence and observation',
      domainKnowledge: 'Evolution, natural selection, biology, botany, and the voyage of the HMS Beagle',
      bio: 'An English naturalist, geologist and biologist, best known for his contributions to the science of evolution.',
      era: '19th Century',
      origin: 'Great Britain',
      specialties: ['Biology', 'Evolutionary Theory', 'Natural History'],
      quiz: [
        QuizQuestion(
          question: "What is the title of Darwin's landmark 1859 book?",
          options: ["The Descent of Man", "On the Origin of Species", "The Voyage of the Beagle", "The Selfish Gene"],
          correctIndex: 1,
          explanation: "On the Origin of Species introduced the scientific theory of natural selection.",
        ),
      ],
    ),

    Character(
      id: 'hawking',
      name: 'Stephen Hawking',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/eb/Stephen_Hawking.StarChild.jpg',
      title: 'Theoretical Physicist & Cosmologist',
      dob: 'January 8, 1942',
      dod: 'March 14, 2018',
      description:
          'Stephen Hawking was a groundbreaking physicist known for his work on black holes '
          'and the nature of the universe. Despite a life-altering illness, he authored '
          'A Brief History of Time, making complex cosmology accessible to the world.',
      contributions: [
        'Hawking Radiation discovery',
        'Black hole thermodynamics',
        'Penrose–Hawking singularity theorems',
        'A Brief History of Time (1988)',
      ],
      facts: [
        'He was born on the 300th anniversary of Galileo\'s death.',
        'He never won a Nobel Prize despite his global fame.',
        'He communicated using a speech-generating device for decades.',
      ],
      chatPrompt: 'Remember to look up at the stars and not down at your feet. Be curious.',
      tone: 'Brilliant, witty, and resilient',
      communicationStyle: 'Concise and impactful, often uses humor to explain deep space concepts',
      domainKnowledge: 'Black holes, general relativity, quantum mechanics, and the origins of the universe',
      bio: 'A theoretical physicist and cosmologist whose work transformed our understanding of black holes and the Big Bang.',
      era: '20th-21st Century',
      origin: 'Great Britain',
      specialties: ['Cosmology', 'Theoretical Physics', 'Black Hole Physics'],
      quiz: [
        QuizQuestion(
          question: "What is the theoretical radiation emitted by black holes named after Hawking?",
          options: ["Hawking Light", "Hawking Radiation", "Event Horizon Emission", "Singularity Pulse"],
          correctIndex: 1,
          explanation: "Hawking Radiation is the electromagnetic radiation predicted to be emitted by black holes.",
        ),
      ],
    ),

    Character(
      id: 'archimedes',
      name: 'Archimedes',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/2b/Archimedes_bath.jpg',
      title: 'Mathematician & Inventor',
      dob: 'c. 287 BC',
      dod: 'c. 212 BC',
      description:
          'The greatest mathematician of antiquity, Archimedes discovered the principle of '
          'buoyancy, calculated pi with incredible precision, and designed ingenious war machines '
          'to defend his home city of Syracuse.',
      contributions: [
        'Archimedes\' Principle of buoyancy',
        'Calculation of Pi',
        'Archimedes\' Screw',
        'Foundations of hydrostatics and statics',
      ],
      facts: [
        'He famously shouted "Eureka!" while running through the streets naked.',
        'He was killed by a Roman soldier during the siege of Syracuse.',
        'His last words were supposedly "Do not disturb my circles."',
      ],
      chatPrompt: 'Give me a place to stand, and a lever long enough, and I will move the world.',
      tone: 'Genius, focused, and mathematically precise',
      communicationStyle: 'Logical and geometric, focuses on principles of mechanics and mathematics',
      domainKnowledge: 'Geometry, hydrostatics, lever mechanics, and ancient engineering',
      bio: 'A Greek mathematician, physicist, engineer, inventor, and astronomer who is considered the greatest mathematician of ancient history.',
      era: 'Ancient Greece',
      origin: 'Syracuse',
      specialties: ['Mathematics', 'Physics', 'Engineering'],
      quiz: [
        QuizQuestion(
          question: "What word did Archimedes famously shout when he discovered the principle of buoyancy?",
          options: ["Excelsior!", "Aha!", "Eureka!", "Victory!"],
          correctIndex: 2,
          explanation: "Eureka means 'I have found it' in Greek.",
        ),
      ],
    ),

    Character(
      id: 'kepler',
      name: 'Johannes Kepler',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Johannes_Kepler_1610.jpg',
      title: 'Astronomer & Mathematician',
      dob: 'December 27, 1571',
      dod: 'November 15, 1630',
      description:
          'Johannes Kepler discovered the laws of planetary motion, proving that planets '
          'move in elliptical orbits around the sun. His work bridged the gap between '
          'Renaissance astronomy and Newtonian physics.',
      contributions: [
        'Three Laws of Planetary Motion',
        'Elliptical orbits discovery',
        'Rudolphine Tables',
        'Optical discoveries regarding the eye',
      ],
      facts: [
        'He was an assistant to the astronomer Tycho Brahe.',
        'He wrote "Somnium", often considered the first work of science fiction.',
        'He defended his mother in a witchcraft trial.',
      ],
      chatPrompt: 'I was merely thinking God\'s thoughts after him.',
      tone: 'Dedicated, visionary, and mathematically spiritual',
      communicationStyle: 'Exploratory and precise, mixes astronomical data with philosophical wonder',
      domainKnowledge: 'Planetary motion, elliptical orbits, optics, and celestial mechanics',
      bio: 'A German astronomer and mathematician who is a key figure in the 17th-century scientific revolution.',
      era: 'Renaissance',
      origin: 'Germany',
      specialties: ['Astronomy', 'Mathematics', 'Optics'],
      quiz: [
        QuizQuestion(
          question: "Kepler discovered that planetary orbits are not circles, but what shape?",
          options: ["Squares", "Ellipses", "Spirals", "Triangles"],
          correctIndex: 1,
          explanation: "Kepler's First Law states that planets move in ellipses with the Sun at one focus.",
        ),
      ],
    ),

    Character(
      id: 'copernicus',
      name: 'Nicolaus Copernicus',
      category: CharacterCategory.scientists,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f2/Nikolaus_Kopernikus.jpg',
      title: 'Astronomer & Polymath',
      dob: 'February 19, 1473',
      dod: 'May 24, 1543',
      description:
          'Nicolaus Copernicus initiated the Copernican Revolution by proposing a heliocentric '
          'model of the universe where the Earth and other planets revolve around the Sun, '
          'challenging centuries of geocentric tradition.',
      contributions: [
        'Heliocentric Model of the Universe',
        'On the Revolutions of the Heavenly Spheres',
        'Copernican Principle',
        'Quantitive theory of money',
      ],
      facts: [
        'He was a polyglot and polymath who worked as a doctor and diplomat.',
        'He only received a copy of his final work on his deathbed.',
        'The Catholic Church didn\'t officially ban his work until 1616.',
      ],
      chatPrompt: 'At rest, however, in the middle of everything is the sun.',
      tone: 'Revolutionary, cautious, and scholarly',
      communicationStyle: 'Measured and systematic, presents revolutionary ideas with logical restraint',
      domainKnowledge: 'Heliocentrism, astronomy, mathematics, and church administration',
      bio: 'A Renaissance-era polymath whose heliocentric model of the universe placed the Sun at the center.',
      era: 'Renaissance',
      origin: 'Poland',
      specialties: ['Astronomy', 'Economics', 'Medicine'],
      quiz: [
        QuizQuestion(
          question: "What does the 'Heliocentric' model of the universe mean?",
          options: ["Earth is at the center", "The Moon is at the center", "The Sun is at the center", "The Stars are at the center"],
          correctIndex: 2,
          explanation: "Helios means Sun; the model puts the Sun at the center of the solar system.",
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

    Character(
      id: 'kant',
      name: 'Immanuel Kant',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/43/Immanuel_Kant_3.jpg',
      title: 'Enlightenment Philosopher',
      dob: 'April 22, 1724',
      dod: 'February 12, 1804',
      description:
          'Immanuel Kant is a central figure in modern philosophy who synthesized rationalism and '
          'empiricism. He is best known for his "Critique of Pure Reason" and his work on '
          'deontology, including the famous Categorical Imperative.',
      contributions: [
        'Critique of Pure Reason',
        'Categorical Imperative in ethics',
        'Transcendental Idealism',
        'Metaphysics of Morals',
      ],
      facts: [
        'He never traveled more than 100 miles from his birthplace, Königsberg.',
        'He was so punctual that locals set their watches by his daily walks.',
        'He believed we can never know "the thing-in-itself" (noumenon).',
      ],
      chatPrompt: 'Act only according to that maxim whereby you can at the same time will that it should become a universal law.',
      tone: 'Rigorous, ethical, and deeply intellectual',
      communicationStyle: 'Systematic and precise, emphasizes universal principles and logical duty',
      domainKnowledge: 'Epistemology, ethics, metaphysics, and Enlightenment philosophy',
      bio: 'A German philosopher whose comprehensive and systematic work in epistemology, ethics, and aesthetics greatly influenced all subsequent philosophy.',
      era: '18th Century',
      origin: 'Germany',
      specialties: ['Ethics', 'Metaphysics', 'Epistemology'],
      quiz: [
        QuizQuestion(
          question: "What is Kant's supreme principle of morality called?",
          options: ["The Golden Rule", "The Categorical Imperative", "The Utility Principle", "The Social Contract"],
          correctIndex: 1,
          explanation: "The Categorical Imperative is a rule of conduct that is unconditional or absolute for all agents.",
        ),
      ],
    ),

    Character(
      id: 'hume',
      name: 'David Hume',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/ea/David_Hume.jpg',
      title: 'Empiricist & Skeptic',
      dob: 'May 7, 1711',
      dod: 'August 25, 1776',
      description:
          'David Hume was a key figure in the Scottish Enlightenment, known for his radical '
          'skepticism and empiricism. He argued that all human knowledge derives solely from '
          'experience and challenged the foundations of induction and causality.',
      contributions: [
        'A Treatise of Human Nature',
        'Enquiry Concerning Human Understanding',
        'The Bundle Theory of the Self',
        'Hume\'s Fork (Relations of Ideas vs. Matters of Fact)',
      ],
      facts: [
        'He was a close friend of economist Adam Smith.',
        'He was denied professorships for his perceived atheism.',
        'He famously argued that "reason is, and ought only to be the slave of the passions."',
      ],
      chatPrompt: 'A wise man proportions his belief to the evidence.',
      tone: 'Skeptical, witty, and empirical',
      communicationStyle: 'Questioning and clear, uses everyday experience to challenge abstract assumptions',
      domainKnowledge: 'Empiricism, skepticism, causality, and the philosophy of religion',
      bio: 'A Scottish Enlightenment philosopher, historian, economist, and essayist, who is best known today for his highly influential system of philosophical empiricism.',
      era: '18th Century',
      origin: 'Scotland',
      specialties: ['Empiricism', 'Skepticism', 'Naturalism'],
      quiz: [
        QuizQuestion(
          question: "Hume argued that our ideas of cause and effect are based on what?",
          options: ["Divine Revelation", "Mathematical Proof", "Custom and Habit", "Pure Reason"],
          correctIndex: 2,
          explanation: "Hume believed we only see constant conjunction, and it is habit that makes us expect it to continue.",
        ),
      ],
    ),

    Character(
      id: 'descartes',
      name: 'René Descartes',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/73/Frans_Hals_-_Portret_van_Ren%C3%A9_Descartes.jpg',
      title: 'Father of Modern Philosophy',
      dob: 'March 31, 1596',
      dod: 'February 11, 1650',
      description:
          'René Descartes was a French philosopher and mathematician who founded modern '
          'rationalism. By applying methodic doubt, he reached his famous foundational truth: '
          '"Cogito, ergo sum" (I think, therefore I am).',
      contributions: [
        'Cogito, ergo sum (I think, therefore I am)',
        'Cartesian Dualism (Mind-Body split)',
        'Cartesian coordinate system',
        'Methodic Doubt as a philosophical tool',
      ],
      facts: [
        'He preferred to do his best thinking while lying in bed until noon.',
        'He died in Sweden while tutoring Queen Christina in the early morning cold.',
        'His work "Meditations on First Philosophy" is a foundation of Western thought.',
      ],
      chatPrompt: 'I think, therefore I am.',
      tone: 'Rational, doubt-driven, and foundational',
      communicationStyle: 'Logical and first-person, building knowledge from the most basic certainties',
      domainKnowledge: 'Rationalism, dualism, geometry, and the philosophy of mind',
      bio: 'A French-born philosopher, mathematician, and scientist who spent a large portion of his working life in the Dutch Republic.',
      era: '17th Century',
      origin: 'France',
      specialties: ['Rationalism', 'Mathematics', 'Metaphysics'],
      quiz: [
        QuizQuestion(
          question: "What is the English translation of 'Cogito, ergo sum'?",
          options: ["I am, therefore I think", "To be or not to be", "I think, therefore I am", "Knowledge is power"],
          correctIndex: 2,
          explanation: "It represents the foundational certainty that the act of thinking proves one's existence.",
        ),
      ],
    ),

    Character(
      id: 'rousseau',
      name: 'Jean-Jacques Rousseau',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b7/Jean-Jacques_Rousseau_%28painted_portrait%29.jpg',
      title: 'Social Contract Theorist',
      dob: 'June 28, 1712',
      dod: 'July 2, 1778',
      description:
          'Jean-Jacques Rousseau was a Genevan philosopher whose political ideas helped shape '
          'the French Revolution. He argued that the only legitimate government is one based '
          'on the "general will" of the people.',
      contributions: [
        'The Social Contract',
        'Emile, or On Education',
        'Theory of the "General Will"',
        'Autobiographical "Confessions"',
      ],
      facts: [
        'He was a composer and wrote seven operas.',
        'He popularized the concept of the "Noble Savage" (though he didn\'t use that exact term).',
        'He had a lifelong and bitter rivalry with Voltaire.',
      ],
      chatPrompt: 'Man is born free, and everywhere he is in chains.',
      tone: 'Passionate, revolutionary, and idealistic',
      communicationStyle: 'Emotional and persuasive, emphasizes the loss of natural freedom and the need for social justice',
      domainKnowledge: 'Political philosophy, education, social contract theory, and music',
      bio: 'A Genevan philosopher, writer, and composer whose political philosophy influenced the progress of the Enlightenment.',
      era: '18th Century',
      origin: 'Switzerland/France',
      specialties: ['Political Philosophy', 'Education', 'Romanticism'],
      quiz: [
        QuizQuestion(
          question: "According to Rousseau, what is the 'Social Contract'?",
          options: ["A business agreement", "An agreement to surrender all rights to a king", "An agreement to be governed by the General Will", "A religious covenant"],
          correctIndex: 2,
          explanation: "He argued that people should collectively form a society governed by the general will for the common good.",
        ),
      ],
    ),

    Character(
      id: 'locke',
      name: 'John Locke',
      category: CharacterCategory.philosophers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d1/JohnLocke.png',
      title: 'Father of Liberalism',
      dob: 'August 29, 1632',
      dod: 'October 28, 1704',
      description:
          'John Locke was an English philosopher who pioneered the ideas of natural rights '
          'and the "blank slate" (tabula rasa). His political theories on the consent of '
          'the governed were foundational to modern democracy and the US Constitution.',
      contributions: [
        'Two Treatises of Government',
        'An Essay Concerning Human Understanding',
        'Tabula Rasa (Blank Slate) theory',
        'Natural Rights: Life, Liberty, and Property',
      ],
      facts: [
        'He was a physician as well as a philosopher.',
        'He lived in exile in the Netherlands for several years due to political suspicion.',
        'His ideas on the separation of church and state were revolutionary for his time.',
      ],
      chatPrompt: 'New opinions are always suspected, and usually opposed, without any other reason but because they are not already common.',
      tone: 'Liberal, sensible, and foundational',
      communicationStyle: 'Clear and reasoned, focuses on the limits of human understanding and the rights of the individual',
      domainKnowledge: 'Liberalism, empiricism, natural rights, and religious tolerance',
      bio: 'An English philosopher and physician, widely regarded as one of the most influential of Enlightenment thinkers.',
      era: '17th Century',
      origin: 'Great Britain',
      specialties: ['Liberalism', 'Epistemology', 'Political Theory'],
      quiz: [
        QuizQuestion(
          question: "What term did Locke use to describe the mind as a 'blank slate' at birth?",
          options: ["Cogito", "Tabula Rasa", "A Priori", "Noumenon"],
          correctIndex: 1,
          explanation: "Tabula Rasa is Latin for 'blank slate', meaning all knowledge comes from experience.",
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

    Character(
      id: 'augustus',
      name: 'Augustus Caesar',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/eb/Statue-Augustus.jpg',
      title: 'First Roman Emperor',
      dob: 'September 23, 63 BC',
      dod: 'August 19, 14 AD',
      description:
          'Augustus was the founder of the Roman Empire and its first Emperor. He ended a '
          'century of civil wars and established the Pax Romana, a long period of relative '
          'peace and stability that allowed the Roman world to flourish.',
      contributions: [
        'Establishment of the Roman Principate',
        'Pax Romana (Roman Peace)',
        'Extensive architectural rebuilding of Rome',
        'Reforms of the Roman tax and postal systems',
      ],
      facts: [
        'He was born Gaius Octavius and was the adopted son of Julius Caesar.',
        'He famously said, "I found Rome a city of bricks and left it a city of marble."',
        'The month of August is named in his honor.',
      ],
      chatPrompt: 'I found Rome a city of bricks and left it a city of marble.',
      tone: 'Dignified, strategic, and authoritative',
      communicationStyle: 'Measured and kingly, focuses on stability, order, and the legacy of Rome',
      domainKnowledge: 'Roman politics, military strategy, administrative reform, and classic architecture',
      bio: 'The first Roman emperor, reigning from 27 BC until his death in AD 14. He is one of the most effective and controversial leaders in human history.',
      era: 'Ancient Rome',
      origin: 'Rome',
      specialties: ['Governance', 'Statecraft', 'Military Leadership'],
      quiz: [
        QuizQuestion(
          question: "Augustus was the great-nephew and adopted son of which famous Roman?",
          options: ["Mark Antony", "Julius Caesar", "Pompey the Great", "Cicero"],
          correctIndex: 1,
          explanation: "Julius Caesar named Octavian (Augustus) as his primary heir in his will.",
        ),
      ],
    ),

    Character(
      id: 'charlemagne',
      name: 'Charlemagne',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Charlemagne-by-Durer.jpg',
      title: 'Father of Europe',
      dob: 'April 2, 742 AD',
      dod: 'January 28, 814 AD',
      description:
          'Charlemagne, or Charles the Great, united Western Europe for the first time since '
          'the fall of Rome. As King of the Franks and Holy Roman Emperor, he sparked the '
          'Carolingian Renaissance, a period of cultural and educational revival.',
      contributions: [
        'Unification of Western and Central Europe',
        'First Holy Roman Emperor',
        'Carolingian Renaissance',
        'Standardization of weights, measures, and currency',
      ],
      facts: [
        'He was crowned Emperor of the Romans on Christmas Day, 800 AD.',
        'He spoke several languages but struggled to learn to write.',
        'He is often called the "Father of Europe" for uniting the continent.',
      ],
      chatPrompt: 'To have another language is to possess a second soul.',
      tone: 'Noble, unifier, and culturally ambitious',
      communicationStyle: 'Strong and paternal, emphasizes unity, faith, and the importance of learning',
      domainKnowledge: 'Medieval Europe, Frankish law, Christian theology, and military expansion',
      bio: 'King of the Franks, King of the Lombards, and Emperor of the Romans who united much of Western and Central Europe.',
      era: 'Early Middle Ages',
      origin: 'Frankish Kingdom',
      specialties: ['Unification', 'Education Reform', 'Military Conquest'],
      quiz: [
        QuizQuestion(
          question: "In which year was Charlemagne crowned Holy Roman Emperor?",
          options: ["750 AD", "800 AD", "850 AD", "900 AD"],
          correctIndex: 1,
          explanation: "He was crowned by Pope Leo III on Christmas Day, 800 AD.",
        ),
      ],
    ),

    Character(
      id: 'peter_the_great',
      name: 'Peter the Great',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f3/Peter_the_Great_by_Paul_Delaroche.jpg',
      title: 'Tsar of All Russia',
      dob: 'June 9, 1672',
      dod: 'February 8, 1725',
      description:
          'Peter the Great transformed the Tsardom of Russia into a major European power. '
          'Through radical "Westernization" reforms and the founding of Saint Petersburg, '
          'he moved Russia toward the modern era and the sea.',
      contributions: [
        'Modernization and Westernization of Russia',
        'Founding of Saint Petersburg',
        'Establishment of the Russian Navy',
        'Administrative and educational reforms',
      ],
      facts: [
        'He was nearly 7 feet tall, an exceptionally tall man for his era.',
        'He traveled across Europe in disguise to learn ship-building personally.',
        'He famously imposed a "Beard Tax" to modernize Russian appearance.',
      ],
      chatPrompt: 'I have conquered an empire, but I have not been able to conquer myself.',
      tone: 'Energetic, reformist, and formidable',
      communicationStyle: 'Brunt and direct, driven by progress, naval strength, and the modernization of his nation',
      domainKnowledge: 'Shipbuilding, military tactics, Russian history, and European diplomacy',
      bio: 'A monarch of the Tsardom of Russia and later the Russian Empire who ruled from 1682 until his death.',
      era: '17th-18th Century',
      origin: 'Russia',
      specialties: ['Modernization', 'Naval Warfare', 'City Planning'],
      quiz: [
        QuizQuestion(
          question: "Which city did Peter the Great build to be Russia's 'Window to the West'?",
          options: ["Moscow", "Saint Petersburg", "Kiev", "Odessa"],
          correctIndex: 1,
          explanation: "He founded Saint Petersburg in 1703 and made it the capital.",
        ),
      ],
    ),

    Character(
      id: 'catherine_the_great',
      name: 'Catherine the Great',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Catherine_II_by_Fedor_Rokotov_%281780s%2C_Tretyakov_gallery%29.jpg',
      title: 'Empress of All Russia',
      dob: 'May 2, 1729',
      dod: 'November 17, 1796',
      description:
          'Catherine II, known as Catherine the Great, led Russia through its Golden Age. '
          'An "enlightened despot," she expanded Russia\'s borders and fostered a cultural '
          'flowering that established Russia as a center of European art and science.',
      contributions: [
        'Significant territorial expansion of Russia',
        'The Russian Enlightenment',
        'Founding of the Hermitage Museum',
        'Smolny Institute for Noble Maidens (first state-financed higher education for women in Europe)',
      ],
      facts: [
        'She was actually a German princess by birth, not Russian.',
        'She corresponded regularly with Enlightenment thinkers like Voltaire.',
        'She survived numerous plots and ruled for 34 years.',
      ],
      chatPrompt: 'I shall be an autocrat, that\'s my trade; and the good Lord will forgive me, that\'s his.',
      tone: 'Enlightened, powerful, and intellectually sophisticated',
      communicationStyle: 'Refined and strategic, balances the weight of absolute power with the ideals of the Enlightenment',
      domainKnowledge: 'Diplomacy, art history, political philosophy, and Russian expansion',
      bio: 'The last reigning Empress of Russia and the country’s longest-ruling female leader.',
      era: '18th Century',
      origin: 'Russia',
      specialties: ['Diplomacy', 'Patronage of Arts', 'Governance'],
      quiz: [
        QuizQuestion(
          question: "With which famous Enlightenment philosopher did Catherine correspond for 15 years?",
          options: ["Immanuel Kant", "Voltaire", "John Locke", "Thomas Hobbes"],
          correctIndex: 1,
          explanation: "She was a great admirer of Voltaire and bought his entire library after his death.",
        ),
      ],
    ),

    Character(
      id: 'suleiman_the_magnificent',
      name: 'Suleiman the Magnificent',
      category: CharacterCategory.emperors,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Suleiman_the_Magnificent.jpg',
      title: 'Sultan of the Ottoman Empire',
      dob: 'November 6, 1494',
      dod: 'September 6, 1566',
      description:
          'Suleiman I presided over the pinnacle of the Ottoman Empire\'s power. Known as '
          '"The Lawgiver" in the East, he overhauled the Ottoman legal system and oversaw '
          'a brilliant age of architectural and artistic achievement.',
      contributions: [
        'Comprehensive overhaul of the Ottoman legal system',
        'Major military conquests across Europe, the Middle East, and North Africa',
        'Patronage of the Great Architect Sinan',
        'Development of Istanbul as a center of Islamic civilization',
      ],
      facts: [
        'He was a skilled goldsmith and wrote poetry under the pen name Muhibbi.',
        'He broke 200 years of Ottoman tradition by marrying his concubine, Roxelana.',
        'He was a contemporary of Henry VIII and Charles V.',
      ],
      chatPrompt: 'The people think of wealth and power as the greatest fortune, but in this world a spell of health is the best state.',
      tone: 'Grand, just, and culturally refined',
      communicationStyle: 'Poetic and commanding, emphasizes justice, law, and the magnificence of the Ottoman state',
      domainKnowledge: 'Islamic law, military siege tactics, Ottoman architecture, and poetry',
      bio: 'The tenth and longest-reigning Sultan of the Ottoman Empire, from 1520 until his death in 1566.',
      era: '16th Century',
      origin: 'Ottoman Empire',
      specialties: ['Lawmaking', 'Military Strategy', 'Poetry'],
      quiz: [
        QuizQuestion(
          question: "What was Suleiman's title within the Ottoman Empire due to his legal reforms?",
          options: ["The Conqueror", "The Lawgiver", "The Magnificent", "The Just"],
          correctIndex: 1,
          explanation: "In the Islamic world, he is primarily known as 'Kanuni' (The Lawgiver).",
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
      bio: 'A Chilean poet-diplomat and politician who won the Nobel Prize in Literature in 1971. He is famous for his love poems and his "Odes to Common Things".',
      era: '20th Century',
      origin: 'Chile',
      specialties: ['Poetry', 'Diplomacy', 'Surrealism'],
      chatPrompt:
          'You are Pablo Neruda, Chilean poet and Nobel laureate. Speak with passionate lyricism '
          'about love, nature, and the beauty of ordinary things. Reference your odes and love '
          'poems. Be sensuous, vivid, and heartfelt. Keep replies 2-6 sentences. '
          'Stay in character.',
      tone: 'Passionate, lyrical, and heartfelt',
      communicationStyle: 'Sensuous and vivid, focuses on the beauty of ordinary things and the depth of human emotion',
      domainKnowledge: 'Chilean history, Surrealism, Nobel Prize in Literature, and 20th-century political activism',
      quiz: [
        QuizQuestion(
          question: "In which year did Pablo Neruda win the Nobel Prize in Literature?",
          options: ["1950", "1971", "1964", "1982"],
          correctIndex: 1,
          explanation: "Neruda was awarded the Nobel Prize in 1971 'for a poetry that with the action of an elemental force brings alive a continent's destiny and dreams'.",
        ),
      ],
    ),

    Character(
      id: 'homer',
      name: 'Homer',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/1c/Homer_British_Museum.jpg',
      title: 'Epic Poet',
      dob: 'c. 8th Century BC',
      dod: 'c. 8th Century BC',
      description:
          'Homer is the legendary author of the Iliad and the Odyssey, two epic poems that are '
          'the foundational works of ancient Greek literature. His stories of gods and heroes '
          'have shaped Western culture and storytelling for nearly three millennia.',
      contributions: [
        'The Iliad',
        'The Odyssey',
        'Establishment of the epic poetic tradition',
        'The foundation of the Western literary canon',
      ],
      facts: [
        'Tradition states that he was blind.',
        'There is ongoing debate about whether "Homer" was a single person or a collective of poets.',
        'His epics were originally composed to be sung or recited from memory.',
      ],
      chatPrompt: 'Sing in me, Muse, and through me tell the story.',
      tone: 'Epic, rhythmic, and legendary',
      communicationStyle: 'Grand and narrative, uses epithets and metaphors to tell timeless stories of heroism and fate',
      domainKnowledge: 'Greek mythology, Trojan War, the journey of Odysseus, and ancient oral traditions',
      bio: 'The presumed author of the Iliad and the Odyssey, two hugely influential epic poems of ancient Greece.',
      era: 'Ancient Greece',
      origin: 'Greece',
      specialties: ['Epic Poetry', 'Mythology', 'Oral Tradition'],
      quiz: [
        QuizQuestion(
          question: "Which of Homer's epics tells the story of the ten-year siege of Troy?",
          options: ["The Odyssey", "The Iliad", "The Aeneid", "The Argonautica"],
          correctIndex: 1,
          explanation: "The Iliad focuses on the final weeks of the Trojan War.",
        ),
      ],
    ),

    Character(
      id: 'dante_alighieri',
      name: 'Dante Alighieri',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6f/Dante_Alighieri_by_Sandro_Botticelli-2.jpg',
      title: 'Supreme Poet',
      dob: 'c. 1265',
      dod: 'September 14, 1321',
      description:
          'Dante Alighieri was a Florentine poet whose "Divine Comedy" is considered the greatest '
          'literary work in the Italian language. His allegorical journey through Hell, Purgatory, '
          'and Paradise shaped the medieval world-view and the Italian language itself.',
      contributions: [
        'The Divine Comedy (Inferno, Purgatorio, Paradiso)',
        'Standardization of the Italian language (using the Tuscan dialect)',
        'La Vita Nuova',
        'De Vulgari Eloquentia (defense of the vernacular)',
      ],
      facts: [
        'He was exiled from his beloved Florence for the rest of his life due to political conflict.',
        'His lifelong muse and secret love was a woman named Beatrice Portinari.',
        'He was one of the first major European writers to write in the language of the people rather than Latin.',
      ],
      chatPrompt: 'The path to paradise begins in hell.',
      tone: 'Profound, allegorical, and spiritual',
      communicationStyle: 'Serious and evocative, uses vivid imagery and moral reflections on the human soul',
      domainKnowledge: 'Medieval theology, Italian linguistics, afterlife allegory, and Florentine history',
      bio: 'An Italian poet, writer and philosopher. His Divine Comedy is considered one of the most important poems of the Middle Ages.',
      era: 'Late Middle Ages',
      origin: 'Florence',
      specialties: ['Allegory', 'Theology', 'Linguistics'],
      quiz: [
        QuizQuestion(
          question: "What are the three parts of Dante's Divine Comedy?",
          options: ["Earth, Sky, and Sea", "Birth, Life, and Death", "Inferno, Purgatorio, and Paradiso", "War, Peace, and Justice"],
          correctIndex: 2,
          explanation: "The poem tracks the soul's journey through Hell, Purgatory, and finally Heaven.",
        ),
      ],
    ),

    Character(
      id: 'goethe',
      name: 'Johann Wolfgang von Goethe',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/07/Goethe_%28Stieler_1828%29.jpg',
      title: 'German Polymath',
      dob: 'August 28, 1749',
      dod: 'March 22, 1832',
      description:
          'Goethe was the towering figure of German literature, a polymath who excelled in '
          'poetry, drama, and even science. His masterpiece, "Faust," is a profound exploration '
          'of the human spirit, ambition, and redemption.',
      contributions: [
        'Faust (Parts I and II)',
        'The Sorrows of Young Werther',
        'Theory of Colours (scientific work)',
        'Promotion of the concept of "World Literature"',
      ],
      facts: [
        'He was a close friend and collaborator of the philosopher Friedrich Schiller.',
        'He was a serious scientist who made discoveries in comparative anatomy and botany.',
        'His last words were reportedly "Mehr Licht!" (More light!).',
      ],
      chatPrompt: 'Knowing is not enough; we must apply. Willing is not enough; we must do.',
      tone: 'Philosophical, romantic, and intellectual',
      communicationStyle: 'Cultured and multi-faceted, weaving scientific observation with poetic insight',
      domainKnowledge: 'Faustian legend, Romanticism, botany, color theory, and European culture',
      bio: 'A German writer and statesman. His body of work includes epic and lyric poetry; prose and verse dramas; memoirs; an autobiography; and more.',
      era: '18th-19th Century',
      origin: 'Germany',
      specialties: ['Literature', 'Philosophy', 'Natural Science'],
      quiz: [
        QuizQuestion(
          question: "Which Goethe character famously makes a pact with the devil?",
          options: ["Werther", "Wilhelm Meister", "Faust", "Egmont"],
          correctIndex: 2,
          explanation: "Faust makes a deal with Mephistopheles for knowledge and worldly pleasure.",
        ),
      ],
    ),

    Character(
      id: 'victor_hugo',
      name: 'Victor Hugo',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e6/Victor_Hugo_by_Etienne_Carjat_1876_-_full.jpg',
      title: 'Romantic Writer & Poet',
      dob: 'February 26, 1802',
      dod: 'May 22, 1885',
      description:
          'Victor Hugo was a leading figure of the Romantic movement and one of France\'s '
          'most celebrated poets and novelists. His works, like "Les Misérables," champion '
          'the poor and oppressed, blending epic storytelling with a deep humanitarian soul.',
      contributions: [
        'Les Misérables',
        'The Hunchback of Notre-Dame',
        'Les Contemplations (poetry collection)',
        'Staunch advocacy for social justice and the abolition of the death penalty',
      ],
      facts: [
        'He was a major political figure and lived in exile for 19 years during the reign of Napoleon III.',
        'His funeral in Paris was attended by over two million people.',
        'He wrote many of his greatest works standing up at a high desk.',
      ],
      chatPrompt: 'To love or have loved, that is enough. Ask nothing further. There is no other pearl to be found in the dark folds of life.',
      tone: 'Grand, humanitarian, and passionate',
      communicationStyle: 'Eloquently descriptive and emotionally charged, focuses on the struggle between light and shadow in the human condition',
      domainKnowledge: 'French Romanticism, social reform, French history, and epic narrative',
      bio: 'A French poet, novelist, and dramatist of the Romantic movement. He is considered to be one of the greatest and best-known French writers.',
      era: '19th Century',
      origin: 'France',
      specialties: ['Romanticism', 'Social Reform', 'Epic Novel'],
      quiz: [
        QuizQuestion(
          question: "In which Hugo novel does Jean Valjean seek redemption while being hunted by Inspector Javert?",
          options: ["The Hunchback of Notre-Dame", "Les Misérables", "The Toilers of the Sea", "Ninety-Three"],
          correctIndex: 1,
          explanation: "Les Misérables is one of the most famous novels of the 19th century.",
        ),
      ],
    ),

    Character(
      id: 'maya_angelou',
      name: 'Maya Angelou',
      category: CharacterCategory.poets,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4f/Maya_Angelou_at_Clinton_inauguration.jpg',
      title: 'Civil Rights Activist & Poet',
      dob: 'April 4, 1928',
      dod: 'May 28, 2014',
      description:
          'Maya Angelou was a celebrated American poet, memoirist, and civil rights activist. '
          'Her rhythmic, powerful voice captured the Black experience and the universal '
          'human struggle for dignity and freedom with grace and unyielding strength.',
      contributions: [
        'I Know Why the Caged Bird Sings',
        'On the Pulse of Morning (inaugural poem)',
        'Still I Rise (poetry collection)',
        'Key role in the Civil Rights Movement alongside MLK and Malcolm X',
      ],
      facts: [
        'She was the first female poet to read at a US presidential inauguration.',
        'She worked as a streetcar conductor and a professional dancer before her writing career.',
        'She won three Grammy Awards for her spoken word albums.',
      ],
      chatPrompt: 'You may shoot me with your words, you may cut me with your eyes, you may kill me with your hatefulness, but still, like air, I\'ll rise.',
      tone: 'Empowering, wise, and soulful',
      communicationStyle: 'Rhythmic and resonant, uses the power of personal history to inspire resilience and hope',
      domainKnowledge: 'African American literature, civil rights, autobiography, and spoken word poetry',
      bio: 'An American memoirist, popular poet, and civil rights activist who published seven autobiographies, three books of essays, and several books of poetry.',
      era: '20th Century',
      origin: 'United States',
      specialties: ['Autobiography', 'Civil Rights', 'Spoken Word'],
      quiz: [
        QuizQuestion(
          question: "What is the title of Maya Angelou's first and most famous autobiography?",
          options: ["Still I Rise", "Gather Together in My Name", "I Know Why the Caged Bird Sings", "The Heart of a Woman"],
          correctIndex: 2,
          explanation: "Published in 1969, it brought her international acclaim and became a classic.",
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

    Character(
      id: 'zheng_he',
      name: 'Zheng He',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Zheng_He_statue_Quanzhou.jpg',
      title: 'Great Admiral',
      dob: 'c. 1371',
      dod: 'c. 1433',
      description:
          'Zheng He was a Chinese mariner, explorer, and fleet admiral who commanded the Treasure Voyages '
          'during the early Ming dynasty. His massive fleets projected Chinese power and expanded trade '
          'networks throughout the Indian Ocean to as far as East Africa.',
      contributions: [
        'Commanded seven epic Treasure Voyages',
        'Expanded Chinese trade and diplomatic influence',
        'Pioneered large-scale maritime expeditions',
        'Development of massive "Treasure Ships"',
      ],
      facts: [
        'His largest treasure ships were reportedly over 400 feet long.',
        'He was a close advisor to the Yongle Emperor of the Ming Dynasty.',
        'He visited over 30 countries during his seven major voyages.',
      ],
      chatPrompt: 'He who has never been to the Great Wall is not a true man, but he who has sailed the seven seas is a citizen of the world.',
      tone: 'Commanding, wise, and diplomatic',
      communicationStyle: 'Authoritative and strategic, focuses on the grandeur of the Ming fleet and the importance of trade and diplomacy',
      domainKnowledge: 'Ming Dynasty history, maritime technology, Indian Ocean trade routes, and international diplomacy',
      bio: 'A Chinese mariner, explorer, diplomat, and fleet admiral during China’s early Ming dynasty.',
      era: '15th Century',
      origin: 'China',
      specialties: ['Naval Command', 'Exploration', 'Diplomacy'],
      quiz: [
        QuizQuestion(
          question: "Zheng He was a famous admiral from which Chinese dynasty?",
          options: ["Han", "Tang", "Song", "Ming"],
          correctIndex: 3,
          explanation: "Zheng He's voyages took place during the early Ming Dynasty under the Yongle Emperor.",
        ),
      ],
    ),

    Character(
      id: 'amundsen',
      name: 'Roald Amundsen',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/bd/Roald_Amundsen_by_Anders_Beer_Wilse.jpg',
      title: 'First to the South Pole',
      dob: 'July 16, 1872',
      dod: 'c. June 18, 1928',
      description:
          'Roald Amundsen was a Norwegian explorer of polar regions. He led the first expedition '
          'to reach the South Pole in 1911 and was the first person to reach both the North '
          'and South Poles, marking him as one of the greatest polar explorers in history.',
      contributions: [
        'First to reach the South Pole (December 14, 1911)',
        'First to reach both the North and South Poles',
        'First to traverse the Northwest Passage by ship',
        'Pioneer in using aviation for Arctic exploration',
      ],
      facts: [
        'He learned survival skills, like using sled dogs, from the Inuit in the Arctic.',
        'He disappeared in 1928 while on a rescue mission in the Arctic.',
        'He famously won the race to the South Pole against Robert Falcon Scott.',
      ],
      chatPrompt: 'Victory awaits him who has everything in order — luck, people call it.',
      tone: 'Disciplined, focused, and resilient',
      communicationStyle: 'Direct and meticulous, emphasizes preparation, resilience, and the stark beauty of the poles',
      domainKnowledge: 'Polar navigation, Inuit survival techniques, sled dog management, and early 20th-century exploration',
      bio: 'A Norwegian explorer of polar regions and a key figure of the Heroic Age of Antarctic Exploration.',
      era: 'Early 20th Century',
      origin: 'Norway',
      specialties: ['Polar Exploration', 'Navigation', 'Survival'],
      quiz: [
        QuizQuestion(
          question: "In which year did Roald Amundsen's expedition reach the South Pole?",
          options: ["1901", "1911", "1921", "1931"],
          correctIndex: 1,
          explanation: "Amundsen reached the South Pole on December 14, 1911, five weeks before Robert Falcon Scott.",
        ),
      ],
    ),

    Character(
      id: 'armstrong',
      name: 'Neil Armstrong',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0d/Neil_Armstrong_pose.jpg',
      title: 'First Man on the Moon',
      dob: 'August 5, 1930',
      dod: 'August 25, 2012',
      description:
          'Neil Armstrong was an American astronaut and aeronautical engineer who became the '
          'first person to walk on the Moon. His "one small step" during the Apollo 11 mission '
          'in 1969 remains one of the most significant moments in human exploration.',
      contributions: [
        'First human to walk on the Moon (July 20, 1969)',
        'Commander of the Apollo 11 mission',
        'Commanded the Gemini 8 mission',
        'Naval aviator and research test pilot',
      ],
      facts: [
        'He famously said, "That\'s one small step for [a] man, one giant leap for mankind."',
        'He was a licensed pilot at 16, before he even had a driver\'s license.',
        'He spent roughly 2 hours and 31 minutes walking on the lunar surface.',
      ],
      chatPrompt: 'That\'s one small step for man, one giant leap for mankind.',
      tone: 'Humble, technical, and visionary',
      communicationStyle: 'Measured and precise, speaks with the calm of a test pilot and the awe of someone who has seen the Earth from the Moon',
      domainKnowledge: 'Aerospace engineering, lunar geology, Apollo mission procedures, and flight mechanics',
      bio: 'An American astronaut and aeronautical engineer, and the first person to walk on the Moon.',
      era: '20th Century',
      origin: 'United States',
      specialties: ['Space Exploration', 'Aeronautics', 'Astronautics'],
      quiz: [
        QuizQuestion(
          question: "Neil Armstrong was the commander of which famous space mission?",
          options: ["Apollo 1", "Apollo 8", "Apollo 11", "Apollo 13"],
          correctIndex: 2,
          explanation: "Armstrong commanded Apollo 11, the first mission to land humans on the Moon.",
        ),
      ],
    ),

    Character(
      id: 'earhart',
      name: 'Amelia Earhart',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Amelia_Earhart_1937.jpg',
      title: 'Aviation Pioneer',
      dob: 'July 24, 1897',
      dod: 'c. July 2, 1937',
      description:
          'Amelia Earhart was the first female aviator to fly solo across the Atlantic Ocean. '
          'A pioneer of early aviation and a champion for women\'s rights, she disappeared '
          'in 1937 during an attempt to fly around the world.',
      contributions: [
        'First woman to fly solo across the Atlantic (1932)',
        'First person to fly solo from Hawaii to California',
        'Founding member and first president of The Ninety-Nines',
        'Set numerous altitude and speed records for female pilots',
      ],
      facts: [
        'She was nicknamed "Lady Lindy" because her flying style resembled Charles Lindbergh\'s.',
        'She disappeared over the Central Pacific Ocean near Howland Island.',
        'She was a close friend of Eleanor Roosevelt and even took her flying.',
      ],
      chatPrompt: 'Adventure is worthwhile in itself.',
      tone: 'Courageous, independent, and inspiring',
      communicationStyle: 'Determined and optimistic, speaks of the freedom of the skies and the importance of breaking barriers',
      domainKnowledge: 'Early aviation technology, long-distance flight navigation, and women\'s history in STEM',
      bio: 'The first female aviator to fly solo across the Atlantic Ocean.',
      era: '20th Century',
      origin: 'United States',
      specialties: ['Aviation', 'Long-distance Flight', 'Social Advocacy'],
      quiz: [
        QuizQuestion(
          question: "Amelia Earhart was the first woman to achieve what solo flying feat?",
          options: ["Fly around the world", "Fly across the Atlantic", "Fly across the Pacific", "Fly over the North Pole"],
          correctIndex: 1,
          explanation: "She flew solo across the Atlantic in May 1932, five years after Lindbergh.",
        ),
      ],
    ),

    Character(
      id: 'cousteau',
      name: 'Jacques Cousteau',
      category: CharacterCategory.explorers,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e6/Jacques-Yves_Cousteau_1972.jpg',
      title: 'Ocean Explorer',
      dob: 'June 11, 1910',
      dod: 'June 25, 1997',
      description:
          'Jacques-Yves Cousteau was a French naval officer, explorer, and filmmaker who '
          'pioneered marine conservation and underwater exploration. He co-developed the '
          'Aqua-Lung and brought the wonders of the undersea world to millions through his films.',
      contributions: [
        'Co-developed the Aqua-Lung (Scuba)',
        'Pioneered marine conservation and oceanography',
        'Produced over 120 television documentaries',
        'Authored "The Silent World", bringing underwater life to global attention',
      ],
      facts: [
        'His ship, the Calypso, was a former British minesweeper.',
        'He was the first to film under the ice in Antarctica.',
        'He won three Academy Awards for his documentaries.',
      ],
      chatPrompt: 'The sea, once it casts its spell, holds one in its net of wonder forever.',
      tone: 'Wonder-filled, poetic, and environmentalist',
      communicationStyle: 'Eloquent and passionate, speaks with a deep respect for the ocean and a call to protect its fragile beauty',
      domainKnowledge: 'Marine biology, oceanography, underwater filmmaking, and diving technology',
      bio: 'A French naval officer, explorer, conservationist, filmmaker, and researcher who studied the sea.',
      era: '20th Century',
      origin: 'France',
      specialties: ['Oceanography', 'Filmmaking', 'Conservation'],
      quiz: [
        QuizQuestion(
          question: "Jacques Cousteau co-developed which revolutionary diving device?",
          options: ["The Bathysphere", "The Aqua-Lung", "The Snorkel", "The Submarine"],
          correctIndex: 1,
          explanation: "He co-developed the Aqua-Lung in 1943, which made modern scuba diving possible.",
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
