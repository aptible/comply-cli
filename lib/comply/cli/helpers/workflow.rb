require 'aptible/comply'
require 'json'

require_relative 'asset'

module Comply
  module CLI
    module Helpers
      module Workflow
        include Helpers::Asset

        AUTH_REVIEW = 'access_authorization_review'.freeze
        GRANT_REVIEW = 'access_grant_review'.freeze
        AVAILABLE_WORKFLOWS = [AUTH_REVIEW, GRANT_REVIEW].freeze

        def pretty_print_workflows
          AVAILABLE_WORKFLOWS.each do |workflow|
            pretty_print_workflow(workflow)
          end
        end

        def pretty_print_workflow(workflow)
          say "workflow:#{workflow}"
        end

        def run(workflow_id)
          case workflow_id
          when AUTH_REVIEW
            auth_review(options[:asset])
          when GRANT_REVIEW
            grant_review(options[:asset])
          else
            raise Thor::Error, 'Workflow not found. ' \
            'Please run comply workflows:list for a list of options.'
          end
        end

        def grant_review(asset_ids)
          assets = fetch_assets(asset_ids)

          assets.each do |asset|
            # TODO: Make this into find or create logic
            # in case the review was launched previously
            asset.create_asset_review!(
              asset_id: asset.id,
              review_type: GRANT_REVIEW
            )
            # TODO: Print authorizations
            # TODO: Print grants based on querying grants
          end

          say 'Review access to ensure every group or individual ' \
          'who should have access, and no others, have authorized access.'

          complete_review(asset_reviews)
        end

        def auth_review(asset_ids)
          assets = fetch_assets(asset_ids)

          asset_reviews = assets.map do |asset|
            # TODO: Make this into find or create logic
            # in case the review was launched previously
            asset.create_asset_review!(
              asset_id: asset.id,
              review_type: AUTH_REVIEW
            )
            # TODO: Print authorizations
          end

          say 'Review access to ensure every group or individual who should ' \
          'have access, and no others, have authorized access.'

          complete_review(asset_reviews)
        end

        def complete_review(asset_reviews)
          completed = ask('Complete workflow (Y/N):', limited_to: %w(Y y N n))

          return unless %w(Y y).include?(completed)

          notes = ask('Notes:')

          now = Time.now
          asset_reviews.each do |asset_review|
            asset_review.update_asset_review!(completed_at: now, notes: notes)
          end
        end

        def fetch_assets(asset_ids)
          assets = assets_by_type('VENDOR')
          if asset_ids.any?
            assets.select do |asset|
              asset_ids.include?(asset.id)
            end
          else
            assets
          end
        end
      end
    end
  end
end
