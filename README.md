# homebrew-latlng

The Homebrew tap for [latlng](https://github.com/tobilg/latlng), a geospatial object server and command-line tools.

## Requirements

- macOS on Apple Silicon (`arm64`)

## Installation

```sh
brew tap tobilg/latlng
brew install latlng
```

This installs the following binaries:

- `latlng-server`
- `latlng-cli`

## Configuration

A default config file is written on install (if it does not already exist) to:

```
$(brew --prefix)/etc/latlng/latlng.toml
```

Defaults:

- Listens on `127.0.0.1:7421`
- Cap'n Proto disabled (would listen on `127.0.0.1:7422` if enabled)
- AOF persistence at `$(brew --prefix)/var/latlng/appendonly.aof`
- Webhook queue at `$(brew --prefix)/var/latlng/webhook-queue.sqlite`
- Logs to `$(brew --prefix)/var/log/latlng/latlng-server.log`

## Running as a service

Start latlng as a background service managed by Homebrew:

```sh
brew services start latlng
```

Stop it:

```sh
brew services stop latlng
```

## Running manually

```sh
latlng-server --config $(brew --prefix)/etc/latlng/latlng.toml
```

## License

MIT
