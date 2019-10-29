require 'spec_helper'

describe Comply::CLI::Agent do
  before do
    allow(subject).to receive(:ask)
    allow(subject).to receive(:save_token)
    allow(subject).to receive(:token_file).and_return 'some.json'
  end

  describe '#version' do
    it 'should print the version' do
      version = Comply::CLI::VERSION

      expect do
        subject.version
      end.to output("comply-cli v#{version}\n").to_stdout
    end
  end

  describe '#login' do
    let(:token) { double('Aptible::Auth::Token') }
    let(:created_at) { Time.now }
    let(:expires_at) { created_at + 1.week }

    before do
      m = -> (code) { @code = code }
      OAuth2::Error.send :define_method, :initialize, m

      allow(token).to receive(:access_token).and_return 'access_token'
      allow(token).to receive(:created_at).and_return created_at
      allow(token).to receive(:expires_at).and_return expires_at
      allow(subject).to receive(:puts) {}
    end

    it 'should save a token to ~/.aptible/tokens' do
      allow(Aptible::Auth::Token).to receive(:create).and_return token
      expect(subject).to receive(:save_token).with('access_token')
      subject.login
    end

    it 'should output the token location and token lifetime' do
      allow(Aptible::Auth::Token).to receive(:create).and_return token
      allow(subject).to receive(:puts).and_call_original

      expect { subject.login }.to output(/token written to.*json/i).to_stdout
      expect { subject.login }.to output(/expire after 7 days/i).to_stdout
    end

    it 'should raise an error if authentication fails' do
      allow(Aptible::Auth::Token).to receive(:create)
        .and_raise(OAuth2::Error, 'foo')
      expect do
        subject.login
      end.to raise_error 'Could not authenticate with given credentials: foo'
    end

    it 'should use command line arguments if passed' do
      options = { email: 'test@example.com', password: 'password',
                  lifetime: '30 minutes' }
      allow(subject).to receive(:options).and_return options
      args = { email: options[:email], password: options[:password],
               expires_in: 30.minutes.seconds }
      expect(Aptible::Auth::Token).to receive(:create).with(args) { token }
      subject.login
    end

    it 'should default to 1 week expiry when OTP is disabled' do
      options = { email: 'test@example.com', password: 'password' }
      allow(subject).to receive(:options).and_return options
      args = options.dup.merge(expires_in: 1.week.seconds)
      expect(Aptible::Auth::Token).to receive(:create).with(args) { token }
      subject.login
    end

    it 'should fail if the lifetime is invalid' do
      options = { email: 'test@example.com', password: 'password',
                  lifetime: 'this is sparta' }
      allow(subject).to receive(:options).and_return options

      expect { subject.login }.to raise_error(/Invalid token lifetime/)
    end

    context 'with OTP' do
      let(:email) { 'foo@example.org' }
      let(:password) { 'bar' }
      let(:token) { '123456' }

      context 'with options' do
        before do
          allow(subject).to receive(:options)
            .and_return(email: email, password: password, otp_token: token)
        end

        it 'should authenticate without otp_token_required feedback' do
          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, otp_token: token,
                  expires_in: 12.hours.seconds)
            .once
            .and_return(token)

          subject.login
        end
      end

      context 'with prompts' do
        before do
          [
            [['Email: '], email],
            [['Password: ', echo: false], password],
            [['2FA Token: '], token]
          ].each do |prompt, val|
            expect(subject).to receive(:ask).with(*prompt).once.and_return(val)
          end
        end

        it 'should prompt for an OTP token and use it' do
          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, expires_in: 1.week.seconds)
            .once
            .and_raise(OAuth2::Error, 'otp_token_required')

          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, otp_token: token,
                  expires_in: 12.hours.seconds)
            .once
            .and_return(token)

          subject.login
        end

        it 'should let the user override the default lifetime' do
          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, expires_in: 1.day.seconds)
            .once
            .and_raise(OAuth2::Error, 'otp_token_required')

          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, otp_token: token,
                  expires_in: 1.day.seconds)
            .once
            .and_return(token)

          allow(subject).to receive(:options).and_return(lifetime: '1d')
          subject.login
        end

        it 'should not retry non-OTP errors.' do
          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, expires_in: 1.week.seconds)
            .once
            .and_raise(OAuth2::Error, 'otp_token_required')

          expect(Aptible::Auth::Token).to receive(:create)
            .with(email: email, password: password, otp_token: token,
                  expires_in: 12.hours.seconds)
            .once
            .and_raise(OAuth2::Error, 'foo')

          expect { subject.login }.to raise_error(/Could not authenticate/)
        end
      end
    end
  end
end
