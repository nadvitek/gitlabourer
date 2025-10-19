import Foundation
import SwiftUI
import GitLabourerUI

extension AppFlowCoordinator {
    func setupAppearance() {
        
        // Customize tab bar colors
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Background color
        appearance.backgroundColor = GitLabourerUIAsset.gitlabDark.color
        
        // Selected item colors
        let selectedColor = GitLabourerUIAsset.gitlabOrangeTwo.color
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        // Unselected item colors
        let unselectedColor = GitLabourerUIAsset.gitlabGray.color
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        appearance.inlineLayoutAppearance.normal.iconColor = unselectedColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        appearance.compactInlineLayoutAppearance.normal.iconColor = unselectedColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.unselectedItemTintColor = unselectedColor
    }
}

extension ContentView {
    func setupAppearance() {

        // Customize tab bar colors
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Background color
        appearance.backgroundColor = GitLabourerUIAsset.gitlabDark.color

        // Selected item colors
        let selectedColor = GitLabourerUIAsset.gitlabOrangeTwo.color
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        // Unselected item colors
        let unselectedColor = GitLabourerUIAsset.gitlabGray.color
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        appearance.inlineLayoutAppearance.normal.iconColor = unselectedColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        appearance.compactInlineLayoutAppearance.normal.iconColor = unselectedColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.unselectedItemTintColor = unselectedColor
    }
}
