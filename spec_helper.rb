require "rspec"
require "json"

require "./helpers"
require "./user"
require "./template"
require "./crawler"
require "./listing"

include CraigslistCrawler

CraigslistCrawler.database = "./test.db"