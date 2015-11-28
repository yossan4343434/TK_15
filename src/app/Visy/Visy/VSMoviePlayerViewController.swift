//
//  VSMoviePlayerViewController.swift
//  Visy
//
//  Created by Yoshiyuki Kuga on 2015/11/28.
//  Copyright © 2015年 TK_15. All rights reserved.
//

import UIKit
import HCYoutubeParser
import MediaPlayer
import Spring
import AVFoundation
import Alamofire
import SwiftyJSON

class VSMoviePlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviePlayerView: UIView!
    @IBOutlet weak var controlBarView: UIView!
    @IBOutlet weak var sceneTableView: UITableView!
    @IBOutlet weak var soundButton: UIButton!

    var youtubeId = String()
    var moviePlayer: MPMoviePlayerController!
    var audioPlayer: AVAudioPlayer!
    var statusTimer: NSTimer!
    var sounds: [VSSound] = []
    var nextSound: VSSound!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneTableView.delegate = self
        sceneTableView.dataSource = self

        setupSounds()

        setupMoviePlayer()
        moviePlayer.play()

        statusTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:"playWithTime", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(animated: Bool) {
        moviePlayer.stop()
        statusTimer.invalidate()
        statusTimer = nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "sceneCell")
        cell.textLabel?.text = "シーン" + String(indexPath.row + 1)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let times: [NSTimeInterval] = [1530, 3217, 3877, 3275, 3800, 4425, 4545, 4965, 5805, 5810, 5815, 6215]
        let time: NSTimeInterval = times[indexPath.row]
        moviePlayer.currentPlaybackTime = time
    }

    func setupSounds() {
        Alamofire.request(.GET, "http://27.120.86.25/visy/minisounds.json")
            .responseJSON {
                response in
                let json = JSON(data:response.data!)
                for (key, subJson) in json {
                    let playTime = subJson["playtime"].doubleValue
                    let name =  subJson["name"].stringValue
                    self.sounds.append(VSSound.init(time:playTime, item:name))
                }
        }
    }

    func setupMoviePlayer() {
        let urlString = "https://www.youtube.com/embed/" + youtubeId + "?feature=player_detailpage&playsinline=1"
        let srcUrl = NSURL(string: urlString)
        let dict:NSDictionary = HCYoutubeParser.h264videosWithYoutubeURL(srcUrl)
        let str = dict["medium"] as! String
        let videoUrl = NSURL(string: str)
        moviePlayer = MPMoviePlayerController(contentURL: videoUrl)
        moviePlayer.view.frame = CGRect(x: 0, y: 40, width: 375, height: 250)
        moviePlayerView.addSubview(moviePlayer.view)
    }
    
    func playWithTime() {
        let currentTime = moviePlayer.currentPlaybackTime
        print(currentTime)
        let oldTime = currentTime - 0.5
        if !currentTime.isNaN && !sounds.isEmpty {
            getNextSound(currentTime)
            if currentTime > nextSound.time - 0.5 && oldTime < nextSound.time {
                playSound(nextSound)
            }
        }
    }

    func getNextSound(time: NSTimeInterval) {
        for sound in sounds {
            nextSound = sound
            if time < sound.time {
                break
            } else {
                continue
            }
        }
    }

    func playSound(sound: VSSound) {
        let filename: String = "Resource/" + sound.item
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "m4a")!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: audioPath)
        audioPlayer.play()
    }

    @IBAction func soundButtonTapped(sender: AnyObject) {
        if !moviePlayer.currentPlaybackTime.isNaN {
            let sound = VSSound(time: moviePlayer.currentPlaybackTime, item: "yahoo")
            playSound(sound)

            let params = [
                "name": sound.item,
                "playtime": sound.time
            ]

            Alamofire.request(.POST, "http://27.120.86.25/visy/minisounds.json", parameters: params as! [String : AnyObject] ,encoding: .JSON)

        }
    }

}
