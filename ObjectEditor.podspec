# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "ObjectEditor"
  s.version      = "0.3.0"
  s.license      = { :type => 'None', :text => '© Reaction Software Inc., 2013' }
  s.summary      = "Provides a UI framework for an object editor (a.k.a. inspector)."
  s.author       = { "Todd Reed" => "todd.reed@reactionsoftware.com" }
  s.source       = { :git => "git@bitbucket.org:toddreed/object-editor.git", :tag => "#{s.version}"}
  s.homepage     = 'http://www.reactionsoftware.com'
  s.license      = { :type => 'None' }
  s.platform     = :ios, '5.0'
  s.source_files = 'src/main/objc/**/*.{h,m}', 'src/library/objc/autocomplete/*.{h,m}'
  s.exclude_files = 'src/main/objc/QManagedObjectToOneRelationshipViewController.{h,m}', 'src/main/objc/QRelationshipPropertyEditor.{h,m}'
  s.public_header_files = 'src/main/objc/**/*.h', 'src/library/objc/autocomplete/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.dependency 'Symbolset', '~> 0.1'
  s.dependency 'TRUITheme', '~> 0.1'
end
