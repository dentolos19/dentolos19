# Git

## Commits

- Write the subject as a past-tense action in sentence case without a trailing period, such as `Added README.md` or `Updated authentication system`.
- Add a body when the subject alone does not explain the change: one or two short paragraphs on what changed and why, in plain language.
- Do not hard-wrap the body. Write each paragraph on a single line.

## Pull Requests and Issues

- Write PR titles in Title Case as a feature or a fix, like `Case Region Improvements` or `Agentic Integration`.
- Structure PR descriptions with a `## Summary` section giving an overview, followed by a `## Changes` section listing the specific modifications.
- Structure issue descriptions with a `## Summary` section giving an overview, followed by a `## Requirements` section listing the requirements as bullet points.
- Keep issue and PR descriptions approachable rather than technical.

## GitHub

- Set the about description to a short, direct, one-sentence description of the product or purpose.
- Set the homepage to a verified public project URL, such as the custom domain declared by its deployment configuration.
- For topics, use lowercase, single-word topics. Include languages, major frameworks, platforms, concise product-domain terms the repository actually uses, and context topics such as `hackathon`, `assignment`, `experimental`, `personal`, `community`, and `club`.
- Remove stale, misspelled, redundant, or speculative topics when replacing the topic set. Do not include frameworks the repository does not depend on, redundant tags like `web`, or incidental ones like `css`.
- Keep GitHub's 9 default issue labels with their default colors and descriptions. Add project-specific labels as needed.
- Enable secret scanning and push protection for eligible repositories.
- To update settings on an archived repository, unarchive it, apply the edits, and archive it again. GitHub disables push protection when a repository is archived, so secret scanning alone is the expected state for archived repositories.

For GitHub Actions workflows, see [Configuration](configuration.md#github-actions).
