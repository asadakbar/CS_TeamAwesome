require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require_relative 'listing'

module CraigslistCrawler

  class Crawler

    def initialize(options)
      @location = options.fetch(:location) { raise ArgumentError.new("You need to pass in a location") } # eg sfbay
      @section = options.fetch(:section) { raise ArgumentError.new("You need to pass in a section") } # eg sfc
      @query = options.fetch(:query) { nil }
      @bedrooms = options.fetch(:bedrooms) { nil } # integer
      @cat = options.fetch(:cat) { false } # cat is addTwo, passing in true or false
      @dog = options.fetch(:dog) { false } # dog is addThree, passing in true or false
      @min_price = options.fetch(:min_price) { nil } # minAsk
      @max_price = options.fetch(:max_price) { nil } #maxAsk
      @sub_region = options.fetch(:sub_region) { nil } # sfc, sby, eby, pen, nby, scz, goes right after craigslist.org
    end

    def url
      "http://#{@location}.craigslist.org/search/#{@section}#{"/#{@sub_region}" unless @sub_region.nil?}"\
        "?query=#{@query}&srchType=A&minAsk=#{@min_price}&maxAsk=#{@max_price}&bedrooms=#{@bedrooms}"\
        "&addTwo=#{'purrr' if @cat == true}&addThree=#{'wooof' if @dog == true}"
    end

    def listing_urls
      doc = Nokogiri::HTML(open(url))
      doc.css('p.row').collect {|url| url.xpath('.//a')[0].attributes['href'].value}
    end

    def listings
      listings = listing_urls.collect do |listing_url|
        doc = Nokogiri::HTML(open(listing_url))
        next if listing_details(doc).nil?
        Listing.new(listing_details(doc))
      end.compact!
      listings
    end

    private
    def listing_details(doc)
      full_email = doc.css('span.returnemail').collect {|email| email.children[1].attributes['href'].value unless email.children[1].nil?} [0] #can be nil or empty
      return nil if full_email.nil?
      email = full_email.match(/^mailto:(.*)\?/)[1]
      title = CGI.escape(doc.css('title').collect {|title| title.children.text } [0].strip)
      craigslist_id = doc.css('span.postingidtext').collect { |post| post.children.text.gsub('PostingID: ', '') }[0].to_i
      {:title => title, :email => email, :craigslist_id => craigslist_id}
    end

  end
end