json.extract! order, :id, :customer, :phone, :address, :comment, :created_at, :updated_at
json.url order_url(order, format: :json)
