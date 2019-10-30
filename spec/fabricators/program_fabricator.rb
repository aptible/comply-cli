class StubProgram < OpenStruct
end

Fabricator(:program, from: :stub_program) do
  id { Fabricate.sequence(:program_id) { |i| i } }

  organization
  organization_url { |attrs| attrs[:organization].href }

  errors { Aptible::Resource::Errors.new }
end
