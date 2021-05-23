require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { create :vote }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:votable) }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_uniqueness_of(:user).scoped_to(:votable_type, :votable_id) }
  it { is_expected.to define_enum_for(:status).with_values(like: 1, dislike: -1) }
end
