module Comply
  module CLI
    module Subcommands
      module Group
        include Helpers::Program

        def self.included(thor)
          thor.class_eval do
            desc 'groups:list', 'List groups in the current program'
            define_method 'groups:list' do
            end

            desc 'groups:membership GROUP_ID', 'List members of a group'
            define_method 'groups:membership' do |group_id|
            end

            desc 'groups:create', 'Create a new group'
            option :name
            define_method 'groups:create' do
            end

            desc 'groups:add GROUP_ID PERSON_ID', 'Add a user to a group'
            define_method 'groups:add' do |group_id, person_id|
              # Create PeopleGroup record
            end

            desc 'groups:remove GROUP_ID PERSON_ID', 'Remove a user from a group'
            define_method 'groups:remove' do |asset_id, person_id|
              # Delete PeopleGroup record
            end
          end
        end
      end
    end
  end
end
