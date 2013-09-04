require 'calabash-android/operations'

module Screenful module Android
  module Interceptor
    def performAction(action, *arguments)
      if action =~ /press/ || action =~ /click/ || action =~ /touch/
        screenshot_embed :name => "intercept"
      end
      super
    end
  end
end end
