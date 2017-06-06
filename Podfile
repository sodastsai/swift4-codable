platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'Codable' do
  pod 'Alamofire', '~> 4.4'
end

post_install { |installer|
  installer.use_swift32 'Alamofire'
}

Pod::Installer.class_eval {
  def use_swift32(*swift32_packages)
    self.pods_project.targets.select { |target|
      swift32_packages.include? target.name
    }.each { |target|
      target.build_configurations.each { |build_conf|
        build_conf.build_settings['SWIFT_VERSION'] = 3
      }
    }
  end
}
