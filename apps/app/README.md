## Structure

```pwsh
lib/
└── src/
    ├── widgets/
    ├── constants/
    ├── localization/
    ├── router/
    ├── utils/
    └── features/
        # Core
        ├── auth/
        ├── local_auth/
        ├── cloud_sync/
        ├── profiles/
        ├── transactions/
        ├── categories/
        ├── currency/
        ├── preferences/
        ├── calculator/
        # Derived
        ├── insights/
        ├── search/
        ├── home/
        └── exports/
```

## Inner Structure

```pwsh
auth/
├── repository/     # Data Source
├── model/          # Model Entities
├── application/    # Providers & Logic
└── presentation/   # Widgets & Screens
```