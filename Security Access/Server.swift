//
//  Server.swift
//  Security Access
//
//  Created by Owner on 6/9/17.
//  Copyright © 2017 FibonacciCorp. All rights reserved.
//

import Foundation
import NMSSH

enum ServerError : Error{
    case NilServer
}

class Server{
    
    var serverHost : String? = nil
    private var serverSession : NMSSHSession? = nil
    var isLoggedIn : Bool {
        if let sesh = serverSession{
            return (sesh.isAuthorized && sesh.isConnected)
        }
        return false
    }
    
    var lastError : Error?{
        if let error = serverSession?.lastError{
            return error
        }
        return nil
    }
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    init(host : String){
        serverHost = host
    }
    
    func logIn(username : String, password : String){
        
        guard let host = serverHost else{
            print("Nil Host")
            return
        }
        
        if let session = NMSSHSession(host: host, andUsername: username){
            session.connect()
            if(session.isConnected){
                
                session.authenticate(byPassword: password)
                if(session.isAuthorized){
                    print("Logged In Successfully")
                    self.serverSession = session
                    app.lastHostName = host
                }else{
                    print("Could not authorize")
                }
            }else{
                print("Not connected")
            }
            
        }else{
            print("Could not connect")
        }
    }
    
    func downloadFile(remotePath : String, localPath : String) -> Bool{
        if let session = serverSession{
            let succeeded = session.channel.downloadFile(remotePath, to: localPath)
            return succeeded
        }else{
            print("Nil Session")
            return false
        }
        
    }
    
    func executeCommandArray(commandArray : [String]) -> String{
        
        if let session = serverSession{
            do{
                if commandArray.count > 1{
                    var commandString = commandArray.reduce("", {$0 + "; " + $1})
                    commandString.remove(at: commandString.startIndex)
                    commandString.remove(at: commandString.startIndex)
                    return try session.channel.execute(commandString)
                }else{
                    return try session.channel.execute(commandArray[0])
                }
            
            }catch{
                print("Could not execute commands")
            }
        }
        return ""
    }
    
}
