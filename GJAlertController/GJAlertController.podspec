

Pod::Spec.new do |s|


  s.name         = "GJAlertController"
  s.version      = "1.0.0"
  s.summary      = "可以任意在代码中使用UIAlertController，而不用担心低版本兼容的问题"

  
  s.description  = "在低版本中动态加入GJAlertController，内部用alertView实现，但是在使用的时候，不用关心alertView，也不用担心版本兼容问题，直接用UIAlertController。 Just do it!"

  #s.homepage     = "http://EXAMPLE/GJAlertController"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "erlianhzi" => "guoxiaoliang850417@163.com" }
  # Or just: s.author    = "erlianhzi"
  # s.authors            = { "erlianhzi" => "guoxiaoliang850417@163.com" }
  # s.social_media_url   = "http://twitter.com/erlianhzi"


  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  s.source_files  = "GJAlertController/*.{h,m}"


end
