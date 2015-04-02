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
  
  s.dependency 'Symbolset', '~> 0.1'
  s.dependency 'UITheme', '~> 0.2'

  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |ss|
    s.frameworks = 'Foundation', 'UIKit'
    s.source_files = 'src/main/objc/Core/*.{h,m}', 'src/main/objc/PropertyEditors/*.{h,m}'
    s.public_header_files = 'src/main/objc/Core/*.h', 'src/main/objc/PropertyEditors/*.h'
  end
  
  s.subspec 'CoreData' do |ss|
    s.frameworks = 'CoreData'
    s.source_files = 'src/main/objc/CoreData/*.{h,m}'
    s.public_header_files = 'src/main/objc/CoreData/*.h'
  end

end
