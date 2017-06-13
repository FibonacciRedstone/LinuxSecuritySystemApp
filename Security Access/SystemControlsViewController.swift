//
//  SystemControlsViewController.swift
//  Security Access
//
//  Created by Fibonacci on 6/13/17.
//  Copyright © 2017 FibonacciCorp. All rights reserved.
//

import Foundation

class SystemControlsViewController : UIViewController{
    
    @IBOutlet weak var startSystemButton: UIButton!
    @IBOutlet weak var stopSystemButton: UIButton!
    @IBOutlet weak var lastActivatedLabel: UILabel!
    @IBOutlet weak var serverOnIndictor: UIView!
    @IBOutlet weak var lastImageView: UIImageView!
    
    var lastActivated : String? = nil
    let app = UIApplication.shared.delegate as! AppDelegate
    
    private var documentsDirURL : URL? = nil
    var currentServer : Server? = nil
    
    override func viewDidLoad() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            documentsDirURL = dir
        }
        updateView()
        serverOnIndictor.layer.cornerRadius = serverOnIndictor.frame.width/2
        serverOnIndictor.clipsToBounds = true
        serverOnIndictor.layer.borderColor = UIColor.black.cgColor
        serverOnIndictor.layer.borderWidth = 1
        
        if !app.useCamera{
            lastImageView.layer.borderColor = UIColor.black.cgColor
            lastImageView.layer.borderWidth = 2
            
            let y = lastImageView.frame.height/2
            let noCameraLabel = UILabel(frame: CGRect(x: 0, y: y, width: lastImageView.frame.width, height: 15))
            noCameraLabel.text = "No Camera Enabled"
            noCameraLabel.textAlignment = .center
            lastImageView.addSubview(noCameraLabel)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }
    
    func updateView(){
        updateSystemViews()
        updateSaveLabels()
        updateSaveLabels()
    }
    
    func updateIndicator(){
        if isSystemOn(){
            serverOnIndictor.backgroundColor = .green
            startSystemButton.isEnabled = false
            stopSystemButton.isEnabled = true
        }else{
            serverOnIndictor.backgroundColor = .red
            startSystemButton.isEnabled = true
            stopSystemButton.isEnabled = false
            
        }
    }
    
    func updateSystemViews(){
        if let server = currentServer{
            if(server.isLoggedIn){
                startSystemButton.isHidden = false
                stopSystemButton.isHidden = false
                serverOnIndictor.isHidden = false
                updateIndicator()
            }else{
                startSystemButton.isHidden = true
                stopSystemButton.isHidden = true
                serverOnIndictor.isHidden = true
                print("Not logged in")
            }
        }else{
            startSystemButton.isHidden = true
            stopSystemButton.isHidden = true
            serverOnIndictor.isHidden = true
            print("Nil Server")
        }
    }
    
    
    
    func isSystemOn() -> Bool{
        let command = "screen -list | grep \"\(app.screenSessionName)\" && echo 1 || echo 0"
        if let server = currentServer{
            let output = server.executeCommandArray(commandArray: [command])
            let componentsArray = output.components(separatedBy: .whitespacesAndNewlines)
            //Session is Active
            if(componentsArray[componentsArray.count-2] == "1"){
                return true
            }
        }
        return false
    }
    
    func runCommandOnScreenString(sessionName : String = "", command : String) -> String{
        var session = sessionName
        if sessionName == ""{
            session = app.screenSessionName
        }
        
        let string = "screen -S \(session) -X stuff $\"\(command)\\n\""
        return string
    }
    
    func updateSaveLabels(){
        
        do{
            try downloadSaveFile()
            if let url = documentsDirURL?.appendingPathComponent(app.saveFileName){
                let contents = try String(contentsOf: url)
                let lineArray = contents.components(separatedBy: .newlines)
                lastActivatedLabel.text = "Last Activated: " + lineArray[0]
                if app.lastImageName != lineArray[1] && app.lastImageName != ""{
                    let pathURL = documentsDirURL!.appendingPathComponent(app.lastImageName)
                    if FileManager.default.fileExists(atPath: pathURL.path){
                        try! FileManager.default.removeItem(at: pathURL)
                    }
                }
                app.lastImageName = lineArray[1]
                if app.useCamera{
                    try downloadLastImage()
                    print("Image Downloaded")
                    let path = documentsDirURL!.appendingPathComponent(app.lastImageName).path
                    let currentImage = UIImage(contentsOfFile: path)
                    lastImageView.image = currentImage
                }
                
            }
                
        }catch ServerError.NilServer{
            print("Nil Server")
        }catch {
            print("Could not read data")
            print(error.localizedDescription)
        }
        
    }
    
    func downloadSaveFile() throws{
        if let server = currentServer{
            let succeeded = server.downloadFile(remotePath: app.commonDirectoryPath + app.saveFileName, localPath: documentsDirURL!.appendingPathComponent(app.saveFileName).standardizedFileURL.path)
            if !succeeded{
                if let lastError = server.lastError{
                    throw lastError
                }
            }
        }else{
            print("Nil Server")
            throw ServerError.NilServer
        }
        
        
    }
    
    func downloadLastImage() throws{
        
        guard app.lastImageName != "" else{
            print("Empty Image Name")
            throw app.emptyError(text: "Empty Image Name")
        }
        
        if let server = currentServer{
            let remote = app.commonDirectoryPath + app.lastImageName
            let local = documentsDirURL!.appendingPathComponent(app.lastImageName).standardizedFileURL.path
            let succeeded = server.downloadFile(remotePath: remote, localPath: local)
            if !succeeded{
                if let lastError = server.lastError{
                    throw lastError
                }
            }
        }else{
            print("Nil Server")
            throw ServerError.NilServer
        }
        
    }
    
    @IBAction func startSystem(_ sender: Any) {
        
        if let server = currentServer{
            
            let startSession = "screen -S \(app.screenSessionName) -d -m"
            let setCurrentDir = runCommandOnScreenString(command: "cd \(app.commonDirectoryPath)")
            let startSecurityProgram = runCommandOnScreenString(command: "python \(app.sensorFile)")
            _ = server.executeCommandArray(commandArray: [startSession, setCurrentDir, startSecurityProgram])
            updateSaveLabels()
            
            
        }
        updateIndicator()
    }
    
    @IBAction func stopSystem(_ sender: Any) {
        if let server = currentServer{
            let commandString = "screen -X -S \"\(app.screenSessionName)\" quit"
            _ = server.executeCommandArray(commandArray: [commandString])
            updateSaveLabels()
        }
        updateIndicator()
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
