require 'aptible/comply'
require 'json'

module Comply
  module CLI
    module Helpers
      module Integration
        def prettify_integration(integration)
          integration.integration_type
        end

        def pretty_print_integration(integration)
          "#{prettify_integration(integration)} (#{integration.id})"
        end

        def prompt_and_create_integration(type)
          env = prompt_for_env(type)
          default_program.create_integration(integration_type: type, env: env)
        end

        def prompt_and_update_integration(integration)
          env = prompt_for_env(integration.integration_type)
          integration.update(env: env)
        end

        def prompt_for_env(type)
          env = {}
          env_vars_by_prompt(type).each do |human, key|
            env[key] = ask("#{human}:", echo: false)
            puts
          end

          env
        end

        def env_vars_by_prompt(type)
          case type
          # TODO: Enable G Suite integration
          # when 'gsuite'
          #   {
          #     'Client ID' => 'GOOGLE_CLIENT_ID',
          #     'Client Secret' => 'GOOGLE_CLIENT_SECRET',
          #     'Access Token' => 'GOOGLE_ACCESS_TOKEN',
          #     'Refresh Token' => 'GOOGLE_REFRESH_TOKEN'
          #   }
          when 'okta'
            {
              'Org Name' => 'OKTA_ORG_NAME',
              'API Key' => 'OKTA_API_KEY'
            }
          end
        end
      end
    end
  end
end
