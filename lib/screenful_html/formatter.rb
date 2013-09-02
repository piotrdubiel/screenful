require 'cucumber/formatter/html'
require 'calabash-cucumber/core'

module ScreenfulHtml
  class Formatter < Cucumber::Formatter::Html
    include Calabash::Cucumber::Core

    def initialize(step_mother, path, options)
      @io = ensure_file(path, "html")
      @step_mother = step_mother
      @options = options
      @buffer = {}
      @builder = create_builder(@io)
      @feature_number = 0
      @scenario_number = 0
      @step_number = 0
      @header_red = nil
      @delayed_messages = []
      @img_id = 0

      #create dirs if necessary
      img_dir = "#{File.dirname(path)}/images"
      FileUtils.mkdir_p ["#{img_dir}/intercepts", "#{img_dir}/fails"]
    end

    def before_features(features)
      #clean screenshots
      FileUtils.rm Dir["tests/images/**/*.png"]
      super
    end

    #def after_step(step)
    #    @builder << '<div>'
    #    screens = Dir["tests/images/intercepts/*.png"]
    #    screens.each {|s|
    #        filename = "images/"+File.basename(s)
    #        FileUtils.mv s, 'tests/images/'
    #        @builder << "<a href=\"#{filename}\"><img width=\"180\" src=\"#{filename}\"/></a>"
    #    }
    #    @builder << '</div>'
    #
    #    super
    #end

    def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
      return if @hide_this_step
      # print snippet for undefined steps
      if status == :undefined
        step_multiline_class = @step.multiline_arg ? @step.multiline_arg.class : nil
        @builder.pre do |pre|
          pre << @step_mother.snippet_text(@step.actual_keyword,step_match.instance_variable_get("@name") || '',step_multiline_class)
        end
      end

      if !exception
        screens = Dir["tests/images/intercepts/*.png"]
        screens.each {|s|
          filename = "images/"+File.basename(s)
          FileUtils.mv s, 'tests/images/'
          @builder << "<a href=\"#{filename}\"><img width=\"180\" src=\"#{filename}\"/></a>"
        }
      end

      @builder << '</li>'
      print_messages
    end

    def build_exception_detail(exception)
      super
      image = extra_screenshot_content
      @builder << image unless image == ""
    end

    def extra_screenshot_content
      begin
        url = "images/fails/fail" + Time.now.to_i.to_s + ".png" 
        filename = "tests/" + url
        #frankly_screenshot(filename)
        highlight_element( nil, filename, 'red' )
        "<a href=\"#{url}\"><img width=\"180\" src=\"#{url}\"/></a>"
      rescue
        ""
      end
    end
  end
end
