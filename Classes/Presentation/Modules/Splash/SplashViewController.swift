//
//  Created by Dmitry Surkov on 07/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import Framezilla

protocol SplashViewInput: class {
    @discardableResult
    func update(with viewModel: SplashViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol SplashViewOutput: class {
    func viewDidLoad()
}

final class SplashViewController: UIViewController {

    private(set) var viewModel: SplashViewModel
    let output: SplashViewOutput

    var needsUpdate: Bool = true

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.icLogo.image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: -  Lifecycle

    init(viewModel: SplashViewModel, output: SplashViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        view.backgroundColor = .eveningSea
        view.addSubviews(logoImageView, activityIndicator)

        output.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topInsetRatio: CGFloat = 306 / view.frame.height
        let imageSize = logoImageView.image!.size

        logoImageView.configureFrame { maker in
            maker.size(width: imageSize.width,
                       height: imageSize.height)
            maker.top(inset: view.bounds.height * topInsetRatio).centerX()
        }

        activityIndicator.configureFrame { maker in
            maker.centerY(between: logoImageView.nui_centerY, view.nui_bottom)
            maker.centerX()
        }
    }
}

// MARK: -  SplashViewInput

extension SplashViewController: SplashViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: SplashViewModel, animated: Bool) -> Bool {

        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        // update view
        func update<Value: Equatable>(keyPath: KeyPath<SplashViewModel, Value>, configureHandler: (Value) -> Void) {
            self.update(new: viewModel, old: oldViewModel, keyPath: keyPath, configureBlock: configureHandler)
        }

        update(keyPath: \.isLoading) { isLoading in
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }

        needsUpdate = false

        return true
    }
}
