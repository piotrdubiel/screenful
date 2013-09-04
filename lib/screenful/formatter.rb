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
      @storyboard << %{
        <span style="display: inline-block; margin-right: 10px;">
          <img id="#{id}" style="height: 300px; display: block;" src="#{src}">
          <h2 style="text-align: right;">#{@img_id}</h2>
        </span>
      }
      @img_description = "<span>[see image #{@img_id}]</span>"
    end

    def after_step(step)
      if @img_description
        @builder << @img_description
        @img_description = nil
      end
      super
    end

    def after_steps(steps)
      super
      @builder.div(:class => 'embed') do |pre|
        pre << @storyboard
      end
      @storyboard = ""
    end

    private
    def image_separator
      %{<span style="display: inline-block; margin-bottom: 130px; width:0; height:0; border-color: transparent transparent transparent #666; border-width: 20px; border-style: solid;"></span>}
    end
  end
end
