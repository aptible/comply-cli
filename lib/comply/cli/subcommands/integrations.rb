module Comply
  module CLI
    module Subcommands
      module Integrations
        include Helpers::Integration

        def self.included(thor)
          thor.class_eval do
            desc 'integrations:list', 'List integrations'
            define_method 'integrations:list' do
              integrations = default_program.integrations
              if integrations.empty?
                say 'No integrations found.'
              else
                integrations.each do |integration|
                  say pretty_print_integration(integration)
                end
              end
            end

            desc 'integrations:enable INTEGRATION_ID', 'Enable an integration'
            define_method 'integrations:enable' do |integration_type|
              integration = default_program.integrations.find do |i|
                i.integration_type == integration_type
              end
              raise Thor::Error, 'Integration already enabled' if integration

              prompt_and_create_integration(integration_type)
            end

            desc 'integrations:update INTEGRATION_ID', 'Enable an integration'
            define_method 'integrations:update' do |integration_type|
              integration = default_program.integrations.find do |i|
                i.integration_type == integration_type
              end
              raise Thor::Error, 'Integration not found' unless integration

              prompt_and_update_integration(integration)
            end

            desc 'integrations:sync INTEGRATION_ID', 'Sync an integration'
            define_method 'integrations:sync' do |integration_type|
              integration = default_program.integrations.find do |i|
                i.integration_type == integration_type
              end
              raise Thor::Error, 'Integration not found' unless integration

              integration.links['sync'].post
              say 'Integration synced'
            end
          end
        end
      end
    end
  end
end
