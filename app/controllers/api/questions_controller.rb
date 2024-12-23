class Api::QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_category, only: [ :index ]

  def index
    if @category
      questions = @category.all_questions
    else
      questions = Question.all
    end
    render json: questions.as_json
  end

  def show
      question = Question.find(params[:id])
      render json: question
  end

  def create
      question = Question.new(question_params)
      if question.save
        render json: question
      else
          render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
      question = Question.find(params[:id])
      if question.update(question_params)
        render json: question
      else
          render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def destroy
      question = Question.find(params[:id])
      question.destroy
      head :no_content
  end

  private

  def question_params
      params.require(:question).permit(:text, :explanation, answer_choices_attributes: [ :id, :text, :is_correct, :_destroy ])
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end
end
