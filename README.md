# Kodlabs Homebrew Tap

This is the official Homebrew tap for command-line products maintained by
[Kodlabs](https://github.com/kodlabs-in).

## Install MachBatch

After the first bottled MachBatch release is published, install it with:

```bash
brew install kodlabs-in/tap/machbatch
```

Homebrew will select a matching precompiled bottle when one is available. A
source build requires Xcode with a Swift 6.2-compatible toolchain.

Verify the installation with:

```bash
machbatch --version
machbatch doctor
sinfo
```

## Upgrade

```bash
brew update
brew upgrade machbatch
```

## Uninstall

```bash
brew uninstall machbatch
```

Uninstalling the formula removes Homebrew-managed commands but preserves
MachBatch state in `~/Library/Application Support/MachBatch`.

## Platform support

MachBatch targets macOS 13 or newer on Apple Silicon and Intel. Bottle
availability follows the matrix tested for each release. Intel bottles are
published only after validation on native Intel hardware.

## Support

- Report product defects in the
  [MachBatch repository](https://github.com/kodlabs-in/machbatch).
- Report formula or bottle defects in this tap repository.
- Consult the
  [Homebrew documentation](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
  for general Homebrew usage.

