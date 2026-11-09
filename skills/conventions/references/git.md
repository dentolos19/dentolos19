# Git

- Describe commit messages as past-tense actions, such as `Added README.md` or `Updated authentication system`.
- Write PR titles as a feature or a fix, like `Case Region Improvements` or `Agentic Integration`.
- For PR descriptions, include a summary section with a overview of the PR, and then the changes section listing the specific modifications.
- Do not be too technical on the description when writing issues or pull requests.

# Ignores

- In `dentolos19`, use the `.gitignore` file as a base template for any project.
- Sync rules for other ignore files including `.dockerignore`, use the local `.gitignore` as a base.
- Put normal rules at the top, exception rules at the bottom, with a empty line separating them.
- Sort rules alphabetically. Do not add comments.

## GitHub

- Set the about description to a short, direct, one-sentence description of the product or purpose.
- Set the homepage to a verified public project URL, such as the custom domain declared by its deployment configuration.
- For topics, use lowercase, single-word topics. Include languages, major frameworks, platforms, and concise product-domain terms that the repository actually uses.
- Remove stale, misspelled, redundant, or speculative topics when replacing the topic set.
- Enable secret scanning and push protection for eligible repositories.

## GitHub Actions

- Format cache keys as `v{version}-{group}-{dependencies}`. Group names must contain no spaces or dashes. Include only inputs needed for cache invalidation or isolation. Use matching version, group, and scope prefixes for `restore-keys`. Separate save steps must reuse the restore step’s `cache-primary-key`. Bump the version when the cache format becomes incompatible.
