//
//  VideoPlayerViewController.swift
//  Mirage
//
//  Created by Oddin on 29/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import MobileCoreServices

class VideoPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    var dataPath = String()
    var name = String()
    var mime = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        
        if mime.contains(StringUtil.video) {
            playVideo()
        } else {
            playAudio()
        }
        
        
    }
    
    func playVideo() {
        let videoAsset = (AVAsset(url: URL(fileURLWithPath: dataPath)))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Play the video
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        player.volume = 1.0
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func playerDidFinishPlaying(name: NSNotification) {
        
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController!.popViewController(animated: true)
    }
    
    func playAudio() {
        let soundURL = URL(fileURLWithPath: dataPath)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.delegate = self
            // check if audioPlayer is prepared to play audio
            if (audioPlayer.prepareToPlay()) {
                audioPlayer.play()
            }
        }
        catch{ }
    }
}


