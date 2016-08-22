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

class AnswersTabBarViewController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    
    let imagePicker = UIImagePickerController()
    var image: UIImage!
    var videoData: NSData!
    var audioData: NSData!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    
    var indexContribution = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = question.text
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.Plain, target:nil, action:nil)

        let item1 = self.textDoubtResponse()
        let item2 = self.audioDoubtResponse()
        let item3 = self.videoDoubtResponse()
        let item4 = self.attachmentDoubtResponse()
        
        let icon1 = UITabBarItem(title: StringUtil.Texto, image: ImageUtil.imageTextBlack, selectedImage: ImageUtil.imageTextWhite)
        item1.tabBarItem = icon1
        let icon2 = UITabBarItem(title: StringUtil.Audio, image: ImageUtil.imageAudioBlack, selectedImage: ImageUtil.imageAudioWhite)
        item2.tabBarItem = icon2
        let icon3 = UITabBarItem(title: StringUtil.Video, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item3.tabBarItem = icon3
        let icon4 = UITabBarItem(title: StringUtil.Anexo, image: ImageUtil.imageAttachment, selectedImage: ImageUtil.imageAttachment)
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        contributionButtonTapped(0)
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController.nibName == StringUtil.textDoubtReponseViewController {
            contributionButtonTapped(0)
        } else if viewController.nibName == StringUtil.AudioDoubtResponseViewController {
            contributionButtonTapped(1)
        } else if viewController.nibName == StringUtil.VideoDoubtResponseViewController {
            contributionButtonTapped(2)
        } else if viewController.nibName == StringUtil.AttachmentDoubtResponseViewController {
            contributionButtonTapped(3)
        }
        
        return true
    }
    
    func contributionButtonTapped(index: Int) {
//        if discipline.profile == 2 {
//            if index == 0 {
//                let newContribution = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(DoubtsResponseTabBarViewController.showNewTextContribution))
//                newContribution.tintColor = ColorUtil.orangeColor
//                
//                self.navigationItem.setRightBarButtonItems([newContribution], animated: true)
//            } else if index == 1 {
//                let newContribution = UIBarButtonItem(image: ImageUtil.imageAudioDoubtResponse, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DoubtsResponseTabBarViewController.newAudioContributionAlert))
//                newContribution.tintColor = ColorUtil.orangeColor
//                
//                self.navigationItem.setRightBarButtonItems([newContribution], animated: true)
//            } else if index == 2 {
//                let newContribution = UIBarButtonItem(image: ImageUtil.imageVideoDoubtResponse, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DoubtsResponseTabBarViewController.recordVideo))
//                newContribution.tintColor = ColorUtil.orangeColor
//                
//                self.navigationItem.setRightBarButtonItems([newContribution], animated: true)
//            } else if index == 3 || index == 4 {
//                let newContribution = UIBarButtonItem(image: ImageUtil.imageAttachmentDoubtResponse, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DoubtsResponseTabBarViewController.newAttachmentContributionAlert))
//                newContribution.tintColor = ColorUtil.orangeColor
//                
//                self.navigationItem.setRightBarButtonItems([newContribution], animated: true)
//            }
//        }
    }
    
    func textDoubtResponse() -> TextAnswerViewController {
        let item1 = TextAnswerViewController()
        item1.instruction = instruction
        item1.presentation = presentation
        item1.question = question
        item1.getDoubtResponse()
        
        return item1
    }
    
    func audioDoubtResponse() -> AudioAnswerViewController {
        let item2 = AudioAnswerViewController()
        item2.instruction = instruction
        item2.presentation = presentation
        item2.question = question
        item2.getDoubtResponse()
        
        return item2
    }
    
    func videoDoubtResponse() -> VideoAnswerViewController {
        let item3 = VideoAnswerViewController()
        item3.instruction = instruction
        item3.presentation = presentation
        item3.question = question
        item3.getDoubtResponse()
        
        return item3
    }
    
    func attachmentDoubtResponse() -> AttachmentAnswerViewController {
        let item4 = AttachmentAnswerViewController()
        item4.instruction = instruction
        item4.presentation = presentation
        item4.question = question
        item4.getDoubtResponse()
        
        return item4
    }
    
    func showNewTextContribution() {
        self.indexContribution = 0
        let newTextResponse = CreateAnswerViewController()
        
        self.navigationController?.pushViewController(newTextResponse, animated: true)
    }
    
    func recordAudio(){
        self.indexContribution = 1
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }
    }
    
    func recordVideo() {
        self.indexContribution = 2
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                self.presentViewController(DefaultViewController.alertMessage(StringUtil.cameraNotAccess), animated: true, completion: nil)
            }
        } else {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.cameraNotAccess), animated: true, completion: nil)
        }
    }
    
    func openAttachment() {
        self.indexContribution = 3
    }
    
    func selectPicture() {
        self.indexContribution = 4
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        self.indexContribution = 4
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.cameraNotAccess), animated: true, completion: nil)
        }
    }
    
    func playAudio() {
        if !audioRecorder.recording {
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.3gpp")
        return soundURL
    }
    
//    func playVideo(sender: AnyObject) {
//        // Find the video in the app's document directory
//        let paths = NSSearchPathForDirectoriesInDomains(
//            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        let documentsDirectory: AnyObject = paths[0]
//        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
//        let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
//        let playerItem = AVPlayerItem(asset: videoAsset)
//        
//        // Play the video
//        let player = AVPlayer(playerItem: playerItem)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        
//        self.presentViewController(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//    }
    
    func stopRecordingAudio(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            audioData = NSData(contentsOfURL: audioRecorder.url)
            self.imputFileName()
        } catch {
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = #selector(AnswersTabBarViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            videoData = NSData(contentsOfURL: pickedVideo)
//            let paths = NSSearchPathForDirectoriesInDomains(
//                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//            let documentsDirectory: AnyObject = paths[0]
//            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
//            videoData?.writeToFile(dataPath, atomically: false)
            
            dismissViewControllerAnimated(true, completion: nil)
            imputFileName()
        }
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            
            dismissViewControllerAnimated(true, completion: nil)
            imputFileName()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: {
            self.contributionButtonTapped(self.indexContribution)
        })
    }
    
    // Any tasks you want to perform after recording a video
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // What you want to happen
            })
        }
    }
    
    func uploadImageRequest(fname: String) {
        let request  = Server.uploadRequestImagePNG(Server.presentationURL+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(question.id)" + Server.contribution, fname: fname, image: image)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
    }
    
    func uploadVideoRequest(fname: String) {
        let request  = Server.uploadRequestVideoMP4(Server.presentationURL+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(question.id)" + Server.contribution, fname: fname, videoData: videoData)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
    }
    
    func uploadAudioRequest(fname: String) {
        let request  = Server.uploadRequestAudiom4a(Server.presentationURL+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(question.id)" + Server.contribution, fname: fname, audioRecorder: audioData)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
    }

    
    func imputFileName() {
        let alertController = UIAlertController(title: StringUtil.fileName, message: StringUtil.fileNameEmpty, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = StringUtil.name
        }
        
        let confirmAction = UIAlertAction(title: StringUtil.confirm, style: .Default) { (_) in
            let field = alertController.textFields![0] as UITextField
            
            if self.indexContribution == 2 {
                self.uploadVideoRequest(field.text!)
            } else if self.indexContribution == 3 || self.indexContribution == 4 {
                self.uploadImageRequest(field.text!)
            } else if self.indexContribution == 1 {
                self.uploadAudioRequest(field.text!)
            }
        }
        
        let cancelAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func newAudioContributionAlert() {
        let myAlert = UIAlertController(title: StringUtil.newContribution, message: "", preferredStyle: UIAlertControllerStyle.Alert)

        let startRecordAudio = UIAlertAction(title: StringUtil.Anexo, style: .Default) { action -> Void in
            self.recordAudio()
        }
        
        let stopRecordAudio = UIAlertAction(title: StringUtil.Galeria, style: .Default) { action -> Void in
            self.stopRecordingAudio()
        }
        
        let playAudio = UIAlertAction(title: StringUtil.Galeria, style: .Default) { action -> Void in
            self.playAudio()
        }
        
        let cancelAction = UIAlertAction(title: StringUtil.cancel, style: UIAlertActionStyle.Destructive, handler: nil)
        
        
        let start = ImageUtil.imageAttachment
        startRecordAudio.setValue(start, forKey: StringUtil.image)
        
        let stop = ImageUtil.imageBlack
        stopRecordAudio.setValue(stop, forKey: StringUtil.image)
        
        let play = ImageUtil.imageBlack
        playAudio.setValue(play, forKey: StringUtil.image)
        
        myAlert.addAction(startRecordAudio)
        myAlert.addAction(stopRecordAudio)
        myAlert.addAction(playAudio)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func newAttachmentContributionAlert() {
        let myAlert = UIAlertController(title: StringUtil.newContribution, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let attachmentContribution = UIAlertAction(title: StringUtil.Anexo, style: .Default) { action -> Void in
            self.openAttachment()
        }
        
        let galeryContribution = UIAlertAction(title: StringUtil.Galeria, style: .Default) { action -> Void in
            self.selectPicture()
        }
        
        let pictureContribution = UIAlertAction(title: StringUtil.Foto, style: .Default) { action -> Void in
            self.openCamera()
        }
        
        let cancelAction = UIAlertAction(title: StringUtil.cancel, style: UIAlertActionStyle.Destructive, handler: nil)
        
        
        let attachment = ImageUtil.imageAttachment
        attachmentContribution.setValue(attachment, forKey: StringUtil.image)
        
        let galery = ImageUtil.imageBlack
        galeryContribution.setValue(galery, forKey: StringUtil.image)
        
        let picture = ImageUtil.imageCameraBlack
        pictureContribution.setValue(picture, forKey: StringUtil.image)
        
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
