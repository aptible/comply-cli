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
  comply access:authorize VENDOR_URL [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]    # Authorize access to an asset
  comply access:deauthorize VENDOR_URL [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]  # Deauthorize access to an asset
  comply access:grant VENDOR_URL  [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]       # Grant access to an asset
  comply access:list VENDOR_URL                                                                                   # List access for an asset
  comply access:ungrant VENDOR_URL [--person PERSON_ID | --group GROUP_ID | --scope SCOPE1_ID SCOPE2_id ...]      # Ungrant access to an asset
  comply groups:add GROUP_ID PERSON_ID                                                                            # Add person to group
  comply groups:deprovision GROUP_ID                                                                              # Deprovision group
  comply groups:list                                                                                              # List groups
  comply groups:members GROUP_ID                                                                                  # List the membors of a group
  comply groups:provision NAME                                                                                    # Create a group
  comply groups:remove GROUP_ID PERSON_ID                                                                         # Remove person from group
  comply help [COMMAND]                                                                                           # Describe available commands or one specific command
  comply integrations:enable INTEGRATION_ID                                                                       # Enable an integration
  comply integrations:list                                                                                        # List integrations
  comply integrations:sync INTEGRATION_ID                                                                         # Sync an integration
  comply login                                                                                                    # Log in to Aptible
  comply people:deprovision PERSON_ID                                                                             # Deprovision a user
  comply people:list                                                                                              # List people in the current program
  comply people:provision                                                                                         # Provision a new user
  comply programs:select                                                                                          # Select a program for CLI context
  comply vendors:deregister VENDOR_                                                                               # Deregister a vendor
  comply vendors:list                                                                                             # List registered vendors
  comply vendors:register                                                                                         # Register a new vendor
  comply version                                                                                                  # Print Aptible CLI version
  comply workflows:list                                                                                           # List available workflows
  comply workflows:overdue                                                                                        # List overdue workflows
  comply workflows:run WORKFLOW_ID [--vendor VENDOR_URL VENDOR_URL ...]                                           # Run a workflow
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
