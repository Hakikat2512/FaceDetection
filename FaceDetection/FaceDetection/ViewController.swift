//
//  ViewController.swift
//  FaceDetection
//
//  Created by Mobile on 21/06/17.
//  Copyright © 2017 Hakikat Singh. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var personPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personPic.image = UIImage(named: "smile")
        detect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- DETECTION FUNCTION 
    
    
    func detect() {
        
        guard let personciImage = CIImage(image: personPic.image!)else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let firstFace = faceDetector?.features(in: personciImage)
        
        /* 
         For converting the Core Image Coordinates to UIView Coordinates
         */
        
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)


        /*
         FOR LOOP FOR FIRST IMAGE VIEW
         */
        
        for face in firstFace as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            /* 
             Apply the transform to convert the coordinates 
             */
            
            var faceViewBounds = face.bounds.applying(transform)
            
            /* 
             Calculate the actual position and size of the rectangle in the image view 
             */
            
            let viewSize = personPic.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.white.cgColor
            faceBox.backgroundColor = UIColor.clear
            
            personPic.addSubview(faceBox)
            
            //Left eyes position
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            //Right eyes position
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
            //Mouth position
            if face.hasMouthPosition{
                print("Mouth Position \(face.mouthPosition)")
            }
            
            //detect the smile
            if face.hasSmile{
                print("The person is smiling")
            }

        }
    }
}

