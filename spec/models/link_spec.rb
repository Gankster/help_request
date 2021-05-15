require 'rails_helper'

RSpec.describe Link, type: :model do
  subject { build(:link) }

  describe 'associations' do
    it { is_expected.to belong_to :linkable }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :url }
    it { is_expected.to allow_value('https://www.google.com/').for(:url) }
    it { is_expected.not_to allow_value('htps.google.com/').for(:url) }
  end
end
