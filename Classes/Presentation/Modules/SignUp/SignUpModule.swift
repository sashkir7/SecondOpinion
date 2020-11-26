//
//  Created by Dmitry Surkov on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol SignUpModuleInput: class {
    var state: SignUpState { get }
    func update(animated: Bool)
}

protocol SignUpModuleOutput: class {
    func signUpModuleDidComplete(_ moduleInput: SignUpModuleInput)
    func signUpModuleDidRequestTermsAndConditions(_ moduleInput: SignUpModuleInput)
    func signUpModule(_ moduleInput: SignUpModuleInput, didFailWith error: Error)
}

final class SignUpModule {

    var input: SignUpModuleInput {
        return presenter
    }
    weak var output: SignUpModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: SignUpViewController
    private let presenter: SignUpPresenter

    init(state: SignUpState = .init()) {
        let viewModel = SignUpViewModel(state: state)
        let presenter = SignUpPresenter(state: state, dependencies: ServiceContainer())
        let viewController = SignUpViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
