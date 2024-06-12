class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email
end
