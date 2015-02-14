Pod::Spec.new do |s|

  s.name             = "Projection"
  s.version          = "0.0.1"

  s.author           = { "Mikey Lintz" => "mlintz@gmail.com" }
  s.social_media_url = "http://twitter.com/mikeylintz"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/mlintz/Projection"
  # TODO: add tag
  s.source       = { :git => "https://github.com/mlintz/Projection.git",
                     :tag => "v#{spec.version}" }
  s.summary      = "iOS library for laying out views using smart rectangles."
  # TODO: add description
  s.description  = <<-DESC
                   An iOS layout library as an alternative to Autolayout.

                   Frames are defined incrementally using smart rectangles which can infer new values based on what's been previously set.
                   DESC

  s.platform     = :ios, "6.0"
  s.framework    = "UIKit"

  s.source_files  = "Projection/**/*.{h,m}"
  s.public_header_files = "Projection/*.h"  

end
