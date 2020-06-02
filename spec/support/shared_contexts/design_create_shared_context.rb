RSpec.shared_context 'valid design create params' do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:illustration) { create(:illustration) }
  let(:illustration_ids) { [illustration.id] }
  let(:blueprint) { create(:blueprint) }
  let(:blueprint_ids) { [blueprint.id] }

  let(:params) do
    {
      name: 'Design name',
      description: '3D model description',
      license_type: 'license_none',
      allow_comments: '1',
      category_id: category.id,
      illustration_ids: illustration_ids,
      blueprint_ids: blueprint_ids
    }
  end
end

RSpec.shared_context 'invalid design create params' do
  let(:user) { nil }
  let(:category) { nil }
  let(:illustration) { nil }
  let(:illustration_ids) { [] }
  let(:blueprint) { nil }
  let(:blueprint_ids) { [] }

  let(:params) do
    {
      name: 'Design name',
      description: '3D model description',
      license_type: 'license_none',
      allow_comments: '1',
      category_id: category.try(:id),
      illustration_ids: illustration_ids,
      blueprint_ids: blueprint_ids
    }
  end
end
