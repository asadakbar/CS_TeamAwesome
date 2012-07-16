require_relative "helpers"

module CraigslistCrawler
  class Template
    attr_accessor :text, :id

    def initialize(text, user_id)
      @text = text
      @user_id = user_id
    end

    def save
      CraigslistCrawler.database.execute("INSERT INTO message_templates (text, user_id)
                                          VALUES ('#{@text}', '#{@user_id}')")
      @id = CraigslistCrawler.database.last_insert_row_id
    end

    def self.from_db(user)
      template_array = CraigslistCrawler.database.execute("SELECT text
                                                           FROM message_templates
                                                           WHERE id = #{user.id}")
      Template.new(template_array[0][0], user)
    end
  end
end