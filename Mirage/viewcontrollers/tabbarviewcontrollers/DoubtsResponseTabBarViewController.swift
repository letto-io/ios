//
//  DoubtsResponseTabBarViewController.swift
//  Mirage
//
//  Created by Oddin on 06/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import MobileCoreServices


class DoubtsResponseTabBarViewController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!
    var icon3: UITabBarItem!
    var icon4: UITabBarItem!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    var image = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = doubt.text

        let item1  = TextDoubtReponseViewController()
        item1.discipline = discipline
        item1.presentation = presentation
        item1.doubt = doubt
        item1.getDoubtResponse()
        
        let item2 = AudioDoubtResponseViewController()
        item2.discipline = discipline
        item2.presentation = presentation
        item2.doubt = doubt
        item2.getDoubtResponse()
        
        let item3 = VideoDoubtResponseViewController()
        item3.discipline = discipline
        item3.presentation = presentation
        item3.doubt = doubt
        item3.getDoubtResponse()
        
        let item4 = AttachmentDoubtResponseViewController()
        item4.discipline = discipline
        item4.presentation = presentation
        item4.doubt = doubt
        item4.getDoubtResponse()
        
        icon1 = UITabBarItem(title: StringUtil.Texto, image: ImageUtil.imageTextBlack, selectedImage: ImageUtil.imageTextWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.Audio, image: ImageUtil.imageAudioBlack, selectedImage: ImageUtil.imageAudioWhite)
        item2.tabBarItem = icon2
        icon3 = UITabBarItem(title: StringUtil.Video, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item3.tabBarItem = icon3
        icon4 = UITabBarItem(title: StringUtil.Anexo, image: ImageUtil.imageAttachment, selectedImage: ImageUtil.imageAttachment)
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        if discipline.profile == 2 {
            let newContribution = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(DoubtsResponseTabBarViewController.newContributionAlert))
            newContribution.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButtonItems([newContribution], animated: true)
        }
        
        
        
//        let playVideo = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: #selector(DoubtsResponseTabBarViewController.playVideo))
//        playVideo.tintColor = ColorUtil.orangeColor
//        
//        let newContrbution = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(DoubtsResponseTabBarViewController.UploadRequest))
//        newVideoContrbution.tintColor = ColorUtil.orangeColor
        
        
    }
    
    func recordVideo() {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func playVideo(sender: AnyObject) {
        print("Play a video")
        
        // Find the video in the app's document directory
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
        let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Play the video
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got a video")
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = #selector(DoubtsResponseTabBarViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            videoData?.writeToFile(dataPath, atomically: false)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // Any tasks you want to perform after recording a video
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // What you want to happen
            })
        }
    }
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func selectPicture() {
        
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(ImagePicker, animated: true, completion: nil)
        
    }
    
    func UploadRequest() {
        let url = NSURL(string: "http://ws-edupanel.herokuapp.com/controller/instruction/5/presentation/108/doubt/86/contribution")
        let request = NSMutableURLRequest(URL: url!)
        let image_data = UIImagePNGRepresentation(ImageUtil.imageAllBlack)
        
        
        let fname = "test.png"
        let mimetype = "video/mp4"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.HTTPMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)

        request.HTTPBody = body
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
    }
    
    //exibe mensagens de alerta
    func newContributionAlert() {
        let myAlert = UIAlertController(title: StringUtil.newContribution, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let textContribution = UIAlertAction(title: StringUtil.Texto, style: .Default) { action -> Void in
            let newTextResponse = CreateNewTextDoubtResponseViewController()
            
            self.navigationController?.pushViewController(newTextResponse, animated: true)
        }
        
        let audioContribution = UIAlertAction(title: StringUtil.Audio, style: .Default) { action -> Void in
            
        }
        
        let videoContribution = UIAlertAction(title: StringUtil.Video, style: .Default) { action -> Void in
            self.recordVideo()
        }
        
        let attachmentContribution = UIAlertAction(title: StringUtil.Anexo, style: .Default) { action -> Void in
            
        }
        
        let galeryContribution = UIAlertAction(title: StringUtil.Galeria, style: .Default) { action -> Void in
            self.selectPicture()
        }
        
        let pictureContribution = UIAlertAction(title: StringUtil.Foto, style: .Default) { action -> Void in
            
        }
        
        let cancelAction = UIAlertAction(title: StringUtil.cancel, style: UIAlertActionStyle.Destructive, handler: nil)
        
        let text = ImageUtil.imageTextBlack
        textContribution.setValue(text, forKey: StringUtil.image)
        
        let audio = ImageUtil.imageAudioBlack
        audioContribution.setValue(audio, forKey: StringUtil.image)
        
        let video = ImageUtil.imageVideoBlack
        videoContribution.setValue(video, forKey: StringUtil.image)
        
        let attachment = ImageUtil.imageAttachment
        attachmentContribution.setValue(attachment, forKey: StringUtil.image)
        
        let galery = ImageUtil.imageBlack
        galeryContribution.setValue(galery, forKey: StringUtil.image)
        
        let picture = ImageUtil.imageCameraBlack
        pictureContribution.setValue(picture, forKey: StringUtil.image)
        
        myAlert.addAction(textContribution)
        myAlert.addAction(audioContribution)
        myAlert.addAction(videoContribution)
        myAlert.addAction(attachmentContribution)
        myAlert.addAction(galeryContribution)
        myAlert.addAction(pictureContribution)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.doubtsResponseTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
