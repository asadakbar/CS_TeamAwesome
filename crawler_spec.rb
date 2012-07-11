require 'simplecov'
SimpleCov.start
require 'rspec'
require_relative 'crawler'
require_relative 'listing'

include CraigslistCrawler

describe "Crawler.new" do

  let(:crawler) {Crawler.new(:location => "sfbay", :section => 'hhh')}

  context "initialize the crawler with options" do
    it "initializes the crawler" do
      crawler.should be_an_instance_of Crawler
    end

    it "raises an argument if location is not passed in as an option" do
      expect {Crawler.new(:section => 'hhh')}.should raise_error(ArgumentError, "You need to pass in a location")
    end

    it "raises an argument if section is not passed in as an option" do
      expect {Crawler.new(:location => 'sfbay')}.should raise_error(ArgumentError, "You need to pass in a section")
    end

    it "raises an argument if user id is not passed in as an option"
  end

  context "generates a craigslist url with the specified parameters" do
    it "returns the craigslist search url" do
      crawler.url.should eq 'http://sfbay.craigslist.org/search/hhh?srchType=A&addTwo=&addThree=&maxAsk=&minAsk='
      option2 = {:location => 'sfbay', :section => 'hhh', :cat => true, :min_price => 3000, :bedrooms => 3 }
      Crawler.new(option2).url.should eq 'http://sfbay.craigslist.org/search/hhh?srchType=A&bedrooms=3&addTwo=purrr&addThree=&maxAsk=&minAsk=3000'
      option3 = {:location => 'sfbay', :section => 'hhh', :sub_region => 'sby', :max_price => 2000, :bedrooms => 4, :query => 'view', :dog => true }
      Crawler.new(option3).url.should eq 'http://sfbay.craigslist.org/search/hhh/sby?srchType=A&sub_region=sby&bedrooms=4&query=view&addTwo=&addThree=wooof&maxAsk=2000&minAsk='
    end
  end

  context "extracts all the individual listing urls from the listings page" do
    it "returns an array of all the listing urls" do
      crawler.listing_urls.length.should eq 100
      crawler.listing_urls[0].should match /http:\/\/sfbay.craigslist.org/
    end
  end

  context "extracts the relavent information from each listing" do
    it "returns an array listing objects" do
      crawler.listings[0].should be_an_instance_of Listing
    end

  end
end

