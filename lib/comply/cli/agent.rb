require 'aptible/auth'
require 'thor'
require 'chronic_duration'
require 'highline/import'

Dir[File.join(__dir__, 'helpers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'subcommands', '*.rb')].each { |file| require file }

module Comply
  module CLI
    class Agent < Thor
      include Thor::Actions

      include Helpers::Token
      include Helpers::Program

      include Subcommands::Vendors
      include Subcommands::Integrations
      include Subcommands::People
      include Subcommands::Groups
      include Subcommands::Access
      include Subcommands::Workflows

      # Forward return codes on failures.
      def self.exit_on_failure?
        true
      end

      def initialize(*)
        Aptible::Resource.configure { |conf| conf.user_agent = version_string }
        super
      end

      desc 'version', 'Print Aptible CLI version'
      def version
        puts version_string
      end

      desc 'login', 'Log in to Aptible'
      option :email
      option :password
      option :lifetime, desc: 'The duration the token should be valid for ' \
                              '(example usage: 24h, 1d, 600s, etc.)'
      option :otp_token, desc: 'A token generated by your second-factor app'
      def login
        email = options[:email] || ask('Email: ')
        password = options[:password] || ask('Password: ', echo: false)
        puts ''

        token_options = { email: email, password: password }

        otp_token = options[:otp_token]
        token_options[:otp_token] = otp_token if otp_token

        begin
          lifetime = '1w'
          lifetime = '12h' if token_options[:otp_token]
          lifetime = options[:lifetime] if options[:lifetime]

          duration = ChronicDuration.parse(lifetime)
          if duration.nil?
            raise Thor::Error, "Invalid token lifetime requested: #{lifetime}"
          end

          token_options[:expires_in] = duration
          token = Aptible::Auth::Token.create(token_options)
        rescue OAuth2::Error => e
          if e.code == 'otp_token_required'
            token_options[:otp_token] = options[:otp_token] ||
                                        ask('2FA Token: ')
            retry
          end

          raise Thor::Error, 'Could not authenticate with given credentials: ' \
                             "#{e.code}"
        end

        save_token(token.access_token)
        puts "Token written to #{token_file}"

        lifetime_format = { units: 2, joiner: ', ' }
        token_lifetime = (token.expires_at - token.created_at).round
        expires_in = ChronicDuration.output(token_lifetime, lifetime_format)
        puts "This token will expire after #{expires_in} " \
             '(use --lifetime to customize)'

        # Select a default program
        set_default_program
      end

      desc 'programs:select', 'Select a program for CLI context'
      define_method 'programs:select' do
        candidates = accessible_programs
        current_program_id = begin
                               fetch_program_id
                             rescue Thor::Error
                               nil
                             end

        choose do |menu|
          menu.prompt = 'Choose a program (* is current default):'
          candidates.each do |program|
            pretty = pretty_print_program(program)
            if program.id == current_program_id
              pretty = "* #{pretty}"
              menu.default = pretty
            end

            menu.choice pretty do
              save_program_id program.id
            end
          end
        end
      end

      private

      def version_string
        bits = [
          'comply-cli',
          "v#{Comply::CLI::VERSION}"
        ]
        bits.join ' '
      end
    end
  end
end
