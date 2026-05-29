# Config Bootstrap

Dev container feature that clones a configuration repository from GitHub and executes its `install.sh` to bootstrap the dev container environment.

## Usage

```json
{
  "features": {
    "https://github.com/xzmeng/devcontainer-features.git": {
      "feature": "config-bootstrap"
    }
  }
}
```

Or via GHCR (after CI publishes):

```json
{
  "features": {
    "ghcr.io/xzmeng/config-bootstrap:1": {}
  }
}`
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `CONFIG_REPO` | `https://github.com/xzmeng/config` | GitHub repository URL to clone |
| `CONFIG_REPO_BRANCH` | `main` | Branch or tag to checkout |
| `CONFIG_REPO_DIR` | `$HOME/config` | Local directory to clone into |

## How it works

1. Clones `CONFIG_REPO` at the specified branch into `CONFIG_REPO_DIR`
2. If `install.sh` exists in the repo root, makes it executable and runs it
3. Otherwise, exits cleanly with a message

## Authentication

For private repos, configure git credentials in your dev container (e.g., mount SSH keys or use a credential helper). This feature does not handle authentication itself.
