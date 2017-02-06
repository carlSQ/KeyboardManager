
Pod::Spec.new do |s|
  s.name             = 'KeyboardManager'
  s.version          = '0.1.0'
  s.summary          = 'Keyboard Animation Manager'

  s.description      = <<-DESC
                        Keyboard Animation easy manager.
                       DESC

  s.homepage         = 'https://github.com/carlSQ/KeyboardManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiang.shen' => 'qiang..shen@ele.me' }
  s.source           = { :git => 'https://github.com/carlSQ/KeyboardManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'Classes/**/*'

end
