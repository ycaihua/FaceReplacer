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
        var faces = self.recognizeFaces(self)
        return self.swapFacesRandomly(faces!, onImage: self)
    }
    
    func recognizeFaces(inputImage: UIImage) -> [CIFaceFeature]? {
        var image:CoreImage = CoreImage(CGImage: inputImage.CGImage)
        var options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let context = CIContext(options:[kCIContextUseSoftwareRenderer : true])
        
        var detector:CoreDetector = CoreDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        var features:[CIFaceFeature] = detector.featuresInImage(image) as! [CIFaceFeature]
    
        println("Objects count = \(features.count)")
        
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
            
            var tempImage = sourceImage.croppedImage(randomizedFace.bounds)!
            croppedRandomizedFaces.append(tempImage.scaleImage(tempImage, toSize: originalFace.bounds.size))
        }
        
        for index in 0..<originalFaces.count {
            let originalFace:CIFaceFeature = originalFaces[index]
            let randomizedFace:CIFaceFeature = facesCopy[index]
            
            tempEditedImage = self.drawPiece(croppedRandomizedFaces[index],
                                             inRect: originalFace.bounds,
                                             onImage: tempEditedImage!)
        }
        
        return tempEditedImage
    }

    func drawPiece(piece: UIImage, inRect newRect:CGRect, onImage sourceImage: UIImage) -> UIImage {
        let sourceImageRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)
        UIGraphicsBeginImageContextWithOptions(sourceImageRect.size, false, 1.0)
        
        var context = UIGraphicsGetCurrentContext()
        sourceImage.drawInRect(sourceImageRect)
        piece.drawInRect(newRect)
        
        CGContextSetLineWidth(context, 10)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextAddRect(context, newRect)
        CGContextStrokePath(context)
        
        var resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}







