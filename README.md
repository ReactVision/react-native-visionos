<p align="center" style="background-colour: #CCCCCC;">
  <a href="https://www.reactvision.xyz/">
    <img src="https://avatars.githubusercontent.com/u/74572641?s=200&v=4" alt="ReactVision logo" width="120px" height="120px">
  </a>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/@reactvision/react-native-visionos">
    <img src="https://img.shields.io/npm/v/@reactvision/react-native-visionos" alt="npm version">
  </a>
  <a href="https://github.com/ReactVision/react-native-visionos/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT licensed">
  </a>
  <a href="https://discord.gg/yqqEGUjK">
    <img src="https://img.shields.io/discord/774471080713781259?label=Discord" alt="Discord">
  </a>
</p>

# React Native for visionOS, By ReactVision

React Native for visionOS lets you build Apple Vision Pro apps with React Native. It is an
**out-of-tree platform**: your project keeps its `ios/` and `android/` folders and gains a
`visionos/` one, all three driven by the same JavaScript.

This fork exists so that [ViroReact](https://github.com/ReactVision/viro) can render spatial scenes
on visionOS. It is useful on its own for any React Native app targeting the platform.

MIT licensed and free forever.

## Attribution

This work stands on two others, and neither is ours:

- **React Native** is built by Meta and its contributors. This repository is a fork of it, and every
  commit of that history is preserved here.
- **visionOS support** was created by [Callstack](https://github.com/callstack/react-native-visionos).
  The platform, the Swift app scaffolding, the `visionos` resolver — that design is theirs. ReactVision
  continues it from React Native 0.86 onward.

## Supported versions

| React Native | Package | Status |
| --- | --- | --- |
| 0.86.x | `@reactvision/react-native-visionos@0.86.x` | ✅ Current |
| 0.79.6 and earlier | `@callstack/react-native-visionos` | Callstack's releases |

The package version tracks the React Native version it is built from, so `0.86.2` is React Native
0.86.2 with visionOS support added. Install it *alongside* `react-native`, not instead of it.

## Installation

```bash
npm install @reactvision/react-native-visionos
```

Then create the `visionos/` folder once, and build:

```bash
npx expo prebuild
cd visionos && pod install
```

`Platform.OS` is `"ios"` on visionOS — the platform keeps the iOS identity so that the ecosystem's
iOS code paths work unchanged. Branch on the platform only where you genuinely need to.

## Using it with ViroReact

If you want 3D, AR or VR content rather than 2D UI, this fork is the foundation and
[ViroReact](https://github.com/ReactVision/viro) is the renderer on top. Its config plugin wires up
everything this platform needs — pods, the Metro resolver, the immersive space scene, the Xcode
bundling phase — so a Viro project needs no manual visionOS setup.

See the ViroReact visionOS guide for the full walkthrough.

## What this adds to React Native

- A `visionos` platform target, resolved through `@callstack/out-of-tree-platforms`
- SwiftUI app scaffolding with `WindowGroup` and `ImmersiveSpace` scenes
- `WindowManager` and `XR` native modules for opening windows and immersive spaces from JavaScript
- visionOS-aware podspecs and build settings across React Native's own pods

## Documentation

React Native's own documentation applies unchanged for everything that is not visionOS-specific:
<https://reactnative.dev/docs/getting-started>

For ViroReact and spatial rendering: <https://viro-community.readme.io/docs/overview>

## Community

Discord is the best place to find the team and other developers building with ReactVision:

<a href="https://discord.gg/A6TaFNqwVc">
  <img src="https://discordapp.com/api/guilds/774471080713781259/widget.png?style=banner2" />
</a>

## Contributing

Issues and pull requests are welcome. Changes that belong upstream — in React Native itself, or in
Callstack's visionOS work — are better sent there, and this fork will pick them up on the next
rebase.

## Find Out More

- Website: <https://reactvision.xyz>
- ViroReact: <https://reactvision.xyz/viro-react>
- ReactVision Studio: <https://studio.reactvision.xyz>
- Blog: <https://updates.reactvision.xyz>

## A little history…

React Native was open-sourced by Meta in 2015. Callstack added visionOS as an out-of-tree platform in
2024, carrying it to React Native 0.79. ReactVision picked it up from 0.86 to keep ViroReact shipping
on Apple Vision Pro, and maintains this fork in the open.

---

MIT licensed. React Native is © Meta Platforms, Inc. and affiliates; visionOS support is © Callstack
and © ReactVision, Inc.
