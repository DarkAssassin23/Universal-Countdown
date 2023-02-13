//
//  Networking.swift
//  Universal_Countdown
//
//  Created by Will  Jones on 2/11/23.
//

import Foundation
import CoreData
import Network
import SwiftUI

/// Class that handles TCP network connections
///
/// > Warning: The class does not do any checking of IP addresses or port
/// numbers. Make sure you ensure they are valid before passing them
/// into the constructor
class Network : ObservableObject
{
    /// Initialization constructor for the Network object
    /// - Parameters:
    ///   - hostName:  IP address of the server you are trying to connect to.
    ///   - port: The port number to connect on.
    ///   - context: NSManagedObjectContext to allow for saving of CoreData.
    init(hostName: String, port: Int, context: NSManagedObjectContext? = nil) {
        let host = NWEndpoint.Host(hostName)
        let port = NWEndpoint.Port("\(port)")!
        self.connection = NWConnection(host: host, port: port, using: .tcp)
        self.context = context // Required to save data when a connection is recieved
    }

    var connection: NWConnection
    var context: NSManagedObjectContext?
    var rec_val : String = "" //Rec Network Data
    var textstorage : String = "" //Saves complete Network Data
    let textstorage_max : Int = 250 //Max size of textStorage
    @Published var rec_val_state = false //Variable set when Data is aviable to show on view
    @Published var connection_status = false //When connect true else false
    
    
    /// Start the TCP connection with the server
    /// - Parameter data: CoreData object to save data too
    func start(data: FetchedResults<Item>)
    {
        NSLog("will start")
        self.connection.stateUpdateHandler = self.didChange(state:)
        self.startReceive(coreData: data)
        self.connection.start(queue: .main)
    }
    
    func restart()
    {
        self.connection.restart()
    }
    
    func stop()
    {
        self.connection.cancel()
        NSLog("did stop")
    }
    
    private func didChange(state: NWConnection.State)
    {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            NSLog("is waiting: %@", "\(error)")
        case .preparing:
            break
        case .ready:
            connection_status = true
            break
        case .failed(let error):
            NSLog("did fail, error: %@", "\(error)")
            connection_status = false
            self.stop()
        case .cancelled:
            NSLog("was cancelled")
            connection_status = false
            //self.stop()
        @unknown default:
            break
        }
    }
    
    private func startReceive(coreData: FetchedResults<Item>)
    {
        self.connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [self] data, _, isDone, error in
            if let data = data, !data.isEmpty {
                self.rec_val = String(data: data, encoding: .utf8)!
                
                if self.textstorage.count > self.textstorage_max
                {
                    for _ in 1...self.rec_val.count
                    {
                        self.textstorage.remove(at: self.textstorage.startIndex)
                    }

                }
                self.textstorage = self.textstorage + self.rec_val
                self.rec_val_state = true
                
                updateCoreData(data: coreData, dataToSave: self.rec_val, context: context!)
                
                print("Recieved data \(self.rec_val)")
            }
            if let error = error {
                NSLog("did receive, error: %@", "\(error)")
                self.stop()
                return
            }
            if isDone {
                NSLog("did receive, EOF")
                self.stop()
                return
            }
            // Only recieve once so this is uneeded
            //self.startReceive()
        }
    }

    
    /// Sends data to the server
    /// - Parameter line: The string data to send to the server
    func send(line: String)
    {
        let data = Data("\(line)\r\n".utf8)
        self.connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                NSLog("did send, error: %@", "\(error)")
                self.stop()
            } else {
                NSLog("did send, data: %@", data as NSData)
            }
        })
    }
}
