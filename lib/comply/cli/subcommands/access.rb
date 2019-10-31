module Comply
  module CLI
    module Subcommands
      module Access
        include Helpers::Program

        def self.included(thor)
          thor.class_eval do
            desc 'access:list', 'List people in the current program'
            define_method 'access:list' do
            end

            desc 'access:authorize ASSET_ID', 'Provision a new user'
            define_method 'access:authorize' do

            end

            desc 'access:grant ASSET_ID PERSON_ID', 'Deprovision a user'
            define_method 'access:grant' do |asset_id, person_id|
            end

            desc 'access:ungrant ASSET_ID PERSON_ID', 'Deprovision a user'
            define_method 'access:ungrant' do |asset_id, person_id|
            end

            desc 'access:deauthorize ASSET_ID', 'Deprovision a user'
            define_method 'access:deauthorize' do |asset_id|
            end
          end
        end
      end
    end
  end
end
