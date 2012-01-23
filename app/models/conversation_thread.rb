require "rubygems"
require "net/http"
require "uri"
require "nokogiri"

class ConversationThread < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  attr_accessible :conversation_id, :user_id, :content

  def chatbot_reply(conversation_id, content)
    uri = URI.parse("http://www.pandorabots.com/pandora/talk-xml")
    bot_id = "a6962efc2e34d0a3"
    response = Net::HTTP.post_form(uri, {"botid" => bot_id, "input" => content, "custid" => conversation_id })
    xml_doc  = Nokogiri::XML(response.body)
    bot_reply = xml_doc.xpath("//result//that").inner_html
    return bot_reply
  end

end
