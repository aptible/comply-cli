module Comply
  module CLI
    module Subcommands
      module Workflows
        def self.included(thor)
          thor.class_eval do
            include Helpers::Workflow

            desc 'workflows:list', 'List available workflows'
            define_method 'workflows:list' do
              pretty_print_workflows
            end

            desc 'workflows:run WORKFLOW_ID [--asset ASSET1_ID ASSET2_ID ...]',
                 'Run a workflow'
            option :asset, type: :array, default: []
            define_method 'workflows:run' do |workflow_id|
              run(workflow_id)
            end
          end
        end
      end
    end
  end
end
