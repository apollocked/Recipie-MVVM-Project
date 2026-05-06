## Dio Recipe MVVM Project

A Flutter recipe browsing app built with a layered structure (`data`, `logic`, `presentation`) and modern state management.  
The app fetches recipes from an API using `dio`, supports search and favorites, and includes light/dark theme switching with persistence.

---

### Features

- Browse recipes in a card-based feed with image, cuisine, cook time, calories, and rating.
- Open a recipe details bottom sheet with full ingredients and step-by-step instructions.
- Search recipes by name with an animated in-app search field.
- Save and unsave favorite recipes from any recipe card.
- View favorites in a dedicated tab.
- Pull to refresh recipes from the API.
- Switch between light and dark theme from settings (with confirmation dialog).
- Persist favorites and theme mode locally using `shared_preferences`.
- Use environment-based flavors:
  - `main_dev.dart` loads `.env.dev`
  - `main_prod.dart` loads `.env.prod`

---

### Tech Stack

- Flutter
- Dart
- Dio
- flutter_bloc
- Provider
- go_router
- shared_preferences
- flutter_dotenv

---

### Project Structure

```text
lib/
  core/            # App theme, routes, constants, shared utilities
  data/            # API service, repository, recipe model
  logic/           # BLoC (recipes) + Provider (theme)
  presentation/    # Pages, layout, and reusable widgets
  main_dev.dart    # Development entry point
  main_prod.dart   # Production entry point
```

---

### Getting Started

1. Install dependencies:

```bash
flutter pub get
```

2. Create and configure environment files in the project root:

```env
# .env.dev / .env.prod
FLAVOR=DEVELOPMENT
API_URL=https://your-api-endpoint
```

3. Run the app:

```bash
# Development flavor
flutter run -t lib/main_dev.dart

# Production flavor
flutter run -t lib/main_prod.dart
```

---

### Author

Muhammed Jameel  
Mobile Application Developer
