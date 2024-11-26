class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show, :shuffle ]
  before_action :set_category
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]

  def index
    reset_shuffle
    if @category
      @questions = @category.all_questions
    else
      @questions = Question.all
    end
  end

  def show
    @question = Question.find(params[:id])
    if @category
      @next_question = @category.all_questions.where("questions.id > ?", @question.id).order(:id).first
      @next_question ||= @category.all_questions.order(:id).first
    else
      @next_question = Question.where("questions.id > ?", @question.id).order(:id).first
      @next_question ||= Question.order(:id).first
    end
  end

  def shuffle
    session[:shuffle] = true
    last_question_ids = session[:last_shuffled_question_ids] || []
    if @category
      random_question = @category.all_questions.where.not(id: last_question_ids).order("RANDOM()").first
    else
      random_question = Question.where.not(id: last_question_ids).order("RANDOM()").first
    end
    session[:last_shuffled_question_ids] ||= []
    session[:last_shuffled_question_ids] << random_question.id if random_question
    if random_question
      redirect_to @category ? category_question_path(@category, random_question) : question_path(random_question)
    else
      redirect_to @category ? category_questions_path(@category) : questions_path, alert: "No more questions available to shuffle."
    end
  end

  def new
    if @category
      @question = @category.questions.build
      @question.question_categories.build(category_id: @category.id)
      @form_url = category_questions_path(@category)
    else
      @question = Question.new
      @form_url = questions_path
    end
    4.times { @question.answer_choices.build }
    1.times { @question.question_categories.build }
  end

  def edit
    @question = Question.find(params[:id])
    (4 - @question.answer_choices.size).times { @question.answer_choices.build }
    (1 - @question.question_categories.size).times { @question.question_categories.build }
    if @category
      @form_url = category_question_path(@category, @question)
    else
      @form_url = question_path(@question)
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to @category ? category_question_path(@category, @question) : @question, notice: "Question was successfully updated."
    else
      render :edit
    end
  end

  def create
    if @category
      @question = @category.questions.build(question_params)
    else
      @question = Question.new(question_params)
    end
    if @question.save
      redirect_to @category ? category_question_path(@category, @question) : question_path(@question), notice: "Question was successfully created."
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to @category ? category_questions_path(@category) : questions_path, notice: "Question was successfully deleted."
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  private

  def set_question
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @question = @category.all_questions.find(params[:id])
    else
      @question = Question.find(params[:id])
    end
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

  def reset_shuffle
    session[:shuffle_category] = false
    session[:shuffle] = false
    session[:last_shuffled_question_ids] = []
  end
end
