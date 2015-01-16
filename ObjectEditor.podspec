Pod::Spec.new do |s|
  s.name         = "ObjectEditor"
  s.version      = "0.5.1"
  s.summary      = "Provides a UI framework for an object editor (a.k.a. inspector)."
  s.homepage     = 'https://bitbucket.org/reactionsoftware/object-editor'
  s.author       = { "Todd Reed" => "todd.reed@reactionsoftware.com" }
  s.license      = { :type => 'Proprietary' }
  s.source       = { :git => "git@bitbucket.org:reactionsoftware/object-editor.git", :tag => s.version.to_s}
  s.platform     = :ios, '7.0'
  s.source_files = 'src/main/objc/**/*.{h,m}', 'src/library/objc/autocomplete/*.{h,m}'
  s.exclude_files = 'src/main/objc/QManagedObjectToOneRelationshipViewController.{h,m}', 'src/main/objc/QRelationshipPropertyEditor.{h,m}'
  s.public_header_files = 'src/main/objc/**/*.h', 'src/library/objc/autocomplete/*.h'
  s.header_dir = 'ObjectEditor'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.dependency 'Symbolset', '~> 0.1'
  s.dependency 'UITheme', '~> 0.2'
end
