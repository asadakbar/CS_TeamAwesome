require "rspec"
require "json"

require "helpers"
require "user"
require "template"
require "crawler"
require "listing"
require "message"
require 'fakeweb'

include CraigslistCrawler

CraigslistCrawler.database = "db/test.db"
#FakeWeb.allow_net_connect = false
p Dir.pwd
FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/search/hhh?srchType=A&addTwo=&addThree=&maxAsk=&minAsk=", :body => File.read("./spec/listings.html"))
FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/sby/reb/3114067639.html", :body => File.read("./spec/listing.html"))
FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/sby/reb/3103486295.html", :body => File.read("./spec/listing2.html"))

# describe CraigslistCrawler do
#   before :each do
#     CraigslistCrawler.database = "./db/test.db"
#     CraigslistCrawler.database.execute(File.read("db/schema.sql"))
#   end
# end