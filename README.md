# LeafWiki Homebrew Tap

This tap installs LeafWiki from prebuilt macOS release assets.

## Install

```bash
brew install jtomanik/leafwiki/leafwiki
```

This installs:

- `leafwiki`
- `run.sh`

`run.sh mcp` starts LeafWiki in native MCP STDIO mode for MCP clients that spawn
a local command. Workspace sync is enabled by default.

You can also tap first and then install:

```bash
brew tap jtomanik/leafwiki
brew install leafwiki
```

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "jtomanik/leafwiki"
brew "leafwiki"
```

## Documentation

- LeafWiki: https://github.com/jtomanik/leafwiki
- Homebrew: `brew help`, `man brew`, or https://docs.brew.sh
