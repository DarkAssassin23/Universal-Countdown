//
//  Utils.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/12/23.
//

import Foundation
import SwiftUI
import CoreData

extension Int
{
    static func parse(from string: String) -> Int?
    {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension View
{
    func hideKeyboard()
    {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

/// Given a date, convert it to a string
/// - Parameter date: The date to format as a string
/// - Returns: The date formated to look like so: Feb 12, 2023 at 8:30 AM
func dateToString(date: Date) -> String
{
    let dateFormat = DateFormatter()
    dateFormat.dateStyle = .medium
    dateFormat.timeStyle = .short
    let result = dateFormat.string(from: date)
    return result
}


/// Make sure the IP is a valid IP
/// - Parameter ip: The IP address to validate
/// - Returns: If the IP address is valid
func isValidIP(ip: String) -> Bool
{
    let octets = ip.components(separatedBy: ".")
    if(octets.count != 4)
    {
        return false
    }
    for octet in octets
    {
        if let num = Int.parse(from: octet)
        {
            if(num < UInt8.min || num >= UInt8.max)
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    return true
}

/// Make sure the port is a valid port number
/// - Parameter port: The port number to validate as a string
/// - Returns: The port number as an int, if it is valid, otherwise -1
func validatePort(port: String) -> Int
{
    var portNumber = -1
    if let portNum = Int.parse(from: port)
    {
        if(portNum >= UInt16.min && portNum <= UInt16.max)
        {
            portNumber = portNum
        }
    }
    return portNumber
}

/// Update the CoreData with the latest data
/// - Parameters:
///   - data: The CoreData object to update
///   - dataToSave: The string of text the CoreData will be updated from
///   - context: NSManagedObjectContext to allow the CoreData to be written
func updateCoreData(data: FetchedResults<Item>, dataToSave: String, context: NSManagedObjectContext)
{
    let prevChange = data.last!.lastUpdated
    let comps = dataToSave.components(separatedBy: ",")
    if(comps.count == 1 && dataToSave != "")
    {
        data.last!.done = true
        data.last!.lastUpdated = Date.now
    }
    else if(comps.count > 1)
    {
        data.last!.done = false
        data.last!.lastUpdated = Date.now
        
        let DAYS = 0
        let HRS = 1
        let MIN = 2
        let SEC = 3
        
        var temp = comps[DAYS].components(separatedBy: " ")
        data.last!.days = temp[temp.count-2]
        
        temp = comps[HRS].components(separatedBy: " ")
        data.last!.hours = temp[temp.count-2]
        
        temp = comps[MIN].components(separatedBy: " ")
        data.last!.minutes = temp[temp.count-2]
        
        temp = comps[SEC].components(separatedBy: " ")
        data.last!.seconds = temp[temp.count-2]
    }
    if(prevChange != data.last!.lastUpdated)
    {
        do
        {
            try context.save()
        }
        catch let error
        {
            print(error)
        }
    }
}
