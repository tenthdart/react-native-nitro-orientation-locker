# Publishing to npm

This package is published as
[`@tenthdart/react-native-nitro-orientation-locker`](https://www.npmjs.com/package/@tenthdart/react-native-nitro-orientation-locker)
under the MIT license, scoped to the
[`tenthdart`](https://www.npmjs.com/org/tenthdart) npm organization.

There are two paths: **automated via GitHub Releases** (recommended) and
**manual from your machine**.

---

## One-time setup

### 1. Confirm the name is free under the scope

```sh
npm view @tenthdart/react-native-nitro-orientation-locker
```

A `404` means the name is available.

### 2. Create an npm Granular Access Token for the scope

1. Sign in at https://www.npmjs.com.
2. **Avatar → Access Tokens → Generate New Token → Granular Access Token**:
   - **Expiration**: 1 year (or your policy)
   - **Packages and scopes**:
     - Select **"Only select packages and scopes"**
     - Add the **`@tenthdart` scope** (this grants publish rights to every
       package under the org, including ones that don't exist yet — required
       for first-time publish)
   - **Permissions** → Packages and scopes: **Read and write**
3. Copy the `npm_…` token (shown only once).

> **Why a scope and not "Only select packages"?**
> A package-level grant can only publish to packages that already exist on
> npm. The very first publish of a new package needs scope-level (or
> account-level) write access.

> **2FA gotcha**: under npm Account Settings → Two-Factor Authentication,
> if 2FA is set to **"Authorization and publishing"**, automation tokens
> cannot publish. Switch to **"Authorization only"** or migrate to Trusted
> Publishing once the package exists.

### 3. Add the token as a GitHub secret

In the repo on GitHub → **Settings → Secrets and variables → Actions → New repository secret**:

- Name: `NPM_TOKEN`
- Value: the `npm_…` token

### 4. (After first publish) switch to Trusted Publishing

Once `@tenthdart/react-native-nitro-orientation-locker` exists on npm, on
its package page → **Settings → Publishing access** → add **Trusted
Publisher → GitHub Actions** pointing at this repo + the `publish.yml`
workflow. You can then delete `NPM_TOKEN` and remove `NODE_AUTH_TOKEN`
from the workflow — `--provenance` keeps working via OIDC.

---

## Automated release (recommended)

```sh
# 1. Bump version (creates a commit + tag like v0.1.1)
npm version patch     # or minor / major

# 2. Push the commit + tag
git push --follow-tags

# 3. Create a GitHub Release from the tag
#    UI:  Releases → Draft a new release → choose tag v0.1.1 → Publish
#    CLI: gh release create v0.1.1 --generate-notes
```

Publishing the GitHub Release fires `release: published`, which triggers
`.github/workflows/publish.yml` to install deps, run nitrogen, typecheck,
and `npm publish --access public --provenance`.

### Dry-run before a real release

Actions tab → **Publish to npm → Run workflow → Dry run: true**. Runs
`npm publish --dry-run` so you can inspect the tarball without publishing.

---

## Manual release (fallback)

```sh
npm login                                                # one-time
npm ci
npx nitrogen                                             # populate nitrogen/generated/
npm run typecheck
npm pack --dry-run                                       # inspect tarball
npm version patch                                        # bump + tag
git push --follow-tags
npm publish --access public                              # prepublishOnly runs bob build
```

After publishing, verify:

```sh
npm view @tenthdart/react-native-nitro-orientation-locker version
npm view @tenthdart/react-native-nitro-orientation-locker files
```

---

## Pre-publish checklist

Before the very first publish:

- [ ] `package.json` `name` is `@tenthdart/react-native-nitro-orientation-locker`
- [ ] `publishConfig.access` is `public` (scoped packages default to private otherwise)
- [ ] `version` is `0.1.0` (or your starting version)
- [ ] `repository`, `homepage`, `bugs`, `author` are correct
- [ ] `LICENSE` matches `package.json` `license`
- [ ] `nitrogen/generated/` is committed (consumers don't run nitrogen)
- [ ] `package-lock.json` is committed (`npm ci` in CI depends on it)
- [ ] `npm pack --dry-run` shows only the expected files

For every subsequent publish:

- [ ] Bump version following semver
- [ ] Tag matches `package.json` version

---

## Unpublishing / deprecating

npm only allows unpublishing within 72 hours and if there are no dependents.
Prefer `deprecate`:

```sh
npm deprecate @tenthdart/react-native-nitro-orientation-locker@"<0.1.1" \
  "Critical fix in 0.1.1, please upgrade"
```
