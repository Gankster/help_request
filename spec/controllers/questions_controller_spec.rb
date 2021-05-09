require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    context 'when question has answers' do
      let!(:question) { create(:question, :with_answers) }

      it 'has array of answers' do
        expect(question.answers).to match_array Answer.all
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has current user' do
      expect(controller.current_user).to eq user
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      subject(:http_request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in DB' do
        expect { http_request }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        http_request
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attrubutes' do
      subject(:http_request) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { http_request }.not_to change(Question, :count)
      end

      it 'renders :new view' do
        http_request
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is the author of question' do
      let!(:question) { create(:question, author: user) }

      context 'with valid attributes' do
        subject(:http_request) do
          patch :update, params: { id: question, question: { body: 'New Question' } }, format: :js
        end

        it 'changes answer attributes' do
          http_request
          question.reload
          expect(question.body).to eq 'New Question'
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        subject(:http_request) do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end

        it 'does not change answer attributes' do
          expect { http_request }.not_to change(question, :body)
        end

        it 'renders :update view' do
          http_request
          expect(response).to render_template :update
        end
      end
    end

    context 'when user is not the author of question' do
      subject(:http_request) do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it 'does not change answer attributes' do
        expect { http_request }.not_to change(question, :body)
      end
    end
  end

  describe 'PATCH #mark_best' do
    subject(:http_request) do
      patch :mark_best, params: { id: question, answer_id: question.answers.first }, format: :js
    end

    context 'when user is the author of question' do
      let(:question) { create(:question, :with_answers, author: user) }

      it 'has best answer' do
        http_request
        expect(assigns(:question).best_answer).to eq question.answers.first
      end

      it 'renders :mark_best view' do
        http_request
        expect(response).to render_template :mark_best
      end
    end

    context 'when user is not the author of question' do
      let(:question) { create(:question, :with_answers) }

      it 'has best answer' do
        http_request
        expect(assigns(:question).best_answer).to eq nil
      end

      it 'renders mark_best view' do
        http_request
        expect(flash[:notice]).to eq 'You must be the author to mark the answer as best.'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: question } }

    context 'when user is the author of question' do
      let!(:question) { create(:question, author: user) }

      it 'destroys question from DB' do
        expect { http_request }.to change(Question, :count).by(-1)
      end

      it 'redirect to :index view' do
        http_request
        expect(response).to redirect_to questions_path
      end
    end

    context 'when user is not the author of question' do
      before { question }

      it 'does not destroy question from DB' do
        expect { http_request }.not_to change(Question, :count)
      end

      it 'renders :show view' do
        http_request
        expect(response).to render_template :show
      end
    end
  end
end
