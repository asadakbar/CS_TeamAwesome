require "spec_helper"

describe Template do

  let(:test_template) { Template.new("Hey you've got a great place. Let's talk.") }

  before :each do
    File.read("db/schema.sql").split(";").each { |line| CraigslistCrawler.database.execute(line) }
  end

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

  context "#save" do
    it "should return the database id for the template" do
      test_template.save.should eq CraigslistCrawler.database.last_insert_row_id
    end
  end

  context ".from_db" do
    it "should create a template from the database" do
      template_id = test_template.save
      Template.from_db(template_id).text.should eq "Hey you've got a great place. Let's talk."
    end
  end

end