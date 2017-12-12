# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DogsApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DogsApp
  pod "Kingfisher", "~> 4.5.0"
  pod 'SwiftIconFont'
  pod 'R.swift'
  pod "Reusable"
  pod "SnapKit"

  target 'DogsAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod "Quick"
    pod "Nimble"
    pod 'Nimble-Snapshots'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
