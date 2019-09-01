platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
    pod 'RxCocoa'
    pod 'RxSwift'

end

target 'LandmarkRemark' do
  	shared_pods
    pod 'Firebase/Core'
    pod 'Firebase/Database'

end

target 'LandmarkRemarkTests' do
	shared_pods

	pod 'Firebase'
	pod 'RxTest'

end
