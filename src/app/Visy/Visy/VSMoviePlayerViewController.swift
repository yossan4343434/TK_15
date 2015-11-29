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
    var movie: VSMovie!
    var sounds: [VSSound] = []
    var nextSound: VSSound!
    var sceneTimes: [NSTimeInterval]!

    override func viewDidLoad() {
        super.viewDidLoad()

        movie = VSMovie(youtubeId: youtubeId)

        setupSounds()

        setupMoviePlayer()

        setupSceneTableView()

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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 60))
        sectionLabel.font = UIFont.systemFontOfSize(14)
        sectionLabel.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        if (section == 0) {
            sectionLabel.text = "感情"
        } else {
            sectionLabel.text = "プレイヤー"
        }
        return sectionLabel
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return movie.emotion.count
        } else {
            return movie.person.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: VSSceneListCell = tableView.dequeueReusableCellWithIdentifier("sceneListCell", forIndexPath: indexPath) as! VSSceneListCell

        if (indexPath.section == 0) {
            let emotionTitle = Array(movie.emotion.keys)[indexPath.row]
            cell.sceneLabel.text = emotionTitle
            cell.sceneImageView.image = UIImage(named: emotionTitle)
        } else {
            let personTitle = Array(movie.person.keys)[indexPath.row]
            cell.sceneLabel.text = personTitle
            cell.sceneImageView.image = UIImage(named: personTitle)
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VSSceneListCell.cellHeight()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if (indexPath.section == 0) {
            sceneTimes = Array(movie.emotion.values)[indexPath.row] as [NSTimeInterval]
        } else {
            sceneTimes = Array(movie.person.values)[indexPath.row] as [NSTimeInterval]
        }
        if !sceneTimes.isEmpty {
            moviePlayer.currentPlaybackTime = sceneTimes[0]
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    func setupSceneTableView() {
        let nib: UINib = UINib(nibName: "VSSceneListCell", bundle: nil)
        sceneTableView.registerNib(nib, forCellReuseIdentifier: "sceneListCell")

        sceneTableView.delegate = self
        sceneTableView.dataSource = self
    }
    
    func playWithTime() {
        let currentTime = moviePlayer.currentPlaybackTime
        print(currentTime)
        let oldTime = currentTime - 0.5
        if (!currentTime.isNaN && !sounds.isEmpty) {
            getNextSound(currentTime)
            if (currentTime > nextSound.time - 0.5 && oldTime < nextSound.time) {
                playSound(nextSound)
            }
        }
    }

    func getNextSound(time: NSTimeInterval) {
        for sound in sounds {
            nextSound = sound
            if (time < sound.time) {
                break
            } else {
                continue
            }
        }
    }

    func playSound(sound: VSSound) {
        if !sound.item.isEmpty {
            let filename: String = "Resource/" + sound.item
            let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "m4a")!)
            audioPlayer = try! AVAudioPlayer(contentsOfURL: audioPath)
            audioPlayer.play()
        }
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
