require 'aptible/comply'
require 'json'

module Comply
  module CLI
    module Helpers
      module Person
        include Helpers::Program
        include Helpers::Token

        def pretty_print_person(person)
          "person:#{person.email} (#{person.id})"
        end

        def own_people
          default_program.people
        end
      end
    end
  end
end
