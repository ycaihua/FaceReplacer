//
//  UIImage+Crop.swift
//  FaceReplacer
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    
    func croppedImage(rectangle: CGRect) -> UIImage? {
        var cgImage:CGImageRef = CGImageCreateWithImageInRect(self.CGImage, rectangle)
        return UIImage(CGImage: cgImage)
    }
}