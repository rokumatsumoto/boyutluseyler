RSpec.shared_examples 'user is not signed-in policy' do
  let(:user) { nil }

  it { within_block_is_expected.to raise_error(Pundit::NotAuthorizedError) }
end
