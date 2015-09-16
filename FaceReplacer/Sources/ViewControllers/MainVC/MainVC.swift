//
//  MainVC.swift
//  FaceReplacer
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import QuartzCore

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var swapFacesBarButton: UIBarButtonItem!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    
    // MARK: - Variables
    var imagePickerController:UIImagePickerController = UIImagePickerController()
    
    // MARK: - ViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)!
        self.imagePickerController.delegate = self
    }

    // MARK: - IBActions

    @IBAction func SwapFacesButtonPressed(sender: UIBarButtonItem) {
        if let photoImageViewsImage = self.photoImageView.image {
            sender.enabled = false
            self.cameraBarButton.enabled = false
            
            var processedImage: UIImage?
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidden = false
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                processedImage = photoImageViewsImage.recognizeAndSwapFaces()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    
                    if let resultImage = processedImage {
                        self.photoImageView.image = resultImage
                    }
                    else {
                        let alertView = UIAlertView(title: "Face recognition problem",
                                                    message: "Can't find faces and swap them. Please chose another photo",
                                                    delegate: nil,
                                                    cancelButtonTitle: "OK")
                        alertView.show()
                    }
                    sender.enabled = true
                    self.cameraBarButton.enabled = true
                })
            })
        }
        else {
            let alertView = UIAlertView(title: "Image is empty",
                                        message: "Please chose photo from library before swapping faces",
                                        delegate: nil,
                                        cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    @IBAction func CameraButtonPressed(sender: UIBarButtonItem) {
        presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage: UIImage? = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        if let libraryImage = originalImage {
            self.photoImageView.image = libraryImage
            
            
            
        }
        else {
            let alertView = UIAlertView(title: "Error",
                                        message: "Can't get image",
                                        delegate: nil,
                                        cancelButtonTitle: "OK")
            alertView.show()
        }
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        
    }
}







