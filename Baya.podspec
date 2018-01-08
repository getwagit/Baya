Pod::Spec.new do |s|
  s.name         = "Baya"
  s.version      = "0.2.0"
  s.summary      = "Baya"

  s.homepage     = "https://github.com/getwagit/Baya.git"
  s.license      = "MIT"
  
  s.author             = { 
    "Markus Riegel" => "markus@getwagit.com",
    "Joachim Fröstl" => "hello@jogga.co"
  }
  
  s.platform     = :ios, "9.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.source       = { :git => "https://github.com/getwagit/Baya.git", :tag => "#{s.version}" }
  s.source_files  = "Baya/**/*.{swift,h,m}"
end