//
//  AudioDoubtResponseViewController.swift
//  Mirage
//
//  Created by Oddin on 09/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class AudioDoubtResponseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
    var audioResponse = Array<Contributions>()
    var doubtContributions = Array<Contributions>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        refreshControl.addTarget(self, action: #selector(DoubtViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        refreshTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshTableView()
    }
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: StringUtil.doubtResponseCell , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
        view.addSubview(tableView)
        
        getDoubtResponse()
        tableView.reloadData()
    }
    
    // pull to refresh
    func refresh() {
        getDoubtResponse()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getDoubtResponse() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(doubt.id)" + Server.contribution
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = [StringUtil.set_Cookie : StringUtil.key_Value]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        print(cookies)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let doubtResponseJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (doubtResponseJSONData.valueForKey(StringUtil.error) != nil) {
                    return
                } else {
                    let contributions : NSArray = doubtResponseJSONData.valueForKey(StringUtil.contributions) as! NSArray
                    let mcmaterials : NSArray = contributions.valueForKey(StringUtil.mcmaterial) as! NSArray
                    let persons : NSArray = contributions.valueForKey(StringUtil.person) as! NSArray
                    
                    self.doubtContributions = Contributions.iterateJSONArray(contributions, mcmaterials: mcmaterials, persons: persons)
                }
                print(doubtResponseJSONData)
            }
        })
        task.resume()
        
        audioResponse.removeAll()
        
        var auxContributions = Array<Contributions>()
        
        for i in 0 ..< doubtContributions.count {
            var j = 0
            
            if doubtContributions[i].mcmaterial.mime.containsString(StringUtil.audio) {
                auxContributions.insert(doubtContributions[i], atIndex: j)
                j += 1
            }
        }
        
        audioResponse = auxContributions
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioResponse.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtResponseTableViewCell
        
        let doubtResponse = audioResponse[ indexPath.row ]
        
        
        cell.textName.text = doubtResponse.mcmaterial.name
        
        
        return cell
    }
    
    init() {
        super.init(nibName: StringUtil.AudioDoubtResponseViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
