//
//  UIImage+Resize.swift
//
//  Created by Admin on 02.07.15.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
 
    func scaleImage(image:UIImage,  toSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0);
        
        let aspectRatioAwareSize = self.aspectRatioAwareSize(image.size, boxSize: toSize, useLetterBox: false)

        let leftMargin = (toSize.width - aspectRatioAwareSize.width) * 0.5
        let topMargin = (toSize.height - aspectRatioAwareSize.height) * 0.5
        
        image.drawInRect(CGRectMake(leftMargin, topMargin, aspectRatioAwareSize.width , aspectRatioAwareSize.height))
        let retVal = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return retVal
    }
    
    func aspectRatioAwareSize(imageSize: CGSize, boxSize: CGSize, useLetterBox: Bool) -> CGSize {
        // aspect ratio aware size
        // http://stackoverflow.com/a/6565988/8047
        let wi = imageSize.width
        let hi = imageSize.height
        let ws = boxSize.width
        let hs = boxSize.height
        
        let ri = wi/hi
        let rs = ws/hs
        
        let retVal : CGSize
        // use the else at your own risk: it seems to work, but I don't know
        // the math
        if (useLetterBox) {
            retVal = rs > ri ? CGSizeMake(wi * hs / hi, hs) : CGSizeMake(ws, hi * ws / wi)
        } else {
            retVal = rs < ri ? CGSizeMake(wi * hs / hi, hs) : CGSizeMake(ws, hi * ws / wi)
        }
        
        return retVal
    }
}

