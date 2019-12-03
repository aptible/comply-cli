# Comply CLI

Command-line interface for Aptible Comply.

## Installation

_Note: while this gem is in development, it is (a) private, and (b) built against API endpoints that are still in development. As a result, the instructions here are both temporary (subject to change) and more complicated than they will eventually be._

1. Clone this repo: `git clone git@github.com:aptible/comply-cli.git`
2. From the repo directory, install the gem:

        pushd comply-cli/
        bundle install
        bundle exec rake install
        popd

When using the gem, you will need to configure it to point at a version of the Comply CLI that supports the endpoints required by the CLI. At this moment, the "comply-api-cli" app in the "aptible-staging" environment on Deploy is the deployment kept mos up to date. To use this app with comply-cli, set `APTIBLE_AUTH_ROOT_URL` and `APTIBLE_COMPLY_ROOT_URL` each time you open a new shell (terminal) to use the CLI:

```
export APTIBLE_AUTH_ROOT_URL=https://auth-api-master.aptible-staging.com APTIBLE_COMPLY_ROOT_URL=https://comply-api-cli.aptible-staging.com
```


## Usage

From `comply help`:

<!-- BEGIN USAGE -->
```
Commands:
  comply help [COMMAND]                      # Describe available commands or one specific command
  comply integrations:enable INTEGRATION_ID  # Enable an integration
  comply integrations:list                   # List integrations
  comply integrations:sync INTEGRATION_ID    # Sync an integration
  comply integrations:update INTEGRATION_ID  # Enable an integration
  comply login                               # Log in to Aptible
  comply programs:select                     # Select a program for CLI context
  comply version                             # Print Aptible CLI version
```
<!-- END USAGE -->

## Contributing

1. Fork the project.
1. Commit your changes, with specs.
1. Ensure that your code passes specs (`rake spec`) and meets Aptible's Ruby style guide (`rake rubocop`).
1. If you add a command, sync this README (`bundle exec script/sync-readme-usage`).
1. Create a new pull request on GitHub.

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2019 [Aptible](https://www.aptible.com) and contributors.
