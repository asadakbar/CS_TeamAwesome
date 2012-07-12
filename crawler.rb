require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require_relative 'listing'
require 'sqlite3'

module CraigslistCrawler

  class Crawler

    #attr_reader :listings

    def initialize(options = {})
      #@id = nil
      @user_id = options.delete(:user_id) { raise ArgumentError.new("You need to pass in a user id") }

      #required params
      @location = options.delete(:location) { raise ArgumentError.new("You need to pass in a location") } # eg sfbay
      @section = options.delete(:section) { raise ArgumentError.new("You need to pass in a section") } # eg hhh

      default_params = { :srchType => 'A' }

      #other params
      @params = default_params.merge(options)
      @params[:addTwo] = @params.delete(:cat) ? 'purrr' : '' # e.g. :cat => true
      @params[:addThree] = @params.delete(:dog) ? 'wooof' : '' # e.g. :dog => true
      @params[:maxAsk] = @params.delete(:max_price) # e.g :max_price => 2000 ($2000)
      @params[:minAsk] = @params.delete(:min_price) # e.g :min_price => 500 ($500)
      #other acceptable params:
        #:query => "bay view" (search query)
        #:bedrooms => 5 (number of bedrooms)
        #:sub_region => sfc (others: eby, pen, nby, etc)

      #@listings = listings
    end

    def url
      "#{base_url}?#{url_params}"
    end

    def listing_urls
      doc = Nokogiri::HTML(open(url))
      doc.css('p.row > a').collect {|url| url['href']}
    end

    def listings
      listings = listing_urls.collect do |listing_url|
        doc = Nokogiri::HTML(open(listing_url))
        next if listing_details(doc).nil?
         #check if listing already exists before saving
        indiv_listing = Listing.new(listing_details(doc))
       # p indiv_listing

        indiv_listing.save!#save to db
        indiv_listing
      end.compact!
      listings
    end

    private
    def base_url
      url = "http://#{@location}.craigslist.org/search/#{@section}"
      url << "/#{@params[:sub_region]}" if @params[:sub_region]
      url
    end

    def url_params
      @params.collect { |key, value| "#{key}=#{value}"}.join("&")
    end

    def listing_details(doc)
      full_email = doc.css('span.returnemail').collect {|email| email.children[1].attributes['href'].value unless email.children[1].nil?} [0] #can be nil or empty
      return nil if full_email.nil?
      email = full_email.match(/^mailto:(.*)\?/)[1]
      title = CGI.escape(doc.css('h2').first.children.text.gsub(' (map)', ''))
      craigslist_id = doc.css('span.postingidtext').collect { |post| post.children.text.gsub('PostingID: ', '') }[0].to_i
      {:title => title, :email => email, :craigslist_id => craigslist_id, :user_id => @user_id }
    end

  end
end

# crawler = CraigslistCrawler::Crawler.new(:location => "sfbay", :section => 'hhh', :user_id => 2)

# puts crawler.listings.inspect