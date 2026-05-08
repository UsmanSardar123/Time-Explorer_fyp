import '../../domain/entities/event_category.dart';
import '../../domain/entities/historical_event.dart';
import '../models/historical_event_model.dart';

class EventStaticDataSource {
  static const _base = 'https://upload.wikimedia.org/wikipedia/commons/thumb';

  static final List<HistoricalEventModel> _events = [
    // ── Wars & Conflicts ──────────────────────────────────────────────────────
    HistoricalEventModel(
      id: 'war_001',
      title: 'Battle of Marathon',
      category: EventCategory.warsAndConflicts,
      period: '490 BC',
      location: 'Marathon, Greece',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/b/bc/Battle_of_Marathon.png/800px-Battle_of_Marathon.png',
        'assets/images/events/war_001.png',
      ],
      galleryUrls: const [
        '$_base/5/5b/Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg/800px-Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg',
        '$_base/4/44/Akropolis_by_Leo_von_Klenze.jpg/800px-Akropolis_by_Leo_von_Klenze.jpg',
      ],
      description:
          'The Battle of Marathon was a decisive Athenian victory over the invading Persian army of Darius I. '
          'Outnumbered roughly three to one, the Athenian army and their Plataean allies routed the Persian forces, '
          'ending the first Persian invasion of Greece and demonstrating that the Persian Empire could be defeated. '
          'The victory preserved Greek democracy and established Athens as a preeminent military power.',
      timeline: const [
        TimelinePoint(date: 'August 490 BC', description: 'Persian fleet lands at Marathon Bay with ~25,000 troops'),
        TimelinePoint(date: 'September 490 BC', description: 'Athenian generals debate strategy; Miltiades argues for immediate attack'),
        TimelinePoint(date: '12 September 490 BC', description: 'Battle commences — Athenian wings envelop Persian flanks'),
        TimelinePoint(date: 'After battle', description: 'Pheidippides runs ~40 km to Athens to announce victory'),
        TimelinePoint(date: '490 BC', description: 'Persian fleet sails around Attica but retreats; first invasion repelled'),
      ],
      keyFacts: const [
        '~10,000 Athenians vs ~25,000 Persians',
        'Athens lost ~192 men; Persians ~6,400',
        'Origin of the modern marathon race',
        'First defeat of a Persian land army by Greeks',
        'Saved nascent Athenian democracy',
      ],
      latitude: 38.1130,
      longitude: 23.9785,
    ),

    HistoricalEventModel(
      id: 'war_006',
      title: 'Battle of Thermopylae',
      category: EventCategory.warsAndConflicts,
      period: '480 BC',
      location: 'Thermopylae, Greece',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5b/Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg/800px-Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Leonidas_I_-_Sparta.jpg/640px-Leonidas_I_-_Sparta.jpg',
      ],
      galleryUrls: const [
        '$_base/6/67/Heliocentric.jpg/640px-Heliocentric.jpg',
        '$_base/4/44/Akropolis_by_Leo_von_Klenze.jpg/800px-Akropolis_by_Leo_von_Klenze.jpg',
      ],
      description:
          'At the narrow coastal pass of Thermopylae, King Leonidas I of Sparta and his 300 elite Spartans — '
          'backed by roughly 7,000 Greek allies — held back Xerxes I\'s vast Persian army for three days. '
          'Betrayed by a local who revealed a mountain path, the Greeks were surrounded. Leonidas dismissed '
          'most allies and fought to the last man, buying time for Greece to prepare. Their sacrifice became '
          'the greatest symbol of courage in Western military history.',
      timeline: const [
        TimelinePoint(date: 'Spring 480 BC', description: 'Xerxes I crosses the Hellespont with an army estimated at 100,000–300,000 men'),
        TimelinePoint(date: 'July 480 BC', description: 'Leonidas arrives at Thermopylae with 300 Spartans and 7,000 Greek allies'),
        TimelinePoint(date: 'Day 1–2', description: 'Persian infantry attack repeatedly; Greek phalanx repels every assault'),
        TimelinePoint(date: 'Day 3 morning', description: 'Ephialtes reveals the Anopaia mountain path to the Persians'),
        TimelinePoint(date: 'Day 3', description: 'Leonidas sends most Greeks away; 300 Spartans and allies fight to the death'),
        TimelinePoint(date: '480 BC', description: 'Greek fleet wins at Salamis; Persians retreat — Thermopylae delay proves decisive'),
      ],
      keyFacts: const [
        '300 Spartans held off an army of hundreds of thousands',
        'Fought to the last man after being surrounded',
        'Inspired Greek unity against the Persian invasion',
        'Battle of Salamis victory followed within months',
        '"Molon labe" — Come and take them — Leonidas\'s legendary reply',
      ],
      latitude: 38.7954,
      longitude: 22.5318,
    ),

    HistoricalEventModel(
      id: 'war_007',
      title: 'The First Crusade',
      category: EventCategory.warsAndConflicts,
      period: '1096–1099 AD',
      location: 'Europe to Jerusalem',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/3/3e/Crusades-Godfrey_of_Bouillon.jpg/640px-Crusades-Godfrey_of_Bouillon.jpg',
        'assets/images/events/war_007.png',
      ],
      galleryUrls: const [
        '$_base/9/9c/Genghis_Khan_empire.png/800px-Genghis_Khan_empire.png',
        '$_base/e/e1/Henry_V_from_NPG.jpg/640px-Henry_V_from_NPG.jpg',
      ],
      description:
          'Pope Urban II\'s 1095 call to arms at Clermont launched the First Crusade — a military campaign '
          'to recapture Jerusalem from Seljuk Turkish control. Tens of thousands of knights, nobles, and '
          'common folk marched 5,000 km across Europe and the Middle East. After three years of brutal '
          'sieges, Crusader forces captured Jerusalem in July 1099, establishing the Latin Kingdom of '
          'Jerusalem and reshaping Christian-Muslim relations for centuries.',
      timeline: const [
        TimelinePoint(date: 'Nov 1095', description: 'Pope Urban II preaches the Crusade at Council of Clermont'),
        TimelinePoint(date: '1096', description: 'People\'s Crusade — 40,000 civilians march; annihilated in Anatolia'),
        TimelinePoint(date: '1097', description: 'Princes\' Crusade captures Nicaea and Dorylaeum'),
        TimelinePoint(date: 'Jun–Jul 1098', description: 'Crusaders besiege and capture Antioch after 8 months'),
        TimelinePoint(date: 'Jul 1099', description: 'Jerusalem stormed after 5-week siege; city taken on July 15'),
      ],
      keyFacts: const [
        'First of nine major Crusades over 200 years',
        'Jerusalem captured July 15, 1099',
        'Created four Crusader states in the Levant',
        'Launched 200 years of Christian-Muslim conflict',
        'Reopened trade routes between East and West',
      ],
    ),

    HistoricalEventModel(
      id: 'war_002',
      title: 'Mongol Sack of Baghdad',
      category: EventCategory.warsAndConflicts,
      period: '1258 AD',
      location: 'Baghdad, Iraq',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/6/6d/Hulagu.jpg/640px-Hulagu.jpg',
        'assets/images/events/war_002.png',
      ],
      galleryUrls: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        '$_base/9/9c/Genghis_Khan_empire.png/800px-Genghis_Khan_empire.png',
      ],
      description:
          'The Mongol sack of Baghdad in 1258 was one of the most devastating events in Islamic history. '
          'Hulagu Khan\'s forces besieged and sacked the Abbasid capital, killing Caliph Al-Musta\'sim and '
          'destroying the House of Wisdom. Hundreds of thousands died and centuries of accumulated knowledge '
          'were lost as the Tigris reportedly ran black with ink from destroyed manuscripts.',
      timeline: const [
        TimelinePoint(date: 'January 1258', description: 'Mongol forces of Hulagu Khan surround Baghdad'),
        TimelinePoint(date: '29 Jan 1258', description: 'Caliph Al-Musta\'sim rejects demands for surrender'),
        TimelinePoint(date: '5 Feb 1258', description: 'Mongols breach the eastern city walls'),
        TimelinePoint(date: '10 Feb 1258', description: 'Caliph surrenders; city sacked for 7 days'),
        TimelinePoint(date: '20 Feb 1258', description: 'Caliph executed; Abbasid Caliphate ends after 508 years'),
      ],
      keyFacts: const [
        'Est. 200,000–800,000 people killed',
        'House of Wisdom and its vast library destroyed',
        'Ended the 500-year Abbasid Caliphate',
        'Tigris ran black with ink from destroyed books',
        'Ended the Islamic Golden Age',
      ],
    ),

    HistoricalEventModel(
      id: 'war_003',
      title: 'Battle of Agincourt',
      category: EventCategory.warsAndConflicts,
      period: '1415 AD',
      location: 'Agincourt, France',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/1/11/Battle_of_agincourt.jpg/800px-Battle_of_agincourt.jpg',
        'assets/images/events/war_003.png',
      ],
      galleryUrls: const [
        '$_base/e/e1/Henry_V_from_NPG.jpg/640px-Henry_V_from_NPG.jpg',
        '$_base/b/bc/Battle_of_Marathon.png/800px-Battle_of_Marathon.png',
      ],
      description:
          'Henry V of England led a battle-worn, outnumbered English army to a stunning victory over the much '
          'larger French force at Agincourt. The English longbowmen proved devastatingly effective against '
          'French cavalry charging across muddy ground. The battle became one of England\'s most celebrated '
          'military victories and was immortalised by Shakespeare in his play Henry V.',
      timeline: const [
        TimelinePoint(date: 'Aug 1415', description: 'Henry V invades France; captures Harfleur'),
        TimelinePoint(date: 'Oct 1415', description: 'Henry\'s exhausted army of ~6,000 marches for Calais'),
        TimelinePoint(date: '24 Oct 1415', description: 'French army blocks the road at Agincourt'),
        TimelinePoint(date: '25 Oct 1415', description: 'Battle begins — English archers devastate French knights'),
        TimelinePoint(date: '25 Oct 1415', description: 'French cavalry mired in mud; English secure victory'),
      ],
      keyFacts: const [
        'English outnumbered by at least 2:1',
        'Longbow range: 250 metres with armour-piercing arrows',
        '~6,000 French killed vs ~400 English',
        'Inspired Shakespeare\'s Henry V (1599)',
        'Key to the Treaty of Troyes (1420)',
      ],
    ),

    HistoricalEventModel(
      id: 'war_004',
      title: 'Battle of Waterloo',
      category: EventCategory.warsAndConflicts,
      period: '18 June 1815',
      location: 'Waterloo, Belgium',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/9/95/Battle_of_Waterloo_1815.PNG/800px-Battle_of_Waterloo_1815.PNG',
        'assets/images/events/war_004.png',
      ],
      galleryUrls: const [
        '$_base/5/50/Napoleon_Bonaparte.jpg/640px-Napoleon_Bonaparte.jpg',
        '$_base/3/3e/Duke_of_Wellington_by_Goya.jpg/640px-Duke_of_Wellington_by_Goya.jpg',
      ],
      description:
          'The Battle of Waterloo marked Napoleon Bonaparte\'s final defeat at the hands of the Duke of '
          'Wellington\'s Anglo-allied army and Prussian forces under Field Marshal Blücher. Napoleon\'s '
          'gamble during the "Hundred Days" campaign ended in catastrophic defeat. He abdicated four days '
          'later and was exiled to Saint Helena, ending 23 years of French Revolutionary and Napoleonic Wars.',
      timeline: const [
        TimelinePoint(date: '1 Mar 1815', description: 'Napoleon escapes Elba and returns to France'),
        TimelinePoint(date: '16 Jun 1815', description: 'Napoleon defeats Prussians at Ligny'),
        TimelinePoint(date: '18 Jun 1815', description: 'Battle commences; French attack Wellington\'s ridge'),
        TimelinePoint(date: '18 Jun 1815 7PM', description: 'Prussians arrive on Napoleon\'s flank; tide turns'),
        TimelinePoint(date: '22 Jun 1815', description: 'Napoleon abdicates; exiled to Saint Helena'),
      ],
      keyFacts: const [
        '~73,000 French vs ~118,000 Allied forces',
        '~47,000 total casualties over one day',
        'Napoleon exiled to Saint Helena where he died in 1821',
        'Reshaped European borders at the Congress of Vienna',
        '"Waterloo" became a byword for decisive defeat',
      ],
    ),

    HistoricalEventModel(
      id: 'war_008',
      title: 'World War I — Battle of the Somme',
      category: EventCategory.warsAndConflicts,
      period: '1 July – 18 November 1916',
      location: 'Somme River, France',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/4/49/Cheshire_Regiment_trench_Somme_1916.jpg/800px-Cheshire_Regiment_trench_Somme_1916.jpg',
        'assets/images/events/war_008.png',
      ],
      galleryUrls: const [
        '$_base/3/37/Eisenhower_meets_with_paratroopers_of_502nd.jpg/800px-Eisenhower_meets_with_paratroopers_of_502nd.jpg',
        '$_base/6/66/Normandy_June_1944_British_troops.jpg/800px-Normandy_June_1944_British_troops.jpg',
      ],
      description:
          'The Battle of the Somme was one of the largest and bloodiest battles in human history, fought '
          'during World War I. On the first day alone — July 1, 1916 — the British Army suffered nearly '
          '57,000 casualties, including almost 20,000 killed. The battle introduced tank warfare for the '
          'first time. After 141 days of industrial-scale slaughter in the mud, Allied forces advanced just '
          '12 km. It became a defining symbol of the futility and horror of trench warfare.',
      timeline: const [
        TimelinePoint(date: 'Jul 1914', description: 'Assassination of Archduke Franz Ferdinand triggers WWI'),
        TimelinePoint(date: '1915–1916', description: 'Western Front stalemates in trench warfare'),
        TimelinePoint(date: '1 Jul 1916', description: 'British infantry advance — 57,470 casualties on Day 1'),
        TimelinePoint(date: '15 Sep 1916', description: 'Tanks used in warfare for the first time'),
        TimelinePoint(date: '18 Nov 1916', description: 'Battle ends; ~1.2 million total casualties'),
      ],
      keyFacts: const [
        '57,470 British casualties on Day 1 alone',
        'Total casualties: over 1 million across both sides',
        'First use of tanks in warfare (September 15, 1916)',
        'British artillery fired 1.5 million shells before the attack',
        'Advanced only 12 km over 141 days of fighting',
      ],
    ),

    HistoricalEventModel(
      id: 'war_009',
      title: 'Battle of Stalingrad',
      category: EventCategory.warsAndConflicts,
      period: '23 August 1942 – 2 February 1943',
      location: 'Stalingrad, Soviet Union',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/f/fd/Bundesarchiv_Bild_183-W0506-316%2C_Russland%2C_Kampf_um_Stalingrad%2C_Vormarsch.jpg/640px-Bundesarchiv_Bild_183-W0506-316%2C_Russland%2C_Kampf_um_Stalingrad%2C_Vormarsch.jpg',
        'assets/images/events/war_009.png',
      ],
      galleryUrls: const [
        '$_base/9/9c/Aldrin_Apollo_11_original.jpg/800px-Aldrin_Apollo_11_original.jpg',
        '$_base/a/a5/Into_the_Jaws_of_Death_23-0455M_edit.jpg/800px-Into_the_Jaws_of_Death_23-0455M_edit.jpg',
      ],
      description:
          'The Battle of Stalingrad was the turning point of World War II on the Eastern Front. Germany\'s '
          'Sixth Army fought Soviet forces in brutal house-to-house urban combat for over five months. '
          'Soviet forces encircled and trapped 300,000 German troops. Field Marshal Paulus surrendered '
          'in February 1943 — the first German field marshal ever to surrender. The defeat ended German '
          'offensive capability in the east.',
      timeline: const [
        TimelinePoint(date: 'Aug 1942', description: 'German 6th Army reaches Volga; bombing begins'),
        TimelinePoint(date: 'Sep–Nov 1942', description: 'Urban combat in the ruins of the city'),
        TimelinePoint(date: '19 Nov 1942', description: 'Soviet forces encircle the German 6th Army'),
        TimelinePoint(date: 'Dec 1942', description: 'German relief attempt fails'),
        TimelinePoint(date: '2 Feb 1943', description: 'Final German surrender; 91,000 survivors taken prisoner'),
      ],
      keyFacts: const [
        'Largest battle in human history — ~2 million total casualties',
        'German 6th Army of 300,000 completely destroyed',
        'Turning point — Germany never recovered strategically in the East',
        'Soviet sniper Vasily Zaitsev became a national hero',
        'Paulus was the first German field marshal to surrender',
      ],
    ),

    HistoricalEventModel(
      id: 'war_005',
      title: 'D-Day — Normandy Landings',
      category: EventCategory.warsAndConflicts,
      period: '6 June 1944',
      location: 'Normandy, France',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/a5/Into_the_Jaws_of_Death_23-0455M_edit.jpg/800px-Into_the_Jaws_of_Death_23-0455M_edit.jpg',
        'assets/images/events/war_005.png',
      ],
      galleryUrls: const [
        '$_base/6/66/Normandy_June_1944_British_troops.jpg/800px-Normandy_June_1944_British_troops.jpg',
        '$_base/3/37/Eisenhower_meets_with_paratroopers_of_502nd.jpg/800px-Eisenhower_meets_with_paratroopers_of_502nd.jpg',
      ],
      description:
          'Operation Overlord — the Normandy landings — was the largest seaborne invasion in history. '
          'Allied forces stormed five beaches codenamed Utah, Omaha, Gold, Juno and Sword. The operation '
          'opened a decisive Western Front in World War II and led directly to the liberation of '
          'Western Europe from Nazi occupation.',
      timeline: const [
        TimelinePoint(date: '5 Jun midnight', description: 'Paratroopers drop behind enemy lines'),
        TimelinePoint(date: '6 Jun 6:30 AM', description: 'Naval bombardment begins; vessels approach'),
        TimelinePoint(date: '6 Jun 7:30 AM', description: 'Five Allied divisions storm the beaches'),
        TimelinePoint(date: '6 Jun evening', description: 'All beachheads secured; 156,000 troops ashore'),
        TimelinePoint(date: '25 Aug 1944', description: 'Paris liberated; Allied advance continues'),
      ],
      keyFacts: const [
        '156,000 Allied troops landed on D-Day alone',
        '5 beaches: Utah, Omaha, Gold, Juno, Sword',
        '~10,000 Allied casualties on June 6',
        'Largest naval armada ever assembled',
        'Germany surrendered less than 11 months later',
      ],
    ),

    HistoricalEventModel(
      id: 'war_010',
      title: 'Vietnam War',
      category: EventCategory.warsAndConflicts,
      period: '1955–1975',
      location: 'Vietnam, Southeast Asia',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/7/7e/UH-1D_helicopters_in_Vietnam_War.jpg/800px-UH-1D_helicopters_in_Vietnam_War.jpg',
        'assets/images/events/war_010.png',
      ],
      galleryUrls: const [
        '$_base/3/3e/Duke_of_Wellington_by_Goya.jpg/640px-Duke_of_Wellington_by_Goya.jpg',
        '$_base/5/50/Napoleon_Bonaparte.jpg/640px-Napoleon_Bonaparte.jpg',
      ],
      description:
          'The Vietnam War was a Cold War-era conflict between communist North Vietnam and South Vietnam '
          '(backed by the United States). The US deployed over 2.7 million troops in a guerrilla war '
          'they could not win. The Tet Offensive of 1968 shattered public confidence. US forces withdrew '
          'in 1973; Saigon fell in 1975. The war killed an estimated 3.5 million people.',
      timeline: const [
        TimelinePoint(date: '1954', description: 'Dien Bien Phu; Vietnam split at 17th parallel'),
        TimelinePoint(date: '1964', description: 'Gulf of Tonkin incident; full US intervention'),
        TimelinePoint(date: 'Jan 1968', description: 'Tet Offensive shocks US public'),
        TimelinePoint(date: '1973', description: 'US forces withdraw following Peace Accords'),
        TimelinePoint(date: '30 Apr 1975', description: 'Saigon falls; war ends with communist victory'),
      ],
      keyFacts: const [
        '2.7 million US troops served; 58,000 died',
        'An estimated 3.5 million Vietnamese killed',
        'First "television war" — broadcast globally',
        'Tet Offensive was the political turning point',
        'Last US helicopter evacuated Saigon April 30, 1975',
      ],
    ),

    // ── Revolutions & Political Events ────────────────────────────────────────
    HistoricalEventModel(
      id: 'rev_001',
      title: 'Magna Carta',
      category: EventCategory.revolutionsAndPolitical,
      period: '1215 AD',
      location: 'Runnymede, England',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/e/eb/Magna_Carta_%28British_Library_Cotton_MS_Augustus_II.106%29.jpg/400px-Magna_Carta_%28British_Library_Cotton_MS_Augustus_II.106%29.jpg',
        'assets/images/events/rev_001.png',
      ],
      galleryUrls: const [
        '$_base/9/9b/King_John_signing_Magna_Carta.jpg/640px-King_John_signing_Magna_Carta.jpg',
        '$_base/8/89/Parliament_of_Great_Britain_%281707%29.jpg/640px-Parliament_of_Great_Britain_%281707%29.jpg',
      ],
      description:
          'The Magna Carta was sealed by King John of England under pressure from rebel barons. It '
          'established that the king was subject to the rule of law. Its principles influenced the '
          'US Constitution, the Bill of Rights, and modern democratic systems worldwide.',
      timeline: const [
        TimelinePoint(date: 'May 1215', description: 'Rebel barons capture London'),
        TimelinePoint(date: '15 Jun 1215', description: 'Magna Carta sealed at Runnymede'),
        TimelinePoint(date: 'Aug 1215', description: 'Charter annulled; civil war resumes'),
        TimelinePoint(date: '1225', description: 'Definitive version issued; becomes permanent law'),
      ],
      keyFacts: const [
        'First document limiting English royal power',
        'Established habeas corpus principles',
        'Directly influenced the US Constitution (1787)',
        'Basis of modern constitutional democracies',
        '63 clauses protecting rights of citizens and Church',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_006',
      title: 'The Protestant Reformation',
      category: EventCategory.revolutionsAndPolitical,
      period: '1517 AD',
      location: 'Wittenberg, Germany',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5f/Lucas_Cranach_the_Elder-_Martin_Luther%2C_1528.jpg/640px-Lucas_Cranach_the_Elder-_Martin_Luther%2C_1528.jpg',
        'assets/images/events/rev_006.png',
      ],
      galleryUrls: const [
        '$_base/1/13/Gutenberg_Bible.jpg/640px-Gutenberg_Bible.jpg',
        '$_base/8/8f/US_declaration_independence.jpg/800px-US_declaration_independence.jpg',
      ],
      description:
          'Martin Luther ignited a religious revolution by nailing his 95 Theses to the door of Wittenberg '
          'Castle Church. This split Western Christianity into Catholic and Protestant branches, triggering '
          'centuries of religious and political transformation in Europe.',
      timeline: const [
        TimelinePoint(date: '31 Oct 1517', description: 'Luther posts 95 Theses attacking indulgences'),
        TimelinePoint(date: '1521', description: 'Diet of Worms; Luther declared a heretic'),
        TimelinePoint(date: '1555', description: 'Peace of Augsburg gives rights to Lutheran princes'),
        TimelinePoint(date: '1618–1648', description: 'Thirty Years\' War devastates Europe'),
      ],
      keyFacts: const [
        'Split Christianity into Catholic and Protestant',
        'Enabled by Gutenberg\'s printing press',
        'Luther translated the Bible into German (1522)',
        'Led to the Thirty Years\' War',
        'Laid groundwork for freedom of conscience',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_002',
      title: 'American Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1775–1783',
      location: 'Thirteen Colonies, North America',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/9/92/EmmanuelLeutze.jpg/800px-EmmanuelLeutze.jpg',
        'assets/images/events/rev_002.png',
      ],
      galleryUrls: const [
        '$_base/8/8f/US_declaration_independence.jpg/800px-US_declaration_independence.jpg',
        '$_base/a/a4/Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg/640px-Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg',
      ],
      description:
          'The American Revolution transformed thirteen colonies into the United States of America — the '
          'first modern nation founded on Enlightenment principles of liberty and self-government. The '
          'Declaration of Independence (1776) became a template for democratic governance worldwide.',
      timeline: const [
        TimelinePoint(date: '1773', description: 'Boston Tea Party'),
        TimelinePoint(date: '19 Apr 1775', description: 'Battles of Lexington and Concord'),
        TimelinePoint(date: '4 Jul 1776', description: 'Declaration of Independence signed'),
        TimelinePoint(date: '19 Oct 1781', description: 'British surrender at Yorktown'),
        TimelinePoint(date: '3 Sep 1783', description: 'Treaty of Paris recognises US independence'),
      ],
      keyFacts: const [
        'First modern democratic republic',
        'Declaration of Independence: July 4, 1776',
        'Constitution ratified September 17, 1787',
        'George Washington becomes first president',
        'Inspired the French Revolution',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_003',
      title: 'French Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1789–1799',
      location: 'France',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/57/Liberty_Leading_the_People.jpg/800px-Liberty_Leading_the_People.jpg',
        'assets/images/events/rev_003.png',
      ],
      galleryUrls: const [
        '$_base/a/aa/Prisonrobespierreconciergerie.jpg/640px-Prisonrobespierreconciergerie.jpg',
        '$_base/9/92/EmmanuelLeutze.jpg/800px-EmmanuelLeutze.jpg',
      ],
      description:
          'The French Revolution abolished the monarchy and established a republic, spreading ideals of '
          'liberty, equality, and fraternity across Europe. It culminated in the rise of Napoleon Bonaparte '
          ' and permanently changed the relationship between governments and citizens.',
      timeline: const [
        TimelinePoint(date: '14 Jul 1789', description: 'Storming of the Bastille'),
        TimelinePoint(date: '26 Aug 1789', description: 'Declaration of the Rights of Man'),
        TimelinePoint(date: '21 Jan 1793', description: 'King Louis XVI guillotined'),
        TimelinePoint(date: '1793–1794', description: 'Reign of Terror under Robespierre'),
        TimelinePoint(date: 'Nov 1799', description: 'Napoleon\'s coup ends the Revolution'),
      ],
      keyFacts: const [
        'Overthrew a 1,000-year-old monarchy',
        '~17,000 executed during the Reign of Terror',
        'Spread "Liberté, Égalité, Fraternité" worldwide',
        'Abolished feudalism across Europe',
        'Inspired Latin American independence',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_007',
      title: 'Haitian Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1791–1804',
      location: 'Saint-Domingue (Haiti)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5b/Toussaint_L%27Ouverture.jpg/640px-Toussaint_L%27Ouverture.jpg',
        'assets/images/events/rev_007.png',
      ],
      galleryUrls: const [
        '$_base/5/57/Liberty_Leading_the_People.jpg/800px-Liberty_Leading_the_People.jpg',
        '$_base/a/aa/Prisonrobespierreconciergerie.jpg/640px-Prisonrobespierreconciergerie.jpg',
      ],
      description:
          'The Haitian Revolution was the only successful slave revolt in history, transforming the colony '
          'into the independent Republic of Haiti. Led by Toussaint L\'Ouverture, it defeated the French, '
          'Spanish, and British armies, becoming the world\'s first Black republic.',
      timeline: const [
        TimelinePoint(date: 'Aug 1791', description: 'Enslaved people launch massive uprising'),
        TimelinePoint(date: '1801', description: 'L\'Ouverture proclaims himself Governor'),
        TimelinePoint(date: '1803', description: 'Haitian forces defeat French at Vertières'),
        TimelinePoint(date: '1 Jan 1804', description: 'Haiti declares independence'),
      ],
      keyFacts: const [
        'Only successful large-scale slave revolt in history',
        'Created the world\'s first Black republic',
        'Second independent nation in the Americas',
        'Abolished slavery permanently in 1804',
        'Inspired abolitionist movements worldwide',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_008',
      title: 'Indian Independence Movement',
      category: EventCategory.revolutionsAndPolitical,
      period: '1857–1947',
      location: 'British India',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/7/7a/Mahatma-Gandhi%2C_studio%2C_1931.jpg/640px-Mahatma-Gandhi%2C_studio%2C_1931.jpg',
        'assets/images/events/rev_008.png',
      ],
      galleryUrls: const [
        '$_base/4/47/Nicholas_II_of_Russia.jpg/640px-Nicholas_II_of_Russia.jpg',
        '$_base/7/70/Red_army_1917-1922.jpg/640px-Red_army_1917-1922.jpg',
      ],
      description:
          'India won independence from the British Empire through a long struggle led by Mahatma Gandhi\'s '
          'doctrine of non-violent civil disobedience. The movement mobilised millions and finally ended '
          'British rule in 1947, though the continent was partitioned into India and Pakistan.',
      timeline: const [
        TimelinePoint(date: '1857', description: 'First major rebellion against British rule'),
        TimelinePoint(date: '1930', description: 'Gandhi leads the Salt March to defy salt tax'),
        TimelinePoint(date: '1942', description: 'Quit India Movement launched'),
        TimelinePoint(date: '15 Aug 1947', description: 'India and Pakistan become independent'),
      ],
      keyFacts: const [
        'Gandhi\'s non-violence doctrine influenced the world',
        'Salt March (1930) was a pivotal turning point',
        'Independence Day: August 15, 1947',
        'Partition displaced 10–20 million people',
        'Inspired civil rights leaders like MLK Jr.',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_004',
      title: 'Russian Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1917',
      location: 'Russia',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/d6/Lenin_Kremlin_museum_portrait.jpg/640px-Lenin_Kremlin_museum_portrait.jpg',
        'assets/images/events/rev_004.png',
      ],
      galleryUrls: const [
        '$_base/7/70/Red_army_1917-1922.jpg/640px-Red_army_1917-1922.jpg',
        '$_base/4/47/Nicholas_II_of_Russia.jpg/640px-Nicholas_II_of_Russia.jpg',
      ],
      description:
          'The Russian Revolution dismantled the Romanov dynasty and brought the Bolsheviks to power. '
          'The October Revolution replaced the government with a Soviet state, leading to the formation '
          'of the USSR and sparking communist movements worldwide.',
      timeline: const [
        TimelinePoint(date: 'Feb 1917', description: 'Tsar Nicholas II abdicates after protests'),
        TimelinePoint(date: 'Oct 1917', description: 'Bolsheviks storm the Winter Palace'),
        TimelinePoint(date: '1917–1922', description: 'Civil War between Red and White armies'),
        TimelinePoint(date: '30 Dec 1922', description: 'USSR is formally declared'),
      ],
      keyFacts: const [
        'Ended the 300-year Romanov dynasty',
        'Led to the formation of the USSR',
        'World\'s first socialist state',
        'Triggered global communist movements',
        'Nicholas II and family executed July 1918',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_009',
      title: 'Chinese Communist Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1927–1949',
      location: 'China',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/8/8c/Tiananmen_after_1949_1959.jpg/640px-Tiananmen_after_1949_1959.jpg',
        'assets/images/events/rev_009.png',
      ],
      galleryUrls: const [
        '$_base/d/d6/Lenin_Kremlin_museum_portrait.jpg/640px-Lenin_Kremlin_museum_portrait.jpg',
        '$_base/a/ae/Thefalloftheberlinwall1989.JPG/800px-Thefalloftheberlinwall1989.JPG',
      ],
      description:
          'After decades of civil war, the Communist Party led by Mao Zedong emerged victorious over the '
          'Nationalists. On 1 October 1949, Mao proclaimed the People\'s Republic of China, establishing '
          'the most populous communist state in history.',
      timeline: const [
        TimelinePoint(date: '1934–1935', description: 'Long March — 9,000 km strategic retreat'),
        TimelinePoint(date: '1937–1945', description: 'War against Japanese invasion'),
        TimelinePoint(date: '1946–1949', description: 'Final phase of the Civil War'),
        TimelinePoint(date: '1 Oct 1949', description: 'Proclamation of the People\'s Republic'),
      ],
      keyFacts: const [
        'World\'s most populous communist state',
        'Long March forged the Communist army',
        'Nationalists retreated to Taiwan',
        'Created a major shift in global geopolitics',
        'Mao Zedong becomes paramount leader',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_010',
      title: 'End of Apartheid',
      category: EventCategory.revolutionsAndPolitical,
      period: '1948–1994',
      location: 'South Africa',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/0/02/Nelson_Mandela_1994.jpg/640px-Nelson_Mandela_1994.jpg',
        'assets/images/events/rev_010.png',
      ],
      galleryUrls: const [
        '$_base/7/79/Checkpoint_Charlie_1961-10-27.jpg/800px-Checkpoint_Charlie_1961-10-27.jpg',
        '$_base/3/37/Berlinermauer.jpg/640px-Berlinermauer.jpg',
      ],
      description:
          'Nelson Mandela led the resistance against South Africa\'s institutionalised racial segregation. '
          'After 27 years in prison, his release and subsequent election as president marked the peaceful '
          'end of Apartheid and a major victory for human rights.',
      timeline: const [
        TimelinePoint(date: '1948', description: 'Apartheid laws implemented'),
        TimelinePoint(date: '1964', description: 'Mandela sentenced to life imprisonment'),
        TimelinePoint(date: '1990', description: 'Mandela released from prison'),
        TimelinePoint(date: '27 Apr 1994', description: 'First fully democratic election in South Africa'),
      ],
      keyFacts: const [
        'Mandela imprisoned 27 years (1964–1990)',
        'First Black president of South Africa (1994)',
        'Truth and Reconciliation Commission established',
        'Nobel Peace Prize to Mandela and de Klerk (1993)',
        'A global symbol of reconciliation',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_005',
      title: 'Fall of the Berlin Wall',
      category: EventCategory.revolutionsAndPolitical,
      period: '9 November 1989',
      location: 'Berlin, Germany',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/ae/Thefalloftheberlinwall1989.JPG/800px-Thefalloftheberlinwall1989.JPG',
        'assets/images/events/rev_005.png',
      ],
      galleryUrls: const [
        '$_base/7/79/Checkpoint_Charlie_1961-10-27.jpg/800px-Checkpoint_Charlie_1961-10-27.jpg',
        '$_base/3/37/Berlinermauer.jpg/640px-Berlinermauer.jpg',
      ],
      description:
          'The fall of the Berlin Wall was the defining moment of the end of the Cold War. It led to the '
        'reunification of Germany and the subsequent dissolution of the Soviet Union in 1991.',
      timeline: const [
        TimelinePoint(date: '13 Aug 1961', description: 'Construction of the wall begins'),
        TimelinePoint(date: '9 Nov 1989', description: 'Wall is breached; checkpoints open'),
        TimelinePoint(date: '3 Oct 1990', description: 'German reunification declared'),
        TimelinePoint(date: '25 Dec 1991', description: 'Soviet Union formally dissolves'),
      ],
      keyFacts: const [
        'Wall stood for 28 years (1961–1989)',
        'Symbolic end of the Cold War',
        'German reunification: October 3, 1990',
        'Over 140 people died attempting to cross',
        'Led to the fall of the Iron Curtain',
      ],
    ),

    // ── Science & Discoveries ─────────────────────────────────────────────────
    HistoricalEventModel(
      id: 'sci_001',
      title: 'Gutenberg\'s Printing Press',
      category: EventCategory.scienceAndDiscoveries,
      period: 'c. 1440 AD',
      location: 'Mainz, Germany',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/3/39/PrintMus_038.jpg/640px-PrintMus_038.jpg',
        'assets/images/events/sci_001.png',
      ],
      galleryUrls: const [
        '$_base/1/13/Gutenberg_Bible.jpg/640px-Gutenberg_Bible.jpg',
        '$_base/6/65/Johannes_Gutenberg.jpg/640px-Johannes_Gutenberg.jpg',
      ],
      description:
          'Johannes Gutenberg\'s invention of the movable-type printing press democratised knowledge, '
          'enabling the Protestant Reformation and the Scientific Revolution by making information '
          'available to the general public for the first time.',
      timeline: const [
        TimelinePoint(date: 'c.1440', description: 'Printing press operational in Mainz'),
        TimelinePoint(date: '1455', description: 'Gutenberg Bible printed; ~180 copies produced'),
        TimelinePoint(date: '1500', description: '20 million books printed across Europe'),
      ],
      keyFacts: const [
        'Reduced cost of books by ~99%',
        'First major printed work: The Gutenberg Bible',
        '20 million books printed by 1500',
        'Enabled the Protestant Reformation',
        'Called the most important invention of the millennium',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_002',
      title: 'Copernican Revolution',
      category: EventCategory.scienceAndDiscoveries,
      period: '1543 AD',
      location: 'Frombork, Poland',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/f/f2/Nikolaus_Kopernikus.jpg/640px-Nikolaus_Kopernikus.jpg',
        'assets/images/events/sci_002.png',
      ],
      galleryUrls: const [
        '$_base/6/67/Heliocentric.jpg/640px-Heliocentric.jpg',
        '$_base/d/d4/Galileo.arp.300pix.jpg/640px-Galileo.arp.300pix.jpg',
      ],
      description:
          'Nicolaus Copernicus proposed a heliocentric model of the solar system, displacing Earth from '
          'the centre of the universe. This work triggered the Scientific Revolution and directly inspired '
          'Galileo, Kepler, and Newton.',
      timeline: const [
        TimelinePoint(date: '1514', description: 'Circulates first heliocentric outline'),
        TimelinePoint(date: '1543', description: 'De Revolutionibus published; Copernicus dies'),
        TimelinePoint(date: '1609', description: 'Galileo\'s telescope confirms the model'),
      ],
      keyFacts: const [
        'Contradicted the 1,400-year-old Ptolemaic model',
        'Earth orbits the Sun every 365.25 days',
        'Foundation of modern astronomy and physics',
        'Led to Galileo\'s persecution by the Inquisition',
        'Newton later completed the gravitational framework',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_003',
      title: 'Newton\'s Principia',
      category: EventCategory.scienceAndDiscoveries,
      period: '1687 AD',
      location: 'Cambridge, England',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/3/39/GodfreyKneller-IsaacNewton-1689.jpg/640px-GodfreyKneller-IsaacNewton-1689.jpg',
        'assets/images/events/sci_003.png',
      ],
      galleryUrls: const [
        '$_base/a/a2/Lavoisier.jpg/640px-Lavoisier.jpg',
        '$_base/c/c2/Marie_Curie_1911.jpg/640px-Marie_Curie_1911.jpg',
      ],
      description:
          'Isaac Newton\'s "Principia Mathematica" laid the foundations of classical mechanics. '
          'He described universal gravitation and the three laws of motion, which dominated the '
          'scientific view of the physical universe for the next three centuries.',
      timeline: const [
        TimelinePoint(date: '1666', description: 'Newton develops calculus and gravity during plague years'),
        TimelinePoint(date: '1687', description: 'Principia Mathematica is published'),
        TimelinePoint(date: '1704', description: 'Newton publishes Opticks'),
      ],
      keyFacts: const [
        'Established the three laws of motion',
        'Law of Universal Gravitation',
        'Invented calculus to describe physical changes',
        'Integrated terrestrial and celestial mechanics',
        'Remains a foundation of modern engineering',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_004',
      title: 'Discovery of Oxygen',
      category: EventCategory.scienceAndDiscoveries,
      period: '1774 AD',
      location: 'England/France',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/d/d1/Priestley.jpg/640px-Priestley.jpg',
        'assets/images/events/sci_004.png',
      ],
      galleryUrls: const [
        '$_base/a/a2/Lavoisier.jpg/640px-Lavoisier.jpg',
        '$_base/d/d1/Priestley.jpg/640px-Priestley.jpg',
      ],
      description:
          'Joseph Priestley and Antoine Lavoisier independently discovered oxygen, overturning the '
          'phlogiston theory and launching modern chemistry. Lavoisier later named the gas and '
          'explained its role in combustion and respiration.',
      timeline: const [
        TimelinePoint(date: '1774', description: 'Priestley isolates "dephlogisticated air"'),
        TimelinePoint(date: '1777', description: 'Lavoisier names it Oxygen and explains combustion'),
      ],
      keyFacts: const [
        'Overturned the phlogiston theory',
        'Oxygen makes up ~21% of Earth\'s atmosphere',
        'Essential for respiration and combustion',
        'Lavoisier is called the "Father of Modern Chemistry"',
        'Oxygen is the most abundant element in Earth\'s crust',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_005',
      title: 'Darwin\'s Theory of Evolution',
      category: EventCategory.scienceAndDiscoveries,
      period: '1859 AD',
      location: 'London, England',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/ae/Darwin_1868.jpg/640px-Darwin_1868.jpg',
        'assets/images/events/sci_005.png',
      ],
      galleryUrls: const [
        '$_base/f/f1/HMS_Beagle_by_Conrad_Martens.jpg/800px-HMS_Beagle_by_Conrad_Martens.jpg',
        '$_base/b/b5/Darwin_tree.png/640px-Darwin_tree.png',
      ],
      description:
          'Charles Darwin published "On the Origin of Species," introducing the theory of evolution by '
          'natural selection. This provided a unifying explanation for the diversity of life on Earth '
          'and remains the foundation of modern biology.',
      timeline: const [
        TimelinePoint(date: '1831–1836', description: 'Darwin travels on HMS Beagle'),
        TimelinePoint(date: '24 Nov 1859', description: 'On the Origin of Species published'),
      ],
      keyFacts: const [
        'Proposed natural selection as the mechanism',
        'All life shares a common ancestor',
        'Revolutionized biology and our view of humanity',
        'Controversial at the time but now universally accepted',
        'The book sold out on its first day of publication',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_006',
      title: 'Marie Curie — Radioactivity',
      category: EventCategory.scienceAndDiscoveries,
      period: '1898 AD',
      location: 'Paris, France',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/c/c2/Marie_Curie_1911.jpg/640px-Marie_Curie_1911.jpg',
        'assets/images/events/sci_006.png',
      ],
      galleryUrls: const [
        '$_base/f/fd/Curie_Nobel_1903.jpg/640px-Curie_Nobel_1903.jpg',
        '$_base/c/c2/Marie_Curie_1911.jpg/640px-Marie_Curie_1911.jpg',
      ],
      description:
          'Marie Curie discovered the elements Polonium and Radium and coined the term "radioactivity." '
          'She was the first woman to win a Nobel Prize and remains the only person to win them in two '
          'different scientific fields (Physics and Chemistry).',
      timeline: const [
        TimelinePoint(date: '1898', description: 'Curie isolates Polonium and Radium'),
        TimelinePoint(date: '1903', description: 'Wins Nobel Prize in Physics'),
        TimelinePoint(date: '1911', description: 'Wins Nobel Prize in Chemistry'),
      ],
      keyFacts: const [
        'First person to win two Nobel Prizes in science',
        'Discovered Polonium and Radium',
        'Developed mobile X-ray units during WWI',
        'Died from radiation exposure in 1934',
        'Her notebooks are still radioactive today',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_007',
      title: 'Einstein\'s General Relativity',
      category: EventCategory.scienceAndDiscoveries,
      period: '1915 AD',
      location: 'Berlin, Germany',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/d3/Albert_Einstein_Head.jpg/640px-Albert_Einstein_Head.jpg',
        'assets/images/events/sci_007.png',
      ],
      galleryUrls: const [
        '$_base/d/d3/Albert_Einstein_Head.jpg/640px-Albert_Einstein_Head.jpg',
        '$_base/6/67/Heliocentric.jpg/640px-Heliocentric.jpg',
      ],
      description:
          'Albert Einstein published the General Theory of Relativity, describing gravity not as a '
          'force, but as a curvature of spacetime caused by mass and energy. It predicted black holes, '
          'gravitational waves, and the bending of light.',
      timeline: const [
        TimelinePoint(date: '1905', description: 'Special Relativity and E=mc² published'),
        TimelinePoint(date: '1915', description: 'General Theory of Relativity finalized'),
        TimelinePoint(date: '1919', description: 'Solar eclipse confirms light bending'),
      ],
      keyFacts: const [
        'Gravity is the curvature of spacetime',
        'Predicted gravitational waves (detected in 2015)',
        'Foundation of modern cosmology',
        'Predicted that time passes slower in stronger gravity',
        'Einstein won the 1921 Nobel Prize for the photoelectric effect',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_008',
      title: 'Discovery of Penicillin',
      category: EventCategory.scienceAndDiscoveries,
      period: '1928 AD',
      location: 'London, England',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/b/b9/Alexander_Fleming.jpg/640px-Alexander_Fleming.jpg',
        'assets/images/events/sci_008.png',
      ],
      galleryUrls: const [
        '$_base/8/83/Penicillin_core.svg/640px-Penicillin_core.svg',
        '$_base/3/39/PrintMus_038.jpg/640px-PrintMus_038.jpg',
      ],
      description:
          'Alexander Fleming discovered the first true antibiotic, Penicillin, by accident when mould '
          'contaminated a petri dish. This launched the antibiotic age, saving millions of lives '
          'from bacterial infections.',
      timeline: const [
        TimelinePoint(date: '1928', description: 'Fleming observes mould killing bacteria'),
        TimelinePoint(date: '1941', description: 'First human patient treated with penicillin'),
        TimelinePoint(date: '1945', description: 'Fleming, Florey, and Chain receive Nobel Prize'),
      ],
      keyFacts: const [
        'First true "miracle drug"',
        'Saved millions of soldiers during World War II',
        'Accidental discovery from a discarded petri dish',
        'Florey and Chain developed mass production',
        'Increased human life expectancy by years',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_009',
      title: 'Structure of DNA',
      category: EventCategory.scienceAndDiscoveries,
      period: '1953 AD',
      location: 'Cambridge, England',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/3/3b/James_D_Watson_2012.jpg/640px-James_D_Watson_2012.jpg',
        'assets/images/events/sci_009.png',
      ],
      galleryUrls: const [
        '$_base/d/db/DNA_double_helix.svg/640px-DNA_double_helix.svg',
        '$_base/b/b9/Alexander_Fleming.jpg/640px-Alexander_Fleming.jpg',
      ],
      description:
          'James Watson and Francis Crick, using data from Rosalind Franklin, discovered the double helix '
          'structure of DNA. This revealed how genetic information is stored and copied in all living '
          'organisms.',
      timeline: const [
        TimelinePoint(date: '1952', description: 'Rosalind Franklin produces Photo 51'),
        TimelinePoint(date: 'Apr 1953', description: 'Watson and Crick publish their model in Nature'),
        TimelinePoint(date: '1962', description: 'Watson, Crick, and Wilkins receive Nobel Prize'),
      ],
      keyFacts: const [
        'The Double Helix is the structure of life',
        'Photo 51 was the critical piece of evidence',
        'Franklin died in 1958 and was not eligible for the Nobel',
        'Launched the field of molecular biology',
        'Led to the Human Genome Project',
      ],
    ),

    HistoricalEventModel(
      id: 'sci_010',
      title: 'Apollo 11 Moon Landing',
      category: EventCategory.scienceAndDiscoveries,
      period: '20 July 1969',
      location: 'The Moon',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/9/9c/Aldrin_Apollo_11_original.jpg/800px-Aldrin_Apollo_11_original.jpg',
        'assets/images/events/sci_010.png',
      ],
      galleryUrls: const [
        '$_base/4/4e/AS8-14-2383.jpg/800px-AS8-14-2383.jpg',
        '$_base/6/68/Neil_Armstrong_pose.jpg/640px-Neil_Armstrong_pose.jpg',
      ],
      description:
          'Neil Armstrong and Buzz Aldrin became the first humans to walk on the Moon. This achievement '
          'represented the pinnacle of the Space Race and a landmark for humanity.',
      timeline: const [
        TimelinePoint(date: '16 Jul 1969', description: 'Apollo 11 launches from Florida'),
        TimelinePoint(date: '20 Jul 1969', description: 'Lunar module "Eagle" lands on the Moon'),
        TimelinePoint(date: '24 Jul 1969', description: 'Astronauts return safely to Earth'),
      ],
      keyFacts: const [
        'Estimated 600 million people watched live',
        '"One small step for man, one giant leap for mankind"',
        'Fulfilled JFK\'s challenge to land before 1970',
        '382 kg of moon rocks returned to Earth',
        'Only 12 people have ever walked on the Moon',
      ],
    ),

    // ── Culture & Civilizations ───────────────────────────────────────────────
    HistoricalEventModel(
      id: 'cul_001',
      title: 'Construction of the Great Wall',
      category: EventCategory.cultureAndCivilizations,
      period: '7th century BC – 17th century AD',
      location: 'Northern China',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/g/g4/Great_Wall_of_China.jpg',
      ],
      galleryUrls: const [
        '$_base/b/b1/Geat_Wall_of_China_Aug_2006.jpg/800px-Geat_Wall_of_China_Aug_2006.jpg',
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
      ],
      description:
          'The Great Wall of China is one of humanity\'s greatest engineering achievements — a series of '
          'fortifications built over more than 2,000 years by successive dynasties. Stretching over 21,000 km, '
          'it was designed to defend against nomadic invasions from the north. The iconic Ming Dynasty sections '
          'visible today were constructed between 1368 and 1644 AD.',
      timeline: const [
        TimelinePoint(date: '7th–3rd c. BC', description: 'Various warring kingdoms build separate northern fortification walls'),
        TimelinePoint(date: '221 BC', description: 'Qin Shi Huang unifies China; connects and extends existing walls'),
        TimelinePoint(date: '206 BC–220 AD', description: 'Han Dynasty extends wall westward to 6,200 km'),
        TimelinePoint(date: '1368–1644', description: 'Ming Dynasty rebuilds and reinforces wall with bricks; creates iconic sections'),
        TimelinePoint(date: '1987', description: 'Great Wall designated a UNESCO World Heritage Site'),
      ],
      keyFacts: const [
        'Total length: over 21,196 km',
        'Took over 1 million workers to build',
        'Not actually visible from space — a persistent myth',
        'UNESCO World Heritage Site since 1987',
        'Contains over 30,000 watchtowers',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_002',
      title: 'The Roman Empire at its Peak',
      category: EventCategory.cultureAndCivilizations,
      period: '1st–2nd century AD',
      location: 'Rome and the Mediterranean',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/de/Colosseo_2020.jpg/800px-Colosseo_2020.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/5/51/Rome_Colosseum_Exterior_2007.jpg',
      ],
      galleryUrls: const [
        '$_base/5/53/Hadrians_Wall_at_Walltown_Crags.jpg/800px-Hadrians_Wall_at_Walltown_Crags.jpg',
        '$_base/a/a6/Forum_of_Trajan_-_Saturday_September_2011.jpg/800px-Forum_of_Trajan_-_Saturday_September_2011.jpg',
      ],
      description:
          'The Roman Empire at its zenith during the Pax Romana (27 BC–180 AD) governed over 50 million '
          'people across 5 million square kilometres — from Britain to Mesopotamia. The Romans built '
          'aqueducts, roads, and the Colosseum; codified law; and spread Latin, which became the basis of '
          'French, Spanish, Italian, Portuguese and Romanian.',
      timeline: const [
        TimelinePoint(date: '27 BC', description: 'Augustus becomes first Roman Emperor; Pax Romana begins'),
        TimelinePoint(date: '80 AD', description: 'Colosseum completed under Emperor Titus; inaugurated with 100 days of games'),
        TimelinePoint(date: '117 AD', description: 'Emperor Trajan expands empire to its greatest extent'),
        TimelinePoint(date: '125 AD', description: 'Pantheon completed under Hadrian; still the best-preserved Roman building'),
        TimelinePoint(date: '312 AD', description: 'Constantine converts to Christianity; begins Christianisation of empire'),
        TimelinePoint(date: '476 AD', description: 'Fall of the Western Roman Empire; Eastern (Byzantine) continues to 1453'),
      ],
      keyFacts: const [
        'Over 50 million subjects at peak',
        '80,000-seat Colosseum still stands today',
        '400,000 km of Roman roads built',
        'Latin became the foundation of Romance languages',
        'Roman law is the basis of legal systems worldwide',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_003',
      title: 'The Islamic Golden Age',
      category: EventCategory.cultureAndCivilizations,
      period: '8th–13th century AD',
      location: 'Baghdad and the Islamic World',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/2/2c/Astrolabe_1208.jpg',
      ],
      galleryUrls: const [
        '$_base/4/44/Akropolis_by_Leo_von_Klenze.jpg/800px-Akropolis_by_Leo_von_Klenze.jpg',
        '$_base/6/6d/Hulagu.jpg/640px-Hulagu.jpg',
      ],
      description:
          'The Islamic Golden Age was a period of extraordinary cultural, scientific, and intellectual '
          'achievement under the Abbasid Caliphate. Scholars in Baghdad\'s House of Wisdom translated and '
          'expanded upon Greek, Persian, and Indian knowledge, making breakthroughs in mathematics, '
          'astronomy, medicine, and philosophy that later fuelled the European Renaissance.',
      timeline: const [
        TimelinePoint(date: '762 AD', description: 'Baghdad founded as the Abbasid capital; becomes world\'s largest city'),
        TimelinePoint(date: '830 AD', description: 'House of Wisdom established in Baghdad; translation movement peaks'),
        TimelinePoint(date: 'c.820 AD', description: 'Al-Khwarizmi writes Al-Kitāb al-mukhtasar — founding algebra'),
        TimelinePoint(date: 'c.1025 AD', description: 'Avicenna\'s Canon of Medicine becomes Europe\'s standard medical text'),
        TimelinePoint(date: '12th century', description: 'Islamic texts translated into Latin; knowledge flows into Europe'),
        TimelinePoint(date: '1258 AD', description: 'Mongol sack of Baghdad destroys the House of Wisdom; age ends'),
      ],
      keyFacts: const [
        'Al-Khwarizmi invented algebra; his name gave us "algorithm"',
        'Preserved Greek texts lost to medieval Europe',
        'Ibn Sina\'s medical text used in Europe for 600 years',
        'Developed modern numerals (Arabic numerals)',
        'Breakthroughs in optics, chemistry, and astronomy',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_004',
      title: 'The Renaissance',
      category: EventCategory.cultureAndCivilizations,
      period: '14th–17th century',
      location: 'Florence, Italy (then Europe)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/5/5b/Michelangelo_David.jpg',
      ],
      galleryUrls: const [
        '$_base/6/6a/%27David%27_by_Michelangelo_Fir_JBU004.jpg/640px-%27David%27_by_Michelangelo_Fir_JBU004.jpg',
        '$_base/7/7e/Michelangelo_-_Creation_of_Adam_%28cropped%29.jpg/800px-Michelangelo_-_Creation_of_Adam_%28cropped%29.jpg',
      ],
      description:
          'The Renaissance ("Rebirth") began in Florence and spread across Europe, reviving classical '
          'Greco-Roman learning after the medieval period. It produced extraordinary achievements across '
          'art, architecture, science, literature, and philosophy. Figures like Leonardo da Vinci, '
          'Michelangelo, Raphael, Copernicus, and Galileo redefined human knowledge and expression.',
      timeline: const [
        TimelinePoint(date: '1347', description: 'Black Death kills ~1/3 of Europe; reshapes society and thought'),
        TimelinePoint(date: '1397', description: 'Medici banking dynasty rises in Florence; becomes great art patron'),
        TimelinePoint(date: '1455', description: 'Gutenberg Bible printed; enables rapid spread of Renaissance ideas'),
        TimelinePoint(date: '1485–1519', description: 'Leonardo da Vinci produces Last Supper and Mona Lisa'),
        TimelinePoint(date: '1508–1512', description: 'Michelangelo paints the Sistine Chapel ceiling'),
        TimelinePoint(date: '1543', description: 'Copernicus publishes heliocentric model; Scientific Revolution begins'),
      ],
      keyFacts: const [
        'Renaissance means "Rebirth" in French',
        'Michelangelo sculpted David in 1504',
        'Da Vinci filled 13,000 pages of notebooks',
        'Led directly to the Scientific Revolution',
        'Produced architecture still standing today (St Peter\'s Basilica)',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_005',
      title: 'The Silk Road',
      category: EventCategory.cultureAndCivilizations,
      period: '2nd century BC – 15th century AD',
      location: 'Asia, Middle East and Europe',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/0/03/Silk_Road_Map.png',
      ],
      galleryUrls: const [
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
      ],
      description:
          'The Silk Road was an ancient network of trade routes connecting China with Central Asia, the '
          'Middle East, and Europe. More than a trade network, it was a conduit for the exchange of ideas, '
          'religions, technologies, languages, and art. It spread Buddhism, Islam, and Christianity across '
          'continents and transmitted technologies like papermaking, gunpowder, and printing westward.',
      timeline: const [
        TimelinePoint(date: '130 BC', description: 'Han Dynasty opens the Silk Road; Zhang Qian\'s diplomatic missions begin'),
        TimelinePoint(date: '1st–2nd c. AD', description: 'Rome and Han China trade indirectly; silk exchanged for gold'),
        TimelinePoint(date: '7th–12th c.', description: 'Islamic merchants dominate routes; Baghdad becomes trading hub'),
        TimelinePoint(date: '1271–1295', description: 'Marco Polo travels the Silk Road; his accounts inspire European exploration'),
        TimelinePoint(date: '15th century', description: 'Ottoman expansion and sea routes gradually replace overland Silk Road'),
      ],
      keyFacts: const [
        'Over 7,000 km of interconnected overland routes',
        'Connected 4 continents for over 1,500 years',
        'Spread Buddhism, Islam, and Christianity',
        'Transmitted paper, gunpowder, and printing to the West',
        'Inspired Vasco da Gama\'s sea route to Asia (1498)',
      ],
    ),

    // ── Wars & Conflicts (continued) ─────────────────────────────────────────
    HistoricalEventModel(
      id: 'war_006',
      title: 'Battle of Thermopylae',
      category: EventCategory.warsAndConflicts,
      period: '480 BC',
      location: 'Thermopylae, Greece',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5b/Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg/800px-Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Leonidas_I_-_Sparta.jpg/640px-Leonidas_I_-_Sparta.jpg',
      ],
      galleryUrls: const [
        '$_base/6/67/Heliocentric.jpg/640px-Heliocentric.jpg',
        '$_base/4/44/Akropolis_by_Leo_von_Klenze.jpg/800px-Akropolis_by_Leo_von_Klenze.jpg',
      ],
      description:
          'At the narrow coastal pass of Thermopylae, King Leonidas I of Sparta and his 300 elite Spartans — '
          'backed by roughly 7,000 Greek allies — held back Xerxes I\'s vast Persian army for three days. '
          'Betrayed by a local who revealed a mountain path, the Greeks were surrounded. Leonidas dismissed '
          'most allies and fought to the last man, buying time for Greece to prepare. Their sacrifice became '
          'the greatest symbol of courage in Western military history.',
      timeline: const [
        TimelinePoint(date: 'Spring 480 BC', description: 'Xerxes I crosses the Hellespont with an army estimated at 100,000–300,000 men'),
        TimelinePoint(date: 'July 480 BC', description: 'Leonidas arrives at Thermopylae with 300 Spartans and 7,000 Greek allies'),
        TimelinePoint(date: 'Day 1–2', description: 'Persian infantry attack repeatedly; Greek phalanx repels every assault'),
        TimelinePoint(date: 'Day 3 morning', description: 'Ephialtes reveals the Anopaia mountain path to the Persians'),
        TimelinePoint(date: 'Day 3', description: 'Leonidas sends most Greeks away; 300 Spartans and allies fight to the death'),
        TimelinePoint(date: '480 BC', description: 'Greek fleet wins at Salamis; Persians retreat — Thermopylae delay proves decisive'),
      ],
      keyFacts: const [
        '300 Spartans held off an army of hundreds of thousands',
        'Fought to the last man after being surrounded',
        'Inspired Greek unity against the Persian invasion',
        'Battle of Salamis victory followed within months',
        '"Molon labe" — Come and take them — Leonidas\'s legendary reply',
      ],
      latitude: 38.7954,
      longitude: 22.5318,
    ),

    HistoricalEventModel(
      id: 'war_007',
      title: 'The First Crusade',
      category: EventCategory.warsAndConflicts,
      period: '1096–1099 AD',
      location: 'Europe to Jerusalem',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/9/9b/CrucifixionofJesusChristRemnant.jpg/640px-CrucifixionofJesusChristRemnant.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Crusades-Godfrey_of_Bouillon.jpg/640px-Crusades-Godfrey_of_Bouillon.jpg',
      ],
      galleryUrls: const [
        '$_base/9/9c/Genghis_Khan_empire.png/800px-Genghis_Khan_empire.png',
        '$_base/e/e1/Henry_V_from_NPG.jpg/640px-Henry_V_from_NPG.jpg',
      ],
      description:
          'Pope Urban II\'s 1095 call to arms at Clermont launched the First Crusade — a military campaign '
          'to recapture Jerusalem from Seljuk Turkish control. Tens of thousands of knights, nobles, and '
          'common folk marched 5,000 km across Europe and the Middle East. After three years of brutal '
          'sieges, Crusader forces captured Jerusalem in July 1099, establishing the Latin Kingdom of '
          'Jerusalem and reshaping Christian-Muslim relations for centuries.',
      timeline: const [
        TimelinePoint(date: 'Nov 1095', description: 'Pope Urban II preaches the Crusade at Council of Clermont; crowd shouts "God wills it!"'),
        TimelinePoint(date: '1096', description: 'People\'s Crusade — 40,000 poorly armed civilians march; annihilated in Anatolia'),
        TimelinePoint(date: '1097', description: 'Princes\' Crusade captures Nicaea and Dorylaeum; enters Anatolia'),
        TimelinePoint(date: 'Jun–Jul 1098', description: 'Crusaders besiege and capture Antioch after 8 months; defeat relief army'),
        TimelinePoint(date: 'Jul 1099', description: 'Jerusalem stormed after 5-week siege; city taken on July 15'),
        TimelinePoint(date: '1099', description: 'Godfrey of Bouillon becomes first ruler of the Latin Kingdom of Jerusalem'),
      ],
      keyFacts: const [
        'First of nine major Crusades over 200 years',
        'Jerusalem captured July 15, 1099',
        'Created four Crusader states in the Levant',
        'Launched 200 years of Christian-Muslim conflict',
        'Reopened trade routes between East and West',
      ],
    ),

    HistoricalEventModel(
      id: 'war_008',
      title: 'World War I — Battle of the Somme',
      category: EventCategory.warsAndConflicts,
      period: '1 July – 18 November 1916',
      location: 'Somme River, France',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/4/49/Cheshire_Regiment_trench_Somme_1916.jpg/800px-Cheshire_Regiment_trench_Somme_1916.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/WW1_TrenchWarfare.jpg/640px-WW1_TrenchWarfare.jpg',
      ],
      galleryUrls: const [
        '$_base/3/37/Eisenhower_meets_with_paratroopers_of_502nd.jpg/800px-Eisenhower_meets_with_paratroopers_of_502nd.jpg',
        '$_base/6/66/Normandy_June_1944_British_troops.jpg/800px-Normandy_June_1944_British_troops.jpg',
      ],
      description:
          'The Battle of the Somme was one of the largest and bloodiest battles in human history, fought '
          'during World War I. On the first day alone — July 1, 1916 — the British Army suffered nearly '
          '57,000 casualties, including almost 20,000 killed. The battle introduced tank warfare for the '
          'first time. After 141 days of industrial-scale slaughter in the mud, Allied forces advanced just '
          '12 km. It became a defining symbol of the futility and horror of trench warfare.',
      timeline: const [
        TimelinePoint(date: 'Jul 1914', description: 'Assassination of Archduke Franz Ferdinand triggers World War I'),
        TimelinePoint(date: '1915–1916', description: 'Western Front stalemates; opposing trenches stretch 750 km from Belgium to Switzerland'),
        TimelinePoint(date: '24 Jun 1916', description: 'Week-long British artillery bombardment of 1.5 million shells begins'),
        TimelinePoint(date: '1 Jul 1916', description: 'British infantry advance — 57,470 casualties on the first day, worst in British military history'),
        TimelinePoint(date: '15 Sep 1916', description: 'Tanks used in warfare for the first time near Flers'),
        TimelinePoint(date: '18 Nov 1916', description: 'Battle ends; ~1.2 million total casualties; 12 km gained'),
      ],
      keyFacts: const [
        '57,470 British casualties on Day 1 alone',
        'Total casualties: over 1 million across both sides',
        'First use of tanks in warfare (September 15, 1916)',
        'British artillery fired 1.5 million shells before the attack',
        'Advanced only 12 km over 141 days of fighting',
      ],
    ),

    HistoricalEventModel(
      id: 'war_009',
      title: 'Battle of Stalingrad',
      category: EventCategory.warsAndConflicts,
      period: '23 August 1942 – 2 February 1943',
      location: 'Stalingrad, Soviet Union',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/f/fd/Bundesarchiv_Bild_183-W0506-316%2C_Russland%2C_Kampf_um_Stalingrad%2C_Vormarsch.jpg/640px-Bundesarchiv_Bild_183-W0506-316%2C_Russland%2C_Kampf_um_Stalingrad%2C_Vormarsch.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Bundesarchiv_Bild_183-R74190%2C_Russland%2C_Kampf_um_Stalingrad.jpg/640px-Bundesarchiv_Bild_183-R74190%2C_Russland%2C_Kampf_um_Stalingrad.jpg',
      ],
      galleryUrls: const [
        '$_base/9/9c/Aldrin_Apollo_11_original.jpg/800px-Aldrin_Apollo_11_original.jpg',
        '$_base/a/a5/Into_the_Jaws_of_Death_23-0455M_edit.jpg/800px-Into_the_Jaws_of_Death_23-0455M_edit.jpg',
      ],
      description:
          'The Battle of Stalingrad was the turning point of World War II on the Eastern Front. Germany\'s '
          'Sixth Army, commanded by Field Marshal Paulus, fought Soviet forces in brutal house-to-house '
          'urban combat for over five months. Soviet General Zhukov\'s Operation Uranus encircled and '
          'trapped 300,000 German troops. Paulus surrendered in February 1943 — the first German field '
          'marshal ever to surrender. The defeat ended German offensive capability in the east.',
      timeline: const [
        TimelinePoint(date: 'Jun 1942', description: 'Germany launches Case Blue — summer offensive toward the Caucasus and Stalingrad'),
        TimelinePoint(date: '23 Aug 1942', description: 'German 6th Army reaches Volga; Luftwaffe bombing kills tens of thousands of civilians'),
        TimelinePoint(date: 'Sep–Nov 1942', description: 'Urban combat — Soviet defenders hold ruins of factories and buildings block by block'),
        TimelinePoint(date: '19 Nov 1942', description: 'Operation Uranus — Soviet forces encircle the entire German 6th Army'),
        TimelinePoint(date: 'Dec 1942', description: 'German relief attempt fails; 300,000 troops trapped without food or ammunition'),
        TimelinePoint(date: '2 Feb 1943', description: 'Field Marshal Paulus surrenders — 91,000 survivors taken prisoner'),
      ],
      keyFacts: const [
        'Largest battle in human history — ~2 million total casualties',
        'German 6th Army of 300,000 completely destroyed',
        'Field Marshal Paulus was the first German marshal to surrender',
        'Turning point — Germany never recovered strategically in the East',
        'Soviet sniper Vasily Zaitsev became a national hero',
      ],
    ),

    HistoricalEventModel(
      id: 'war_010',
      title: 'Vietnam War',
      category: EventCategory.warsAndConflicts,
      period: '1955–1975',
      location: 'Vietnam, Southeast Asia',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/7/7e/UH-1D_helicopters_in_Vietnam_War.jpg/800px-UH-1D_helicopters_in_Vietnam_War.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/UH-1_Huey_in_Vietnam.jpg/640px-UH-1_Huey_in_Vietnam.jpg',
      ],
      galleryUrls: const [
        '$_base/3/3e/Duke_of_Wellington_by_Goya.jpg/640px-Duke_of_Wellington_by_Goya.jpg',
        '$_base/5/50/Napoleon_Bonaparte.jpg/640px-Napoleon_Bonaparte.jpg',
      ],
      description:
          'The Vietnam War was a Cold War-era conflict between communist North Vietnam (backed by China '
          'and the Soviet Union) and South Vietnam (backed by the United States). The US deployed over '
          '2.7 million troops in a guerrilla war they could not win. The Tet Offensive of 1968 shattered '
          'public confidence. US forces withdrew in 1973; Saigon fell in 1975. The war killed an estimated '
          '3.5 million people and profoundly changed American society.',
      timeline: const [
        TimelinePoint(date: '1954', description: 'French defeated at Dien Bien Phu; Vietnam split at 17th parallel'),
        TimelinePoint(date: '1955–1960', description: 'US sends military advisors to South Vietnam; Viet Cong insurgency grows'),
        TimelinePoint(date: '1964', description: 'Gulf of Tonkin incident; US Congress authorises full military intervention'),
        TimelinePoint(date: 'Jan 1968', description: 'Tet Offensive — North Vietnam attacks 100 cities simultaneously; shocks US public'),
        TimelinePoint(date: '1969–1972', description: '"Vietnamization" — US gradually withdraws while bombing intensifies'),
        TimelinePoint(date: '30 Apr 1975', description: 'Saigon falls to North Vietnamese forces; war ends with communist victory'),
      ],
      keyFacts: const [
        '2.7 million US troops served; 58,000 died',
        'An estimated 3.5 million Vietnamese killed',
        'First "television war" — broadcast into American living rooms',
        'Tet Offensive was a military failure but political turning point',
        'Last US helicopter evacuated from Saigon on April 30, 1975',
      ],
    ),

    // ── Revolutions & Political Events (continued) ───────────────────────────
    HistoricalEventModel(
      id: 'rev_006',
      title: 'The Protestant Reformation',
      category: EventCategory.revolutionsAndPolitical,
      period: '1517 AD',
      location: 'Wittenberg, Germany (then Europe)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5f/Lucas_Cranach_the_Elder-_Martin_Luther%2C_1528.jpg/640px-Lucas_Cranach_the_Elder-_Martin_Luther%2C_1528.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Martin_Luther_by_Cranach-restoration.jpg/640px-Martin_Luther_by_Cranach-restoration.jpg',
      ],
      galleryUrls: const [
        '$_base/8/8f/US_declaration_independence.jpg/800px-US_declaration_independence.jpg',
        '$_base/1/13/Gutenberg_Bible.jpg/640px-Gutenberg_Bible.jpg',
      ],
      description:
          'On 31 October 1517, Martin Luther — an Augustinian monk — nailed his 95 Theses to the door of '
          'the Wittenberg Castle Church, denouncing the Catholic Church\'s sale of indulgences. Spread rapidly '
          'by Gutenberg\'s printing press, his ideas ignited a religious revolution that split Western '
          'Christianity into Catholic and Protestant branches, triggered a century of religious wars, '
          'and permanently changed European politics, culture, and education.',
      timeline: const [
        TimelinePoint(date: '31 Oct 1517', description: 'Martin Luther posts 95 Theses attacking indulgences; printed copies spread across Germany within weeks'),
        TimelinePoint(date: '1519–1521', description: 'Luther debates Johann Eck; refuses to recant; excommunicated by Pope Leo X'),
        TimelinePoint(date: '1521', description: 'Diet of Worms — Luther declared a heretic; translated Bible into German while in hiding'),
        TimelinePoint(date: '1524–1525', description: 'Peasants\' War — 100,000 killed in uprising partly inspired by Reformation ideas'),
        TimelinePoint(date: '1555', description: 'Peace of Augsburg — Lutheran and Catholic princes given equal rights in Holy Roman Empire'),
        TimelinePoint(date: '1618–1648', description: 'Thirty Years\' War — Europe\'s most destructive religious conflict; 8 million dead'),
      ],
      keyFacts: const [
        '95 Theses spread across Germany within two weeks via printing press',
        'Split Christianity into Catholic and Protestant',
        'Luther translated the Bible into German (1522)',
        'Led to the Thirty Years\' War (1618–1648)',
        'Laid groundwork for freedom of conscience and religious tolerance',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_007',
      title: 'Haitian Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1791–1804',
      location: 'Saint-Domingue (Haiti)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/5b/Toussaint_L%27Ouverture.jpg/640px-Toussaint_L%27Ouverture.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Jean-Jacques_Dessalines.jpg/640px-Jean-Jacques_Dessalines.jpg',
      ],
      galleryUrls: const [
        '$_base/a/aa/Prisonrobespierreconciergerie.jpg/640px-Prisonrobespierreconciergerie.jpg',
        '$_base/5/57/Liberty_Leading_the_People.jpg/800px-Liberty_Leading_the_People.jpg',
      ],
      description:
          'The Haitian Revolution was the only successful slave revolt in history, transforming the French '
          'colony of Saint-Domingue into the independent Republic of Haiti. Led by formerly enslaved people '
          'including Toussaint L\'Ouverture and Jean-Jacques Dessalines, the revolution defeated the French, '
          'Spanish, and British armies. Haiti declared independence on 1 January 1804 — becoming the world\'s '
          'first Black republic and the second independent nation in the Americas.',
      timeline: const [
        TimelinePoint(date: 'Aug 1791', description: 'Bois Caïman ceremony — enslaved people launch massive uprising; 100,000 join within days'),
        TimelinePoint(date: '1791–1798', description: 'Toussaint L\'Ouverture emerges as leader; defeats British and Spanish forces'),
        TimelinePoint(date: '1801', description: 'L\'Ouverture proclaims himself Governor-for-Life; abolishes slavery'),
        TimelinePoint(date: '1802–1803', description: 'Napoleon sends 40,000 troops; L\'Ouverture captured by treachery; dies in prison'),
        TimelinePoint(date: '18 Nov 1803', description: 'Battle of Vertières — Haitian forces defeat French in final decisive battle'),
        TimelinePoint(date: '1 Jan 1804', description: 'Haiti declares independence — first Black republic, first free nation in the Caribbean'),
      ],
      keyFacts: const [
        'Only successful large-scale slave revolt in history',
        'Created the world\'s first Black republic (1804)',
        'Second independent nation in the Western Hemisphere',
        'Abolished slavery permanently in 1804',
        'Terrified slaveholding nations; inspired abolitionist movements worldwide',
      ],
      latitude: 18.5944,
      longitude: -72.3074,
    ),

    HistoricalEventModel(
      id: 'rev_008',
      title: 'Indian Independence Movement',
      category: EventCategory.revolutionsAndPolitical,
      period: '1857–1947',
      location: 'British India',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/7/7a/Mahatma-Gandhi%2C_studio%2C_1931.jpg/640px-Mahatma-Gandhi%2C_studio%2C_1931.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Gandhi_and_Nehru_1942.jpg/640px-Gandhi_and_Nehru_1942.jpg',
      ],
      galleryUrls: const [
        '$_base/4/47/Nicholas_II_of_Russia.jpg/640px-Nicholas_II_of_Russia.jpg',
        '$_base/7/70/Red_army_1917-1922.jpg/640px-Red_army_1917-1922.jpg',
      ],
      description:
          'India\'s independence from the British Empire was won through 90 years of struggle, culminating '
          'in Mahatma Gandhi\'s revolutionary doctrine of non-violent civil disobedience. Gandhi mobilised '
          'hundreds of millions of Indians through campaigns like the Salt March (1930) and Quit India (1942). '
          'Britain, exhausted by World War II, agreed to independence in 1947. However, the subcontinent was '
          'partitioned into India and Pakistan, causing one of history\'s largest mass migrations.',
      timeline: const [
        TimelinePoint(date: '1857', description: 'Indian Rebellion (Sepoy Mutiny) — first major uprising against British rule; brutally suppressed'),
        TimelinePoint(date: '1885', description: 'Indian National Congress founded — first organised political independence movement'),
        TimelinePoint(date: '1919', description: 'Amritsar Massacre — British troops kill 379+ unarmed protesters; galvanises independence movement'),
        TimelinePoint(date: '1930', description: 'Gandhi leads 24-day Salt March — 240 miles to the sea to defy British salt tax'),
        TimelinePoint(date: '1942', description: 'Quit India Movement — Gandhi calls for immediate British withdrawal; 100,000 arrested'),
        TimelinePoint(date: '15 Aug 1947', description: 'India and Pakistan become independent; Partition causes 10–20 million displaced, ~1 million dead'),
      ],
      keyFacts: const [
        'Gandhi\'s non-violence doctrine influenced movements worldwide',
        'Salt March (1930): 240-mile walk, 60,000 people arrested',
        'Independence Day: August 15, 1947',
        'Partition displaced 10–20 million people',
        'Inspired Martin Luther King Jr. and Nelson Mandela',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_009',
      title: 'Chinese Communist Revolution',
      category: EventCategory.revolutionsAndPolitical,
      period: '1927–1949',
      location: 'China',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/8/8c/Tiananmen_after_1949_1959.jpg/640px-Tiananmen_after_1949_1959.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Mao_Zedong_1963_%28cropped%29.jpg/640px-Mao_Zedong_1963_%28cropped%29.jpg',
      ],
      galleryUrls: const [
        '$_base/a/ae/Thefalloftheberlinwall1989.JPG/800px-Thefalloftheberlinwall1989.JPG',
        '$_base/d/d6/Lenin_Kremlin_museum_portrait.jpg/640px-Lenin_Kremlin_museum_portrait.jpg',
      ],
      description:
          'After two decades of civil war between the Nationalist (Kuomintang) forces of Chiang Kai-shek '
          'and the Communist Party of China led by Mao Zedong, the Communists emerged victorious. The '
          'legendary Long March (1934–35) — a 9,000 km strategic retreat — forged the Communist army\'s '
          'legendary status. On 1 October 1949, Mao proclaimed the People\'s Republic of China from '
          'Beijing\'s Tiananmen Gate, establishing the most populous communist state in history.',
      timeline: const [
        TimelinePoint(date: '1921', description: 'Chinese Communist Party founded in Shanghai'),
        TimelinePoint(date: '1927', description: 'Chiang Kai-shek\'s Shanghai Massacre kills thousands of Communists; civil war begins'),
        TimelinePoint(date: '1934–1935', description: 'Long March — 100,000 Communists retreat 9,000 km; only ~10,000 survive; Mao consolidates leadership'),
        TimelinePoint(date: '1937–1945', description: 'Second Sino-Japanese War — both sides fight Japan; Communists gain popular support'),
        TimelinePoint(date: '1946–1949', description: 'Civil war resumes; Communist People\'s Liberation Army advances; Nationalists flee to Taiwan'),
        TimelinePoint(date: '1 Oct 1949', description: 'Mao Zedong proclaims the People\'s Republic of China from Tiananmen Gate'),
      ],
      keyFacts: const [
        'People\'s Republic of China proclaimed October 1, 1949',
        'World\'s most populous communist state',
        'Long March covered 9,000 km over 370 days',
        'Nationalist government retreated to Taiwan',
        'Created the world\'s most populous nation under communism',
      ],
    ),

    HistoricalEventModel(
      id: 'rev_010',
      title: 'End of Apartheid — Nelson Mandela',
      category: EventCategory.revolutionsAndPolitical,
      period: '1948–1994',
      location: 'South Africa',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/0/02/Nelson_Mandela_1994.jpg/640px-Nelson_Mandela_1994.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Nelson_Mandela-2008_%28edit%29.jpg/640px-Nelson_Mandela-2008_%28edit%29.jpg',
      ],
      galleryUrls: const [
        '$_base/7/79/Checkpoint_Charlie_1961-10-27.jpg/800px-Checkpoint_Charlie_1961-10-27.jpg',
        '$_base/3/37/Berlinermauer.jpg/640px-Berlinermauer.jpg',
      ],
      description:
          'Apartheid was a system of institutionalised racial segregation imposed on South Africa from 1948. '
          'Nelson Mandela, leader of the African National Congress, was imprisoned for 27 years for opposing '
          'it. International sanctions, internal resistance, and his unbroken spirit ultimately forced the '
          'regime to release him in 1990. In 1994 South Africa held its first fully democratic election, '
          'and Mandela became the country\'s first Black president — a peaceful transition that astonished '
          'the world.',
      timeline: const [
        TimelinePoint(date: '1948', description: 'National Party wins South African election; implements Apartheid — forced racial separation'),
        TimelinePoint(date: '1960', description: 'Sharpeville Massacre — police kill 69 unarmed protesters; ANC banned'),
        TimelinePoint(date: '1964', description: 'Mandela sentenced to life imprisonment at Robben Island'),
        TimelinePoint(date: '1976', description: 'Soweto Uprising — students protest Afrikaans-only education; 176 killed'),
        TimelinePoint(date: '11 Feb 1990', description: 'Mandela walks free after 27 years; apartheid laws begin to be repealed'),
        TimelinePoint(date: '27 Apr 1994', description: 'South Africa\'s first democratic election — Mandela wins; inaugurated May 10'),
      ],
      keyFacts: const [
        'Mandela imprisoned 27 years (1964–1990)',
        'First Black president of South Africa (1994)',
        'International sanctions helped end apartheid',
        'Truth and Reconciliation Commission — unique peaceful transition',
        'Nobel Peace Prize awarded to Mandela and F.W. de Klerk (1993)',
      ],
      latitude: -33.9249,
      longitude: 18.4241,
    ),

    // ── Culture & Civilizations ──────────────────────────────────────────────
    HistoricalEventModel(
      id: 'cul_006',
      title: 'The Pyramids of Giza',
      category: EventCategory.cultureAndCivilizations,
      period: 'c. 2560 BC',
      location: 'Giza, Egypt',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/e/e3/Kheops-Pyramid.jpg/800px-Kheops-Pyramid.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/All_Gizah_Pyramids.jpg/800px-All_Gizah_Pyramids.jpg',
      ],
      galleryUrls: const [
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
      ],
      description:
          'The Great Pyramid of Giza — built for Pharaoh Khufu around 2560 BC — was the tallest man-made '
          'structure on Earth for 3,800 years. Built from 2.3 million stone blocks averaging 2.5 tonnes each, '
          'it was constructed by tens of thousands of skilled workers (not slaves, as once thought). The Giza '
          'complex also includes the Pyramid of Khafre, the Pyramid of Menkaure, and the Great Sphinx. '
          'The Great Pyramid remains one of the Seven Wonders of the Ancient World — the only one still standing.',
      timeline: const [
        TimelinePoint(date: 'c. 2630 BC', description: 'Step Pyramid of Djoser built — world\'s first large stone structure'),
        TimelinePoint(date: 'c. 2560 BC', description: 'Great Pyramid of Khufu completed — 146 metres high, built in ~20 years'),
        TimelinePoint(date: 'c. 2530 BC', description: 'Pyramid of Khafre and Great Sphinx constructed'),
        TimelinePoint(date: 'c. 2510 BC', description: 'Pyramid of Menkaure built — smallest of the three main Giza pyramids'),
        TimelinePoint(date: '1279 BC', description: 'Ramesses II expands Egyptian Empire; hieroglyphics record pyramid builders were paid workers'),
        TimelinePoint(date: '1987', description: 'Giza Necropolis designated a UNESCO World Heritage Site'),
      ],
      keyFacts: const [
        'Tallest building on Earth for 3,800 years',
        'Built from 2.3 million stone blocks',
        'Only surviving Ancient Wonder of the World',
        'Workers were skilled Egyptians, not enslaved people',
        'Aligned to true north with near-perfect precision',
      ],
      latitude: 29.9792,
      longitude: 31.1342,
    ),

    HistoricalEventModel(
      id: 'cul_001',
      title: 'The Great Wall of China',
      category: EventCategory.cultureAndCivilizations,
      period: '7th Century BC – 1878 AD',
      location: 'Northern China',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
        'assets/images/events/cul_001.png', // Gemini/AI Fallback
      ],
      galleryUrls: const [
        '$_base/5/5b/Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg/800px-Leonidas_at_Thermopylae%2C_by_Jacques-Louis_David.jpg',
        '$_base/e/e3/Kheops-Pyramid.jpg/800px-Kheops-Pyramid.jpg',
      ],
      description:
          'The Great Wall of China is a series of fortifications built across the historical northern '
          'borders of ancient Chinese states and Imperial China as protection against various nomadic '
          'groups. Stretching over 21,000 kilometres, it is the longest man-made structure in the world. '
          'Most of the existing wall was built during the Ming Dynasty (1368–1644). It is a symbol of '
          'Chinese strength and endurance.',
      timeline: const [
        TimelinePoint(date: '7th Century BC', description: 'First sections built by independent states (Qi, Yan, Zhao)'),
        TimelinePoint(date: '221 BC', description: 'Qin Shi Huang unifies China; joins sections to form first unified wall'),
        TimelinePoint(date: '1368–1644', description: 'Ming Dynasty rebuilds and expands the wall using brick and stone'),
        TimelinePoint(date: '1644', description: 'Manchu forces breach the wall at Shanhai Pass; Qing Dynasty begins'),
        TimelinePoint(date: '1987', description: 'Designated a UNESCO World Heritage Site'),
      ],
      keyFacts: const [
        'Total length: ~21,196 km',
        'Built over 2,000+ years by multiple dynasties',
        'Longest man-made structure in human history',
        'Myth: Visible from the moon with the naked eye (false)',
        'Built for protection, border control, and trade regulation',
      ],
      latitude: 40.4319,
      longitude: 116.5704,
    ),

    HistoricalEventModel(
      id: 'cul_007',
      title: 'Birth of Athenian Democracy',
      category: EventCategory.cultureAndCivilizations,
      period: '508–507 BC',
      location: 'Athens, Greece',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/f/f6/The_Parthenon_in_Athens.jpg/800px-The_Parthenon_in_Athens.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/The_Parthenon_in_Athens.jpg/800px-The_Parthenon_in_Athens.jpg',
      ],
      galleryUrls: const [
        '$_base/d/de/Colosseo_2020.jpg/800px-Colosseo_2020.jpg',
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
      ],
      description:
          'Athenian democracy — introduced by Cleisthenes in 508–507 BC — was the world\'s first democratic '
          'system of government. It gave direct political power to male citizens (roughly 30,000 of Athens\'s '
          '300,000 population) to vote on laws, policies, and war. Leaders like Pericles expanded '
          'participation, funded the Parthenon, and created the golden age of Athens. Though imperfect by '
          'modern standards, Athenian democracy became the foundational model for every democratic '
          'government in history.',
      timeline: const [
        TimelinePoint(date: '621 BC', description: 'Draco creates Athens\'s first written laws — notoriously harsh (origin of "draconian")'),
        TimelinePoint(date: '594 BC', description: 'Solon\'s reforms cancel debt slavery; four property classes given different political rights'),
        TimelinePoint(date: '508–507 BC', description: 'Cleisthenes\' reforms: all male citizens get equal vote in Assembly; Ostracism created'),
        TimelinePoint(date: '461–429 BC', description: 'Age of Pericles — democratic participation expanded; Parthenon built'),
        TimelinePoint(date: '399 BC', description: 'Socrates tried and executed by democratic vote — illustrating democracy\'s limits'),
        TimelinePoint(date: '338 BC', description: 'Macedonian conquest ends Athenian independence; democratic ideas preserved in writings'),
      ],
      keyFacts: const [
        'World\'s first democratic system of government',
        '~30,000 male citizens could vote directly on laws',
        'Parthenon (447–432 BC) — democracy\'s architectural symbol',
        'Ostracism: citizens could vote to exile any politician for 10 years',
        'Foundation of every modern democratic constitution',
      ],
      latitude: 37.9755,
      longitude: 23.7348,
    ),

    HistoricalEventModel(
      id: 'cul_005',
      title: 'The Silk Road',
      category: EventCategory.cultureAndCivilizations,
      period: '2nd Century BC – 18th Century AD',
      location: 'Asia and Europe',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Silk_route.jpg/800px-Silk_route.jpg',
      ],
      galleryUrls: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        '$_base/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
      ],
      description:
          'The Silk Road was an ancient network of trade routes that connected the East and West for over '
          '1,500 years. It was central to cultural, religious, and economic interaction between China, India, '
          'Persia, Arabia, and Europe. Beyond silk, it facilitated the spread of technologies like paper '
          'and gunpowder, religions like Buddhism and Islam, and unfortunately, diseases like the Black Death.',
      timeline: const [
        TimelinePoint(date: '138 BC', description: 'Zhang Qian travels west for Han Emperor; marks start of Silk Road trade'),
        TimelinePoint(date: '1st Century AD', description: 'Silk becomes highly prized in the Roman Empire'),
        TimelinePoint(date: '8th Century AD', description: 'Abbasid Caliphate secures trade routes; Islamic Golden Age benefits'),
        TimelinePoint(date: '13th Century AD', description: 'Mongol Empire (Pax Mongolica) makes routes safer than ever'),
        TimelinePoint(date: '15th Century AD', description: 'Ottoman Empire closes land routes; sparks Age of Exploration'),
      ],
      keyFacts: const [
        'Network of routes, not a single road',
        'Total length: ~6,400 km',
        'Facilitated the spread of paper, gunpowder, and printing',
        'Buddhism, Islam, and Christianity spread along the routes',
        'Named "Silk Road" by German geographer Ferdinand von Richthofen (1877)',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_002',
      title: 'Roman Empire — Pax Romana',
      category: EventCategory.cultureAndCivilizations,
      period: '27 BC – 180 AD',
      location: 'Mediterranean Basin and Europe',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/de/Colosseo_2020.jpg/800px-Colosseo_2020.jpg',
        'assets/images/events/cul_002.png', // Gemini/AI Fallback
      ],
      galleryUrls: const [
        '$_base/f/f6/The_Parthenon_in_Athens.jpg/800px-The_Parthenon_in_Athens.jpg',
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
      ],
      description:
          'The Pax Romana ("Roman Peace") was a 200-year period of relative stability and prosperity across '
          'the Mediterranean world under the Roman Empire. During this time, Rome reached its peak '
          'territorial extent, stretching from Britain to the Persian Gulf. The Romans built 80,000 km of '
          'roads, massive aqueducts, and the Colosseum. Their legal system, language (Latin), and '
          'engineering became the foundation of Western civilisation.',
      timeline: const [
        TimelinePoint(date: '27 BC', description: 'Augustus becomes first Roman Emperor; Pax Romana begins'),
        TimelinePoint(date: '43 AD', description: 'Claudius begins the conquest of Britain'),
        TimelinePoint(date: '70–80 AD', description: 'Flavian Amphitheatre (Colosseum) built in Rome'),
        TimelinePoint(date: '117 AD', description: 'Empire reaches its largest extent under Trajan'),
        TimelinePoint(date: '180 AD', description: 'Death of Marcus Aurelius marks the end of Pax Romana'),
        TimelinePoint(date: '476 AD', description: 'Fall of the Western Roman Empire'),
      ],
      keyFacts: const [
        'Stretched across 5 million square km',
        'Population: ~70 million (1/4 of the world at the time)',
        'Built 80,000 km of paved roads',
        'Latin became the basis of all Romance languages',
        'Roman law is the foundation of many modern legal systems',
      ],
      latitude: 41.8902,
      longitude: 12.4922,
    ),

    HistoricalEventModel(
      id: 'cul_003',
      title: 'Islamic Golden Age',
      category: EventCategory.cultureAndCivilizations,
      period: '8th Century – 13th Century AD',
      location: 'Middle East, North Africa, Spain',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        'assets/images/events/cul_003.png', // Gemini/AI Fallback
      ],
      galleryUrls: const [
        '$_base/6/6d/Hulagu.jpg/640px-Hulagu.jpg',
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
      ],
      description:
          'The Islamic Golden Age was a period of cultural, economic, and scientific flourishing in the '
          'history of Islam. Centred in Baghdad at the "House of Wisdom," scholars preserved and '
          'translated Greek works and made massive advances in algebra (Al-Khwarizmi), medicine '
          '(Avicenna), and optics (Alhazen). This era formed a vital bridge between antiquity and the '
          'Renaissance, preserving knowledge that would have otherwise been lost to Europe.',
      timeline: const [
        TimelinePoint(date: '750 AD', description: 'Abbasid Caliphate established; capital moves to Baghdad'),
        TimelinePoint(date: '813–833 AD', description: 'Caliph Al-Ma\'mun founds the House of Wisdom in Baghdad'),
        TimelinePoint(date: 'c. 820 AD', description: 'Al-Khwarizmi writes "The Compendious Book on Calculation by Completion and Balancing" (Algebra)'),
        TimelinePoint(date: '1025 AD', description: 'Avicenna (Ibn Sina) completes "The Canon of Medicine"'),
        TimelinePoint(date: '1258 AD', description: 'Mongol Sack of Baghdad; House of Wisdom destroyed; Golden Age ends'),
      ],
      keyFacts: const [
        'Preserved and translated Ancient Greek and Roman texts',
        'Invented modern algebra (from the word "al-jabr")',
        'Introduced Arabic numerals (originally from India) to the West',
        'Baghdad was the world\'s largest city (~1 million people)',
        'Avicenna\'s medical textbooks were used in Europe until the 17th Century',
      ],
      latitude: 33.3128,
      longitude: 44.3615,
    ),

    HistoricalEventModel(
      id: 'cul_008',
      title: 'The Aztec Empire',
      category: EventCategory.cultureAndCivilizations,
      period: '1300–1521 AD',
      location: 'Tenochtitlan (modern Mexico City)',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/d/d8/Piedra_del_Sol_Museo_Nacional_Antropolog%C3%ADa_M%C3%A9xico.jpg/640px-Piedra_del_Sol_Museo_Nacional_Antropolog%C3%ADa_M%C3%A9xico.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Tenochtitlan_map.jpg/640px-Tenochtitlan_map.jpg',
      ],
      galleryUrls: const [
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
        '$_base/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
      ],
      description:
          'The Aztec Empire, centred at the magnificent island city of Tenochtitlan (now Mexico City), was '
          'the dominant civilisation in Mesoamerica. At its peak, it controlled 5–6 million people across '
          '38 provinces. The Aztecs built floating gardens (chinampas), designed aqueducts, and created '
          'one of the most accurate calendars in history. In 1519, Spanish conquistador Hernán Cortés '
          'arrived and, by 1521, the empire had collapsed — through warfare, disease, and alliance with '
          'rival indigenous peoples.',
      timeline: const [
        TimelinePoint(date: 'c. 1300', description: 'Aztec (Mexica) people arrive in Valley of Mexico; settle on island in Lake Texcoco'),
        TimelinePoint(date: '1325', description: 'Tenochtitlan founded — city of temples, gardens, and canals on an island'),
        TimelinePoint(date: '1428', description: 'Triple Alliance formed; rapid expansion begins'),
        TimelinePoint(date: '1519', description: 'Hernán Cortés arrives with 600 soldiers; allied with rival Tlaxcalan people'),
        TimelinePoint(date: '1520', description: 'La Noche Triste — Aztecs temporarily drive out Spanish; Emperor Moctezuma dies'),
        TimelinePoint(date: '1521', description: 'Cortés besieges Tenochtitlan with 200,000 indigenous allies; city falls; empire ends'),
      ],
      keyFacts: const [
        'Tenochtitlan had ~200,000 people — larger than any European city in 1500',
        'Aztec Sun Stone calendar accurate to fractions of a second',
        'Chinampas (floating gardens) fed millions',
        'Empire defeated by 600 Spaniards + disease + 200,000 indigenous allies',
        'Smallpox killed ~90% of the indigenous population after conquest',
      ],
      latitude: 19.4326,
      longitude: -99.1332,
    ),

    // ── Culture & Civilizations ───────────────────────────────────────────────
    HistoricalEventModel(
      id: 'cul_001',
      title: 'Ancient Egyptian Pyramids',
      category: EventCategory.cultureAndCivilizations,
      period: 'c. 2580–2560 BC',
      location: 'Giza, Egypt',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/af/All_Gizah_Pyramids.jpg/800px-All_Gizah_Pyramids.jpg',
        'assets/images/events/cul_001.png',
      ],
      galleryUrls: const [
        '$_base/e/e3/Great_Pyramid_of_Giza.jpg/640px-Great_Pyramid_of_Giza.jpg',
        '$_base/9/93/Great_Sphinx_of_Giza_-_20080716a.jpg/640px-Great_Sphinx_of_Giza_-_20080716a.jpg',
      ],
      description:
          'The Great Pyramid of Giza is the oldest and largest of the pyramids in the Giza pyramid complex. '
          'Built as a tomb for the Pharaoh Khufu, it was the tallest man-made structure in the world '
          'for over 3,800 years.',
      timeline: const [
        TimelinePoint(date: 'c. 2580 BC', description: 'Construction begins for Pharaoh Khufu'),
        TimelinePoint(date: 'c. 2560 BC', description: 'Pyramid completed; reaches 146.6 metres'),
        TimelinePoint(date: 'c. 1311 AD', description: 'Lincoln Cathedral completed, surpassing the pyramid\'s height'),
      ],
      keyFacts: const [
        'Oldest of the Seven Wonders of the Ancient World',
        'Composed of 2.3 million stone blocks',
        'Built over a 20-year period',
        'Aligned with extraordinary precision to true north',
        'Only Ancient Wonder still largely intact',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_002',
      title: 'Construction of the Great Wall',
      category: EventCategory.cultureAndCivilizations,
      period: '7th century BC – 17th century AD',
      location: 'Northern China',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
        'assets/images/events/cul_002.png',
      ],
      galleryUrls: const [
        '$_base/b/b1/Geat_Wall_of_China_Aug_2006.jpg/800px-Geat_Wall_of_China_Aug_2006.jpg',
        '$_base/g/g4/Great_Wall_of_China.jpg/640px-Great_Wall_of_China.jpg',
      ],
      description:
          'The Great Wall of China is a series of fortifications built across the historical northern '
          'borders of China to protect against various nomadic groups. It is the world\'s longest '
          'man-made structure.',
      timeline: const [
        TimelinePoint(date: '7th c. BC', description: 'First sections of the wall built'),
        TimelinePoint(date: '221 BC', description: 'Qin Shi Huang unifies the walls'),
        TimelinePoint(date: '1368–1644', description: 'Ming Dynasty builds the most famous sections'),
      ],
      keyFacts: const [
        'Stretches over 21,000 kilometres',
        'Built over two millennia by multiple dynasties',
        'Estimated 1 million people died during construction',
        'Used smoke and fire signals for communication',
        'UNESCO World Heritage Site since 1987',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_003',
      title: 'The Roman Empire at its Peak',
      category: EventCategory.cultureAndCivilizations,
      period: '27 BC – 476 AD',
      location: 'Europe, Africa, Asia',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/de/Colosseo_2020.jpg/800px-Colosseo_2020.jpg',
        'assets/images/events/cul_003.png',
      ],
      galleryUrls: const [
        '$_base/5/53/Hadrians_Wall_at_Walltown_Crags.jpg/800px-Hadrians_Wall_at_Walltown_Crags.jpg',
        '$_base/a/a6/Forum_of_Trajan_-_Saturday_September_2011.jpg/800px-Forum_of_Trajan_-_Saturday_September_2011.jpg',
      ],
      description:
          'The Roman Empire was the most extensive social and political structure in Western civilization. '
          'At its peak under Trajan, it covered 5 million square kilometres and ruled over 20% of '
          'the world\'s population.',
      timeline: const [
        TimelinePoint(date: '27 BC', description: 'Augustus becomes the first Roman Emperor'),
        TimelinePoint(date: '117 AD', description: 'Empire reaches its greatest extent under Trajan'),
        TimelinePoint(date: '476 AD', description: 'Fall of the Western Roman Empire'),
      ],
      keyFacts: const [
        'Unified the Mediterranean for centuries ("Mare Nostrum")',
        'Spread Latin, the ancestor of Romance languages',
        'Engineering marvels: Aqueducts, roads, and concrete',
        'Roman law forms the basis of many modern legal systems',
        'The Colosseum could hold up to 80,000 spectators',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_004',
      title: 'The Silk Road Peak',
      category: EventCategory.cultureAndCivilizations,
      period: '2nd century BC – 15th century AD',
      location: 'Asia to Europe',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
        'assets/images/events/cul_004.png',
      ],
      galleryUrls: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        '$_base/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg/800px-The_Great_Wall_of_China_at_Jinshanling-edit.jpg',
      ],
      description:
          'The Silk Road was an ancient network of trade routes that connected the East and West. '
          'It was central to cultural interaction between the regions for many centuries, spreading '
          'religions, technologies, and philosophies.',
      timeline: const [
        TimelinePoint(date: '130 BC', description: 'Han Dynasty officially opens trade with the West'),
        TimelinePoint(date: '618–907 AD', description: 'Silk Road reaches its golden age during the Tang Dynasty'),
        TimelinePoint(date: '1453 AD', description: 'Ottoman Empire boycotts trade, closing the Silk Road'),
      ],
      keyFacts: const [
        'Named after the lucrative Chinese silk trade',
        'Transmitted the Black Death to Europe in the 1340s',
        'Spread Buddhism from India to China',
        'Marco Polo traveled this route to reach the court of Kublai Khan',
        'Introduced paper and gunpowder to the West',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_005',
      title: 'The Mayan Civilization',
      category: EventCategory.cultureAndCivilizations,
      period: 'c. 250–900 AD',
      location: 'Central America',
      importanceLevel: 4,
      imageUrl: const [
        '$_base/1/1d/Chichen_Itza_3.jpg/800px-Chichen_Itza_3.jpg',
        'assets/images/events/cul_005.png',
      ],
      galleryUrls: const [
        '$_base/e/e1/Tikal_Temple_I_2006.jpg/640px-Tikal_Temple_I_2006.jpg',
        '$_base/1/1d/Chichen_Itza_3.jpg/800px-Chichen_Itza_3.jpg',
      ],
      description:
          'The Maya civilization was noted for its logo-syllabic script — the most sophisticated writing '
          'system in pre-Columbian Americas — as well as for its art, architecture, mathematics, '
          'calendar, and astronomical system.',
      timeline: const [
        TimelinePoint(date: 'c. 250 AD', description: 'Classic period begins; rise of city-states like Tikal'),
        TimelinePoint(date: 'c. 750 AD', description: 'Civilization reaches its peak population and complexity'),
        TimelinePoint(date: 'c. 900 AD', description: 'Mysterious collapse of southern lowland cities'),
      ],
      keyFacts: const [
        'Developed a highly accurate 365-day solar calendar',
        'Invented the concept of zero independently',
        'Built massive pyramids and observatories without metal tools',
        'Sophisticated agricultural systems including raised fields',
        'The script was only fully deciphered in the late 20th century',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_006',
      title: 'The Islamic Golden Age',
      category: EventCategory.cultureAndCivilizations,
      period: '8th–14th century AD',
      location: 'Middle East',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
        'assets/images/events/cul_006.png',
      ],
      galleryUrls: const [
        '$_base/2/2c/Astrolabe_1208.jpg/640px-Astrolabe_1208.jpg',
        '$_base/a/a6/Scholars_at_an_Abbasid_Library.jpg/800px-Scholars_at_an_Abbasid_Library.jpg',
      ],
      description:
          'The Islamic Golden Age was a period of cultural, economic, and scientific flourishing in '
          'the history of Islam. Scholars in Baghdad\'s House of Wisdom preserved and expanded upon '
          'the knowledge of previous civilizations.',
      timeline: const [
        TimelinePoint(date: '762 AD', description: 'Abbasid Caliphate founds Baghdad'),
        TimelinePoint(date: '830 AD', description: 'House of Wisdom established by Al-Ma\'mun'),
        TimelinePoint(date: '1258 AD', description: 'Mongols sack Baghdad, marking the end of the Golden Age'),
      ],
      keyFacts: const [
        'Al-Khwarizmi developed algebra and the concept of algorithms',
        'Avicenna wrote "The Canon of Medicine," a standard text for centuries',
        'Preserved and translated Greek philosophy for future generations',
        'Advanced the fields of optics, chemistry, and astronomy',
        'Developed modern hospitals and university systems',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_007',
      title: 'The Renaissance',
      category: EventCategory.cultureAndCivilizations,
      period: '14th–17th century AD',
      location: 'Europe (Florence)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
        'assets/images/events/cul_007.png',
      ],
      galleryUrls: const [
        '$_base/3/39/PrintMus_038.jpg/640px-PrintMus_038.jpg',
        '$_base/7/7e/Michelangelo_-_Creation_of_Adam_%28cropped%29.jpg/800px-Michelangelo_-_Creation_of_Adam_%28cropped%29.jpg',
      ],
      description:
          'The Renaissance was a "rebirth" of classical learning and art that began in Italy. It marked '
          'the transition from the Middle Ages to modernity and produced some of the greatest '
          'artists and thinkers in history.',
      timeline: const [
        TimelinePoint(date: '1300s', description: 'Petrarch initiates the humanist movement'),
        TimelinePoint(date: '1503', description: 'Leonardo da Vinci begins the Mona Lisa'),
        TimelinePoint(date: '1512', description: 'Michelangelo completes the Sistine Chapel ceiling'),
      ],
      keyFacts: const [
        'Centred on Humanism — the value of human potential',
        'Revolutionized art with linear perspective and realism',
        'Fueled by the patronage of families like the Medici',
        'Leonardo da Vinci epitomized the "Renaissance Man"',
        'Led directly to the Scientific Revolution',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_008',
      title: 'The Age of Exploration',
      category: EventCategory.cultureAndCivilizations,
      period: '15th–17th century AD',
      location: 'Global',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/8/8a/Santamaria.jpg/640px-Santamaria.jpg',
        'assets/images/events/cul_008.png',
      ],
      galleryUrls: const [
        '$_base/5/54/Silk_route.jpg/800px-Silk_route.jpg',
        '$_base/8/8a/Santamaria.jpg/640px-Santamaria.jpg',
      ],
      description:
          'The Age of Exploration was a period from the early 15th century and continuing into the early '
          '17th century, during which European ships traveled around the world to search for new '
          'trading routes and partners.',
      timeline: const [
        TimelinePoint(date: '1492 AD', description: 'Columbus reaches the Americas'),
        TimelinePoint(date: '1498 AD', description: 'Vasco da Gama reaches India by sea'),
        TimelinePoint(date: '1522 AD', description: 'Magellan\'s expedition completes circumnavigation'),
      ],
      keyFacts: const [
        'Driven by the "Three Gs": Gold, Glory, and God',
        'Led to the rise of global trade and colonialism',
        'The "Columbian Exchange" transformed global biology',
        'Introduced new foods like potatoes and corn to Europe',
        'Resulted in the tragic decline of indigenous populations',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_009',
      title: 'The Age of Enlightenment',
      category: EventCategory.cultureAndCivilizations,
      period: '17th–18th century AD',
      location: 'Europe',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/e/e4/Encyclopedie_frontispice_full.jpg/640px-Encyclopedie_frontispice_full.jpg',
        'assets/images/events/cul_009.png',
      ],
      galleryUrls: const [
        '$_base/3/39/GodfreyKneller-IsaacNewton-1689.jpg/640px-GodfreyKneller-IsaacNewton-1689.jpg',
        '$_base/e/e4/Encyclopedie_frontispice_full.jpg/640px-Encyclopedie_frontispice_full.jpg',
      ],
      description:
          'The Enlightenment was an intellectual and philosophical movement that dominated the world of '
          'ideas in Europe. It emphasized reason, logic, and the scientific method as the primary '
          'sources of authority.',
      timeline: const [
        TimelinePoint(date: '1687 AD', description: 'Newton publishes Principia Mathematica'),
        TimelinePoint(date: '1751 AD', description: 'Diderot begins publishing the Encyclopédie'),
        TimelinePoint(date: '1789 AD', description: 'Enlightenment ideals fuel the French Revolution'),
      ],
      keyFacts: const [
        'Advocated for individual liberty and religious tolerance',
        'Philosophers like Locke, Voltaire, and Rousseau led the way',
        'Challenged the absolute power of monarchs and the Church',
        'Laid the groundwork for modern liberal democracies',
        'Promoted the idea of universal human rights',
      ],
    ),

    HistoricalEventModel(
      id: 'cul_010',
      title: 'The Industrial Revolution',
      category: EventCategory.cultureAndCivilizations,
      period: 'c. 1760–1840 AD',
      location: 'Britain (then Global)',
      importanceLevel: 5,
      imageUrl: const [
        '$_base/d/de/Stephenson%27s_Rocket_%28Science_Museum%29.jpg/640px-Stephenson%27s_Rocket_%28Science_Museum%29.jpg',
        'assets/images/events/cul_010.png',
      ],
      galleryUrls: const [
        '$_base/f/f7/Illustration_of_Coalbrookdale_by_Night.jpg/800px-Illustration_of_Coalbrookdale_by_Night.jpg',
        '$_base/d/de/Stephenson%27s_Rocket_%28Science_Museum%29.jpg/640px-Stephenson%27s_Rocket_%28Science_Museum%29.jpg',
      ],
      description:
          'The Industrial Revolution was the transition to new manufacturing processes. It marked a '
          'major turning point in history; almost every aspect of daily life was influenced in '
          'some way.',
      timeline: const [
        TimelinePoint(date: '1769 AD', description: 'James Watt patents the improved steam engine'),
        TimelinePoint(date: '1825 AD', description: 'First public steam railway opens in Britain'),
        TimelinePoint(date: '1851 AD', description: 'The Great Exhibition showcases industrial progress'),
      ],
      keyFacts: const [
        'Shifted society from agrarian to industrial and urban',
        'Mass production led to cheaper goods and rising living standards',
        'Introduced new social challenges like child labour and pollution',
        'The steam engine was the defining technology of the era',
        'Britain became the "Workshop of the World"',
      ],
    ),
  ];

  Future<List<HistoricalEvent>> fetchAll() async => List.unmodifiable(_events);

  static List<HistoricalEvent> get allEvents => List.unmodifiable(_events);

  Future<List<HistoricalEvent>> fetchByCategory(EventCategory category) async =>
      _events.where((e) => e.category == category).toList();

  Future<List<HistoricalEvent>> search(String query) async {
    final q = query.toLowerCase();
    return _events
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.location.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.period.toLowerCase().contains(q))
        .toList();
  }

  // Returns up to [limit] events in the same category, excluding [current].
  static List<HistoricalEvent> relatedTo(HistoricalEvent current,
      {int limit = 3}) {
    return _events
        .where((e) => e.category == current.category && e.id != current.id)
        .take(limit)
        .toList();
  }

  // ── Timeline Context ────────────────────────────────────────────────────────

  static int _parseYear(String raw) {
    final s = raw.trim().toLowerCase();
    final ordinal = RegExp(r'(\d+)(?:st|nd|rd|th)').firstMatch(s);
    if (ordinal != null) {
      final n = int.parse(ordinal.group(1)!);
      final approx = (n - 1) * 100 + 50;
      return s.contains('bc') ? -approx : approx;
    }
    final nums = RegExp(r'\d{3,4}').allMatches(s).toList();
    if (nums.isEmpty) return 0;
    final year = int.parse(nums.last.group(0)!);
    return s.contains('bc') ? -year : year;
  }

  static List<int> _periodRange(String period) {
    final p = period.replaceAll(RegExp(r'c\.\s*'), '');
    final idx = p.indexOf('–');
    if (idx == -1) {
      final y = _parseYear(p);
      return [y, y];
    }
    return [_parseYear(p.substring(0, idx)), _parseYear(p.substring(idx + 1))];
  }

  static List<HistoricalEvent> contextBefore(HistoricalEvent current, {int limit = 5}) {
    final range = _periodRange(current.period);
    final cs = range[0];
    final results = _events.where((e) {
      if (e.id == current.id) return false;
      final er = _periodRange(e.period);
      return er[1] < cs;
    }).toList();
    results.sort((a, b) {
      final ae = _periodRange(a.period)[1];
      final be = _periodRange(b.period)[1];
      return be.compareTo(ae);
    });
    return results.take(limit).toList();
  }

  static List<HistoricalEvent> contextAfter(HistoricalEvent current, {int limit = 5}) {
    final range = _periodRange(current.period);
    final ce = range[1];
    final results = _events.where((e) {
      if (e.id == current.id) return false;
      final er = _periodRange(e.period);
      return er[0] > ce;
    }).toList();
    results.sort((a, b) {
      final as_ = _periodRange(a.period)[0];
      final bs = _periodRange(b.period)[0];
      return as_.compareTo(bs);
    });
    return results.take(limit).toList();
  }

  static List<HistoricalEvent> contextParallel(HistoricalEvent current, {int limit = 5}) {
    final range = _periodRange(current.period);
    final cs = range[0];
    final ce = range[1];
    final results = _events.where((e) {
      if (e.id == current.id) return false;
      final er = _periodRange(e.period);
      return er[0] <= ce && er[1] >= cs;
    }).toList();
    results.sort((a, b) {
      final ad = (_periodRange(a.period)[0] - cs).abs();
      final bd = (_periodRange(b.period)[0] - cs).abs();
      return ad.compareTo(bd);
    });
    return results.take(limit).toList();
  }
}
