# RangBazaar

A premium mini e-commerce Flutter app for an assignment review. Brand: **RangBazaar** (रंग बाज़ार) — *Har cheez, har rang.*

Flow: **Splash → Login → Categories → Product list → Product details → Cart**

Catalog data comes from the public [Fake Store API](https://fakestoreapi.com). Login is local validation plus a simulated delay. Cart lives in memory. Checkout is a placeholder.

## Features

- Animated splash with the RangBazaar lockup
- Email/password login with form validation (no real auth backend)
- Category dashboard from `GET /products/categories`
- Product list from `GET /products/category/{category}`
- Product details from `GET /products/{id}` (ID in the route, always fetched)
- In-memory cart with quantity merge, badge, empty state, INR totals
- Light and dark Material 3 themes, preference persisted
- Loading skeletons, empty states, retryable errors, cached images
- Responsive grids for phone and tablet widths

## Architecture

Feature-first layout with a thin shared core:

- **UI** — pages and reusable widgets
- **State** — Riverpod `Notifier` / `FutureProvider`
- **Data** — `CatalogRepository` over a Dio client
- **Domain** — `Product`, `Category`, `Rating`, `CartItem`

```text
lib/
  core/           # theme, network, router, shared widgets
  features/
    splash/
    auth/
    catalog/      # categories, list, details + Fake Store repository
    cart/         # in-memory cart
    settings/     # theme persistence
```

`UI → Provider → Repository → DioClient → Fake Store API`

## Tech stack

- Flutter 3.47 / Dart 3.13
- flutter_riverpod
- dio
- go_router
- shared_preferences
- cached_network_image
- intl

## API

Base URL: `https://fakestoreapi.com`

| Purpose | Endpoint |
| --- | --- |
| Categories | `/products/categories` |
| Products by category | `/products/category/{category}` |
| Product details | `/products/{id}` |

Prices from the API are numeric only. The app formats them as INR (e.g. `₹1,299.00`) without applying a currency conversion.

## State management

- `categoriesProvider` / `productsByCategoryProvider` / `productDetailsProvider` — async catalog
- `cartProvider` — in-memory cart; adding an existing product increases quantity
- `themeModeProvider` — light/dark, stored in `SharedPreferences`
- `loginControllerProvider` — simulated submit lock

Cart is watched across routes so the badge stays correct on Home, list, details, and cart.

## Theme

`AppColors`, `AppTheme`, `AppSpacing`, `AppRadius`, and `AppTypography` define a navy + pink/coral system sampled from the logo. Widgets use `ColorScheme` and a `RangBazaarColors` theme extension — no scattered hex values.

## How to run

```bash
cd rang_bazaar
flutter pub get
flutter run
```

On a connected Android phone:

```bash
flutter devices
flutter run -d <device_id>
```

Demo login: any valid email and a password of at least 6 characters (for example `demo@rangbazaar.in` / `secret1`).

## How to build

```bash
flutter build apk        # Android
flutter build ios        # iOS (macOS)
```

## Tests

```bash
flutter test
flutter analyze
dart format .
```

Covered: email/password validation, cart add/merge, quantity, removal, totals, INR formatting.

## Assumptions / limitations

- No real authentication or session persistence
- Cart is not persisted across process death
- Checkout does not process payment
- Fake Store category spelling `jewelery` is mapped to **Jewellery** in the UI
- Product images are remote; failed loads show a placeholder
