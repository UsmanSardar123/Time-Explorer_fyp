# Time Explorer — Final Architecture

## System Diagram

```
┌─────────────────────────────────────┐
│          Flutter App (Client)        │
│  - Bloc state management             │
│  - Clean Architecture layers         │
│  - No direct Firestore access        │
└──────────────┬──────────────────────┘
               │
               │ 1. Sign in / Sign up
               ▼
┌─────────────────────────────────────┐
│         Firebase Auth (Google)       │
│  - Handles identity only             │
│  - Issues a signed JWT (ID Token)    │
│  - Token expires in 1 hour           │
└──────────────┬──────────────────────┘
               │
               │ 2. Every API request carries:
               │    Authorization: Bearer <ID Token>
               ▼
┌─────────────────────────────────────┐
│      Node.js API  (Express)          │
│                                      │
│  Middleware stack (in order):        │
│  ① helmet        — HTTP headers      │
│  ② cors          — origin control    │
│  ③ morgan        — request logs      │
│  ④ globalLimiter — 200 req/15 min    │
│  ⑤ express.json  — 50 kb cap         │
│                                      │
│  Per-route guards:                   │
│  • verifyToken   — validates JWT     │
│  • aiLimiter     — 10 req/min on AI  │
│  • validate.*    — input validation  │
│                                      │
│  Routes:                             │
│  /api/users        (CRUD, auth)      │
│  /api/places       (read public,     │
│                     write auth)      │
│  /api/personalities (read public,   │
│                      write auth)    │
│  /api/characters   (read only)       │
│  /api/ai/ask       (auth + limiter)  │
│  /api/health       (public)          │
└──────┬───────────────────┬──────────┘
       │                   │
       │ 3. Admin SDK       │ 4. HTTP fetch
       ▼                   ▼
┌──────────────┐   ┌───────────────────┐
│  Firestore   │   │   Gemini API      │
│ (Admin SDK)  │   │ (Google AI)       │
│              │   │                   │
│ Collections: │   │ gemini-1.5-flash  │
│ • users      │   │ 15 s timeout      │
│ • places     │   │                   │
│ • personalities│  └───────────────────┘
│ • characters │
└──────────────┘
```

---

## Why Each Layer Exists

### Flutter App
Handles all UI, routing, and user interactions. Uses Bloc for predictable state. Talks exclusively to the Node.js API — never to Firestore directly.

### Firebase Auth
Sole source of identity. Produces a cryptographically signed JWT after login. The Flutter SDK handles token refresh automatically. No custom auth code needed.

### Node.js API (Express)
The critical enforcement layer. Every data operation passes through here so that:
- Auth is verified server-side (Firebase Admin SDK checks JWT signature)
- Input is validated and sanitized before touching Firestore
- Business rules (who can write what) are enforced in one place
- Rate limiting protects Gemini costs and prevents abuse
- Secrets (Gemini key, service account) never leave the server

### Firestore (via Admin SDK)
Accessed only by the Node.js server using the Admin SDK, which bypasses Firestore Security Rules entirely. This is safe because the API layer enforces all access control. The Admin SDK credential is stored as an environment variable — never in the repository.

### Gemini API
Called directly from the AI controller with a server-side API key. The Flutter app never holds the key; it only sends prompts through the authenticated `/api/ai/ask` endpoint.

---

## Why Flutter Does NOT Access Firestore Directly

| Concern | Direct Flutter → Firestore | Flutter → Node.js → Firestore |
|---|---|---|
| Secret management | API keys in app bundle (extractable) | Keys stay on server |
| Auth enforcement | Firestore Security Rules (complex, error-prone) | Middleware in one place |
| Input validation | Client-side only (bypassable) | Server-side, always enforced |
| Rate limiting | Not available | Per-IP limits on every route |
| Business logic | Scattered across rules + client | Centralised in controllers |
| Audit logging | None | Structured server logs |

---

## Security Controls Summary

| Control | Implementation |
|---|---|
| Auth on all write routes | `verifyToken` middleware (Firebase JWT) |
| No secrets in codebase | `.env` + `.gitignore`; service account via env var |
| Input validation | `express-validator` on all POST/PUT routes |
| Field whitelisting | Controllers build explicit objects — no `req.body` pass-through |
| Payload size cap | `express.json({ limit: '50kb' })` |
| Global rate limit | 200 req / 15 min per IP |
| AI rate limit | 10 req / 1 min per IP |
| HTTP hardening | `helmet` (CSP, HSTS, X-Frame-Options, etc.) |
| No stack traces in prod | `errorHandler` returns generic message on 500 |
| Auth failure logging | IP + URL logged on every rejected token |
| Firestore result cap | Places limited to max 50 per query |
