# Comply CLI

Command-line interface for Aptible Comply.

## Installation

Add the following line to your application's Gemfile.

    gem 'aptible-cli'

And then run `bundle install`.


## Usage

From `comply help`:

<!-- BEGIN USAGE -->
```
Commands:
  comply help [COMMAND]                      # Describe available commands or one specific command
  comply integrations:enable INTEGRATION_ID  # Enable an integration
  comply integrations:list                   # List integrations
  comply integrations:sync INTEGRATION_ID    # Sync an integration
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
