//
//  Created by Alexander Kireev on 19/10/2020
//  Copyright © 2020 RonasIT. All rights reserved.
//

import UIKit

protocol ResetPasswordModuleInput: class {
    var state: ResetPasswordState { get }
    func update(animated: Bool)
}

protocol ResetPasswordModuleOutput: class {
    func resetPasswordModule(_ moduleInput: ResetPasswordModuleInput, didCompleteWithEmail email: String)
    func resetPasswordModule(_ moduleInput: ResetPasswordModuleInput, didFailWith error: Error)
}

final class ResetPasswordModule {

    var input: ResetPasswordModuleInput {
        return presenter
    }
    weak var output: ResetPasswordModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: ResetPasswordViewController
    private let presenter: ResetPasswordPresenter

    init(state: ResetPasswordState = .init()) {
        let viewModel = ResetPasswordViewModel(state: state)
        let presenter = ResetPasswordPresenter(state: state, dependencies: ServiceContainer())
        let viewController = ResetPasswordViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
