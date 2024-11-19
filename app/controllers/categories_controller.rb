class CategoriesController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
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
    @category = Category.find(params[:id])
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
end
