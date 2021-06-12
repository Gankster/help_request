require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:awards) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:authorizations).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  end

  it {
    expect(subject).to have_many(:access_grants).class_name('Doorkeeper::AccessGrant')
                                                .with_foreign_key(:resource_owner_id).dependent(:destroy)
  }

  it {
    expect(subject).to have_many(:access_tokens).class_name('Doorkeeper::AccessToken')
                                                .with_foreign_key(:resource_owner_id).dependent(:destroy)
  }

  describe '#author?' do
    let(:user) { create(:user) }

    context 'when return true' do
      it 'user is author of question' do
        question = create(:question, author: user)
        expect(user.author?(question)).to be(true)
      end

      it 'user is author of answer' do
        answer = create(:answer, author: user)
        expect(user.author?(answer)).to be(true)
      end
    end

    context 'when return false' do
      it 'user is not author of resource' do
        answer = create(:answer)
        expect(user.author?(answer)).to be(false)
      end

      it 'resource does not have :user_id field' do
        user2 = create(:user)
        expect(user.author?(user2)).to be(false)
      end
    end
  end

  describe '#subscribed?' do
    let(:user) { create :user }

    let(:question) { create :question }

    it 'is truthy if user is subscribed to question' do
      question.subscriptions.create!(user: user)
      expect(user).to be_subscribed(question)
    end

    it 'is falsey if user is not subscribed to question' do
      expect(user).not_to be_subscribed(question)
    end
  end
end
