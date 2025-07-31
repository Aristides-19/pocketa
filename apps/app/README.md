## Structure

```pwsh
lib/
└── src/
    ├── widgets/
    ├── constants/
    ├── localization/
    ├── routing/
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
        ├── export/
        └── splash/
```

## Inner Structure

```pwsh
auth/
├── repository/     # Data Source
├── model/          # Model Entities
├── application/    # Providers & Logic
└── presentation/   # Widgets & Screens
```