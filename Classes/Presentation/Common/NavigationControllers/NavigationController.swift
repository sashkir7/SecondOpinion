//
//  Created by Alx Krw on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol NavigationControllerAnimationDelegate: class {
    func transitionAnimator(for operation: UINavigationController.Operation,
                            from sourceViewController: UIViewController,
                            to destinationViewController: UIViewController) -> NavigationTransitionAnimator?
}

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    weak var navigationAnimationDelegate: NavigationControllerAnimationDelegate?

    override var delegate: UINavigationControllerDelegate? {
        get {
            return super.delegate
        }
        set(newDelegate) {
            guard let newDelegate = newDelegate, newDelegate is NavigationController else {
                fatalError("""
                NavigationController should be delegate itself to hide backBarButtonItem title!
                To apply custom animations use animationDelegate property instead.
                """)
            }
            super.delegate = newDelegate
        }
    }

    private var transitionContext: UIViewControllerTransitionCoordinatorContext?
    private var navigationBarSnapshot: UIView?

    // MARK: -  Lifecycle

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        interactivePopGestureRecognizer?.delegate = self

        let backIndicatorImage = Asset.icBackVector.image.withAlignmentRectInsets(.init(top: 0, left: -6.widthWithRatio, bottom: 0, right: 0))

        navigationBar.backIndicatorImage = backIndicatorImage
        navigationBar.backIndicatorTransitionMaskImage = backIndicatorImage

        interactivePopGestureRecognizer?.addTarget(self, action: #selector(gestureRecognizerChanged))
    }

    private func initialize() {
        delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutNavigationBarSnapshot()
    }

    private func layoutNavigationBarSnapshot() {
        navigationBarSnapshot?.frame = navigationBar.frame
    }

    private func navigationBarAppearance(for viewController: UIViewController) -> NavigationBarAppearance {
        let appearance: NavigationBarAppearance
        if let viewController = viewController as? NavigationBarAppearanceContainer {
            appearance = viewController.navigationBarAppearance
        } else {
            appearance = navigationBarAppearance
        }
        return appearance
    }

    private func applyNavigationBarAppearance(to viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let appearance = navigationBarAppearance(for: viewController)
        navigationBar.isHidden = appearance.isHidden
        navigationBar.tintColor = appearance.tintColor
        navigationBar.backgroundColor = appearance.backgroundColor
        navigationBar.barTintColor = appearance.barTintColor
        navigationBar.isTranslucent = appearance.isTranslucent
        navigationBar.setBackgroundImage(appearance.backgroundImage, for: .default)
        navigationBar.shadowImage = appearance.shadowImage
        navigationBar.clipsToBounds = false
    }

    private func updateNavigationBarSnapshotAlpha() {
        guard let transitionContext = transitionContext,
              let sourceViewController = transitionContext.viewController(forKey: .from),
              let targetViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        let isSourceHidden = navigationBarAppearance(for: sourceViewController).isHidden
        let isTargetHidden = navigationBarAppearance(for: targetViewController).isHidden
        if isSourceHidden, !isTargetHidden {
            navigationBarSnapshot?.alpha = transitionContext.percentComplete
        } else if !isSourceHidden, isTargetHidden {
            navigationBarSnapshot?.alpha = pow(1 - transitionContext.percentComplete, 3).clamped(to: 0...1)
        } else {
            navigationBarSnapshot?.removeFromSuperview()
            navigationBarSnapshot = nil
        }
    }

    private func removeNavigationBarSnapshot() {
        navigationBarSnapshot?.removeFromSuperview()
        navigationBarSnapshot = nil
    }

    @objc private func gestureRecognizerChanged(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            updateNavigationBarSnapshotAlpha()
        case .ended, .cancelled:
            if let context = transitionContext {
                let completionTime = context.transitionDuration * Double(context.percentComplete)
                UIView.animate(withDuration: completionTime) {
                    self.navigationBarSnapshot?.alpha = 0
                }
            }
        default:
            break
        }
    }
}

// MARK: -  UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if let transitionCoordinator = transitionCoordinator {
            // It's not recommended to snapshot UINavigationBar when it's translucent,
            // because in this case the snapshot doesn't contain area over the UINavigationBar. And it looks split and ugly.
            let isTranslucent = (topViewController ??> navigationBarAppearance(for:))?.isTranslucent ?? false
            let needsSnapshot = !isTranslucent
            if transitionCoordinator.isInteractive, needsSnapshot {
                navigationBarSnapshot = navigationBar.snapshotView(afterScreenUpdates: false)
                if let snapshot = navigationBarSnapshot {
                    view.addSubview(snapshot)
                    layoutNavigationBarSnapshot()
                }
                transitionCoordinator.animate(alongsideTransition: { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
                    self?.transitionContext = context
                    self?.updateNavigationBarSnapshotAlpha()
                }, completion: { [weak self] _ in
                    self?.transitionContext = nil
                    self?.removeNavigationBarSnapshot()
                })
            }
            transitionCoordinator.notifyWhenInteractionChanges { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
                guard let self = self else {
                    return
                }
                guard context.isCancelled, let fromViewController = context.viewController(forKey: .from) else {
                    return
                }
                self.removeNavigationBarSnapshot()
                self.delegate?.navigationController?(self, willShow: fromViewController, animated: animated)
                let completionTime = context.transitionDuration * Double(context.percentComplete)
                DispatchQueue.main.asyncAfter(deadline: .now() + completionTime) {
                    self.delegate?.navigationController?(self, didShow: fromViewController, animated: animated)
                }
            }
        }
        applyNavigationBarAppearance(to: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        applyNavigationBarAppearance(to: viewController)
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return navigationAnimationDelegate?.transitionAnimator(for: operation, from: fromVC, to: toVC)
    }
}

// MARK: -  UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

// MARK: - NavigationBarAppearanceContainer

extension NavigationController: NavigationBarAppearanceContainer {

    var navigationBarAppearance: NavigationBarAppearance {
        return .initial()
    }
}
