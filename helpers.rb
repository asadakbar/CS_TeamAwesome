require 'sqlite3'

module CraigslistCrawler
  def self.database=(path_to_database)
    @database = SQLite3::Database.new path_to_database
  end

  def self.database
    @database
  end
end


