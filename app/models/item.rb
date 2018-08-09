class Item < ApplicationRecord
  belongs_to :vendor

  delegate :title, to: :vendor, prefix: true
  validates :title, :expected_price, presence: true
  validates :title, uniqueness: true
  validates :stock, :total, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_defaults

  def self.my_search(column, keyword, is_like=true)
    query = '1 = 0'
    if is_like
      column.each do |c|
          query += " OR #{c} LIKE :kw"
      end
      Item.where(query, kw: "%#{keyword}%")
    else
      column.each do |c|
          query += " OR #{c} = ?"
      end
      Item.where(query, kw: keyword)
    end
  end

  def self.my_find(column, keyword, is_like=true)
    if is_like
      Item.where("#{column} LIKE ?", "%#{keyword}%")
    else
      Item.where("#{column} = ?", keyword)
    end
  end

  private
  def set_defaults
    self.title.try(:strip!)
    self.expected_price ||= 0
    self.total ||= 0
    self.stock ||= 0
    self.actual_price ||= 0
    self.cost ||= 0
    self.style ||= 0
  end
end
