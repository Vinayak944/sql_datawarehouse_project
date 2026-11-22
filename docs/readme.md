# Project documentation

These notes describe the SQL Server warehouse as it is implemented in this repository. They are based on the checked-in Compose, SQL, and test files.

| Document | What it covers |
| --- | --- |
| [Project overview](project_overview.md) | Goals, scope, and known boundaries |
| [Data architecture](data_architecture.md) | Docker host, SQL Server, and Bronze/Silver/Gold layers |
| [Data flow](data_flow.md) | CSV-to-table lineage and load sequence |
| [Data model](data_model.md) | Gold view relationships, grain, and output fields |
| [Data catalog](data_catalog.md) | Source inventory, layer tables, and Gold outputs |
| [Data quality checks](data_quality_checks.md) | Existing check scripts and execution cautions |
| [Naming conventions](naming_conventions.md) | Naming patterns observed in the current project |

The diagrams use Mermaid so they remain editable as text and render on GitHub.
