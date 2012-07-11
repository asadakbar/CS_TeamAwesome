require 'rspec'
require_relative 'template'

include CraigslistCrawler

describe Template do

  let(:test_template) { Template.new("Hey you've got a great place. Let's talk.") }

  context "#new" do
    it "initializes as a new template" do
      test_template.should be_an_instance_of Template
    end
  end

  context "#text" do
    it "returns the text of the message template" do
      test_template.text.should eq("Hey you've got a great place. Let's talk.")
    end
  end

  context "#text=" do
    it "changes the text of the template" do
      test_template.text= "This is a great new message."
      test_template.text.should eq("This is a great new message.")
    end
  end

end
