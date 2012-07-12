require "rspec"
require "json"

require "./helpers"
require "./user"
require "./template"
require "./crawler"
require "./listing"

include CraigslistCrawler

CraigslistCrawler.database = "./db/test.db"

# describe CraigslistCrawler do
#   before :each do
#     CraigslistCrawler.database = "./db/test.db"
#     CraigslistCrawler.database.execute(File.read("./crawler.sql"))
#   end
# end