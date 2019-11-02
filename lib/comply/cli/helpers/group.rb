require 'aptible/comply'
require 'json'

require_relative 'token'

module Comply
  module CLI
    module Helpers
      module Group
        include Helpers::Token

        def fetch_group(program, group_id)
          maybe_group = program.groups.select { |g| g.id == group_id }
          maybe_group.count > 0 ? maybe_group.first : nil
        end

        def pretty_print_group(group)
          group.inspect
        end

        def pretty_print_member(member)
          member.name
        end

      end
    end
  end
end
