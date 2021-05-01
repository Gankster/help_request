require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      subject(:request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in DB' do
        expect { request }.to change(Question, :count).by(1)
      end

      it 'renders :show view' do
        request
        expect(response).to render_template :show
      end
    end

    context 'with invalid attrubutes' do
      subject(:request) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { request }.not_to change(Question, :count)
      end

      it 'renders :new view' do
        request
        expect(response).to render_template :new
      end
    end
  end
end
