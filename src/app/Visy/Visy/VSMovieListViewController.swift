//
//  VSMovieListViewController.swift
//  Visy
//
//  Created by Yoshiyuki Kuga on 2015/11/28.
//  Copyright © 2015年 TK_15. All rights reserved.
//

import UIKit

class VSMovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let youtubeIds: [String] = ["NIXcEWrGtsM", "eGljbxH9jXI", "XxpzKJxye1s"]
    var selectedId = String()

    @IBOutlet weak var movieListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib: UINib = UINib(nibName: "VSMovieListCell", bundle: nil)
        movieListTableView.registerNib(nib, forCellReuseIdentifier: "movieListCell")

        movieListTableView.delegate = self
        movieListTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeIds.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: VSMovieListCell = tableView.dequeueReusableCellWithIdentifier("movieListCell", forIndexPath: indexPath) as! VSMovieListCell
        var movie = VSMovie(youtubeId: youtubeIds[indexPath.row])
        cell.movieTitleLabel.text = movie.title
        cell.movieImageView.image = movie.thumbnail

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return VSMovieListCell.cellHeight()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedId = youtubeIds[indexPath.row]
        performSegueWithIdentifier("toMoviePlayer", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMoviePlayer" {
            var moviePlayerViewController = VSMoviePlayerViewController()
            moviePlayerViewController = segue.destinationViewController as! VSMoviePlayerViewController
            moviePlayerViewController.youtubeId = selectedId
        }
    }
}
