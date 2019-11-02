module Comply
  module CLI
    module Subcommands
      module People
        include Helpers::Program

        def self.included(thor)
          thor.class_eval do
            desc 'person:list', 'List people in the current program'
            define_method 'person:list' do
              if own_people.empty?
                say '[No people found.]'
              else
                own_people.each do |person|
                  say pretty_print_person(person)
                end
              end
            end

            desc 'person:provision', 'Provision a new user'
            option :email
            option :first_name
            option :last_name
            define_method 'person:provision' do
              email = options[:email] || ask('Email: ')
              first_name = options[:first_name] || ask('First name: ')
              last_name = options[:last_name] || ask('Last name: ')

              if email.empty? || first_name.empty? || last_name.empty?
                raise Thor::Error, 'Error. All fields required.'
              end

              person = default_program.create_person(
                email: email,
                first_name: first_name,
                last_name: last_name,
                program_id: fetch_program_id
              )
              say "Successfully created user #{options[:email]}" if person
            end

            desc 'person:deprovision PERSON_ID', 'Deprovision a user'
            define_method 'person:deprovision' do |person_id|
              person = Aptible::Comply::Person.find(person_id,
                                                    token: fetch_token)

              if person
                person.destroy
                say 'Deprovisioned person'
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
