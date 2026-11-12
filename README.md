# Switch Bench Provisioner — browser-only edition

## Contents
- `index.html` — the complete application.
- `profile.json` — site-specific non-secret working profile; do not distribute it unchanged.
- `profile.distribution.example.json` — sanitized distribution profile. Site names, addresses, infrastructure endpoints, and account names use `${VARIABLE}` placeholders resolved from the imported encrypted key file.
- `.env.example` — complete example key-file format. It contains placeholder site values and no usable secrets.
- `start-local.cmd` — optional Windows static-host launcher; it does not read profiles, keys, or serial data.

## Use
1. Copy `.env.example` to a private `.env` file and replace every placeholder. Do not upload or commit this file.
2. For distribution or a new site, start with `profile.distribution.example.json`. Keep `${VARIABLE}` references for all site-specific names, addresses, endpoints, and account names; define the corresponding values in the private `.env` file.
3. Run `start-local.cmd`, then open the localhost address it reports in Edge or Chrome. Web Serial requires a secure browser context; `localhost` is accepted.
4. In the app, connect to the serial adapter using **Connect serial**. Browser Web Serial is the only serial-port owner.
5. Use read-only inspection, paste/capture interface status, and edit the clickable port map. Ports found in use are protected unless individually overridden.
6. Import the selected profile and the private `.env` file. Enter a passphrase and click **Encrypt imported secrets in memory**.
7. Build and review the redacted plan. Re-enter the passphrase, acknowledge, type `APPLY`, and apply only to the intended bench switch at a privileged `#` prompt.

## Management SSH source list

Set `MGMT_SSH_SOURCES` in `.env` to a comma-separated list of approved IPv4 management sources. The tool accepts 1 through 100 unique addresses and expands them into sequential `MANAGEMENT_NET` ACL permits for SSH. The redacted plan shows one numbered placeholder per encrypted list item; the secure apply fills each actual address only in memory.

## SNMPv3 key-file entries
When the bundled profile’s SNMPv3 policy is enabled, add these entries to the private key file before locking it in the browser:

```text
SNMPV3_USERNAME=[REDACTED]
SNMPV3_AUTH_PASSWORD=[REDACTED]
SNMPV3_PRIV_PASSWORD=[REDACTED]
```

Use an SHA authentication secret and AES-128 privacy secret compatible with the monitoring platform. The profile sends SNMPv3 traps to its configured monitoring host and never shows these values in the secure preview.

## Secret handling
- The key file is read locally by the browser.
- It is encrypted in active-tab memory with AES-256-GCM, using a fresh random salt and IV plus PBKDF2-SHA-256 (600,000 iterations).
- It is not saved to localStorage, IndexedDB, downloads, server logs, or the preview.
- During secure apply, serial output is suppressed while credential-bearing commands are sent, then the received serial buffer is cleared. This prevents normal console logging of echoed secret commands; inspect protected-command errors directly at the physical switch if one occurs.
- Browser-memory encryption is not protection from a compromised unlocked workstation, malicious browser extension, or someone controlling the open browser tab.

## Safety
- The app does not run `write memory` or `copy running-config startup-config`.
- Every serial command waits for an IOS prompt and stops on detected IOS syntax/error text.
- Review the rendered plan and console before manually saving configuration.
- The normal configuration preview is non-secret; the secure profile preview redacts all key-file substitutions.
