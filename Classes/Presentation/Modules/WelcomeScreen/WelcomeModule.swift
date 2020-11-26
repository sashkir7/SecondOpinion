//
//  Created by Alexander Kireev on 06/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol WelcomeModuleInput: class {
    var state: WelcomeState { get }
    func update(animated: Bool)
}

protocol WelcomeModuleOutput: class {
    func welcomeModuleDidRequestSignUp(_ moduleInput: WelcomeModuleInput)
    func welcomeModuleDidRequestLogIn(_ moduleInput: WelcomeModuleInput)
}

final class WelcomeModule {

    var input: WelcomeModuleInput {
        return presenter
    }
    weak var output: WelcomeModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: WelcomeViewController
    private let presenter: WelcomePresenter

    init(state: WelcomeState = .init()) {
        let viewModel = WelcomeViewModel(state: state)
        let presenter = WelcomePresenter(state: state, dependencies: ServiceContainer())
        let viewController = WelcomeViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
