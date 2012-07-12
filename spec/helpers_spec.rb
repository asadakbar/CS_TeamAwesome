require 'spec_helper'

describe CraigslistCrawler do
  context '.database=' do
    it "should set the database" do
      CraigslistCrawler.database = './db/test.db'
      CraigslistCrawler.database.should be_an_instance_of SQLite3::Database
    end
  end
end
