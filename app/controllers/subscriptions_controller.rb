class SubscriptionsController < ApplicationController
  include Notifiable
  before_action :set_subscription, only: [:update]
  
  # POST /subscriptions
  def create
    @subscriptions = Subscription.new(subscription_params)

    if @subscriptions.save
      serialized_subscription = SubscriptionSerializer.new(@subscriptions).serialized_json
      # notify_third_parties(serialized_subscription)
      render json: serialized_subscription, status: :created
    else
      render json: @subscriptions.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PUT /subscriptions/:id
  def update
    if @subscription.update(subscription_params)
      serialized_subscription = SubscriptionSerializer.new(@subscription).serialized_json
      notify_third_parties(serialized_subscription)
      render json: serialized_subscription, status: :ok
    else
      render json: @subscription.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  # Set Subcription based on ID or return 404 if not found
  def set_subscription
    @subscription = Subscription.find_by(id: params[:id])
    return render json: { message: "Subscription with ID: #{params[:id]} not found" }, status: :not_found if @subscription.blank?
  end

  # Only allow a trusted parameter "whitelist" through.
  def subscription_params
    params.require(:subscription).permit(:name, :email)
  end
end
