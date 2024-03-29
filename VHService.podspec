Pod::Spec.new do |spec|

  spec.name         = "VHService"
  spec.version      = "2.0.0"
  spec.summary      = "VHService is a simple HTTP networking library written in Swift."

  spec.homepage     = "https://github.com/vidalhara/VHService"

  spec.license      = "MIT"

  spec.author       = "Vidal HARA"
  spec.documentation_url = 'https://vidalhara.github.io/VHService/'
  
  spec.ios.deployment_target = '12.0'
  spec.libraries = 'Network'
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']

  spec.source       = { :git => "https://github.com/vidalhara/VHService.git", :tag => spec.version }
  
  spec.source_files = "Sources/**/*.swift"
  spec.frameworks = "UIKit"
end
