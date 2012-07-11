module CraigslistCrawler

  def self.db(db_file_name)
    SQLite3::Database.new db_file_name
  end

end