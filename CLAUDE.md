# Chambi Frontend

## UI Framework
- Use **Cupertino widgets** exclusively (`CupertinoApp`, `CupertinoPageScaffold`, `CupertinoButton`, etc.)
- `uses-material-design: false` is set in pubspec.yaml — do not introduce Material widgets

## Design Style
- Follow an **Uber-like visual style**: just for the style, keep backgrounds white, high contrast, clean typography, minimal decoration
- Use bold, full-width buttons with rounded corners
- Prefer flat, card-less layouts with subtle separators over heavy card elevation
- Typography uses the **Lexend** font family (already configured)
- Keep the UI functional and professional — avoid decorative elements

## Backend
- Spring REST backend integration is **not yet functional** — do not implement real API calls
- Use mock data or stub responses for all backend interactions for now
