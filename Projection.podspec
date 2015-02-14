Pod::Spec.new do |s|

  s.name             = "Projection"
  s.version          = "0.0.1"

  s.author           = { "Mikey Lintz" => "mlintz@gmail.com" }
  s.social_media_url = "http://twitter.com/mikeylintz"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/mlintz/Projection"
  # TODO: add tag
  s.source       = { :git => "https://github.com/mlintz/Projection.git", :commit => "1079fb0bdf14c8053e35330bf411d546c2c59234" }
  s.summary      = "iOS library for laying out views using smart rectangles."
  # TODO: add description
  s.description  = <<-DESC
                   iOS library for laying out views using smart rectangles.
                   DESC

  s.platform     = :ios, "6.0"
  s.framework    = "UIKit"

  s.source_files  = "Projection/**/*.{h,m}"
  s.public_header_files = "Projection/*.h"  

end
