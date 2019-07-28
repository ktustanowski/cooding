import UIKit

extension UIButton {
    /// Use to simulate button taps so we don't have to expose underlying methods.
    /// This takes first target and first action for touch up inside - ONLY!
    func simulateTap() {
        guard let target = allTargets.first as NSObject?,
            let action = actions(forTarget: target, forControlEvent: .touchUpInside)?.first else {
                assertionFailure("Button doesn't have action set up properly")
                return }

        let selector = NSSelectorFromString(action)
        let isWithSender = action.contains(":")

        if isWithSender {
            target.perform(selector, with: UIButton())
        } else {
            target.perform(selector)
        }
    }
}
