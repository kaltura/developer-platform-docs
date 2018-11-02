gem 'onebox', '=1.5.31'
require "onebox"


module Jekyll
  class OneboxP < Liquid::Tag
    def initialize(tag_name, text, tokens)
       super
       @text = text
    end
    
    def render(context)
      # pipe param through liquid to make additional replacements possible
      url = Liquid::Template.parse(@text).render context
      preview = Onebox.preview(url.strip) 
	print "ahhh" + "#{preview}"
      "#{preview}"

    end
  end
end

Liquid::Template.register_tag('onebox', Jekyll::OneboxP)
