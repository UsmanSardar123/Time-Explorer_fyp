# .NET Version Upgrade

## Preferences
- **Flow Mode**: Automatic
- **Target Framework**: .NET 10 (LTS)

## Source Control
- **Source Branch**: main
- **Working Branch**: upgrade-dotnet-10
- **Commit Strategy**: After Each Task
- **Branch Sync**: Auto (Merge)

## Strategy
**Selected**: No-op
**Rationale**: The assessment found no .NET solution or project in the repository, so there is no executable .NET version upgrade scope.

### Execution Constraints
- Do not modify source code, dependencies, or build configuration.
- Do not run .NET restore, build, or test validation because no .NET target exists.
- Stop the scenario until a valid .NET solution or project path is supplied.
