module Comply
  module CLI
    module Subcommands
      module People
        include Helpers::Person

        def self.included(thor)
          thor.class_eval do
            desc 'people:list', 'List people in the current program'
            define_method 'people:list' do
              people = default_program.people
              if people.empty?
                say 'No people found.'
              else
                people.each do |person|
                  say pretty_print_person(person)
                end
              end
            end

            desc 'people:provision', 'Provision a new user'
            option :email
            option :first_name
            option :last_name
            define_method 'people:provision' do
              email = options[:email] || ask('Email: ')
              first_name = options[:first_name] || ask('First name: ')
              last_name = options[:last_name] || ask('Last name: ')

              if email.empty? || first_name.empty? || last_name.empty?
                raise Thor::Error, 'All fields required'
              end

              person = default_program.create_person(
                email: email,
                first_name: first_name,
                last_name: last_name,
                program_id: fetch_program_id
              )
              say "Successfully created #{pretty_print_person(person)}"
            end

            desc 'people:deprovision PERSON_ID', 'Deprovision a user'
            define_method 'people:deprovision' do |person_id|
              person = find_person_by_alias(person_id)

              if person
                person.destroy
                say "Deprovisioned #{pretty_print_person(person)}"
              else
                say 'Person not found'
              end
            end
          end
        end
      end
    end
  end
end
