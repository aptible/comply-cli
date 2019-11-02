module Comply
  module CLI
    module Subcommands
      module Access
        include Helpers::Grant

        PERSON_OR_GROUP = '[--person PERSON_ID | --group GROUP_ID]'.freeze

        def self.included(thor)
          thor.class_eval do
            desc 'access:list ASSET_ID', 'List access for an asset'
            define_method 'access:list' do |asset_id|
              asset = asset_by_vendor_id(asset_id)
              raise Thor::Error, 'Asset not found' unless asset

              puts pretty_print_grants(asset.grants)
            end

            desc "access:authorize ASSET_ID #{PERSON_OR_GROUP}",
                 'Authorize access to an asset'
            option :person
            option :group
            define_method 'access:authorize' do |asset_id|
              recipient = recipient_from_options(options)
              raise Thor::Error, 'Recipient not found' unless recipient

              asset = asset_by_vendor_id(asset_id)
              raise Thor::Error, 'Asset not found' unless asset

              find_or_create_grant(asset, recipient)
            end

            desc "access:grant ASSET_ID  #{PERSON_OR_GROUP}",
                 'Grant access to an asset'
            option :person
            option :group
            define_method 'access:grant' do |asset_id|
              recipient = recipient_from_options(options)
              raise Thor::Error, 'Recipient not found' unless recipient

              asset = asset_by_vendor_id(asset_id)
              raise Thor::Error, 'Asset not found' unless asset

              grant = find_or_create_grant(asset, recipient)
              grant.update!(status: 'granted')
            end

            desc "access:ungrant ASSET_ID #{PERSON_OR_GROUP}",
                 'Ungrant access to an asset'
            option :person
            option :group
            define_method 'access:ungrant' do |asset_id|
              recipient = recipient_from_options(options)
              raise Thor::Error, 'Recipient not found' unless recipient

              asset = asset_by_vendor_id(asset_id)
              raise Thor::Error, 'Asset not found' unless asset

              grant = find_or_create_grant(asset, recipient)
              grant.update!(status: 'authorized')
            end

            desc "access:deauthorize ASSET_ID #{PERSON_OR_GROUP}",
                 'Deauthorize access to an asset'
            option :person
            option :group
            define_method 'access:deauthorize' do |asset_id|
              recipient = recipient_from_options(options)
              raise Thor::Error, 'Recipient not found' unless recipient

              asset = asset_by_vendor_id(asset_id)
              raise Thor::Error, 'Asset not found' unless asset

              grant = find_or_create_grant(asset, recipient)
              grant.destroy
            end
          end
        end
      end
    end
  end
end
