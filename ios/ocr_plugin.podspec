#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'ocr_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'


  s.ios.deployment_target = '8.0'

  s.subspec 'AipBase' do |b|
    b.vendored_frameworks ='Classes/AipBase.framework'
  end
  
  s.subspec 'AipOcrSdk' do |s|
    s.vendored_frameworks ='Classes/AipOcrSdk.framework'
  end
  
  s.subspec 'IdcardQuality' do |i|
    i.vendored_frameworks ='Classes/IdcardQuality.framework'
  end
end

