//
//  QuickActions.swift
//  Universal_Countdown
//
//  Created by DarkAssassin23 on 2/13/23.
//

import Foundation
import UIKit


/// Types of supported Quick Actions as a string
enum ActionType: String
{
    case update = "Update"
    case settings = "Settings"
}


/// Convert types of quick actions to enums
enum Action: Equatable
{
    case update
    case settings

    init?(shortcutItem: UIApplicationShortcutItem)
    {
        guard let type = ActionType(rawValue: shortcutItem.type) else
        {
            return nil
        }
        
        switch type
        {
        case .update:
            self = .update
        case .settings:
            self = .settings
        }
    }
}


class ActionService: ObservableObject
{
    static let shared = ActionService()

    @Published var action: Action?
}
