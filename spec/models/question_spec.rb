require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to belong_to(:best_answer).class_name('Answer').optional }
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for :links }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like "linkable"
  it_behaves_like "votable"
  it_behaves_like "commentable"
end
