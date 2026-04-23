# Admin Dashboard Implementation Plan - Time Explorer

The goal is to build a modern, robust, and secure Admin Dashboard with a Node.js/Express backend and Next.js frontend.

## 🛠 Tech Stack
- **Backend**: Node.js, Express, Firebase Admin SDK.
- **Frontend**: Next.js, Tailwind CSS, Lucide Icons.
- **Database**: Google Cloud Firestore.

## 📋 Task List

### Phase 1: Backend (Express API)
- [ ] Initialize Express project in `backend/`.
- [ ] Setup Firebase Admin SDK with valid credentials.
- [ ] Implement `Users` CRUD endpoints (`/api/users`).
- [ ] Implement `Places` CRUD endpoints (`/api/places`).
- [ ] Implement `Personalities` CRUD endpoints (`/api/personalities`).
- [ ] Add input validation (validator.js) for models.

### Phase 2: Frontend (Next.js Dashboard)
- [ ] Initialize Next.js project in `admin-dashboard/`.
- [ ] Design layout with Sidebar and Navbar (Tailwind CSS).
- [ ] Create search-capable `DataTable` component.
- [ ] Implement `Users Management` page.
- [ ] Implement `Places Management` page.
- [ ] Implement `Personalities Management` page (linked to Places).
- [ ] Add `Modal` forms for adding/editing entities.

### Phase 3: Testing and Verification
- [ ] Verify linked data consistency (Personality -> Place).
- [ ] Test system security and validation logic.
- [ ] Finalize with a recorded walkthrough.

---

## 📅 Roadmap

### Today
- Setup both projects.
- Implement core backend routes.
- Implement the dashboard layout.
