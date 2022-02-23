Pod::Spec.new do |s|
  s.name         = "Forma"
  s.version      = "2.0.0"
  s.summary      = "Provides a classes for implementing forms, settings, and inspectors."
  s.homepage     = 'https://github.com/toddreed/Forma'
  s.author       = { "Todd Reed" => "todd.reed@reactionsoftware.com" }
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.source       = { :git => "https://github.com/toddreed/Forma.git", :tag => s.version.to_s}
  s.platform     = :ios, '14.0'
  s.header_dir   = 'Forma'
  s.header_mappings_dir = 'src/main/objc'
  s.resource_bundle = { 'Forma' => ['src/main/resources/**/*.xcassets', 'src/main/objc/**/*.xib'] }

  s.subspec 'Core' do |core|
    core.frameworks = 'Foundation', 'UIKit'
    core.source_files = 'src/main/objc/Core/*.{h,m}', 'src/main/objc/FormItems/*.{h,m}', 'src/main/objc/TableViewCells/*.{h,m}'
    core.public_header_files = 'src/main/objc/Core/*.h', 'src/main/objc/FormItems/*.h', 'src/main/objc/TableViewCells/*.h'
  end

  s.subspec 'CoreData' do |coredata|
    coredata.frameworks = 'CoreData'
    coredata.source_files = 'src/main/objc/CoreData/*.{h,m}'
    coredata.public_header_files = 'src/main/objc/CoreData/*.h'

    coredata.dependency 'Forma/Core'
  end

end
