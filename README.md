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
  comply access:authorize ASSET_ID [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]    # Authorize access to an asset
  comply access:deauthorize ASSET_ID [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]  # Deauthorize access to an asset
  comply access:grant ASSET_ID  [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]       # Grant access to an asset
  comply access:list ASSET_ID                                                                                   # List access for an asset
  comply access:ungrant ASSET_ID [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]      # Ungrant access to an asset
  comply groups:add GROUP_ID PERSON_ID                                                                          # Add person to group
  comply groups:deprovision GROUP_ID                                                                            # Deprovision group
  comply groups:list                                                                                            # List groups
  comply groups:members GROUP_ID                                                                                # List the membors of a group
  comply groups:provision NAME                                                                                  # Create a group
  comply groups:remove GROUP_ID PERSON_ID                                                                       # Remove person from group
  comply help [COMMAND]                                                                                         # Describe available commands or one specific command
  comply integrations:enable INTEGRATION_ID                                                                     # Enable an integration
  comply integrations:list                                                                                      # List integrations
  comply integrations:sync INTEGRATION_ID                                                                       # Sync an integration
  comply login                                                                                                  # Log in to Aptible
  comply people:deprovision PERSON_ID                                                                           # Deprovision a user
  comply people:list                                                                                            # List people in the current program
  comply people:provision                                                                                       # Provision a new user
  comply programs:select                                                                                        # Select a program for CLI context
  comply vendors:deregister VENDOR_ID                                                                           # Deregister a vendor
  comply vendors:list                                                                                           # List registered vendors
  comply vendors:register                                                                                       # Register a new vendor
  comply version                                                                                                # Print Aptible CLI version
  comply workflows:list                                                                                         # List available workflows
  comply workflows:run WORKFLOW_ID [--asset ASSET1_ID ASSET2_ID ...]                                            # Run a workflow
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
