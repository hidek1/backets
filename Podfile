# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target '多趣味のためのバケットリスト' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 多趣味のためのバケットリスト
  pod 'Hue'
  pod 'RealmSwift'
  post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
  target '多趣味のためのバケットリストTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target '多趣味のためのバケットリストUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
