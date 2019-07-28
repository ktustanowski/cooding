import XCTest
import SnapshotTesting

extension XCTestCase {
    /// In test file names saved to disk:
    /// 1 - iPhoneSe
    /// 2 - iPhone 8
    /// 3 - iPhone8Plus
    /// 4 - iPhone X
    /// 5 - iPhone Xs Max
    var defaultDevices: [ViewImageConfig] {
        return [ViewImageConfig.iPhoneSe,
                ViewImageConfig.iPhone8,
                ViewImageConfig.iPhone8Plus,
                ViewImageConfig.iPhoneX,
                ViewImageConfig.iPhoneXsMax,
                ViewImageConfig.iPadMini(.portrait)]
    }

    /// Snapshots by default just get an image of a view of a view controller. Use this function if you need
    /// to snapshot something that is overlying the view controller but is not exactly in its view hierarchy.
    /// Example uf use, this was done for this in the first palce, snapshotting alerts presented over the view controller.
    /// Additionally because showing of the alert takes some time there is small delay to make sure it's on screen before
    /// making a snapshot.
    ///
    /// - Parameters:
    ///   - viewController: view controller used in test
    ///   - whenClosure: code that triggers whatever is tested
    ///   - waitInterval: wait interval between executing when closure and actually making a snapshot
    ///   - size: size of a window
    ///   - timeout: expectation timeout - should be larger than wait interval
    ///   - file: something to pass to assert function so then it does highlighting etc. properly in the place of execution and not inside helper function
    ///   - testName: something to pass to assert function so then it does highlighting etc. properly in the place of execution and not inside helper function
    ///   - line: something to pass to assert function so then it does highlighting etc. properly in the place of execution and not inside helper function
    func assertSnapshotInWindow(viewController: UIViewController,
                                whenClosure: (() -> Void)? = nil,
                                waitInterval: TimeInterval = 0.2,
                                size: CGSize = CGSize(width: 375, height: 667),
                                timeout: TimeInterval = 2.0,
                                file: StaticString = #file,
                                testName: String = #function,
                                line: UInt = #line) {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        let waitExpectation = expectation(description: "delayed_snapshot")

        DispatchQueue.main.asyncAfter(deadline: .now() + waitInterval) {
            assertSnapshot(matching: window.layer, as: .image, file: file, testName: testName, line: line)
            waitExpectation.fulfill()
        }

        whenClosure?()
        wait(for: [waitExpectation], timeout: timeout)
    }
}
