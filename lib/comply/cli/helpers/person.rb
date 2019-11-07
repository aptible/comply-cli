require 'aptible/comply'
require 'json'

module Comply
  module CLI
    module Helpers
      module Person
        def prettify_person(person)
          "person:#{person.email}"
        end

        def pretty_print_person(person)
          "#{prettify_person(person)} (#{person.id})"
        end

        def find_person_by_alias(id_or_pretty)
          if id_or_pretty.uuid?
            Aptible::Comply::Person.find(id_or_pretty, token: fetch_token)
          else
            default_program.people.find do |person|
              prettify_person(person) == id_or_pretty
            end
          end
        end
      end
    end
  end
end
