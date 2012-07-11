module CraigslistCrawler
  class Template
    attr_accessor :text
    def initialize(text)
      @text = text
    end

    def save
      CraigslistCrawler.database.execute("INSERT INTO message_templates (text) VALUES (:text)", :text => @text)
      CraigslistCrawler.database.last_insert_row_id
    end

    def self.from_db(template_id)
      template_array = CraigslistCrawler.database.execute("SELECT text FROM message_templates WHERE id = #{template_id}")
      Template.new(template_array[0][0])
    end
  end
end