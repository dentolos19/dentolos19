# GitHub

Use this reference when changing repository metadata, topics, features, archive state, Actions permissions, or security settings. Read the current remote state first and verify every write afterward.

## Metadata

- Write a short, direct, one-sentence description of the product or purpose.
- Keep descriptions independent of implementation details; do not mention programming languages or frameworks.
- Set the homepage only to a verified public project URL, such as the custom domain declared by its deployment configuration.

## Topics

- Use lowercase, single-word topics.
- Include languages, major frameworks, platforms, and concise product-domain terms that the repository actually uses.
- Use these classification topics exactly when applicable: `community`, `experimental`, `hackathon`, and `assignment`.
- Personal projects receive none of those classification topics.
- Remove stale, misspelled, redundant, or speculative topics when replacing the topic set.

## Repository Settings

- Preserve visibility unless the user explicitly requests a change.
- Unarchive a repository only when the user explicitly asks to reactivate it or when a requested remote write requires reactivation and the intent is clear.
- Disable Issues, Projects, Wiki, and Discussions for application repositories that do not use those features; preserve a feature that has active project content.
- Keep GitHub Actions enabled with read-only default workflow permissions and prevent workflows from approving pull requests unless the project requires it.
- Preserve existing merge methods and branch protection unless the user requests a policy change.

## Security

- Enable secret scanning and push protection for eligible public repositories.
- Treat GitHub-reported unavailability on private repositories as a licensing limitation and report it rather than weakening another setting.
- Preserve Dependabot and advanced security settings unless the task explicitly includes them.

## Verification

- Read back the description, homepage, visibility, archive state, feature flags, topics, and requested security settings after updates.
- Verify Actions permissions separately because they use a different GitHub API endpoint.
