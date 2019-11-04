module Comply
  module CLI
    module Subcommands
      module Groups
        def self.included(thor)
          thor.class_eval do
            include Helpers::Group

            desc 'groups:list', 'List groups'
            define_method 'groups:list' do
              groups = default_program.groups
              return unless groups
              groups.each do |group|
                say(pretty_print_group(group))
              end
            end

            desc 'groups:members GROUP_ID', 'List the membors of a group'
            define_method 'groups:members' do |group|
              group = find_group_by_alias(group)
              fail 'Group not found' unless group

              group.memberships.each do |membership|
                say pretty_print_person(membership.person)
              end
            end

            desc 'groups:provision NAME', 'Create a group'
            define_method 'groups:provision NAME' do |name|
              group = default_program.create_group(name: name)
              say "Successfully created #{pretty_print_group(group)}"
            end

            desc 'groups:add GROUP_ID PERSON_ID', 'Add person to group'
            define_method 'groups:add' do |group, person|
              group = find_group_by_alias(group)
              raise Thor::Error, 'Group not found' unless group

              person = find_person_by_alias(person)
              raise Thor::Error, 'Person not found' unless person

              membership = group.memberships.find do |m|
                m.person.id == person.id
              end
              raise Thor::Error, 'Membership already exists' if membership

              group.create_membership(person_id: person.id)
            end

            # TODO: implement Aptible::Comply::Group.remove_member
            desc 'groups:remove GROUP_ID PERSON_ID', 'Remove person from group'
            define_method 'groups:remove' do |group, person|
              group = find_group_by_alias(group)
              raise Thor::Error, 'Group not found' unless group

              person = find_person_by_alias(person)
              raise Thor::Error, 'Person not found' unless person

              membership = group.memberships.find do |m|
                m.person.id == person.id
              end
              raise Thor::Error, 'Membership does not exist' unless membership

              membership.destroy
            end

            desc 'groups:deprovision GROUP_ID', 'Deprovision group'
            define_method 'groups:deprovision GROUP_ID' do |group|
              group = find_group_by_alias(group)
              if group
                group.destroy
                say "Deprovisioned #{pretty_print_group(group)}"
              else
                say 'Group not found'
              end
            end
          end
        end
      end
    end
  end
end
