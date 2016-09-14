//
//  OpenPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class OpenPresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewPresentationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var presentations = Array<Presentation>()
    var openPresentation = Array<Presentation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPresentation()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.PresentationCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(OpenPresentationViewController.refresh), for: UIControlEvents.valueChanged)
        
        //verifica se é um perfil de professor para fechar apresentações
        if instruction.profile == 1 {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OpenPresentationViewController.longPress(_:)))
            self.view.addGestureRecognizer(longPressRecognizer)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        getPresentation()
    }
    
    //chama displayAlert para fechar apresentação
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            
            if let indexPah = tableView.indexPathForRow(at: touchPoint) {
                let id  = openPresentation[ (indexPah as NSIndexPath).row ].id
                let subject  = openPresentation[ (indexPah as NSIndexPath).row ].subject
                
                alertMessageClosedPresentation(StringUtil.msgClosePresentation, subject: subject, id: id)
            }
        }
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
    }
    
    func getPresentation() {
        let request = Server.getRequestNew(url: Server.url + Server.instructions + "\(instruction.id)" + Server.presentations)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let presentation = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let instruction : NSArray =  presentation.value(forKey: StringUtil.instruction) as! NSArray
                let person : NSArray = presentation.value(forKey: StringUtil.person) as! NSArray
                
                self.presentations = Presentation.iterateJSONArray(presentation, instruction: instruction, person: person)
                
                self.openPresentation.removeAll()
                
                var auxPresent = Array<Presentation>()
                
                for i in 0 ..< self.presentations.count {
                    var j = 0
                    
                    if self.presentations[i].status == 0 {
                        auxPresent.insert(self.presentations[i], at: j)
                        j += 1
                    }
                }
                self.openPresentation = auxPresent.reversed()
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openPresentation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! PresentationCell
        let present = openPresentation[ (indexPath as NSIndexPath).row ]
        
        cell.subjectLabel.text = present.subject
        cell.dateLabel.text = DateUtil.dateAndHour(present.created_at)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentation = openPresentation[ (indexPath as NSIndexPath).row ]
        
        let questionTabBar = QuestionsTabBarViewController()
        questionTabBar.instruction = instruction
        questionTabBar.presentation = presentation
        
        self.navigationController?.pushViewController(questionTabBar, animated: true)
    }
    
    //exibe mensagens de alerta
    func alertMessageClosedPresentation(_ userMessage: String, subject: String, id: Int) {
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle:
            UIAlertControllerStyle.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .destructive) { action -> Void in
            let request = Server.postRequestSendToken(Server.url + Server.presentations + "\(id)" + Server.close)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                data, response, error in
                
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                        HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                        
                        if httpResponse.statusCode == 404 {
                            
                        } else if httpResponse.statusCode == 401 {
                            
                        } else if httpResponse.statusCode == 200 {
                            DispatchQueue.main.async(execute: {
                                self.getPresentation()
                            })
                        }
                    }
                }
            }) 
            task.resume()
        }
        
        let cancelAction = UIAlertAction(title: StringUtil.cancel, style: UIAlertActionStyle.cancel, handler: nil)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.openPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
