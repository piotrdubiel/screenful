module ActionInterceptor
    def touch(uiquery, options = {})
        filename = "tests/images/intercepts/touch" + Time.now.to_i.to_s + ".png"
        highlight_element( selector, filename, 'blue' )
        sleep 1
        super(uiquery, options)
    end
end

include Calabash::Cucumber::Core

Calabash::Cucumber::Core.module_eval { include ActionInterceptor }
