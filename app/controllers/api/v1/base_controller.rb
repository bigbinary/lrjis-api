class Api::V1::BaseController < ApplicationController

  skip_before_action :verify_authenticity_token

  respond_to :json

  rescue_from Exception, with: :handle_api_exceptions

  private

  def handle_api_exceptions exception
    log_exception exception

    error_message = 'Something went wrong. Please try again later.'
    respond_with_error(error_message, 500)
  end

  def respond_with_error(message, status = 500)
    render json: { error: message }, status: status
  end

  def log_exception exception
    Rails.logger.info exception.class.to_s
    Rails.logger.info exception.to_s
    Rails.logger.info exception.backtrace.join("\n")
  end
end
