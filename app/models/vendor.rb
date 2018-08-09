class Vendor < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: true
  before_validation :set_defaults

  def self.my_search(column, keyword, is_like=true)
    query = '1 = 0'
    if is_like
      column.each do |c|
          query += " OR #{c} LIKE :kw"
      end
      Vendor.where(query, kw: "%#{keyword}%")
    else
      column.each do |c|
          query += " OR #{c} = ?"
      end
      Vendor.where(query, kw: keyword)
    end
  end

  private
  def set_defaults
    self.title.try(:strip!)
  end
end
