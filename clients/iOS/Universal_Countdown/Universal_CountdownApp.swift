//
//  Universal_CountdownApp.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/11/23.
//

import SwiftUI

@main
struct Universal_CountdownApp: App {
    let persistenceController = PersistenceController.shared
    private let actionService = ActionService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(actionService)
        }
    }
}
