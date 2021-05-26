class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy edit update]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    if current_user
      @answer = Answer.new(question: @question, author: current_user)
      @answer.links.new
    end
    gon.user_id = current_user&.id

    @answers = @question.answers.where.not(id: @question.best_answer_id)
    @best_answer = @question.best_answer
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_award
  end

  def create
    @question = current_user.questions.new(params_question)
    if @question.save
      # current_user.associate_award(@question.award)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def edit; end

  def update
    if current_user.author?(@question)
      @question.update(params_question)
      flash[:errors] = @question.errors.full_messages
    else
      flash[:notice] = 'You must be the author to edit the question.'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :show, notice: 'You must be the author to delete the question.'
    end
  end

  private

  def params_question
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                    award_attributes: %i[name image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return unless @question.valid?

    question_item = ApplicationController.render(
      partial: 'questions/question_item',
      locals: { question: @question }
    )

    ActionCable.server.broadcast('questions', { question_item: question_item })
  end
end
