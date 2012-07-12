require 'spec_helper'

describe "Listing.new" do

  let(:default_options) { {:title => "$62009 / 2br - Great house!",
                           :craigslist_id => 3071972480,
                           :email => 'vwdzk-3071972480@hous.craigslist.org',
                           :user_id => 1 } }
  let(:listing) { Listing.new(default_options) }



  it "initializes a new listing" do
    listing.should be_an_instance_of Listing
  end

  context "title, id, user id, and email are required to initialize a listing" do
    it "raises an argument error if a title is not passed in" do
      lambda {
        Listing.new(:craigslist_id => 3071972480, :email => 'vwdzk-3071972480@hous.craigslist.org', :user_id => 1)
        }.should raise_error(ArgumentError, "The listing must have a title.")
    end

    it "raises an argument error if an id is not passed in" do
      lambda {
        Listing.new(:title => "$62000 / 2br - Great house!", :email => 'vwdzk-3071972480@hous.craigslist.org', :user_id => 1)
        }.should raise_error(ArgumentError, "The listing must have a craigslist id.")
    end

    it "raises an argument error if an email is not passed in" do
      lambda {
        Listing.new(:title => "$62000 / 2br - Great house!", :craigslist_id => 3071972480, :user_id => 1)
        }.should raise_error(ArgumentError, "The listing must have an email.")
    end

    it "raises an argument error if a user id is not passed in" do
      lambda {
        Listing.new(:title => "$62000 / 2br - Great house!", :email => 'vwdzk-3071972480@hous.craigslist.org', :craigslist_id => 3071972480)
        }.should raise_error(ArgumentError, "The listing must have a user id.")
    end


  end

  context "#save!" do
    it "saves the listing to the database" do
      listing.id.should be_nil
      listing.save!
      listing.id.should be_an_instance_of Fixnum
    end
  end

  context ".user_listings" do
    it "generates an array of listings for a user"
      #user_listings(1)
  end

end