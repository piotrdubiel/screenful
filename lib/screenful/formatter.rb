require 'calabash/formatters/html'

module Screenful
  class Formatter < Calabash::Formatters::Html
    def initialize(step_mother, path, options)
      super
      @storyboard = ""
    end

    def before_features(features)
      @step_count = features.step_count

      @builder.head do
        @builder.meta('http-equiv' => 'Content-Type', :content => 'text/html;charset=utf-8')
        @builder.title 'Cucumber'
        inline_css
        inline_js
      end
      @builder << '<body>'
      @builder << "<!-- Step count #{@step_count}-->"
      @builder << '<div class="cucumber">'
      @builder.div(:id => 'cucumber-header') do
        @builder.div(:id => 'label') do
          @builder.h1('Cucumber Features')
        end
        @builder.div(:id => 'summary') do
          @builder.p('',:id => 'totals')
          @builder.p('',:id => 'duration')
          @builder.div(:id => 'expand-collapse') do
            @builder.p('Expand All', :id => 'expander')
            @builder.p('Collapse All', :id => 'collapser')
          end
        end
      end
    end

    def after_features(features)
      print_stats(features)
      @builder << '</div>'
      @builder << '</body>'
    end

    def embed_image(src, label)
      if _output_relative? && _relative_uri?(src)
        output_dir = Pathname.new(File.dirname(@io.path))
        src_path = Pathname.new(src)
        embed_relative_path = src_path.relative_path_from(output_dir)
        src = embed_relative_path.to_s
      end

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
      %{<span style="display: inline-block; margin-bottom: 140px; width:0; height:0; border-color: transparent transparent transparent #666; border-width: 20px; border-style: solid;"></span>}
    end
  end
end
