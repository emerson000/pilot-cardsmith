class SourcesController < ApplicationController
  def index
    @sources = Source.all
  end

  def show
    @source = Source.find(params[:id])
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find(params[:id])
  end

  def update
    @source = Source.find(params[:id])
    if @source.update(source_params)
      redirect_to sources_path, notice: "Source was successfully updated."
    else
      render :edit
    end
  end

  def create
    @source = Source.new(source_params)
    if @source.save
      redirect_to sources_path, notice: "Source was successfully created."
    else
      render :new
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy
    redirect_to sources_path, notice: "Source was successfully deleted."
  end

  def source_params
    params.require(:source).permit(:title, :description, :url)
  end
end
