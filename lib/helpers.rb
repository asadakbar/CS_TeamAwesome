require 'sqlite3'
require 'open-uri'
require 'nokogiri'
require 'cgi'

require_relative 'crawler'
require_relative 'listing'
require_relative 'message'
require_relative 'template'
require_relative 'user'

module CraigslistCrawler
  def self.database=(path_to_database)
    @database = SQLite3::Database.new path_to_database
  end

  def self.database
    @database
  end
end