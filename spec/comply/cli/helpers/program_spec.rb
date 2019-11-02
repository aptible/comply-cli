require 'spec_helper'
require 'securerandom'

describe Comply::CLI::Helpers::Program do
  around do |example|
    Dir.mktmpdir { |home| ClimateControl.modify(HOME: home) { example.run } }
  end

  subject { Class.new.send(:include, described_class).new }

  let(:program_id) { SecureRandom.uuid }
  let(:token) { double('token') }

  before do
    allow(subject).to receive(:fetch_token) { token }
  end

  describe '#save_program / #fetch_program' do
    it 'reads back a program ID it saved' do
      subject.save_program_id(program_id)
      expect(subject.fetch_program_id).to eq(program_id)
    end
  end

  describe 'accessible_programs' do
    it 'filters programs' do
      o1 = Fabricate(:organization)
      o2 = Fabricate(:organization)

      p1 = Fabricate(:program, organization: o1)
      p2 = Fabricate(:program, organization: o2)
      p3 = Fabricate(:program)

      allow(Aptible::Comply::Program).to receive(:all) { [p1, p2, p3] }
      allow(Aptible::Auth::Organization).to receive(:all) { [o1, o2] }

      programs = subject.accessible_programs
      expect(programs.map(&:id).sort).to eq [p1.id, p2.id].sort
    end
  end
end
