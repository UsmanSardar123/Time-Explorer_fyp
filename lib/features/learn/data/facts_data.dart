/// 100 unique, verified historical and world facts
const List<Map<String, String>> historicalFacts = [
  {
    'fact': 'The Great Wall of China is approximately 21,196 kilometres (13,171 miles) long in total.',
    'category': 'Architecture',
  },
  {
    'fact': 'Cleopatra lived closer in time to the Moon landing (1969) than to the construction of the Great Pyramid of Giza (2560 BC).',
    'category': 'History',
  },
  {
    'fact': 'Oxford University is older than the Aztec Empire. Teaching started at Oxford in 1096 AD, while the Aztec Empire was founded in 1428 AD.',
    'category': 'History',
  },
  {
    'fact': 'The Roman Empire, at its greatest extent, covered about 5 million km² — roughly the size of the European Union today.',
    'category': 'History',
  },
  {
    'fact': 'Woolly mammoths were still alive when the Egyptians were building the Great Pyramid of Giza.',
    'category': 'Nature',
  },
  {
    'fact': 'The shortest war in history was between Britain and Zanzibar, lasting only 38–45 minutes in 1896.',
    'category': 'History',
  },
  {
    'fact': 'Ancient Egyptians used moldy bread as an antibiotic for infected wounds — unknowingly using penicillin millennia before Fleming\'s discovery.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'Nintendo was founded in 1889 — as a playing card company.',
    'category': 'Modern History',
  },
  {
    'fact': 'The Eiffel Tower can grow by up to 15 cm during summer as the iron expands in the heat.',
    'category': 'Science',
  },
  {
    'fact': 'More people have walked on the Moon (12) than have ever been to the deepest point of the ocean, the Mariana Trench.',
    'category': 'Exploration',
  },
  {
    'fact': 'The Library of Alexandria wasn\'t destroyed in one dramatic fire — it declined gradually over centuries through neglect and multiple events.',
    'category': 'Ancient History',
  },
  {
    'fact': 'The Colosseum in Rome could hold between 50,000 and 80,000 spectators and had a retractable linen shade called the "velarium."',
    'category': 'Architecture',
  },
  {
    'fact': 'Shakespeare invented over 1,700 words still used today, including "bedroom," "lonely," and "generous."',
    'category': 'Literature',
  },
  {
    'fact': 'The ancient city of Pompeii was buried under 4–6 metres of volcanic ash and pumice after Mount Vesuvius erupted in 79 AD.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'The Viking Erik the Red was banished from Iceland for manslaughter, then discovered and colonised Greenland.',
    'category': 'Exploration',
  },
  {
    'fact': 'Ancient Greeks brushed their teeth using a paste made from crushed charcoal, bark, oyster shells, and even urine.',
    'category': 'Ancient Greece',
  },
  {
    'fact': 'The First World War saw soldiers on both sides celebrate Christmas in 1914 by temporarily laying down arms and playing football in No Man\'s Land.',
    'category': 'Modern History',
  },
  {
    'fact': 'Machu Picchu was built around 1450 AD by the Inca emperor Pachacuti as a royal estate.',
    'category': 'Architecture',
  },
  {
    'fact': 'The Black Death (1347–1351) killed 30–60% of Europe\'s total population — an estimated 25 million people.',
    'category': 'History',
  },
  {
    'fact': 'Napoleon Bonaparte was not unusually short. He was approximately 5\'7" (170 cm), average for a Frenchman of his era.',
    'category': 'Myths Busted',
  },
  {
    'fact': 'Ancient Egyptians worshipped over 2,000 deities, with Ra, Osiris, and Isis among the most important.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'The Byzantines (Eastern Roman Empire) survived for nearly 1,000 years after the fall of the Western Roman Empire in 476 AD.',
    'category': 'History',
  },
  {
    'fact': 'Leonardo da Vinci designed a functional robotic knight in 1495, centuries before modern robotics.',
    'category': 'Science',
  },
  {
    'fact': 'The oldest known written recipe is for beer, dating back to ancient Sumer around 1800 BC.',
    'category': 'Ancient History',
  },
  {
    'fact': 'During the Cold War, the US seriously considered dropping nuclear bombs on the Moon to demonstrate military power.',
    'category': 'Modern History',
  },
  {
    'fact': 'The Great Sphinx of Giza was originally painted in bright colours — red, yellow, and blue.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'Isaac Newton was 23 years old when he developed his laws of gravity during the Great Plague of 1665, while working in quarantine.',
    'category': 'Science',
  },
  {
    'fact': 'The Silk Road trade routes stretched over 6,400 km and linked China to the Mediterranean world.',
    'category': 'Trade',
  },
  {
    'fact': 'Ancient Romans used powdered mouse brains as toothpaste.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'Genghis Khan\'s Mongol Empire was the largest contiguous empire in history, spanning 24 million km².',
    'category': 'History',
  },
  {
    'fact': 'The astronauts of Apollo 11 were quarantined for 21 days after returning from the Moon in case they brought back lunar bacteria.',
    'category': 'Exploration',
  },
  {
    'fact': 'The construction of the Notre-Dame Cathedral in Paris took 182 years to complete (1163–1345).',
    'category': 'Architecture',
  },
  {
    'fact': 'Julius Caesar was once kidnapped by pirates. After he was ransomed, he returned and crucified them.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'The Taj Mahal was built by Mughal Emperor Shah Jahan in memory of his wife Mumtaz Mahal and took 22 years to complete (1632–1654).',
    'category': 'Architecture',
  },
  {
    'fact': 'Ancient Greeks did not use the word "blue." Homer\'s works never mention the sky as blue — he called the sea "wine-dark."',
    'category': 'Ancient Greece',
  },
  {
    'fact': 'King Tutankhamun was only 9 when he became Pharaoh of Egypt, and died at approximately 18 years of age.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'The first map of the Moon was drawn by British astronomer William Gilbert in 1602, 67 years before the first Moon landing.',
    'category': 'Exploration',
  },
  {
    'fact': 'The city of Carthage (modern-day Tunisia) was so thoroughly destroyed by Rome in 146 BC that its exact site was lost for centuries.',
    'category': 'Ancient History',
  },
  {
    'fact': 'The Great Pyramid of Giza was the world\'s tallest man-made structure for over 3,800 years.',
    'category': 'Architecture',
  },
  {
    'fact': 'Ancient Mesopotamians (Sumerians) invented writing around 3200 BC, primarily for economic record-keeping.',
    'category': 'Ancient History',
  },
  {
    'fact': 'The Battle of Thermopylae (480 BC) saw 300 Spartans hold off a Persian army estimated at 100,000–300,000 soldiers for three days.',
    'category': 'Ancient Greece',
  },
  {
    'fact': 'Nikola Tesla could memorise entire books and visualise three-dimensional objects in his mind with perfect accuracy.',
    'category': 'Science',
  },
  {
    'fact': 'The Aztec city of Tenochtitlán (modern Mexico City) had a population of 200,000–300,000 — larger than any European city at the time.',
    'category': 'History',
  },
  {
    'fact': 'The first passenger railway in the world was the Liverpool and Manchester Railway, opened on 15 September 1830.',
    'category': 'Modern History',
  },
  {
    'fact': 'In ancient Rome, it was considered good luck to wear a charm in the shape of a phallus. They were everywhere — on wind chimes, jewellery, even bakeries.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'Albert Einstein was offered the presidency of Israel in 1952. He respectfully declined.',
    'category': 'Modern History',
  },
  {
    'fact': 'Hadrian\'s Wall in northern England stretched 117 km and was completed around 128 AD to protect Rome\'s northernmost frontier.',
    'category': 'Architecture',
  },
  {
    'fact': 'The first public zoo in the world opened in Paris in 1793 — the Ménagerie du Jardin des Plantes — during the French Revolution.',
    'category': 'Modern History',
  },
  {
    'fact': 'The human eye can see the Andromeda Galaxy — 2.537 million light-years away — with the naked eye on a clear night.',
    'category': 'Science',
  },
  {
    'fact': 'Ancient Egyptians shaved their eyebrows to mourn the death of a cat.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'Attila the Hun died from a nosebleed on his wedding night, not in battle.',
    'category': 'History',
  },
  {
    'fact': 'The pyramids of Giza were originally covered in polished white Tura limestone, making them shine brightly in the desert sun.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'A Viking burial ship dating back to 800 AD was discovered near Oslo in 1904 and is now on display in a museum — fully intact.',
    'category': 'Vikings',
  },
  {
    'fact': 'The Great Wall of China was NOT visible from space. This is a popular myth — the wall is too narrow (4–5 metres wide) to be seen unaided.',
    'category': 'Myths Busted',
  },
  {
    'fact': 'The industrial revolution began in Britain around 1760 and transformed manufacturing, transportation, and daily life within 100 years.',
    'category': 'Modern History',
  },
  {
    'fact': 'Michelangelo was 72 years old when he was appointed chief architect of St. Peter\'s Basilica in Rome.',
    'category': 'Architecture',
  },
  {
    'fact': 'The Dead Sea Scrolls, discovered in 1947, include some of the oldest surviving manuscripts of the Hebrew Bible.',
    'category': 'Archaeology',
  },
  {
    'fact': 'Troy, the city from Homer\'s Iliad, was a real place in modern-day Turkey (Hisarlık), discovered by archaeologist Heinrich Schliemann in 1868.',
    'category': 'Archaeology',
  },
  {
    'fact': 'The first photograph ever taken was in 1826 by French inventor Joseph Nicéphore Niépce. It took an 8-hour exposure to produce.',
    'category': 'Modern History',
  },
  {
    'fact': 'The Khajuraho temples in India, famous for their erotic carvings, were built between 950 and 1050 AD.',
    'category': 'Architecture',
  },
  {
    'fact': 'Hannibal Barca crossed the Alps in 218 BC with 37 war elephants to attack Rome from the north — a feat considered impossible at the time.',
    'category': 'Ancient History',
  },
  {
    'fact': 'Marie Curie remains the only person ever to win Nobel Prizes in two different sciences — Physics (1903) and Chemistry (1911).',
    'category': 'Science',
  },
  {
    'fact': 'The ancient city of Babylon (in modern Iraq) once had walls so thick that chariots could be raced on top of them.',
    'category': 'Ancient History',
  },
  {
    'fact': 'Teotihuacán, near Mexico City, was once one of the largest cities in the world — with a population of ~125,000 in 450 AD.',
    'category': 'History',
  },
  {
    'fact': 'The Inca built a road system of over 40,000 km — all without the wheel, metal tools, or written language.',
    'category': 'Architecture',
  },
  {
    'fact': 'The oldest living tree in the world is a Great Basin Bristlecone Pine called "Methuselah" — approximately 4,855 years old.',
    'category': 'Nature',
  },
  {
    'fact': 'In medieval Europe, it was common to have "second sleep" — people would wake up in the middle of the night for a couple of hours before sleeping again.',
    'category': 'History',
  },
  {
    'fact': 'The Gutenberg Bible (1455) was the first major book printed using movable type, revolutionising the spread of knowledge.',
    'category': 'Modern History',
  },
  {
    'fact': 'Chinese general Sun Tzu wrote "The Art of War" around 500 BC. It is still taught in military schools and business schools worldwide.',
    'category': 'History',
  },
  {
    'fact': 'Petra, the ancient rock-carved city in Jordan, was built by the Nabataean Arabs around 300 BC and housed ~20,000 people.',
    'category': 'Architecture',
  },
  {
    'fact': 'The Colosseum was originally called the Flavian Amphitheatre. It earned the name "Colosseum" from the giant statue of Nero nearby.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'During World War II, the Iraqis discovered oil near Kirkuk in 1927, but it was hidden to prevent German forces from using it.',
    'category': 'Modern History',
  },
  {
    'fact': 'Stonehenge was built in multiple stages between 3000 BC and 1500 BC. The purpose of the monument remains debated by archaeologists.',
    'category': 'Archaeology',
  },
  {
    'fact': 'The Persian Emperor Xerxes I had a bridge of boats built across the Hellespont (Dardanelles) for his army to cross — twice.',
    'category': 'Ancient History',
  },
  {
    'fact': 'Dinosaurs went extinct around 66 million years ago, but birds are technically avian dinosaurs and continue to thrive today.',
    'category': 'Nature',
  },
  {
    'fact': 'The ancient Indus Valley Civilisation (2600–1900 BC) had remarkably advanced urban planning — including indoor toilets and sewage systems.',
    'category': 'Ancient History',
  },
  {
    'fact': 'The first known peace treaty in history was between the Egyptian Pharaoh Ramesses II and the Hittite King Hattusili III in 1259 BC.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'The city of Carthage was destroyed so completely by Rome that the exact site was uncertain for centuries.',
    'category': 'Ancient History',
  },
  {
    'fact': 'Captain James Cook mapped the entire coastline of New Zealand in 1769 in just six months aboard the HMS Endeavour.',
    'category': 'Exploration',
  },
  {
    'fact': 'The Mongol Empire was so vast that it helped transmit the Black Death across Eurasia via trade routes in the 14th century.',
    'category': 'History',
  },
  {
    'fact': 'A gladiator\'s diet in ancient Rome was primarily vegetarian — consisting of beans, barley, and dried fruit.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'The first long-distance oil pipeline in the world was built in 1878 in Pennsylvania, stretching 174 km.',
    'category': 'Modern History',
  },
  {
    'fact': 'The Mayan calendar was so precise that its error was only 1 day per 6,000 years — more accurate than the Julian calendar.',
    'category': 'History',
  },
  {
    'fact': 'Vesuvius wasn\'t the only volcano to destroy a Roman town in 79 AD — nearby Herculaneum and Stabiae were also buried.',
    'category': 'Ancient Rome',
  },
  {
    'fact': 'Charles Darwin spent 5 years on the HMS Beagle voyage (1831–1836) that would lead directly to his theory of evolution.',
    'category': 'Science',
  },
  {
    'fact': 'The Battle of Waterloo (1815) was decided in part by rain — muddy ground delayed Napoleon\'s attack and allowed allied reinforcements to arrive.',
    'category': 'Modern History',
  },
  {
    'fact': 'Ancient Chinese used blank tiles in dominoes as the "wild" card — the game was brought to Europe in the 18th century.',
    'category': 'History',
  },
  {
    'fact': 'The first woman to win a Nobel Prize was Marie Curie in 1903 — 107 years before the second woman won the Nobel Prize in Physics.',
    'category': 'Science',
  },
  {
    'fact': 'The ancient Egyptians had a calendar of 365 days — divided into 12 months of 30 days each, plus 5 "extra" days.',
    'category': 'Ancient Egypt',
  },
  {
    'fact': 'The original Olympic Games in ancient Greece (776 BC) were held in honour of Zeus and competitors competed naked.',
    'category': 'Ancient Greece',
  },
  {
    'fact': 'The Sahara Desert was once a lush, green savannah teeming with life — as recently as 7,000 years ago.',
    'category': 'Nature',
  },
  {
    'fact': 'The Angkor Wat temple complex in Cambodia is the world\'s largest religious monument, covering ~162 hectares.',
    'category': 'Architecture',
  },
  {
    'fact': 'Antarctica has no time zone. Scientists and researchers there use the time zone of their home country.',
    'category': 'Geography',
  },
  {
    'fact': 'The first computer virus was created in 1971 — called "Creeper" — and could replicate itself across early ARPANET networks.',
    'category': 'Modern History',
  },
  {
    'fact': 'The concept of zero as a number was developed in ancient India around the 5th century AD.',
    'category': 'Science',
  },
  {
    'fact': 'The Roman Pantheon has been in continuous use for nearly 2,000 years and its unreinforced concrete dome remains the world\'s largest.',
    'category': 'Architecture',
  },
  {
    'fact': 'Alexander the Great never lost a single battle in his 15-year military campaign that stretched from Greece to modern-day Pakistan.',
    'category': 'Ancient History',
  },
  {
    'fact': 'The human brain generates about 70,000 thoughts per day — though scientists debate the exact number.',
    'category': 'Science',
  },
  {
    'fact': 'The ancient city of Çatalhöyük (Turkey), inhabited 9,000 years ago, had no streets — residents climbed ladders to enter through rooftop openings.',
    'category': 'Archaeology',
  },
  {
    'fact': 'Honey never spoils. Archaeologists have found pots of honey in ancient Egyptian tombs that are over 3,000 years old and still perfectly edible.',
    'category': 'Science',
  },
  {
    'fact': 'A day on Venus is longer than a year on Venus. It takes Venus 243 Earth days to rotate on its axis, but only 225 Earth days to orbit the Sun.',
    'category': 'Space',
  },
  {
    'fact': 'Bananas are classified as berries, but strawberries are not. In botanical terms, berries must develop from one flower with one ovary.',
    'category': 'Botany',
  },
  {
    'fact': 'Wombat poop is cube-shaped. They produce nearly 100 cubic droppings a night, and the shape stops them from rolling away.',
    'category': 'Nature',
  },
  {
    'fact': 'There are more trees on Earth than stars in the Milky Way. There are roughly 3 trillion trees on Earth, compared to 100-400 billion stars in the galaxy.',
    'category': 'Science',
  },
  {
    'fact': 'Scotland has 421 words for "snow". Examples include "snaw" (snow), "sneesl" (to begin to rain or snow), and "flindrikin" (a slight snow shower).',
    'category': 'Language',
  },
  {
    'fact': 'Peanuts aren\'t technically nuts. They are legumes, belonging to the same family as beans, lentils, and peas.',
    'category': 'Botany',
  },
  {
    'fact': 'The Eiffel Tower can be 15 cm taller during the summer. The thermal expansion of the iron structure causes it to grow in the heat.',
    'category': 'Architecture',
  },
  {
    'fact': 'Octopuses have three hearts. Two pump blood to the gills, and one pumps it to the rest of the body.',
    'category': 'Nature',
  },
  {
    'fact': 'The letter "J" was the last added to the English alphabet. It was introduced around the 1520s by Gian Giorgio Trissino.',
    'category': 'Language',
  },
  {
    'fact': 'Sloths can hold their breath longer than dolphins can. By slowing their heart rates, sloths can hold their breath for up to 40 minutes under water.',
    'category': 'Nature',
  },
  {
    'fact': 'A jiffy is an actual unit of time. In physics, a jiffy is the time it takes light to travel one centimeter in a vacuum (about 33.3564 picoseconds).',
    'category': 'Science',
  },
  {
    'fact': 'Some cats are actually allergic to humans. It\'s relatively rare, but feline allergies to human dander do occur.',
    'category': 'Nature',
  },
  {
    'fact': 'The longest English word without a true vowel is "rhythms".',
    'category': 'Language',
  },
  {
    'fact': 'Mantis shrimp can punch with the speed of a bullet. Their club-like appendages accelerate at 10,400 g (102,000 m/s^2).',
    'category': 'Nature',
  },
  {
    'fact': 'Australia is wider than the moon. The moon is about 3,400 km in diameter, while Australia\'s diameter from east to west is almost 4,000 km.',
    'category': 'Geography',
  },
  {
    'fact': 'Venus is the only planet to spin clockwise. All other planets in the solar system spin counterclockwise.',
    'category': 'Space',
  },
  {
    'fact': 'A single strand of spaghetti is called a "spaghetto".',
    'category': 'Language',
  },
  {
    'fact': 'Human teeth are the only part of the body that cannot heal themselves. Teeth are coated in enamel, which is not a living tissue.',
    'category': 'Human Body',
  },
  {
    'fact': 'Cows have best friends and get stressed when separated. Studies show their heart rates increase when they are away from their preferred companions.',
    'category': 'Nature',
  },
  {
    'fact': 'Competitive art used to be an Olympic sport. Between 1912 and 1948, medals were awarded for literature, architecture, sculpture, painting, and music.',
    'category': 'History',
  },
  {
    'fact': 'Pineapples take about two years to grow. They are grown from the crown of a previously harvested pineapple.',
    'category': 'Botany',
  },
  {
    'fact': 'The longest place name on the planet is 85 letters long: "Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu" in New Zealand.',
    'category': 'Geography',
  },
  {
    'fact': 'There\'s only one U.S. state capital without a McDonald\'s: Montpelier, Vermont.',
    'category': 'Geography',
  },
  {
    'fact': 'Armadillo shells are bulletproof. In rare instances, bullets have ricocheted off armadillos and hit the shooter.',
    'category': 'Nature',
  },
  {
    'fact': 'Fingernails grow four times faster than toenails.',
    'category': 'Human Body',
  },
  {
    'fact': 'Water makes different sounds depending on its temperature. Hot water sounds fundamentally lower in pitch when poured than cold water.',
    'category': 'Science',
  },
  {
    'fact': 'Pigs cannot look up into the sky. Their neck anatomy makes it physically impossible.',
    'category': 'Nature',
  },
  {
    'fact': 'It is impossible to hum while holding your nose. Try it!',
    'category': 'Human Body',
  },
  {
    'fact': 'Maine is the closest U.S. state to Africa.',
    'category': 'Geography',
  },
  {
    'fact': 'There is a boss in Japan who gives non-smokers six extra vacation days to make up for the time smokers take for breaks.',
    'category': 'Modern History',
  },
  {
    'fact': 'A flock of flamingos is called a "flamboyance".',
    'category': 'Language',
  },
  {
    'fact': 'Before the invention of alarm clocks, there were "knocker-uppers" who shot peas at people\'s windows to wake them up for work.',
    'category': 'History',
  },
  {
    'fact': 'A group of pandas is called an "embarrassment".',
    'category': 'Language',
  },
  {
    'fact': 'Polar bear fur is not white. It\'s actually translucent, and their skin is black.',
    'category': 'Nature',
  },
  {
    'fact': 'The unicorn is the national animal of Scotland.',
    'category': 'Geography',
  },
  {
    'fact': 'Tears contain a natural painkiller called leucine enkephalin.',
    'category': 'Human Body',
  },
  {
    'fact': 'The 100 folds in a chef\'s hat represent 100 ways to cook an egg.',
    'category': 'Culture',
  },
  {
    'fact': 'New Zealand has more sheep than people. At its peak in 1982, there were 22 sheep for every person.',
    'category': 'Geography',
  },
  {
    'fact': 'Some fungi create zombies, then control their minds. Ophiocordyceps unilateralis famously turns ants into "zombies" to reproduce.',
    'category': 'Nature',
  },
  {
    'fact': 'The world\'s highest waterfall is underwater. The Denmark Strait cataract drops roughly 3,500 meters (11,500 ft).',
    'category': 'Geography',
  },
  {
    'fact': 'Hippopotamus milk is pink.',
    'category': 'Nature',
  },
  {
    'fact': 'High heels were originally worn by aristocratic men in the 10th century to help them stay securely in their stirrups when riding horses.',
    'category': 'History',
  },
  {
    'fact': 'Ketchup was once sold as medicine in the 1830s to treat ailments like diarrhea, indigestion, and jaundice.',
    'category': 'History',
  },
  {
    'fact': 'Animals can be allergic to humans, especially to human dander.',
    'category': 'Nature',
  },
  {
    'fact': 'Bamboo can grow up to 35 inches in a single day, making it the fastest-growing plant in the world.',
    'category': 'Botany',
  },
  {
    'fact': 'Kangaroos cannot walk backwards.',
    'category': 'Nature',
  },
  {
    'fact': 'An octopus can fit through any hole larger than its beak, which is roughly the size of a parrot\'s beak.',
    'category': 'Nature',
  },
  {
    'fact': 'Butterflies taste with their feet. Their taste sensors are located there to quickly identify edible plants.',
    'category': 'Nature',
  },
  {
    'fact': 'Dolphins have names for one another. They use unique whistles to identify each individual dolphin.',
    'category': 'Nature',
  },
  {
    'fact': 'Sea otters hold hands when they sleep so they don\'t drift apart.',
    'category': 'Nature',
  },
  {
    'fact': 'Your nose and ears never stop growing throughout your life.',
    'category': 'Human Body',
  },
  {
    'fact': 'There are more possible iterations of a game of chess than there are atoms in the observable universe.',
    'category': 'Science',
  },
  {
    'fact': 'The moon has "moonquakes" caused by the gravitational stress from Earth.',
    'category': 'Space',
  },
  {
    'fact': 'Apples float in water because they are 25% air.',
    'category': 'Science',
  },
  {
    'fact': 'Cheetahs cannot roar like lions or tigers. Instead, they meow and purr like domestic cats.',
    'category': 'Nature',
  },
  {
    'fact': 'Tomatoes are formally classified as fruits, specifically berries.',
    'category': 'Botany',
  },
  {
    'fact': 'The Hawaiian alphabet consists of only 13 letters: five vowels and eight consonants.',
    'category': 'Language',
  },
  {
    'fact': 'Humans blink about 15-20 times per minute, which adds up to roughly 10% of our waking hours spent with our eyes closed.',
    'category': 'Human Body',
  },
  {
    'fact': 'It would take a sloth about one month to travel a single mile.',
    'category': 'Nature',
  },
  {
    'fact': 'Pluto hasn\'t made a full orbit around the sun since it was discovered in 1930. It will complete its first orbit in 2178.',
    'category': 'Space',
  },
  {
    'fact': 'You can’t breathe and swallow at the same time.',
    'category': 'Human Body',
  },
  {
    'fact': 'Rabbits can see behind them without turning their heads because their eyes are positioned on the sides of their skull.',
    'category': 'Nature',
  },
  {
    'fact': 'In a room of 23 people, there\'s a 50% chance two of them share a birthday. This is known as the Birthday Paradox.',
    'category': 'Math',
  },
  {
    'fact': 'Snails have teeth—up to 14,000 of them, depending on the species, arranged in rows on their tongue.',
    'category': 'Nature',
  },
  {
    'fact': 'A Boeing 747 needs about 1 gallon of fuel every second to fly.',
    'category': 'Technology',
  },
  {
    'fact': 'A snail can sleep for up to three years at a time.',
    'category': 'Nature',
  },
  {
    'fact': 'Owls don\'t have eyeballs. They have eye tubes, meaning they can\'t move their eyes inside their heads.',
    'category': 'Nature',
  },
  {
    'fact': 'The heart of a blue whale is the size of a small car.',
    'category': 'Nature',
  },
  {
    'fact': 'Tigers have striped skin, not just striped fur.',
    'category': 'Nature',
  },
  {
    'fact': 'Dragonflies have six legs but they cannot walk well.',
    'category': 'Nature',
  },
  {
    'fact': 'An ostrich’s eye is larger than its brain.',
    'category': 'Nature',
  },
  {
    'fact': 'Starfish don\'t have a brain. They do, however, have a complex nervous system scattered throughout their arms.',
    'category': 'Nature',
  },
  {
    'fact': 'Jupiter is the fastest spinning planet in our solar system, completing a rotation in just under 10 hours.',
    'category': 'Space',
  },
  {
    'fact': 'Grapes light on fire in the microwave due to a phenomenon where plasma is created between the grape halves.',
    'category': 'Science',
  },
  {
    'fact': 'The hashtag symbol (#) is technically called an octothorpe.',
    'category': 'Language',
  },
  {
    'fact': 'Crickets have ears on their front legs, just below their knees.',
    'category': 'Nature',
  },
  {
    'fact': 'An ant\'s sense of smell is stronger than a dog\'s.',
    'category': 'Nature',
  },
  {
    'fact': 'Sharks existed before trees. The first sharks appeared 400 million years ago, while trees only appeared 350 million years ago.',
    'category': 'Nature',
  },
  {
    'fact': 'Giraffes have no vocal cords, but recent studies suggest they hum to each other at night at incredibly low frequencies.',
    'category': 'Nature',
  },
  {
    'fact': 'Ice is technically considered a mineral.',
    'category': 'Science',
  },
  {
    'fact': 'Peafowl is the correct generic term. "Peacock" applies only to the male, and "peahen" applies to the female.',
    'category': 'Nature',
  },
  {
    'fact': 'Your stomach gets a new lining every few days to protect itself from digesting itself.',
    'category': 'Human Body',
  },
  {
    'fact': 'Only 5% of the ocean has been explored by humans.',
    'category': 'Geography',
  },
  {
    'fact': 'Mount Everest grows approximately 4 millimeters taller every year due to tectonic plates colliding.',
    'category': 'Geography',
  },
  {
    'fact': 'The oldest surviving piece of chewing gum is over 9,000 years old.',
    'category': 'History',
  },
  {
    'fact': 'Hummingbirds are the only birds that can fly backwards.',
    'category': 'Nature',
  },
  {
    'fact': 'Bees can recognize human faces.',
    'category': 'Nature',
  },
  {
    'fact': 'A bolt of lightning contains enough energy to toast 100,000 slices of bread.',
    'category': 'Science',
  },
  {
    'fact': 'Pangolins have scales made of keratin, the same material as human hair and fingernails.',
    'category': 'Nature',
  },
  {
    'fact': 'Elephants are the only animals that can\'t jump.',
    'category': 'Nature',
  },
  {
    'fact': 'A tarantula can live up to two years without food.',
    'category': 'Nature',
  },
  {
    'fact': 'Goats have rectangular pupils, giving them a field of vision of 320 to 340 degrees.',
    'category': 'Nature',
  },
  {
    'fact': 'Koalas sleep up to 22 hours entirely motionless to conserve energy from their exclusively eucalyptus diet.',
    'category': 'Nature',
  },
  {
    'fact': 'The indentation in the middle of your upper lip is called the philtrum.',
    'category': 'Human Body',
  },
  {
    'fact': 'Turtles can breathe out of their butts through a process called cloacal respiration.',
    'category': 'Nature',
  },
  {
    'fact': 'Crocodiles can\'t stick their tongues out. It\'s held in place by a membrane at the bottom of their mouths.',
    'category': 'Nature',
  },
  {
    'fact': 'A day on Pluto lasts equivalent to 153 Earth hours.',
    'category': 'Space',
  },
  {
    'fact': 'Earth is the only planet not named after a god.',
    'category': 'Space',
  },
  {
    'fact': 'A blue whale\'s tongue can weigh as much as an elephant.',
    'category': 'Nature',
  },
  {
    'fact': 'It takes a drop of water 90 days to travel the entire Mississippi River.',
    'category': 'Geography',
  }
];
