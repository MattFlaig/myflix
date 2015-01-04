class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> {order('created_at DESC')}

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%")
  end

  def average_rating
    clean_reviews = reviews.reload.where('rating IS NOT NULL')
    return nil if clean_reviews.empty?
    ratings = clean_reviews.map(&:rating)
    (ratings.sum.to_f / clean_reviews.size.to_f).round(1)
  end
end