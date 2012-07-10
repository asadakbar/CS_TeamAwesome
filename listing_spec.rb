require 'simplecov'
SimpleCov.start
require 'rspec'
require_relative 'listing'

include CraigslistCrawler

describe "Listing.new" do

  let(:listing) { Listing.new(:title => "$62000 / 2br - Great house!", :craigslist_id => 3071972480, :email => 'vwdzk-3071972480@hous.craigslist.org') }

  it "initializes a new listing" do
    listing.should be_an_instance_of Listing
  end

  context "title, id, and email are required to initialize a listing" do
    it "raises an argument error if a title is not passed in" do
      expect {
        Listing.new(:craigslist_id => 3071972480, :email => 'vwdzk-3071972480@hous.craigslist.org')
        }.should raise_error(ArgumentError, "The listing must have a title.")
    end

    it "raises an argument error if an id is not passed in" do
      expect {
        Listing.new(:title => "$62000 / 2br - Great house!", :email => 'vwdzk-3071972480@hous.craigslist.org')
        }.should raise_error(ArgumentError, "The listing must have a craigslist id.")
    end

    it "raises an argument error if an email is not passed in" do
      expect {
        Listing.new(:title => "$62000 / 2br - Great house!", :craigslist_id => 3071972480)
        }.should raise_error(ArgumentError, "The listing must have an email.")
    end

  end

  context "#contacted?" do
    it "returns false if the listing owner was not contacted" do
      listing.contacted?.should be_false
    end

    it "returns true if the listing owner has been contacted" do
      listing = Listing.new(:title => "$62000 / 2br - Great house!", :craigslist_id => 3071972480, :email => 'vwdzk-3071972480@hous.craigslist.org', :contacted_at => Time.now)
      listing.contacted?.should be_true
    end
  end
end