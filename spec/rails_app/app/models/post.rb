class Post < ActiveRecord::Base
  scope :published, lambda {where('published_at <= ?', Time.now)}
  scope :unpublished, lambda {where('published_at > ?', Time.now)}
end
