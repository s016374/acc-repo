class Good < ApplicationRecord
  belongs_to :order

  delegate :customer, to: :order, prefix: true
  validates :title, :price, :number, presence: true
  validates :number, numericality: { other_than: 0 }
  validate :has_item?, on: [:update, :create]
  validate :stock_enough?, on: [:update, :create]
  before_validation :set_defaults
  after_commit :deal_items_when_created, on: :create
  # Do NOT do update and destory, because calculate data would wrong when num were changed.
  # Disable update and destroy by view now.
  after_commit :deal_items_when_updated, on: :update
  after_commit :deal_items_when_destroyed, on: :destroy

  private
  def set_defaults
    self.title.try(:strip!)
    self.number ||= 1
    self.price ||= 10
  end

  # verify good is exist in items.
  def has_item?
    msg = "'#{self.title}' does NOT exsit!"
    self.errors.add(:title, msg) if Item.where("title = :title", title: self.title).empty?
  end

  # verify item stock is enough.
  def stock_enough?
    msg = "'#{self.number}' more than stock!"
    self.errors.add(:number, msg) if self.order.is_purchase == 0 && Item.where("title = :title", title: self.title).first.stock < number
  end

  def method_missing(method_name, *arg, &blk)
    return deal_items(method_name.to_s) if %w(deal_items_when_created deal_items_when_updated deal_items_when_destroyed).include?(method_name.to_s)
    super
  end

  # deal items corresponding with goods when order commit.
  def deal_items(on)
    @target_item = Item.where("title = :title", title: self.title).first
    self.order.is_purchase == 0 ? deal_order_items(on) : deal_purchase_items(on)
  end

  # deal items sold
  def deal_order_items(on)
    # calculate actual price, stock
    sold_num = @target_item.total - @target_item.stock
    case on
    when 'deal_items_when_created'
      @target_item.actual_price = (@target_item.actual_price * sold_num + price * number) / (sold_num + number)
      @target_item.stock -= number
    when 'deal_items_when_updated'
      @target_item.actual_price = (@target_item.actual_price * (sold_num - number) + price * number) / sold_num
    when 'deal_items_when_destroyed'
      @target_item.actual_price = @target_item.actual_price * (sold_num - number) / sold_num
      @target_item.stock += number
    else
      raise 'error: Good#deal_order_items'
    end
    @target_item.save
  end

  # deal items bought
  def deal_purchase_items(on)
    # calculate actual cost, total, stock
    case on
    when 'deal_items_when_created'
      @target_item.cost = (@target_item.cost * @target_item.total + price * number) / (@target_item.total + number)
      @target_item.total += number
      @target_item.stock += number
    when 'deal_items_when_updated'
      @target_item.cost = (@target_item.cost * (@target_item.total - number) + price * number) / @target_item.total
    when 'deal_items_when_destroyed'
      @target_item.cost = (@target_item.cost * @target_item.total - price * number ) / (@target_item.total - number)
      @target_item.total -= number
      @target_item.stock -= number
    else
      raise 'error: Good#deal_order_items'
    end
    @target_item.save
  end
end
