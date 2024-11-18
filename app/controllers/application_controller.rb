class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :handle_foreign_key_constraint
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  private

  # Handle RecordNotFound exception (404)
  def handle_not_found(exception)
    render json: { error: "Resource not found", message: exception.message }, status: :not_found
  end

  # Handle InvalidForeignKey exception (422)
  def handle_foreign_key_constraint(exception)
    render json: { error: "Foreign key constraint failed", message: exception.message }, status: :unprocessable_entity
  end

  # Handle RecordInvalid exception (422)
  def handle_record_invalid(exception)
    render json: { error: "Validation failed", message: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
