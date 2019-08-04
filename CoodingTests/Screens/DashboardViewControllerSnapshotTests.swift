//
//  DashboardViewControllerSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class DashboardControllerSnapshotTests: XCTestCase {
    private var sut: DashboardTabBarController!
    private var dataStore: EphemeralKeyValueStore!
    private var downloaderMock: DownloaderMock<RecipeList>!
    
    override func setUp() {
        super.setUp()
        dataStore = EphemeralKeyValueStore()
        downloaderMock = DownloaderMock<RecipeList>()
    }
    
    func testInitialLook_WhenDataLoaded() {
        downloaderMock.simulateSuccess(with: RecipeList.default)
        sut = DashboardTabBarController(viewModel: DashboardViewModel(storage: dataStore, downloader: downloaderMock))
        sut.apply(theme: DefaultTheme())
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
    
    func testInitialLook_WhenError() {
        sut = DashboardTabBarController(viewModel: DashboardViewModel(storage: dataStore, downloader: downloaderMock))
        sut.apply(theme: DefaultTheme())
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }

}
