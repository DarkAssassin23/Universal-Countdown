//
//  AppDelegate.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/13/23.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate
{
    private let actionService = ActionService.shared

    // Hooks into an event triggered when the app is about
    // launch the main UI
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration
    {
        // If shortcutItem is present, that means the app was
        // launched via a Quick Action and needs to be handled
        if let shortcutItem = options.shortcutItem
        {
            actionService.action = Action(shortcutItem: shortcutItem)
        }

        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate
{
    private let actionService = ActionService.shared

    // Hooks into events that trigger when a user interacts
    // with Quick Actions after the app has already launched
    // for example when it is in the background
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    )
    {
        // Convert the shortcut item into an action
        actionService.action = Action(shortcutItem: shortcutItem)
        completionHandler(true)
    }
}
