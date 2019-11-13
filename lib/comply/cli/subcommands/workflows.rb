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

            desc 'workflows:overdue', 'List overdue workflows'
            option :vendor, type: :array, default: []
            define_method 'workflows:overdue' do
              assets = default_program.assets
              check_overdue_asset_reviews(assets)

              say 'Check complete'
            end

            desc 'workflows:run WORKFLOW_ID [--vendor VENDOR_URL VENDOR_URL ...]',
                 'Run a workflow'
            option :vendor, type: :array, default: []
            define_method 'workflows:run WORKFLOW_ID' do |workflow_id|
              options[:vendor].each do |vendor_url|
                asset = asset_by_vendor_url(vendor_url)
                run_workflow(workflow_id, asset)
              end
            end
          end
        end
      end
    end
  end
end
