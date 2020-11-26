//
//  Created by Dmitry Surkov on 07/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol SplashModuleInput: class {
    var state: SplashState { get }
    func update(animated: Bool)
}

protocol SplashModuleOutput: class {
    func splashModuleDidFail(_ moduleInput: SplashModuleInput)
    func splashModuleDidValidateSession(_ moduleInput: SplashModuleInput)
}

final class SplashModule {

    var input: SplashModuleInput {
        return presenter
    }
    weak var output: SplashModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: SplashViewController
    private let presenter: SplashPresenter

    init(state: SplashState = .init()) {
        let viewModel = SplashViewModel(state: state)
        let presenter = SplashPresenter(state: state, dependencies: ServiceContainer())
        let viewController = SplashViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
