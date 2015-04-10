Pod::Spec.new do |s|
  s.name         = "ObjectEditor"
  s.version      = "1.0.0-alpha"
  s.summary      = "Provides a UI framework for an object editor (a.k.a. inspector)."
  s.homepage     = 'https://bitbucket.org/reactionsoftware/object-editor'
  s.author       = { "Todd Reed" => "todd.reed@reactionsoftware.com" }
  s.license      = { :type => 'Proprietary' }
  s.source       = { :git => "git@bitbucket.org:reactionsoftware/object-editor.git", :tag => s.version.to_s}
  s.platform     = :ios, '7.0'
  s.header_dir   = 'ObjectEditor'
  s.header_mappings_dir = 'src/main/objc'
  
  s.dependency 'Symbolset', '~> 1.0'
  s.dependency 'UITheme', '~> 1.2'

  s.subspec 'Core' do |core|
    core.frameworks = 'Foundation', 'UIKit'
    core.source_files = 'src/main/objc/Core/*.{h,m}', 'src/main/objc/PropertyEditors/*.{h,m}'
    core.public_header_files = 'src/main/objc/Core/*.h', 'src/main/objc/PropertyEditors/*.h'
  end
  
  s.subspec 'CoreData' do |coredata|
    coredata.frameworks = 'CoreData'
    coredata.source_files = 'src/main/objc/CoreData/*.{h,m}'
    coredata.public_header_files = 'src/main/objc/CoreData/*.h'
    
    coredata.dependency 'ObjectEditor/Core'
  end

end
