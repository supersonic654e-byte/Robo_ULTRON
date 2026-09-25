# Docs (ROBO_ULTRON)

Cross-version documentation for the mother project.

```
docs/
├── 00_project/           overview · roadmap · naming_and_versioning · glossary
├── 10_architecture/      system · ros · sensor_fusion · data_flow · safety · ai · diagrams
├── 20_engineering_process/  audit · risk_register · decisions (ADR) · quality_gates · changelog · deployment_guide
├── 30_data_and_privacy/  data_collection_spec · privacy_policy · data_dictionary
├── 40_business/          market_analysis
└── 90_reference/         BOM_shared · datasheets · CAD
```

**Reading order for a newcomer:** `00_project/overview.md` → `00_project/roadmap.md`
→ `10_architecture/system_architecture.md` → `versions/` for a specific build.

**Fast onboarding:** see [`GETTING_STARTED`](../GETTING_STARTED.md) (root) and [`ARCHITECTURE`](ARCHITECTURE.md) (this hub).

**Rule:** shared knowledge lives here; build-specific facts live under
`versions/V0.3_Ultron/`. If a fact is in both, the implementation Bible wins
for V0.3.

**Full index:**

| Area | Key docs | Also see |
|---|---|---|
| **Project** | `00_project/overview.md`, `roadmap.md`, `glossary.md` | `naming_and_versioning.md` |
| **Architecture** | [`ARCHITECTURE.md`](ARCHITECTURE.md) (hub map), `10_architecture/system_architecture.md`, `ros_architecture.md`, `safety_architecture.md` | `sensor_fusion.md`, `data_flow.md`, `ai_architecture.md`, `diagrams/` |
| **Process** | `20_engineering_process/quality_gates.md`, `engineering_audit.md`, `decisions/` (ADRs), `changelog.md` | `user_deployment_guide.md` |
| **Data & privacy** | `30_data_and_privacy/data_collection_spec.md`, `privacy_policy.md` | `data_dictionary.md` |
| **Business** | `40_business/market_analysis.md` | — |
| **Reference** | `90_reference/BOM_shared.md` | `datasheets/`, `CAD/` |
