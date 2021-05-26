require 'rails_helper'

RSpec.describe Authorization, type: :model do
  subject { build :authorization }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
end
