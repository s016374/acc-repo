module OrdersHelper
  # When Add(order.goods do not exist) create 1 new goods.
  # When Edit(order.goods exist) do nothing.
  def setup_order(order)
    1.times { order.goods.build } if order.goods.empty?
    order
  end
end
