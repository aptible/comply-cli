require 'aptible/comply'

module Comply
  module CLI
    module Helpers
      module Asset
        def pretty_print_asset(asset)
          case asset.asset_type
          when 'VENDOR' then
            vendor = Aptible::Comply::Vendor.find(
              asset.vendor_id,
              token: fetch_token
            )
            "#{pretty_print_vendor(vendor)} (#{asset.id})"
          else
            "#{asset.name} (#{asset.id})"
          end
        end

        def pretty_print_vendor(vendor)
          "#{vendor.website_url} | #{vendor.name}"
        end

        def create_asset_from_vendor(vendor)
          # TODO: Move this validation server-side
          assets = assets_by_type('VENDOR')
          if assets.any? { |a| a.vendor_id == vendor.id }
            raise Thor::Error, 'Vendor already registered'
          end

          default_program.create_asset(
            asset_type: 'VENDOR',
            name: vendor.name,
            vendor_id: vendor.id,
            owner: current_user_email
          )
        end

        def assets_by_type(type)
          default_program.assets.select do |asset|
            asset.asset_type == type
          end
        end

        def asset_by_vendor_id(vendor_id)
          matches = Aptible::Comply::Vendor.where(search: vendor_id,
                                                  token: fetch_token)
          vendor = matches.find do |match|
            match.website_url == vendor_id
          end

          return unless vendor

          default_program.assets.find do |asset|
            asset.vendor_id == vendor.id
          end
        end
      end
    end
  end
end
