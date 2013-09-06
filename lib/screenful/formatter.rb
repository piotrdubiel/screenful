require 'erb'
require 'cucumber/formatter/io'

module Screenful
  class Formatter
    include Cucumber::Formatter::Io

    def initialize(runtime, path, options)
      @runtime = runtime
      @htmldir = ensure_dir(path, "Screenful")
      @img_id = 0
      @id = ENV["DEVICE_ID"]
    end

    def before_features(features)
      collect_subresults
      copy_template
    end

    def after_features(features)
      @subresults << render_subresult
    end

    private

    def collect_subresults
      @subresults = Dir.glob(@htmldir+'/result-*.html')
    end

    def copy_template
      filename = File.dirname(__FILE__) + '/formatter/index.html.erb'
      FileUtils.cp(filename, @htmldir)
    end

    def render_subresult
      subresult_path = File.join(@htmldir, "result-#{@id}.html")
      subresult = SubResult.new @id, @runtime
      subresult.render(File.dirname(__FILE__) + '/formatter/result.html.erb', subresult_path)
      FileUtils.cp(File.dirname(__FILE__) + '/formatter/bootstrap.css', @htmldir)
      subresult_path
    end

    def render_result
      result_path = File.join(@htmldir, "index.html")
      summary = Summary.new(@subresults.map { |s| File.read(s) })
      summary.render(File.dirname(__FILE__) + '/formatter/index.html.erb', result_path)
      FileUtils.cp(File.dirname(__FILE__) + '/formatter/bootstrap.css', @htmldir)
      result_path
    end

    class Result
      def render(template, filename)
        result = ERB.new(File.read(template)).result(binding)
        File.open(filename, 'w') do |file|
          file << result
        end
      end
    end

    class SubResult < Result
      attr_reader :passed
      attr_reader :skipped
      attr_reader :failed
      attr_reader :total

      def initialize(id, runtime)
        @device_name = "Device #{id}"
        @total = runtime.scenarios.length

        symbols = [:passed, :skipped, :failed]

        metaclass = class << self; self; end
        symbols.map do |status|
          instance_variable_set("@#{status}", runtime.scenarios(status).length)
          metaclass.send(:define_method, status.to_s + "_percentage") do
            instance_variable_get("@#{status}").to_f * 100 / @total 
          end
        end

        @scenarios = Hash[
          *runtime.scenarios.map do |scenario|
            status = case scenario.status
                     when :passed then "success"
                     when :failed then "error"
                     when :skipped then "info"
                     else ""
                     end
            [scenario.name, status]
          end.flatten
        ]
      end
    end

    class Summary < Result
      attr_reader :results

      def initialize(results)
        @results = results
      end
    end
  end
end
