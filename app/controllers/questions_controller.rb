class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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
      redirect_to questions_path, notice: "Question was successfully updated."
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
