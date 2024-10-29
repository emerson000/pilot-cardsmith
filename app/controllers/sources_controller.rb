class SourcesController < ApplicationController
  def index
    sources = Source.all
    render json: sources
  end

  def show
      source = Source.find(params[:id])
      render json: source
  end

  def create
      source = Source.new(source_params)
      if source.save
        render json: source
      else
          render json: { errors: source.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
      source = Source.find(params[:id])
      if source.update(source_params)
        render json: source
      else
          render json: { errors: source.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def destroy
      source = Source.find(params[:id])
      source.destroy
      head :no_content
  end

  private

  def source_params
      params.require(:source).permit(:title, :description, :url)
  end
end
