//
//  RecipeViewControllerSNapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class RecipeViewControllerSnapshotTests: XCTestCase {
    private var sut: RecipeContainerViewController!
    private var downloaderMock: DownloaderMock<Recipe>!
    
    override func setUp() {
        super.setUp()
        downloaderMock = DownloaderMock<Recipe>()
        sut = RecipeContainerViewController()
        sut.viewModel = RecipeContainerViewModel(shortRecipe: ShortRecipe(name: "Pancakes",
                                                                          sourceURL: URL(string: "https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json")!,
                                                                          imageURL: URL(string: "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg")!),
                                                 downloader: downloaderMock)        
    }
    
    func testInitialLook_WhenDataLoaded() {
        downloaderMock.simulateSuccess(with: Recipe.pancakes)
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
    
    func testInitialLook_WhenLoadingFailed() {
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }

}
