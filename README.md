# MiniShortcutProgress v0.1 — RootHide/Relaxin

Target: iPhone XR, iOS 16.5 / 17.2, RootHide/Relaxin.

This first test build relies on Powercuts' Darwin workflow start/stop notifications. Keep Powercuts installed and enable **Hide top progress banner**. MiniShortcutProgress displays a tiny 30×30 non-interactive running indicator at the upper-left and removes it when the workflow stops. It intentionally does not stop a workflow yet.

## Build on GitHub from iPhone
1. Create a GitHub repository named `MiniShortcutProgress`.
2. Extract this ZIP and upload the **contents inside the MiniShortcutProgress folder** to the repository root. The repository root must contain `Makefile`, `Tweak.xm`, `control`, `MiniShortcutProgress.plist`, and the hidden `.github/workflows/build.yml` path.
3. Open the repository's **Actions** tab.
4. Select **Build RootHide DEB** and choose **Run workflow**.
5. When the run is green, open it and download artifact **MiniShortcutProgress-RootHide-DEB**.
6. Extract the artifact ZIP; install the `.deb` with Filza/Sileo and respring.

If GitHub does not show the workflow, verify that `.github/workflows/build.yml` was uploaded. iOS Files may hide dot-prefixed folders; using GitHub's web editor to create that path manually is an alternative.

## Device setup
- Keep Powercuts installed.
- Enable Powercuts > Hide top progress banner.
- Install this tweak and respring.

## Uninstall/recovery
If the tweak causes trouble, uninstall `MiniShortcutProgress` from Sileo/Filza and respring. Powercuts is separate and does not need to be removed.
