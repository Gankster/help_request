require 'rails_helper'

RSpec.describe Award, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to(:user).optional }

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_attached_of(:image) }

  it { is_expected.to validate_content_type_of(:image).allowing('image/jpeg', 'image/png', 'image/gif') }

  it 'have one attached files' do
    expect(subject.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
