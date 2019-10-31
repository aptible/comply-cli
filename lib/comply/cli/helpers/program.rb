require 'aptible/comply'
require 'json'

require_relative 'token'

module Comply
  module CLI
    module Helpers
      module Program
        include Helpers::Token

        PROGRAM_ENV_VAR = 'APTIBLE_PROGRAM_ID'.freeze

        def default_program
          return nil unless (id = fetch_program_id)
          @default_program ||= Aptible::Comply::Program.find(
            id, token: fetch_token
          )
        end

        def set_default_program
          default_program = own_programs.first
          save_program_id(default_program.id) if default_program
        end

        def pretty_print_program(program)
          "#{program.organization.name} (#{program.id})"
        end

        def fetch_program_id
          @program_id ||=
            ENV[PROGRAM_ENV_VAR] ||
            current_program_id_hash[Aptible::Comply.configuration.root_url]
          return @program_id if @program_id
          raise Thor::Error, 'Could not read program: please run comply ' \
                             "programs:select or set #{PROGRAM_ENV_VAR}"
        end

        def save_program_id(program_id)
          hash = current_program_id_hash.merge(
            Aptible::Comply.configuration.root_url => program_id
          )

          FileUtils.mkdir_p(File.dirname(program_id_file))

          File.open(program_id_file, 'w', 0o600) do |file|
            file.puts hash.to_json
          end
        rescue StandardError => e
          m = "Could not write program to #{program_id_file}: #{e}. " \
              'Check filesystem permissions.'
          raise Thor::Error, m
        end

        def current_program_id_hash
          JSON.parse(File.read(program_id_file))
        rescue
          {}
        end

        def program_id_file
          File.join ENV['HOME'], '.aptible', 'programs.json'
        end

        def own_programs
          # If a user is a member of a role in ACCOUNT_MANAGEMENT_ROLE_IDS
          # in Comply, they have read access to ALL programs. As a result,
          # when offering programs for customers to access, we select just
          # those which actually belong to their organization(s).

          programs = Aptible::Comply::Program.all(token: fetch_token)
          orgs = Aptible::Auth::Organization.all(token: fetch_token)

          programs.select do |program|
            orgs.map(&:href).include?(program.organization_url)
          end
        end
      end
    end
  end
end
