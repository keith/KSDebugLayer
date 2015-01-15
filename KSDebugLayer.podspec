Pod::Spec.new do |s|
  s.name                  = "KSDebugLayer"
  s.version               = "1.0.0"
  s.summary               = "A CALayer subclass for debugging animations"
  s.homepage              = "https://github.com/Keithbsmiley/KSDebugLayer"
  s.license               = "MIT"
  s.author                = { "Keith Smiley" => "keithbsmiley@gmail.com" }
  s.social_media_url      = "http://twitter.com/SmileyKeith"
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source                = { git: "https://github.com/Keithbsmiley/KSDebugLayer.git",
                              tag: "v#{ s.version }" }
  s.source_files          = "*.{h,m}"
  s.framework             = "QuartzCore"
  s.requires_arc          = true
end
