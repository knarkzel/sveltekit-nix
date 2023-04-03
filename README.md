# sveltekit-nix

Reproducible builds for Sveltekit using Nix flakes.

## One-liner for testing

```
ORIGIN=http://localhost:3000 nix run github:knarkzel/sveltekit-nix
```

## Development

```
git clone https://github.com/knarkzel/sveltekit-nix
cd sveltekit-nix
nix develop
yarn
yarn run dev
```
