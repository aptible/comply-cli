module Comply
  module CLI
    module Subcommands
      module Access
        include Helpers::Grant

        PERSON_GROUP_OR_SCOPE = '[--person PERSON_ID | --group GROUP_ID ' \
                                '| --scope SCOPE1_ID SCOPE2_id ...]'.freeze

        def self.included(thor)
          thor.class_eval do
            desc 'access:list VENDOR_ID', 'List access for an asset'
            define_method 'access:list' do |asset_id|
              asset = vendor_asset_by_id(asset_id)

              puts pretty_print_grants(asset.grants)
            end

            desc "access:authorize VENDOR_ID #{PERSON_GROUP_OR_SCOPE}",
                 'Authorize access to an asset'
            option :person
            option :group
            option :scope, type: :array, default: []
            define_method 'access:authorize' do |asset_id|
              recipient = recipient_from_options(options)

              asset = vendor_asset_by_id(asset_id)

              find_or_create_grant(asset, recipient, options[:scope])
            end

            desc "access:grant VENDOR_ID  #{PERSON_GROUP_OR_SCOPE}",
                 'Grant access to an asset'
            option :person
            option :group
            option :scope, type: :array, default: []
            define_method 'access:grant' do |asset_id|
              recipient = recipient_from_options(options)

              asset = vendor_asset_by_id(asset_id)

              grant = find_or_create_grant(asset, recipient, options[:scope])
              grant.update!(status: 'granted')
            end

            desc "access:ungrant VENDOR_ID #{PERSON_GROUP_OR_SCOPE}",
                 'Ungrant access to an asset'
            option :person
            option :group
            option :scope, type: :array, default: []
            define_method 'access:ungrant' do |asset_id|
              recipient = recipient_from_options(options)

              asset = vendor_asset_by_id(asset_id)

              grant = find_or_create_grant(asset, recipient, options[:scope])
              grant.update!(status: 'authorized')
            end

            desc "access:deauthorize VENDOR_ID #{PERSON_GROUP_OR_SCOPE}",
                 'Deauthorize access to an asset'
            option :person
            option :group
            option :scope, type: :array, default: []
            define_method 'access:deauthorize' do |asset_id|
              recipient = recipient_from_options(options)

              asset = vendor_asset_by_id(asset_id)

              grant = find_or_create_grant(asset, recipient, options[:scope])
              grant.destroy
            end
          end
        end
      end
    end
  end
end
