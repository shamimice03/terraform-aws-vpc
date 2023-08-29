# Contributing
When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

## Pull Request Process
1. Update the README.md with details of changes including example hcl blocks and [example files](./examples) if appropriate.
2. Run pre-commit hooks `pre-commit run -a`.
3. Once all outstanding comments and checklist items have been addressed, your contribution will be merged! Merged PRs will be included in the next release. The maintainers take care of updating the CHANGELOG as they merge.

## Checklists for contributions
- [ ] Add [semantics prefix](#semantic-pull-requests) to your PR or Commits (at least one of your commit groups)
- [ ] CI tests are passing
- [ ] `README.md` has been updated after any changes. The variables and outputs in the README.md has been generated (using the `terraform_docs` pre-commit hook).
- [ ] Run pre-commit hooks `pre-commit run -a`

## Semantic Pull Requests
To generate changelog, Pull Requests or Commits must have semantic and must follow conventional specs below:

- `feat:` for new features. `example: feat(new featute): added new feature`
- `fix:` for bug fixes
- `docs:` for documentation and examples
- `refactor:` for code refactoring
- `ci:` for CI purpose
- `test:` Adding missing tests or correcting existing tests

## Pull Request Template
- [ ] A new feature (PR prefix `feat`)
- [ ] A bug fix (PR prefix `fix`)
- [ ] Documentation only changes (PR prefix `docs`)
- [ ] A code change that neither fixes a bug nor adds a feature (PR prefix `refactor`)
- [ ] Changes to our CI configuration files and scripts (PR prefix `ci`)
- [ ] Adding missing tests or correcting existing tests (PR prefix `test`)
