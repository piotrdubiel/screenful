begin
  require 'calabash-android/operations'
rescue LoadError
else
  require 'screenful/interceptors/android'

  Calabash::Android::Operations.module_eval { prepend Screenful::Android::Interceptor }
end

begin
  require 'calabash-cucumber/core'
rescue LoadError
else
  require "screenful/interceptors/ios" 
  Calabash::Cucumber::Core.module_eval { prepend Screenful::IOS::Interceptor }
end
