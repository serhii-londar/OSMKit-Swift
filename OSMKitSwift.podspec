Pod::Spec.new do |spec|
  spec.name         = 'OSMKitSwift'
  spec.author       = 'Serhii Londar'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/serhii-londar/OSMKit-Swift'
  spec.version      = '0.1'
  spec.summary      = 'OpenStreetMap library for iOS and OS X'
  spec.source       = { :git => 'https://github.com/serhii-londar/OSMKit-Swift', :tag => spec.version }
  spec.requires_arc = true
  spec.platform     = :ios, "9.0"


  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |sp|
    sp.source_files = 'Source/{Model,Utilities,Parser}/*.swift'
  end

  spec.subspec 'API' do |sp|
    sp.dependency 'OSMKitSwift/Core'
    sp.source_files = 'Source/API/*.swift'
    sp.dependency 'Alamofire', '~> 3.1'
    sp.dependency 'AEXML', '~> 2.0'
  end
end
