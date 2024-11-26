class CategoriesController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    reset_shuffle
    @categories = Category.all
    @category_tree = build_tree(@categories)
  end

  def build_tree(categories, parent_id = nil)
    categories.select { |category| category.parent_id == parent_id }.map do |category|
      {
        category: category,
        subcategories: build_tree(categories, category.id)
      }
    end
  end

  def show
    reset_shuffle
    @category = Category.find(params[:id])
    @questions = @category.all_questions
  end

  def shuffle
    @category = Category.find(params[:id])
    session[:shuffle_category] = true
    last_question_ids = session[:last_shuffled_question_ids] || []
    random_question = @category.all_questions.where.not(id: last_question_ids).order("RANDOM()").first
    session[:last_shuffled_question_ids] ||= []
    session[:last_shuffled_question_ids] << random_question.id if random_question
    if random_question
      redirect_to category_question_path(@category, random_question)
    else
      redirect_to category_path(@category), alert: "No more questions available to shuffle."
    end
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "Category was successfully deleted."
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  private

  def reset_shuffle
    session[:shuffle_category] = false
    session[:shuffle] = false
    session[:last_shuffled_question_ids] = []
  end
end
