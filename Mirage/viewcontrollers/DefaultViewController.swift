//
//  DefaultViewController.swift
//  Mirage
//
//  Created by Oddin on 17/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DefaultViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        addChildView("InstructionScreenID", titleOfChildren: "Disciplinas", iconName: "book-multiple-black")
        
        //Show the first childScreen
        showFirstChild()
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //funções para uso em qualquer Controller
    
    static func refreshTableView(_ tableView: UITableView, cellNibName: String, view: UIView) -> UITableView {
        let nib = UINib(nibName: cellNibName , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: StringUtil.cell)
        view.addSubview(tableView)
        return tableView
    }
    
    static func refreshControl(_ refreshControl: UIRefreshControl, tableView: UITableView) -> UIRefreshControl {
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        return refreshControl
    }
    
    //exibe mensagens de alerta
    static func alertMessage(_ userMessage: String) -> UIAlertController {
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        return myAlert
    }
    
    //exibe mensagens de alerta
    static func alertMessagePushViewController(_ userMessage: String, navigationController: UINavigationController) -> UIAlertController {
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)

        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.ok, style: .destructive) { action -> Void in
            navigationController.popViewController(animated: true)
        }
        
        myAlert.addAction(okAction)
        
        return myAlert
    }
    
    //salvar arquivos em diretorio local
    static func saveDocumentDirectory(_ name: String, _ data: Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        if let image : UIImage = UIImage(data: data) {
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        } else {
            fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
        }
    }
    
    //recuperar arquivo em diretorio
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //cria diretorio
    static func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("OddinDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
    //abre visualizador de imagem
    static func pushImageViewController(_ name: String, _ navigationController: UINavigationController){
        let fileManager = FileManager.default
        let dataPath = (DefaultViewController.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: dataPath){
            let imageViewController = ImageViewController()
            
            imageViewController.imagePAth = dataPath
            imageViewController.name = name
            
            navigationController.pushViewController(imageViewController, animated: true)
        }else{
            print("No Image")
        }
    }
    
    // abre visualizador de pdf
    static func pushPDFViewController(_ name: String, _ navigationController: UINavigationController) {
        let fileManager = FileManager.default
        let dataPath = (DefaultViewController.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: dataPath){
            let pdf = PDFViewController()
            pdf.name = name
            pdf.dataPath = dataPath
            
            navigationController.pushViewController(pdf, animated: true)
        }else{
            print("No PDF")
        }
    }
    
    static func pushVideoPlayerViewController(_ name: String, _ mime: String, _ navigationController: UINavigationController) {
        let fileManager = FileManager.default
        let dataPath = (DefaultViewController.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: dataPath){
            let videoPlayer = VideoPlayerViewController()
            videoPlayer.name = name
            videoPlayer.dataPath = dataPath
            videoPlayer.mime = mime
            
            navigationController.pushViewController(videoPlayer, animated: true)
        }
    }
}
