//
//  ContentView.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Needed to handle quick actions from the home screen
    @EnvironmentObject var actionService: ActionService
    @Environment(\.scenePhase) var scenePhase
    @State var settingsQuickAction: Bool = false
    @State private var path = NavigationPath()
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.lastUpdated, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack(path: $path)
        {
            VStack
            {
                VStack
                {
                    Text("Universal Countdown")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    HStack
                    {
                        Image("clock")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .padding()
                    }
                }
                //Spacer()
                VStack(alignment: .leading)
                {
                    Text("Time remaining until \(items.last?.occasion ?? "n/a" ):")
                        .font(.title2)
                    Text("(as of \(dateToString(date: items.last?.lastUpdated ?? Date.now)))")
                        .font(.caption)
                    if((items.last?.done ?? false))
                    {
                        Text("Time is up!!!")
                            .font(.headline)
                    }
                    else
                    {
                        HStack
                        {
                            Text("Days:")
                                .font(.headline)
                            Text(items.last?.days ?? "n/a")
                        }
                        HStack
                        {
                            Text("Hours:")
                                .font(.headline)
                            Text(items.last?.hours ?? "n/a")
                        }
                        HStack
                        {
                            Text("Minutes:")
                                .font(.headline)
                            Text(items.last?.minutes ?? "n/a")
                        }
                        HStack
                        {
                            Text("Seconds:")
                                .font(.headline)
                            Text(items.last?.seconds ?? "n/a")
                        }
                    }
                }.padding()
                .onAppear() {initCoreData()}
                Button(action: connectToServer)
                {
                    Text("Update")
                }
                Spacer()
                
            }.toolbar {
                ToolbarItemGroup(placement: .bottomBar)
                {
                    NavigationLink(destination: SettingsView())
                    {
                        //Text("Settings")
                        VStack(alignment: .center)
                        {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
                }
            }
            .onChange(of: scenePhase)
            {
                newValue in
                switch newValue
                {
                case .active:
                    performActionIfNeeded()
                default:
                    break
                }
            }
            .navigationDestination(for: String.self)
            {
                view in
                if view == "settingsView"
                {
                    SettingsView()
                }
            }
        }
    }

    
    /// Initialize the CoreData, if no data exists, so the app doesn't crash
    /// when trying to access data that does not exist
    private func initCoreData()
    {
        if(items.count == 0)
        {
            let newItem = Item(context: viewContext)
            newItem.lastUpdated = Date()
            newItem.ip = "127.0.0.1"
            newItem.port = 8989
            newItem.occasion = "Fun Times!"

            do
            {
                try viewContext.save()
            }
            catch let error
            {
                print(error)
            }
        }
    }
    
    
    /// Connect via TCP to the server to recieve the latest update
    /// on how much time is remaining
    private func connectToServer()
    {
        withAnimation
        {
            let conn = Network(hostName: items.last!.ip!, port: Int(items.last!.port), context: viewContext)
            conn.start(data: items)
        }
    }
    
    
    /// Check if a Quick Action has been triggered and handle
    /// it accordingly
    private func performActionIfNeeded()
    {
        guard let action = actionService.action else {return}
        // If the action is update, update the time remaining
        switch action
        {
        case .update:
            connectToServer()
        case .settings:
            path.append("settingsView")
        }
        actionService.action = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
