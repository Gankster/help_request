RSpec.shared_examples "commentable" do
  it { is_expected.to have_many(:comments).order(:created_at).dependent(:destroy) }
end
