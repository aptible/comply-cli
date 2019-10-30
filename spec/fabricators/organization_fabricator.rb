class StubOrganization < OpenStruct
end

Fabricator(:organization, from: :stub_organization) do
  id { Fabricate.sequence(:organization_id) { |i| i } }

  href { |attrs| "https://auth.aptible.com/organizations/#{attrs[:id]}" }
end
