# This model is not actually backed by the database, but conveniently collects all the changelog entries as models

require 'will_paginate/array' # because model not backed by database, model returns arrays instead of ActiveRecord Relations

class Changelog
  attr_accessor :title, :content
  def initialize(title,content)
    @title = title
    @content = content
  end
  def self.all
    changelogs = IO.read(File.expand_path("../../../../../CHANGELOG.md",__FILE__)).split(/^## /).map{|str| Changelog.new(str.split(/$/,2)[0],str.split(/$/,2)[1])}
    changelogs.slice!(0)
    changelogs
  end
  def self.paginate(options={})
    self.all.paginate(options)
  end
end
