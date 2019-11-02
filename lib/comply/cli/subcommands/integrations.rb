module Comply
  module CLI
    module Subcommands
      module Integrations
        def self.included(thor)
          thor.class_eval do
            desc 'integrations:list', 'List integrations'
            define_method 'integrations:list' do
              raise NotImplementedError
            end

            desc 'integrations:enable INTEGRATION_ID', 'Enable an integration'
            define_method 'integrations:enable' do |_integration_id|
              raise NotImplementedError
            end

            desc 'integrations:sync INTEGRATION_ID', 'Sync an integration'
            define_method 'integrations:sync' do |_integration_id|
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
