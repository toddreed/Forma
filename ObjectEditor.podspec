# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "ObjectEditor"
  s.version      = "0.2.0"
  s.license      = { :type => 'None', :text => '© Reaction Software Inc., 2013' }
  s.summary      = "Provides a UI framework for an object editor (a.k.a. inspector)."
  s.author       = { "Todd Reed" => "todd.reed@reactionsoftware.com" }
  s.source       = { :git => "git@bitbucket.org:toddreed/object-editor.git", :tag => '0.2.0'}
  s.homepage     = 'http://www.reactionsoftware.com'
  s.license      = { :type => 'None' }
  s.platform     = :ios, '5.0'
  s.source_files = 'src/main/objc/**/*.{h,m}'
  s.exclude_files = 'src/main/objc/QManagedObjectToOneRelationshipViewController.{h,m}', 'src/main/objc/QRelationshipPropertyEditor.{h,m}'
  s.public_header_files = 'src/main/objc/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end
