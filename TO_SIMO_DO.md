# TO_SIMO_DO

- **Publish to App Store**: The version has been bumped to 1.1 (build 2). Please open the project in Xcode, create an Archive (Product > Archive), and upload the new build to App Store Connect to publish the new version.

- **Recreate the App Store archive**: Discard the archive rejected with error 90771, create a new archive containing the corrected background modes, and upload that new archive to App Store Connect.

## Website rebuild (2026-08-05)

- **Publish the new site**: the build output is already in `/docs`. Commit and push `docs/`, `website/`, `.gitignore` and the docs files to `main` — GitHub Pages serves `/docs` on `main`, so the new site goes live on that push. Check that Settings → Pages still points at `main` / `/docs`.
- **Rebuild command** whenever you edit the site: `npm --prefix website install` once, then `npm --prefix website run build` (writes into `/docs`).
- **Naming**: the site is branded **SafeSpotter**, matching the App Store listing and `PRODUCT_NAME`. `README.md`, `specifiche.md` and the in-code comments still say "SafeSpot" in places — worth aligning when you next touch them.
- **Support email**: the site now shows `mattioli.simone.10@gmail.com`. Update the Support URL / contact in App Store Connect if it still lists anything else.
- **App Store screenshots**: the site uses the six screenshots from the current listing. If you upload new ones, re-crop them into `website/src/assets/screens/` and rebuild.
- **Social card**: `website/public/og.png` was rendered from `website/og.html`. To regenerate after a copy change, open `og.html` at 1200×630 and screenshot it.
- **Optional cleanup**: `website/node_modules/` is committed to the repository from earlier work. It is now in `.gitignore`, but the already-tracked files stay tracked until you run `git rm -r --cached website/node_modules`.
