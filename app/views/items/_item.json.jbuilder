json.extract! item, :id, :title, :stock, :total, :expected_price, :actual_price, :cost, :style, :description, :created_at, :updated_at
json.url item_url(item, format: :json)
