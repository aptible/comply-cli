require 'aptible/comply'
require 'json'

module Comply
  module CLI
    module Helpers
      module Grant
        def prettify_grant_status(status)
          case status
          when 'authorized' then 'Access Authorizations'
          when 'granted' then 'Access Grants'
          end
        end

        def pretty_print_recipient(recipient)
          case recipient
          when Aptible::Comply::Person
            pretty_print_person(recipient)
          when Aptible::Comply::Group
            pretty_print_group(recipient)
          end
        end

        def recipient_from_options(options)
          unless options[:person] || options[:group]
            raise Thor::Error, 'Group or person must be specified'
          end

          recipient = if options[:person]
                        find_person_by_alias(options[:person])
                      else
                        find_group_by_alias(options[:group])
                      end
          raise Thor::Error, 'Recipient not found' unless recipient

          recipient
        end

        def pretty_print_grants(grants)
          io = StringIO.new

          grants.group_by { |g| g.asset.id }.each do |_asset_id, asset_grants|
            asset = asset_grants.first.asset
            io.puts pretty_print_asset(asset)

            asset_grants.group_by(&:status).each do |status, grants_by_status|
              heading = prettify_grant_status(status)
              io.puts(heading)

              grants_by_status.each do |grant|
                io.puts "  #{pretty_print_recipient(grant.access_recipient)}"
              end
            end

            io.puts
          end

          io.string
        end

        def find_or_create_grant(asset, recipient, scope, status = 'authorized')
          grant = asset.grants.find do |g|
            recipient._type == g.access_recipient._type &&
              recipient.id == g.access_recipient.id
          end

          return grant if grant

          case recipient
          when Aptible::Comply::Person
            asset.create_grant(status: status,
                               person_id: recipient.id,
                               scope: scope)
          when Aptible::Comply::Group
            asset.create_grant(status: status,
                               group_id: recipient.id,
                               scope: scope)
          end
        end
      end
    end
  end
end
