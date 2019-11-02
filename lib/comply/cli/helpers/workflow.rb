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
            say workflow
          end
        end

        def run_workflow(workflow_id, asset)
          case workflow_id
          when AUTH_REVIEW
            auth_review(asset)
          when GRANT_REVIEW
            grant_review(asset)
          else
            raise Thor::Error, 'Workflow not found. ' \
              'Please run comply workflows:list for a list of options.'
          end
        end

        def auth_review(asset)
          review = find_or_create_review(asset,
                                         AUTH_REVIEW,
                                         current_user_email)
          say pretty_print_grants(asset.grants)

          say 'Review access to ensure every group or individual who should ' \
              'have access, and no others, have authorizations.'

          complete_review(review)
        end

        def grant_review(asset)
          review = find_or_create_review(asset,
                                         GRANT_REVIEW,
                                         current_user_email)
          say pretty_print_grants(asset.grants)

          say 'Review access to ensure every group or individual who should ' \
              'have access, and no others, have access grants.'

          complete_review(review)
        end

        def complete_review(review)
          answer = ask('Complete workflow (Y/N):', limited_to: %w(Y y N n))
          return unless %w(Y y).include?(answer)

          notes = ask('Notes:')
          review.update(completed_at: Time.now, notes: notes)
        end

        def find_or_create_review(asset, workflow_id, reviewer_id)
          review = asset.asset_reviews.find do |r|
            r.review_type == workflow_id && r.completed_at.nil?
          end

          return review if review

          asset.create_asset_review(review_type: workflow_id,
                                    reviewer_id: reviewer_id)
        end
      end
    end
  end
end
