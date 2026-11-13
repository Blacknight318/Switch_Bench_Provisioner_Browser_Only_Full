# Release Process

## Version scheme

Use [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html), with a `v` prefix for Git tags and GitHub Releases.

- **Major** (`v1.0.0` → `v2.0.0`): incompatible change to the profile schema, generated IOS command behavior, required browser/security model, or supported workflow.
- **Minor** (`v0.1.0` → `v0.2.0`): backward-compatible capability, control, model, or FAQ/documentation addition.
- **Patch** (`v0.1.0` → `v0.1.1`): backward-compatible bug fix, security fix, documentation correction, or packaging fix.
- **Pre-release** (`v0.2.0-rc.1`): candidate requiring review or bench validation before the stable tag.

Remain in `0.x` while the public profile schema and supported provisioning behavior can still change without a formal compatibility guarantee. Declare `v1.0.0` only after the profile schema, safety gates, and supported platform/workflow contract are intentionally stable.

## What the release workflow publishes

Pushing a valid version tag runs `.github/workflows/release.yml`. The workflow:

1. Confirms the tag matches the root `VERSION` file.
2. Validates the release file set and fails if private `.env`, `profile.json`, keys, certificates, scan output, or archives are tracked.
3. Validates the strict CSP and the expected split `index.html` / `styles.css` / `app.js` structure.
4. Creates a clean ZIP with only the documented distribution files.
5. Creates a SHA-256 checksum file.
6. Creates a GitHub Release and attaches both artifacts.

The generated ZIP deliberately excludes `.github/`, release automation, CodeQL configuration, Git metadata, local profiles, key files, logs, and assessment artifacts.

## Release checklist

1. Ensure the default branch is clean and the GitHub Pages demo reflects the intended commit.
2. Review CodeQL, secret scanning, and Dependabot/security alerts. Resolve or document every open result before release.
3. Confirm no secrets or site-specific values are staged:

   ```text
   .env
   profile.json
   private keys, certificates, tokens, passwords, scan output, logs, CKLB files, archives
   ```

4. Test the hosted page and a localhost copy in Chromium/Edge:
   - profile/key-file selection;
   - redacted plan generation;
   - normal configuration generation;
   - port-use protection;
   - serial apply gates; and
   - FAQ/example-file links.
5. Update `VERSION` and `CHANGELOG.md` together. The value in `VERSION` has no leading `v`.
6. Commit the release preparation, then create and push the matching tag:

   ```bash
   git add VERSION CHANGELOG.md
   git commit -m "Release v0.1.0"
   git tag -a v0.1.0 -m "Release v0.1.0"
   git push origin main --follow-tags
   ```

7. Review the generated GitHub Release. Download its ZIP and checksum; verify the checksum locally before distributing it.

## Emergency security fix

For a confirmed exposure or security defect:

1. Remove the affected material from the current branch and rotate any exposed credential; deleting a pushed secret does not remove it from Git history.
2. Record the remediation in `CHANGELOG.md`.
3. Release a patch version (for example, `v0.1.1`) as soon as the fix and scans are verified.
4. If the release artifact itself contained a secret, delete the GitHub Release asset and notify every known recipient to stop using it. Credential rotation remains mandatory.
