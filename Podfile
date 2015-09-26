platform :ios, '8.0'

source 'git@bitbucket.org:reactionsoftware/cocoapods-podspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target :demo do
  link_with 'Demo'
  pod 'ObjectEditor', :path => './'
end

target :lib do
  link_with 'Object Editor'
  podspec :name => 'ObjectEditor'
end

