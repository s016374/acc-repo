class Order < ApplicationRecord
  has_many :goods, dependent: :destroy
  accepts_nested_attributes_for :goods, allow_destroy: true, reject_if: :all_blank

  validates :customer, presence: true
  before_validation :set_defaults

  def self.my_search(column, keyword, is_like=true)
    query = '1 = 0'
    if is_like
      column.each do |c|
          query += " OR #{c} LIKE :kw"
      end
      Order.where(query, kw: "%#{keyword}%")
    else
      column.each do |c|
          query += " OR #{c} = ?"
      end
      Order.where(query, kw: keyword)
    end
  end

  private
  def set_defaults
    self.customer.try(:strip!)
    self.is_purchase ||= 0
  end
end
