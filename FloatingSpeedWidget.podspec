Pod::Spec.new do |s|
  s.name              = "FloatingSpeedWidget"
  s.version           = "0.1"
  s.summary           = "Driving speed widget"
  s.homepage          = "https://github.com/orxelm/FloatingSpeedWidget"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "Or Elmaliah" => "orxelm@gmail.com" }
  s.social_media_url  = "https://twitter.com/OrElm"
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/orxelm/FloatingSpeedWidget.git", :tag => s.version }
  s.source_files      = "Source/*.swift"
  s.dependency 		    "FormatterKit"
  s.requires_arc      = true
  s.framework         = "UIKit"
end