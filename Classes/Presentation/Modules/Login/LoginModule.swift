//
//  Created by Alexander Kireev on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol LoginModuleInput: class {
    var state: LoginState { get }
    func update(animated: Bool)
}

protocol LoginModuleOutput: class {
    func loginModuleDidRequestResetPassword(_ moduleInput: LoginModuleInput)
    func loginModuleDidComplete(_ moduleInput: LoginModuleInput)
    func loginModule(_ moduleInput: LoginModuleInput, didFailWith error: Error)
}

final class LoginModule {

    var input: LoginModuleInput {
        return presenter
    }
    weak var output: LoginModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: LoginViewController
    private let presenter: LoginPresenter

    init(state: LoginState = .init()) {
        let viewModel = LoginViewModel(state: state)
        let presenter = LoginPresenter(state: state, dependencies: ServiceContainer())
        let viewController = LoginViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
