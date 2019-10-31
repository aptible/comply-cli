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
  comply access:authorize ASSET_ID           # Provision a new user
  comply access:deauthorize ASSET_ID         # Deprovision a user
  comply access:grant ASSET_ID PERSON_ID     # Deprovision a user
  comply access:list                         # List people in the current program
  comply access:ungrant ASSET_ID PERSON_ID   # Deprovision a user
  comply groups:add GROUP_ID PERSON_ID       # Add a user to a group
  comply groups:create                       # Create a new group
  comply groups:list                         # List groups in the current program
  comply groups:membership GROUP_ID          # List members of a group
  comply groups:remove GROUP_ID PERSON_ID    # Remove a user from a group
  comply help [COMMAND]                      # Describe available commands or one specific command
  comply integrations:enable INTEGRATION_ID  # Enable an integration
  comply integrations:list                   # List integrations
  comply integrations:sync INTEGRATION_ID    # Sync an integration
  comply login                               # Log in to Aptible
  comply person:deprovision PERSON_ID        # Deprovision a user
  comply person:list                         # List people in the current program
  comply person:provision                    # Provision a new user
  comply programs:select                     # Select a program for CLI context
  comply vendors:deregister VENDOR_ID        # Deregister a vendor
  comply vendors:list                        # List registered vendors
  comply vendors:register                    # Register a new vendor
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
