require 'aptible/comply'
require 'json'

module Comply
  module CLI
    module Helpers
      module Group
        def prettify_group(group)
          "group:#{group.name}"
        end

        def pretty_print_group(group)
          "#{prettify_group(group)} (#{group.id})"
        end

        def find_group_by_alias(id_or_pretty)
          if id_or_pretty.uuid?
            Aptible::Comply::Group.find(id_or_pretty, token: fetch_token)
          else
            default_program.groups.find do |group|
              prettify_group(group) == id_or_pretty
            end
          end
        end
      end
    end
  end
end
