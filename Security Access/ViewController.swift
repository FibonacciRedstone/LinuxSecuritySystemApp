//
//  ViewController.swift
//  Security Access
//
//  Created by Owner on 6/8/17.
//  Copyright © 2017 FibonacciCorp. All rights reserved.
//

import UIKit
import NMSSH


class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var hostField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var currentServer : Server? = nil
    
    @IBOutlet weak var shouldStayLoggedIn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostField.text = app.lastHostName
        
        if app.shouldAutoLogin{
            usernameField.text = app.currentUser
            hostField.text = app.lastHostName
            passwordField.text = app.currentPassword
            logIn(username: app.currentUser, password: app.currentPassword, serverHost: app.lastHostName)
        }
        
        let keyboardDismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.keyboardDismiss))
        self.view.addGestureRecognizer(keyboardDismissRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logIn(username : String, password : String, serverHost : String? = nil){
        let controlsViewController = self.storyboard?.instantiateViewController(withIdentifier: "controlsController") as! SystemControlsViewController
        
        
        if let server = currentServer{
            server.logIn(username: username, password: password)
            controlsViewController.currentServer = server
            self.present(controlsViewController, animated: true, completion: nil)
            controlsViewController.updateView()
        }else{
            if let host = serverHost{
                let server = Server(host: host)
                server.logIn(username: username, password: password)
                self.currentServer = server
                controlsViewController.currentServer = server
                self.present(controlsViewController, animated: true, completion: nil)
                controlsViewController.updateView()
                
            }else{
                print("Nil Host")
            }
            
        }
        
    }

    @IBAction func logIn(_ sender: Any) {
        
        guard let host = hostField.text else{
            print("Nil Host")
            return
        }
        guard let username = usernameField.text else{
            print("Nil Username")
            return
        }
        guard let password = passwordField.text else{
            print("Nil Password")
            return
        }
        
        logIn(username: username, password: password, serverHost: host)
        if shouldStayLoggedIn.isOn{
            app.currentUser = username
            app.currentPassword = password
            app.shouldAutoLogin = true
        }
        
        
    }
    
    @objc func keyboardDismiss(){
        usernameField.resignFirstResponder()
        hostField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    

}

