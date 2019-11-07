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

              matches = Aptible::Comply::Vendor.where(search: pattern,
                                                      token: fetch_token)
              if matches.empty?
                say 'No matches found'
                return
              end

              choose do |menu|
                menu.prompt = 'Choose a vendor:'
                matches.each do |match|
                  menu.choice(pretty_print_vendor(match)) do
                    create_asset_from_vendor(match)
                  end
                end
              end
            end

            desc 'vendors:deregister VENDOR_ID', 'Deregister a vendor'
            define_method 'vendors:deregister' do |vendor_id|
              asset = vendor_asset_by_id(vendor_id)

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
