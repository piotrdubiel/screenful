require 'calabash-android/operations'
#require 'calabash-cucumber'

module ActionInterceptor
  def performAction(action, *arguments)
    if action =~ /press/ || action =~ /click/ || action =~ /touch/
      screenshot_embed :name => "intercept"
    end
    super
  end
end

operation_modules = [
  #Calabash::Cucumber::Core,
                     Calabash::Android::Operations]

operation_modules.each do |m|
  m.module_eval { prepend ActionInterceptor }
  World(m)
end
