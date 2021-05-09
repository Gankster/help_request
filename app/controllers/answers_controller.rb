class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy edit update]

  def new
    @answer = Answer.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(params_answer.merge(author: current_user))

    if @answer.save
      flash.now[:notice] = 'Your answer successfully created.'
    else
      @question.reload
      flash.now[:errors] = @answer.errors.full_messages
    end
    @new_answer = Answer.new
  end

  def update
    if current_user.author?(@answer)
      @answer.update(params_answer)
      flash.now[:errors] = @answer.errors.full_messages
    else
      flash.now[:notice] = 'You must be the author to edit the answer.'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully deleted.'
    else
      flash.now[:notice] = 'You must be the author to delete the answer.'
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
