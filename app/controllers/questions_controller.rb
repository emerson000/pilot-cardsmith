class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  def index
    session[:shuffle] = false
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])

    # Find the next post by id, if it exists
    @next_question = Question.where("id > ?", @question.id).order(:id).first

    # If there is no next post, loop back to the first post
    @next_question ||= Question.order(:id).first
  end

  def shuffle
    session[:shuffle] = true
    random_question = Question.order("RANDOM()").first
    redirect_to question_path(random_question)
  end

  def next_random
    current_question = Question.find(params[:id])
    next_question = Question.where.not(id: current_question.id).order("RANDOM()").first
    redirect_to question_path(next_question)
  end

  def new
    @question = Question.new
    4.times { @question.answer_choices.build }
    1.times { @question.question_categories.build }
  end

  def edit
    @question = Question.find(params[:id])
    (4 - @question.answer_choices.size).times { @question.answer_choices.build }
    (1 - @question.question_categories.size).times { @question.question_categories.build }
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to question_url(@question), notice: "Question was successfully updated."
    else
      render :edit
    end
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to questions_path, notice: "Question was successfully created."
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_path, notice: "Question was successfully deleted."
  end

  def question_params
    params.require(:question).permit(
      :text,
      :explanation,
      answer_choices_attributes: [ :id, :text, :is_correct, :_destroy ],
      question_categories_attributes: [ :id, :category_id, :_destroy ],
      question_sources_attributes: [ :id, :source_id, :_destroy ]
    ).tap do |whitelisted|
      whitelisted[:answer_choices_attributes].reject! { |_, v| v["text"].blank? }
    end
  end
end
