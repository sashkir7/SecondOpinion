//
//  Created by Dmitry Surkov on 19/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol PasswordCreationModuleInput: class {
    var state: PasswordCreationState { get }
    func update(animated: Bool)
}

protocol PasswordCreationModuleOutput: class {
    func passwordCreationModuleDidComplete(_ moduleInput: PasswordCreationModuleInput)
    func passwordCreationModule(_ moduleInput: PasswordCreationModuleInput, didFailWith error: Error)
}

final class PasswordCreationModule {

    var input: PasswordCreationModuleInput {
        return presenter
    }
    weak var output: PasswordCreationModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: PasswordCreationViewController
    private let presenter: PasswordCreationPresenter

    init(state: PasswordCreationState) {
        let viewModel = PasswordCreationViewModel(state: state)
        let presenter = PasswordCreationPresenter(state: state, dependencies: ServiceContainer())
        let viewController = PasswordCreationViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
