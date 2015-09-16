//
//  UIImage+FaceReplace.swift
//  FaceReplacer
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import Foundation
import CoreImage
import QuartzCore

typealias CoreImage = CIImage
typealias CoreDetector = CIDetector

extension UIImage {
    
    func recognizeAndSwapFaces() -> UIImage? {
        let faces = self.recognizeFaces(self)
        return self.swapFacesRandomly(faces!, onImage: self)
    }
    
    func recognizeFaces(inputImage: UIImage) -> [CIFaceFeature]? {
        let image:CoreImage = CoreImage(CGImage: inputImage.CGImage!)
        let context = CIContext(options: nil)
        
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector:CoreDetector = CoreDetector(ofType: CIDetectorTypeFace,
                                                 context: context,
                                                 options: detectorOptions)
        let featuresOptions = [CIDetectorImageOrientation: NSNumber(integer: self.convertUIImageOrientationToCI(inputImage.imageOrientation))]
        let features:[CIFaceFeature] = detector.featuresInImage(image, options: featuresOptions) as! [CIFaceFeature]
    
        print("Objects count = \(features.count)")
        
        return features
    }
    
    func swapFacesRandomly(faces: [CIFaceFeature], onImage sourceImage: UIImage) -> UIImage?{
        var facesCopy = faces
        var originalFaces = faces
        originalFaces.shuffle()
        
        var tempEditedImage: UIImage? = sourceImage
        var croppedRandomizedFaces = [UIImage]()
        
        for index in 0..<originalFaces.count {
            let originalFace:CIFaceFeature = originalFaces[index]
            let randomizedFace:CIFaceFeature = facesCopy[index]
            
            let tempImage = sourceImage.croppedImage(randomizedFace.bounds)!
            croppedRandomizedFaces.append(tempImage.scaleImage(tempImage, toSize: originalFace.bounds.size))
        }
        
        for index in 0..<originalFaces.count {
            let originalFace:CIFaceFeature = originalFaces[index]
            //let randomizedFace:CIFaceFeature = facesCopy[index]
            
            tempEditedImage = self.drawPiece(croppedRandomizedFaces[index],
                                             inRect: originalFace.bounds,
                                             onImage: tempEditedImage!)
        }
        
        return tempEditedImage
    }

    private func drawPiece(piece: UIImage, inRect newRect:CGRect, onImage sourceImage: UIImage) -> UIImage {
        let sourceImageRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)
        UIGraphicsBeginImageContextWithOptions(sourceImageRect.size, false, 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        sourceImage.drawInRect(sourceImageRect)
        piece.drawInRect(newRect)
        
        CGContextSetLineWidth(context, 10)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextAddRect(context, newRect)
        CGContextStrokePath(context)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    private func convertUIImageOrientationToCI(orientation: UIImageOrientation) -> Int
    {
        var exifOrientation: Int = 0
        
        switch (orientation) {
        case .Up:
            exifOrientation = 1;
            break;
        case .Down:
            exifOrientation = 3;
            break;
        case .Left:
            exifOrientation = 8;
            break;
        case .Right:
            exifOrientation = 6;
            break;
        case .UpMirrored:
            exifOrientation = 2;
            break;
        case .DownMirrored:
            exifOrientation = 4;
            break;
        case .LeftMirrored:
            exifOrientation = 5;
            break;
        case .RightMirrored:
            exifOrientation = 7;
            break;
        }
        
        return exifOrientation
    }
}







