module Comply
  module CLI
    module Subcommands
      module Integrations
        def self.included(thor)
          thor.class_eval do
            desc 'integrations:list', 'List integrations'
            define_method 'integrations:list' do
            end

            desc 'integrations:enable INTEGRATION_ID', 'Enable an integration'
            define_method 'integrations:enable' do |integration_id|
            end

            desc 'integrations:sync INTEGRATION_ID', 'Sync an integration'
            define_method 'integrations:sync' do |integration_id|
            end
          end
        end
      end
    end
  end
end
