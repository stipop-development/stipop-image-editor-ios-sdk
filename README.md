![Cover image](https://user-images.githubusercontent.com/30883319/139041228-f88b6e2f-4523-4d56-913e-927956e88dc6.png)

# Stipop Image Editor SDK for iOS

![Release](https://img.shields.io/github/v/release/stipop-development/stipop-image-editor-ios-sdk?sort=semver&style=flat&label=release)
![Beta](https://img.shields.io/github/v/release/stipop-development/stipop-image-editor-ios-sdk?include_prereleases&sort=semver&style=flat&label=beta)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-green.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-green.svg?style=flat)](https://cocoapods.org/pods/Stipop)

Stipop Image Editor SDK provides over 150,000 .png and .gif stickers that can be easily integrated into mobile app. Bring fun to your mobile app with stickers loved by millions of users worldwide.

## Requirements

- Swift 5.4+
- XCode 12.5+
- iOS 11.0+

## Getting started

- Check [Stipop Docs](https://docs.stipop.io/en/sdk/ios/get-started/quick-start) for the comprehensive guide.

- Sign up to [Stipop Dashboard](https://dashboard.stipop.io/create-application) to download StipopImageEditor.plist file.

## Try demo(for XCode 13.0+)

1. Download(or Clone) Demo App
   (SPM or Cocoapods Adjustment is not necessary)

```bash
git clone https://github.com/stipop-development/stipop-image-editor-ios-sdk
```

2. Add StipopImageEditor.plist file into the project

3. Run demo app


## Including in your project

### Swift Package Manager

#### By XCode

Go to File > Swift Packages > Add Package Dependency...
Enter `https://github.com/stipop-development/stipop-image-editor-ios-sdk`. Then select a version you want to use.

#### By Package.swift

If you have a Swift Package, add dependency into Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/stipop-development/stipop-image-editor-ios-sdk.git", .upToNextMajor(from: "0.0.2"))
]
```

### Cocoapods

Copy & Paste below into `Podfile`. Then, run `pod install`.

```ruby
pod 'StipopImageEditorUIKit', '0.0.2'
```


How do I use StipopImageEditor SDK?
-------------------

1. Add StipopImageEditor.plist file into the project.
2. Import 'StipopImageEditor' and Use 'SEStipopImageEditor.showEditor()' method when image editing is needed.
```swift
import UIKit
import StipopImageEditor

class MainView: UIView {
   ...
}

extension MainView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  ...
    func editImage(_ image: UIImage) {
        guard let owningController = self.getOwningViewController() else { return }
        
        /**
         * You can show StipopImageEditor by using this method.
         * @params
         * _ controller: controller that shows ImageEditor.
         * delegate: set delegate which can observe editor's working.
         * fileName: You can set StipopImageEditor.plist's fileName.    (defValue: StipopImageEditor)
         * image: the image to edit.
         * userId: if you want, you can set user's id    (defValue: -1)
         */
        SEStipopImageEditor.showEditor(owningController,
                                       delegate: self, image: image)
    }
}
```

3. With (process 2), implement 'SEDelegate'.
```swift
import UIKit
import StipopImageEditor

class MainView: UIView {
   ...
}

extension MainView: SEDelegate {
    
    /**
     * When editing is canceled, this method is called.
     */
    func editorCanceled() {
        print("editorCanceled")
    }
    
    /**
     * When editing is finished, this method is called.
     * @params
     * image: editing finished image.
     */
    func editorFinished(image: UIImage) {
        print("editorFinished")
        self.imageView.image = image
    }
}
```

4. If you use 'SAuth', additionally imeplement 'httpError()' method.
```swift
import UIKit
import StipopImageEditor

class MainView: UIView {

 let semaphore = DispatchSemaphore(value: 1)
   ...
}

extension MainView: SEDelegate {
    
    /**
     * When editing is canceled, this method is called.
     */
    func editorCanceled() {
        print("editorCanceled")
    }
    
    /**
     * When editing is finished, this method is called.
     * @params
     * image: editing finished image.
     */
    func editorFinished(image: UIImage) {
        print("editorFinished")
        self.imageView.image = image
    }
    
    /**
     * If you use SAuth, additionally implement this method.
     * when this method is called, refresh AccessToken and reRequest with 'apiEnum' & 'properties'.
     * @params
     * apiEnum: error occured api type.
     * error: error info.
     * properties: dictionary that contains data for recall api.
     */
    func httpError(apiEnum: SEAPIEnum, error: SEError, properties: Dictionary<String, Any>?) {
        print("⚡️Stipop: HTTP Error => \(apiEnum)")
        DispatchQueue.global().async {
            self.semaphore.wait()
            let userId = SEStipopImageEditor.getUser()?.userID ?? SEStipopImageEditor.getCommonUser().userID
            DemoSAuthManager.getAccessTokenIfOverExpiryTime(userId: userId,
                                                            completion: { accessToken in
                self.semaphore.signal()
                guard let accessToken = accessToken else { return }
                SEStipopImageEditor.setAccessToken(accessToken: accessToken)
                SEAuthManager.reRequest(api: apiEnum, properties: properties)
            })
        }
    }
}
```

## Contact us

- For more information, visit [Stipop Docs](https://docs.stipop.io/en/sdk/ios/get-started/quick-start).
- Email us at tech-support@stipop.io if you need any help.
