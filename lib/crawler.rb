
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require_relative 'helpers'

module CraigslistCrawler
  class Crawler
    def initialize(options = {})
      @user_id = options.delete(:user_id) { raise ArgumentError.new("You need to pass in a user id") }
      @location = options.delete(:location) { raise ArgumentError.new("You need to pass in a location") } # eg sfbay
      @section = options.delete(:section) { raise ArgumentError.new("You need to pass in a section") } # eg hhh

      default_params = { :srchType => 'A' }

      @params = default_params.merge(options)
      @params[:addTwo] = @params.delete(:cat) ? 'purrr' : '' # e.g. :cat => true
      @params[:addThree] = @params.delete(:dog) ? 'wooof' : '' # e.g. :dog => true
      @params[:maxAsk] = @params.delete(:max_price) # e.g :max_price => 2000 ($2000)
      @params[:minAsk] = @params.delete(:min_price) # e.g :min_price => 500 ($500)
      #other acceptable params:
        #:query => "bay view" (search query)
        #:bedrooms => 5 (number of bedrooms)
        #:sub_region => sfc (others: eby, pen, nby, etc)
    end

    def url_to_scrape
      base_url = "http://#{@location}.craigslist.org/search/#{@section}"
      base_url << "/#{@params[:sub_region]}" if @params[:sub_region]
      parameters = @params.collect { |key, value| "#{key}=#{value}"}.join("&")
      "#{base_url}?#{parameters}"
    end

    def urls_of_listings
      Nokogiri::HTML(open(url_to_scrape)).css('p.row > a').collect {|url| url['href']}
    end

    def listings
      listings = []

      urls_of_listings.each do |listing_url|
        listing_page = Nokogiri::HTML(open(listing_url))
        mailto = listing_page.css('span.returnemail').collect {|email| email.children[1].attributes['href'].value unless email.children[1].nil?} [0] #can be nil or empty
        email = mailto.match(/^mailto:(.*)\?/)[1]
        title = CGI.escape(listing_page.css('h2').first.children.text.gsub(' (map)', ''))
        craigslist_id = listing_page.css('span.postingidtext').collect { |post| post.children.text.gsub('PostingID: ', '') }[0].to_i
        listing_details = {:title => title, :email => email, :craigslist_id => craigslist_id, :user_id => @user_id }

        unless email.nil?
          listing = Listing.new(listing_details)
          listing.save!
          listings << listing
        end
      end

      listings
    end
  end
end
