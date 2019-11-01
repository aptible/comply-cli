module Comply
  module CLI
    module Subcommands
      module Vendors
        def self.included(thor)
          thor.class_eval do
            include Helpers::Asset

            desc 'vendors:list', 'List registered vendors'
            define_method 'vendors:list' do
              assets = assets_by_type('VENDOR')
              assets.each do |asset|
                say(pretty_print_asset(asset))
              end
            end

            desc 'vendors:register', 'Register a new vendor'
            define_method 'vendors:register' do
              pattern = ask('Search pattern for Trust Center vendor: ')

              matches = Aptible::Comply::Vendor.where(search: pattern)
              if matches.empty?
                say 'No matches found'
                return
              end

              if matches.count == 1
                vendor = matches.first
              else
                choose do |menu|
                  menu.prompt = 'Choose a vendor:'
                  matches.each do |match|
                    menu.choice(pretty_print_vendor(match)) do
                      vendor = match
                    end
                  end
                end
              end

              create_asset_from_vendor(vendor)
            end

            desc 'vendors:deregister VENDOR_ID', 'Deregister a vendor'
            define_method 'vendors:deregister' do |vendor_id|
              asset = asset_by_vendor_id(vendor_id)

              if asset
                asset.destroy
                say 'Deregistered vendor'
              else
                say 'Vendor not registered'
              end
            end
          end
        end
      end
    end
  end
end
