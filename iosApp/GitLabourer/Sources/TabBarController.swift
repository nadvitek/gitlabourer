import UIKit
import Foundation

public final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self // to disable weird tab switch animation on iOS 18
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .pad ? .all : .portrait
    }

    public func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        self
    }
}

extension TabBarController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(
        using transitionContext: (any UIViewControllerContextTransitioning)?
    ) -> TimeInterval {
        .zero
    }

    public func animateTransition(
        using transitionContext: any UIViewControllerContextTransitioning
    ) {
        guard let view = transitionContext.view(forKey: .to) else {
            return
        }

        let container = transitionContext.containerView
        container.addSubview(view)

        transitionContext.completeTransition(true)
    }
}
