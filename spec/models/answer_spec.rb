require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :body }
  end

  describe 'callbacks' do
    describe '#clear_best_answer' do
      let(:question) { answer.question }
      let(:answer) { create(:answer) }

      it 'clear best answer' do
        answer.mark_as_best_answer
        answer.destroy
        expect(question.best_answer).to be nil
      end
    end
  end

  describe '#best_answer?' do
    context 'when answer is the best' do
      let!(:answer) { create(:answer) }
      let!(:question) { answer.question }

      it 'marks as best' do
        answer.mark_as_best_answer
        expect(answer.best_answer?).to be true
      end
    end

    context 'when answer isn`t best' do
      let(:answer) { create(:answer) }
      let(:question) { answer.question }

      it 'does not mark as best' do
        expect(answer.best_answer?).to be false
      end
    end
  end
end
