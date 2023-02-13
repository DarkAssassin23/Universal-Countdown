//
//  SettingsView.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/12/23.
//

import SwiftUI

enum SaveSettingsStatusCode
{
    case success
    case badServerIP
    case badServerPort
    case failedSave
    case unknown
}

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.lastUpdated, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var ip = ""
    @State private var port = ""
    @State private var occasion = ""
    @State private var showingAlert = false
    @State private var alertMessageType = SaveSettingsStatusCode.unknown
    
    var body: some View {
        VStack()
        {
            Text("Settings")
                .font(.largeTitle)
            Spacer()
            Grid(alignment:.leading)
            {
                GridRow
                {
                    Text("Server IP:")
                    TextField("\(items.last!.ip ?? "127.0.0.1")", text: $ip)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(Color.red)
                        .keyboardType(.decimalPad)
                        
                }
                .padding(.horizontal)
                GridRow
                {
                    Text("Server Port:")
                    TextField(String(items.last!.port), text: $port)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(Color.red)
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                GridRow
                {
                    Text("Occasion:")
                    TextField("\(items.last!.occasion ?? "Fun Times!")", text: $occasion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(Color.red)
                }.padding(.horizontal)
            }
            .padding()
            Button(action: saveSettings)
            {
                Text("Save")
            }.alert(isPresented: $showingAlert)
            {
                switch alertMessageType
                {
                case SaveSettingsStatusCode.success:
                    return Alert(title: Text("Success"), message: Text("Your settings saved successfully"),dismissButton: .default(Text("ok")))
                case SaveSettingsStatusCode.badServerIP:
                    return Alert(title: Text("Failed up update settings"),message: Text("The IP address provided for the server is invalid"), dismissButton: .default(Text("ok")))
                case SaveSettingsStatusCode.badServerPort:
                    return Alert(title: Text("Failed up update settings"),message: Text("The port number provided for the server is invalid"), dismissButton: .default(Text("ok")))
                case SaveSettingsStatusCode.failedSave:
                    return Alert(title: Text("Failed up update settings"),message: Text("An error occured trying to save your settings to CoreData"), dismissButton: .default(Text("ok")))
                default:
                    return Alert(title: Text("Error"), message: Text("An unknown error has occured"),dismissButton: .default(Text("ok")))
                }
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    private func saveSettings()
    {
        showingAlert = true
        
        if(ip != "")
        {
            if(!isValidIP(ip: ip))
            {
                alertMessageType = SaveSettingsStatusCode.badServerIP
                return
            }
            items.last!.ip = ip
            ip = ""
        }
        if(port != "")
        {
            let userInputPort = validatePort(port: port)
            if (userInputPort == -1)
            {
                alertMessageType = SaveSettingsStatusCode.badServerPort
                return
            }
            items.last!.port = Int32(userInputPort)
            port = ""
        }
        if(occasion != "")
        {
            items.last!.occasion = occasion
            occasion = ""
        }
        
        do
        {
            try viewContext.save()
        }
        catch let error
        {
            print(error)
            alertMessageType = SaveSettingsStatusCode.failedSave
        }
        alertMessageType = SaveSettingsStatusCode.success
        hideKeyboard()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
