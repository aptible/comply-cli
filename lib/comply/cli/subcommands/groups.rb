module Comply
  module CLI
    module Subcommands
      module Groups
        def self.included(thor)
          thor.class_eval do
            include Helpers::Program

            desc 'groups:list', 'List groups'
            define_method 'groups:list' do
              groups = default_program.groups
              groups.each do |group|
                say(pretty_print_group(group))
              end
            end

            desc 'groups:membership GROUP_ID', 'List the membors of a group'
            define_method 'groups:membership' do |group_id|
              group = fetch_group(default_program, group_id)
              return unless group
              group.first.members.each do |member|
                say(pretty_print_member(member))
              end
            end

            desc 'groups:create', 'Create a group'
            define_method 'groups:create' do
              raise NotImplementedError
            end

            # TODO: implement Aptible::Comply::Group.add_member
            desc 'groups:add', 'Add PERSON to GROUP'
            define_method 'groups:add' do |person_id, group_id|
              group = fetch_group(default_program, group_id)
              if group
                begin
                  group.add_member(member_id)
                rescue
                  msg = "Unable to add person with id #{person_id} " \
                        "to group with id #{group_id}"
                  say(msg)
                end
              else
                say('Group not found')
              end
            end

            # TODO: implement Aptible::Comply::Group.remove_member
            desc 'groups:remove', 'Remove PERSON from GROUP'
            define_method 'groups:remove' do |person_id, group_id|
              group = fetch_group(default_program, group_id)
              if group
                begin
                  group.remove_member(member_id)
                rescue
                  msg = "Unable to remove person with id #{person_id} " \
                        "from group with id #{group_id}"
                  say(msg)
                end
              else
                say('Group not found')
              end
            end
          end
        end
      end
    end
  end
end
