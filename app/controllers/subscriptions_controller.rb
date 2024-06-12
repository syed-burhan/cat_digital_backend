class SubscriptionsController < ApplicationController
  def create
    @subscriptions = Subscription.new(subscription_params)

    if @subscriptions.save
      render json: @subscriptions, status: :created
    else
      render json: @subscriptions.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name, :email)
  end
end
