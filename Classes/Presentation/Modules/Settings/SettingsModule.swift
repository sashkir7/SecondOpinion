//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol SettingsModuleInput: class {
    var state: SettingsState { get }
    func update(animated: Bool)
}

protocol SettingsModuleOutput: class {}

final class SettingsModule {

    var input: SettingsModuleInput {
        return presenter
    }
    weak var output: SettingsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: SettingsViewController
    private let presenter: SettingsPresenter

    init(state: SettingsState = .init()) {
        let viewModel = SettingsViewModel(state: state)
        let presenter = SettingsPresenter(state: state, dependencies: ServiceContainer())
        let viewController = SettingsViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
