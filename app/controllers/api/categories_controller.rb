class Api::CategoriesController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]

    def index
        categories = Category.where(parent: nil).all
        render json: categories
    end

    def show
        category = Category.find(params[:id])
        render json: category
    end

    def create
        category = Category.new(category_params)
        if category.save
            render json: category
        else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        category = Category.find(params[:id])
        if category.update(category_params)
            render json: category
        else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        category = Category.find(params[:id])
        category.destroy
        head :no_content
    end

    private

    def category_params
        params.require(:category).permit(:name, :parent_id)
    end
end
