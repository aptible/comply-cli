require 'spec_helper'

describe Comply::CLI::Agent do
  before do
    # allow(subject).to receive(:save_token)
    # allow(subject).to receive(:attach_to_operation_logs)
    # allow(subject).to receive(:fetch_token) { double 'token' }
  end

  # let!(:account) { Fabricate(:account) }
  # let!(:app) { Fabricate(:app, handle: 'hello', account: account) }
  # let!(:service) { Fabricate(:service, app: app, process_type: 'web') }
  # let(:op) { Fabricate(:operation, status: 'succeeded', resource: app) }

  describe '#groups' do
    xit "lists a program's groups" do

      subject.send('groups')

      expect(captured_output_text)
        .to eq("=== #{account.handle}\n#{app.handle}\n")
    end
  end

end
