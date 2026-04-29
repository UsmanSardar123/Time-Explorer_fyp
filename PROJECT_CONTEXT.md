# PROJECT_CONTEXT.md — Time Explorer
> Central source of truth for architecture, features, AI design, and implementation state.
> **Update this file whenever chat prompts, quiz logic, data flow, or architecture changes.**

---

## 1. Project Overview

**Time Explorer** is a Flutter-based mobile FYP that lets users explore historical places and interact with AI-powered historical personalities. The app combines location-based discovery, conversational AI, and gamification to make history engaging and interactive.

**Core Purpose:**
- Discover historical places with rich context (maps, timelines, facts, AI insights)
- Chat with AI-powered historical figures in character (Gemini-backed)
- Learn through quizzes tied to places and personalities
- Earn XP, badges, and levels through exploration and learning

---

## 2. System Architecture

### Flutter App Structure (Clean Architecture)

```
lib/
├── core/
│   ├── config/        # App config (API keys, env vars via flutter_dotenv)
│   ├── data/          # Dummy/seed data
│   ├── database/      # SQLite helper
│   ├── router/        # GoRouter setup + transitions
│   ├── services/      # Cross-cutting: GamificationService, GeminiService,
│   │                  # WikipediaService, WikimediaService, PixabayService
│   ├── theme/         # Material 3 theme
│   └── widgets/       # Shared UI components
├── features/
│   ├── admin/         # CRUD for places, characters, facts, users
│   ├── auth/          # Firebase Auth (email + Google sign-in)
│   ├── bookmarks/     # Saved places and personalities
│   ├── explore/       # Main discovery feed + search
│   ├── gamification/  # XP / levels / badges / streaks
│   ├── home/          # Dashboard
│   ├── learn/         # Daily historical facts
│   ├── onboarding/    # Splash screen
│   ├── personalities/ # Character chat (Gemini AI)
│   ├── places/        # Historical locations detail + local guide
│   ├── profile/       # User settings and profile
│   └── quiz/          # Interactive knowledge quizzes
└── main.dart
```

### State Management Strategy

| Layer | Mechanism | Use Case |
|-------|-----------|----------|
| Complex feature state | Cubit (BLoC) | Chat streaming, quiz progression, place details |
| Simple global state | Provider (ChangeNotifier) | Gamification, bookmarks, auth |
| UI-only state | Local StatefulWidget state | Scroll, focus, animations |

### Key External Integrations

| Service | Purpose |
|---------|---------|
| Firebase Auth | Email + Google sign-in |
| Cloud Firestore | Characters, user progress, conversation logs |
| Firebase Analytics | Chat sessions, errors, message counts |
| Firebase Remote Config | Dynamic character content updates |
| Firebase Storage | Profile images |
| Google Generative AI (Gemini Flash) | Character chat + local guide chat |
| Wikimedia Commons | Place images |
| Pixabay | Fallback place images |
| Wikipedia | Place info scraping |

### Local Persistence

| Store | Data |
|-------|------|
| SharedPreferences | Gamification progress, quiz high scores, settings, rate limits |
| Hive | Wikipedia content cache |
| SQLite (database_helper) | Auxiliary local data |

---

## 3. Features

### 3.1 Places Module

**Entities:** `Place` — includes name, location, country, era, description, coordinates, architectural info, visitor info, `facts`, `funFacts`, `keyFacts`, `timeline` (List<TimelineEvent>), `quizzes` (List<PlaceQuiz>), `associatedCharacterIds`, `nearbyPlaceIds`, color theme hex.

**Place Details Page** (`place_details_page.dart`) renders:
- Sliver app bar with hero image
- Facts carousel
- Historical timeline widget
- AI-generated insights (cached)
- Associated characters bridge (links to personality chat)
- Nearby places section
- Maps (Flutter Map with lat/long)

**Data Sources:** Firestore + Wikimedia + Pixabay + Wikipedia scraper.

**Gamification hook:** Viewing a place detail triggers `recordPlaceDiscovered(placeId)` → +50 XP (idempotent, first visit only).

### 3.2 Characters Module

**Entities:** `Character` — id, name, category (`CharacterCategory`), imageUrl, title, dob, dod, description, era, origin, bio, chatPrompt, tone, communicationStyle, domainKnowledge, knowledgeCutoffYear, speechStyle, emotionalTriggers, fallbackResponses (×3), rateLimitWarning, contributions, facts, specialties, contextFacts, quiz questions, nationality, legacy, achievements.

**Seeded Characters (5 starters via `character_seeder.dart`):**
| Name | Era | Category | Key Fact |
|------|-----|----------|----------|
| Ibn Battuta | 1304–1368 | Explorers | 117,000 km journey, wrote the Rihla |
| Cleopatra VII | 69–30 BC | Emperors | Spoke 9 languages; Battle of Actium |
| Leonardo da Vinci | 1452–1519 | Scientists | Polymath; mirror script notebooks |
| Salahuddin Ayyubi | 1137–1193 | Emperors | Recaptured Jerusalem 1187; died with 47 silver coins |
| Marie Curie | 1867–1934 | Scientists | Only person with 2 Nobel Prizes (Physics + Chemistry) |

**Categories (8):** Scientists, Philosophers, Emperors, Explorers, Artists, Leaders, Inventors, Reformers.

### 3.3 AI "Talk to Local" Assistant (Place Guide)

- Endpoint: `LocalGuideService` → Gemini streaming
- Prompt builder: `LocalGuidePromptBuilder` — injects full place context (name, location, era, description, builtBy, constructionDate, facts, ticket/opening info)
- Behavior: No token pruning; lightweight single-session streaming
- UI: `LocalGuideChatPage` — minimal chat interface, no suggestion chips
- Route: `/local-guide` (receives `Place` object)

### 3.4 Quiz System

**Quiz Entity:** `Quiz` → list of `QuizQuestion` (question text, 4 options, `correctAnswerIndex`, optional explanation).

**Quiz Types implemented:**
- General quiz (home screen / quiz dashboard)
- Place-based quiz (questions from `Place.quizzes`)
- Character-based quiz (questions from `Character.quiz`)

**Difficulty levels:** Beginner / Enthusiast / Expert — used as category/filter labels; question set varies per difficulty tier.

**Cubit state:** `QuizCubit` tracks currentQuestionIndex, score, `showingExplanation`, `lastSelectedAction`, `isFinished`.

**High scores:** Persisted in SharedPreferences with key `quiz_high_score_{quizId}` as percentage (0–100).

---

## 4. AI Chat System Design

### 4.1 Personality Chat (Character-Aware)

**Prompt strategy** (`ChatPromptBuilder`):

```
IDENTITY: name, title, description
PERSONALITY STYLE: tone, communicationStyle, domainKnowledge
STRICT BEHAVIORAL RULES:
  - Always stay in character; never reveal AI nature
  - No AI filler phrases ("As an AI...", "I'm happy to help...")
  - Speak as a real person from your era

RESPONSE LENGTH TIERS (enforced in every response):
  Tier 1 — Greeting/casual:       1 sentence, max 15 words
  Tier 2 — Simple factual:        1–2 sentences, direct
  Tier 3 — Medium explanation:    2–4 sentences with brief context
  Tier 4 — Deep conceptual:       3–6 sentences max with analogies

STOPPING RULES:
  - Stop when answer is complete; no filler or pleasantries
  - Never repeat facts from conversation history
  - Prioritize natural over helpful

KNOWLEDGE BOUNDARY:
  - No knowledge after {cutoffYear}
  - If asked about modern topics: express confusion, relate to closest era concept
```

**Fallback responses** (3 per character, indexed by error type):
- Index 0: network / timeout error
- Index 1: rate limit reached
- Index 2: content filter triggered

### 4.2 Local Guide Chat (Place-Aware)

**Prompt strategy** (`LocalGuidePromptBuilder`):

```
CONTEXT: Full place data injected (name, location, era, description, builtBy,
         constructionDate, facts, UNESCO status, ticket price, opening hours)

STRICT RESPONSE RULES:
  1. Factual questions: max 1–2 sentences
  2. Descriptive questions: max 3 sentences
  3. Answer directly — no introductions, no "Great question!"
  4. Give exact numbers when available
  5. Stay focused on {place.name} only
  6. No bullet points unless user explicitly requests a list
  7. Natural, confident, helpful tone
  8. Expand only when explicitly asked
  9. Unknown info: one sentence admission
```

### 4.3 Context Handling Rules

- **History preservation:** Full conversation passed to Gemini; pruned only when >3000 tokens
- **Character context:** `contextFacts` map injected into initial system prompt
- **Place context:** Full `Place` entity fields injected into local guide prompt
- **Session scope:** Each chat session is independent; history loaded from Firestore on init

---

## 5. Quiz System Design

### Dynamic Question Generation

- Place quizzes: sourced from `Place.quizzes` (List<PlaceQuiz> — seeded in Firestore or hardcoded per place)
- Character quizzes: sourced from `Character.quiz` (List<QuizQuestion>)
- General quiz: fetched via `getDailyQuiz()` use case (category-filterable)

### Non-Repetitive Logic

- `completedQuizIds` in `UserProgress` tracks finished quizzes (idempotent)
- High scores stored per `quizId` — prevents re-awarding XP for same quiz

### Difficulty Scaling

- Beginner / Enthusiast / Expert used as filter/category labels
- No dynamic AI generation yet — questions are pre-authored per entity

### Context-Based Variation

- Quiz launched from place detail page uses `Place.quizzes` directly
- Quiz launched from character detail page uses `Character.quiz` directly
- Quiz dashboard uses general pool filtered by category

---

## 6. Data Flow

### User Chat Flow (Personality)

```
User types message
  → ChatCubit.sendMessage()
    → RateLimitService.checkAndIncrement()   [block if quota exceeded]
    → ResponseCacheService.checkCache()      [return cached if hit]
    → ChatPromptBuilder.build(character)     [construct system prompt]
    → OpenAIChatService.sendStream()         [Gemini streaming]
      → MemoryScorer prunes history if >3000 tokens
      → Emit chunks → UI updates in real-time
    → ResponseValidator.validate()           [detect anachronisms]
    → Firestore: save message
    → SuggestionService.generate()           [follow-up suggestions]
    → GamificationProvider.recordMessageSent() [+5 XP]
```

### User Chat Flow (Local Guide)

```
User types message
  → LocalGuideCubit (or equivalent handler)
    → LocalGuidePromptBuilder.build(place)   [inject place context]
    → LocalGuideService.sendStream()         [Gemini streaming, no pruning]
    → Emit chunks → UI updates in real-time
```

### Quiz Answer Flow

```
User selects answer
  → QuizCubit.answerQuestion(index)
    → Check correctness
    → Emit state with showingExplanation=true
    → BlocListener triggers:
        isCorrect → GamificationProvider.recordCorrectAnswer()   [+10 XP]
        wrong    → GamificationProvider.recordWrongAnswer()      [+2 XP]
  → User taps Next
    → QuizCubit.nextQuestion()
        if last: emit isFinished=true
                 save high score in SharedPreferences
                 GamificationProvider.recordQuizSessionComplete()  [+30 XP]
                 GamificationProvider.recordQuizCompleted(quizId)  [+20 XP, idempotent]
```

### Place Discovery Flow

```
User opens place detail
  → PlaceDetailsCubit.loadPlaceDetails(placeId)
    → GetPlaceDetailsUseCase → Firestore
    → BlocListener: PlaceDetailsLoaded
      → UserProgressService.recordPlaceExplored(placeId)
      → GamificationProvider.recordPlaceDiscovered(placeId)  [+50 XP, idempotent]
    → Render: image, facts, timeline, AI insights, characters, nearby places
```

### Context Passing (Place → Character)

```
Place detail page shows associatedCharacterIds
  → User taps character card
    → Navigator pushes PersonalityChatPage(character: character)
    → ChatCubit initializes with character context
```

---

## 7. Current Implementation Decisions

### Token Pruning (MemoryScorer)

Activated when conversation history exceeds **3000 tokens**. Scoring per turn:

| Factor | Weight | Rule |
|--------|--------|------|
| Recency | 50% | `(index / totalTurns) * 50` |
| Anchor preservation | Hard | First turn gets +1000 (never deleted) |
| Intellectual density | 30% | +15 if user>60 words or AI>150 words |
| Domain alignment | 20% | +10 per match against `character.domainKnowledge` |
| Intellectual keywords | Bonus | +5 each (explain, why, theory, philosophy, science) |
| Casual penalty | Malus | -10 for greetings/small talk |

Prune loop: remove lowest-scored turn → re-measure → repeat until ≤3000 tokens.

### Rate Limiting

- Daily quota: **100 messages per user**
- Warning threshold: 80% (20 messages remaining)
- Storage: SharedPreferences key `rl_{userId}_{YYYY-MM-DD}`
- On block: `ChatState.isRateLimited = true` → modal shown

### Response Caching

- In-memory `Map<characterId, Map<question, response>>`
- Key: lowercase trimmed question text
- Optional Firestore persistence for cross-session hits
- Cache is per-session only unless explicitly synced

### Gamification — Idempotency

- `completedQuizIds` and `exploredPlaceIds` in `UserProgress` prevent double XP
- `lastLoginDate` checked at day boundary for streak continuity
- Badge unlock checks are additive and stored in `unlockedBadges` list

### Level Formula

```
XP required for level n = Σ floor(100 × k^1.5)  for k = 1 to n-1
Level 1: 0 XP
Level 2: 100 XP
Level 3: 383 XP
Level 4: 903 XP
```

Rank labels: Novice Explorer → Time Traveler (5+) → Expert Explorer (10+) → Master Scholar (15+) → Legendary Historian (20+).

### Prompt Engineering Constraints

- Response length tiers are **embedded in every system prompt** — not runtime-configurable
- Knowledge cutoff year is per-character (`Character.knowledgeCutoffYear`)
- Local guide prompt enforces **1–3 sentence maximum** regardless of question complexity
- Characters must never acknowledge being AI — no escape hatch built in

### Routing

GoRouter with auth guard redirect. Admin users routed to `/admin` on login. Transitions: fade (auth/admin), slide (most), bottom-up (quiz/progress), portal (detail pages).

---

## 8. Known Issues / Limitations

| Issue | Area | Status |
|-------|------|--------|
| Quiz difficulty system is label-only | Quiz | Questions not dynamically generated per difficulty |
| Response cache is in-memory only | Chat | Lost on app restart unless Firestore sync is active |
| Local guide has no conversation history | Places | Each message is stateless (no multi-turn context) |
| Character seeder is hardcoded | Personalities | Only 5 characters; adding more requires code change |
| AI insights caching strategy unclear | Places | May hit Gemini on every detail page load |
| SQLite database_helper usage undefined | Core | Unclear what data is stored vs Firestore |
| No quiz for AI-generated questions | Quiz | All quiz questions are pre-authored, no dynamic generation |
| Streak breaks on timezone edge cases | Gamification | UTC day boundary may not match user's local midnight |

---

## 9. Recent Changes Log

| Date | Change |
|------|--------|
| 2026-04-29 | Created PROJECT_CONTEXT.md — full architecture, AI chat design, quiz system, gamification, data flow documented |
| 2026-04-29 | Places module extended: LocalGuideChatPage, PlaceDetailPage (new), local_guide_service, local_guide_prompt_builder, place_insights_service added |
| 2026-04-29 | Gamification system finalized: XP rewards, badge unlock conditions, level formula, streak logic, idempotency rules |
| 2026-04-29 | Chat system: MemoryScorer token pruning, RateLimitService (100/day), ResponseCacheService, SuggestionService, ResponseValidator all active |
| 2026-04-29 | Character seeder finalized with 5 historical figures: Ibn Battuta, Cleopatra VII, Leonardo da Vinci, Salahuddin Ayyubi, Marie Curie |
| 2026-04-29 | Chat prompt builder enforces 4-tier response length system in all character system prompts |
| 2026-04-29 | Router updated: /local-guide, /place-details (new detail page), /quiz-play, /progress routes added |
