require "spec_helper"

describe Template do

  let(:test_template) do
    user = User.new("test@email.com", "password")
    Template.new("Hey you have got a great place. We should talk.", user)
  end

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
      test_template.text.should eq("Hey you have got a great place. We should talk.")
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
      user = User.new("test@email.com", "password")
      user.save
      Template.from_db(user).text.should eq "Hey you have got a great place. We should talk."
    end
  end

  context "#id" do
    it "should return the database id of the template" do
      test_template.save
      test_template.id.should eq 1
    end
  end

end