//
//  ViewController.swift
//  YPImagePickerExample
//
//  Created by Sacha DSO on 17/03/2017.
//  Copyright © 2017 Octopepper. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.frame = view.frame
        
        button.setTitle("Pick", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.addSubview(button)
        button.center = view.center
        button.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    }
    
    @objc
    func showPicker() {
        
        // Configuration
        var config = YPImagePickerConfiguration()
        
        // Uncomment and play around with the configuration 👨‍🔬 🚀

//        /// Set this to true if you want to force the  library output to be a squared image. Defaults to false
//        config.onlySquareFromLibrary = true
//
//        /// Set this to true if you want to force the camera output to be a squared image. Defaults to true
//        config.onlySquareImagesFromCamera = false
//
//        /// Ex: cappedTo:1024 will make sure images from the library will be
//        /// resized to fit in a 1024x1024 box. Defaults to original image size.
//        config.libraryTargetImageSize = .cappedTo(size: 1024)
//
//        /// Enables videos within the library. Defaults to false
            config.showsVideoInLibrary = true
//
//        /// Enables selecting the front camera by default, useful for avatars. Defaults to false
//        config.usesFrontCamera = true
//
//        /// Adds a Filter step in the photo taking process. Defaults to true
//        config.showsFilters = false
        
        /// Manage filters by yourself
//        config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
//                          YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.filters.remove(at: 1)
        config.filters.insert(YPFilterDescriptor(name: "Blur", filterName: "CIBoxBlur"), at: 1)
//
//        /// Enables you to opt out from saving new (or old but filtered) images to the
//        /// user's photo library. Defaults to true.
//        config.shouldSaveNewPicturesToAlbum = false
//
//        /// Choose the videoCompression.  Defaults to AVAssetExportPresetHighestQuality
//        config.videoCompression = AVAssetExportPreset640x480
//
//        /// Defines the name of the album when saving pictures in the user's photo library.
//        /// In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName"
//        config.albumName = "ThisIsMyAlbum"
//
//        /// Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
//        /// Default value is `.photo`
        config.startOnScreen = .library
//
//        /// Defines which screens are shown at launch, and their order.
//        /// Default value is `[.library, .photo]`
        config.screens = [.library, .photo, .video]

//
//        /// Defines the time limit for recording videos.
//        /// Default is 30 seconds.
//        config.videoRecordingTimeLimit = 5.0
//
//        /// Defines the time limit for videos from the library.
//        /// Defaults to 60 seconds.
        config.videoFromLibraryTimeLimit = 500.0
//
//        /// Adds a Crop step in the photo taking process, after filters. Defaults to .none
        config.showsCrop = .rectangle(ratio: (16/9))
//
//        /// Defines the overlay view for the camera.
//        /// Defaults to UIView().
//        let overlayView = UIView()
//        overlayView.backgroundColor = .red
//        overlayView.alpha = 0.3
//        config.overlayView = overlayView
        
        /// Customize wordings
        config.wordings.libraryTitle = "Gallery"
        
        /// Defines if the status bar should be hidden when showing the picker. Default is true
        config.hidesStatusBar = false
        
        config.maxNumberOfItems = 5
        
        // Here we use a per picker configuration. Configuration is always shared.
        // That means than when you create one picker with configuration, than you can create other picker with just
        // let picker = YPImagePicker() and the configuration will be the same as the first picker.
        let picker = YPImagePicker(configuration: config)
        
        /// Change configuration directly
//        YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"
        
        // Single Photo implementation.
        picker.didFinishPicking { items, cancelled in
            self.imageView.image = items.singlePhoto?.image
            picker.dismiss(animated: true, completion: nil)
        }
        
        // Single Video implementation.
        picker.didFinishPicking { items, cancelled in
            self.imageView.image = items.singleVideo?.thumbnail
            picker.dismiss(animated: true, completion: nil)
        }
        
        // Multiple implementation
        picker.didFinishPicking { items, cancelled in
            _ = items.map { print("🧀 \($0)") }
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.imageView.image = photo.image
                case .video(let video):
                    self.imageView.image = video.thumbnail
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
}

