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
            define_method 'workflows:run WORKFLOW_ID' do |workflow_id|
              options[:asset].each do |asset_id|
                asset = asset_by_vendor_id(asset_id)
                run_workflow(workflow_id, asset)
              end
            end
          end
        end
      end
    end
  end
end
