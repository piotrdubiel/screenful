require 'cucumber/formatter/html'

module Screenful
  class Formatter < Cucumber::Formatter::Html
    #include Calabash::Cucumber::Core


    def initialize(step_mother, path, options)
      super
      @storyboard = ""
    end

    def embed_image(src, label)
      id = "img_#{@img_id}"
      @img_id += 1
      if @storyboard != ""
        @storyboard << image_separator 
      end
      @storyboard << %{<img id="#{id}" style="margin-right: 30px; height: 400px; display: inline-block;" src="#{src}">}    else
    end

    def after_steps(steps)
      super
      @builder.span(:class => 'embed') do |pre|
        pre << @storyboard
      end
      @storyboard = ""
    end

    private
    def image_separator
      %{<span style="display: inline-block; margin-bottom: 200px; width:0; height:0; border-color: transparent transparent transparent #666; border-width: 15px; border-style: solid;"></span>}
    end
  end
end
