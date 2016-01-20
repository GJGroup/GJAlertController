

Pod::Spec.new do |s|

  s.platform     = :ios, "5.0"
  
  s.name         = "GJAlertController"
  s.version      = "1.0.0"
  s.summary      = "可以任意在代码中使用UIAlertController，而不用担心低版本兼容的问题"
  s.description  = "在低版本中动态加入GJAlertController，内部用alertView实现，但是在使用的时候，不用关心alertView，也不用担心版本兼容问题，直接用UIAlertController。 Just do it!"
  s.homepage     = "https://github.com/GJGroup/GJAlertController"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "erlianhzi" => "guoxiaoliang850417@163.com" }

  s.source       = { :git => "https://github.com/GJGroup/GJAlertController.git", :tag => "1.0.0" }
  s.source_files = "GJAlertController/GJAlertController/*.{h,m}"


end
