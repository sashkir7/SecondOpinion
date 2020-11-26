//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class SettingsPresenter {

    typealias Dependencies = Any

    weak var view: SettingsViewInput?
    weak var output: SettingsModuleOutput?

    var state: SettingsState

    private let dependencies: Dependencies

    init(state: SettingsState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: -  SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }
}

// MARK: -  SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {

    func update(animated: Bool) {
        let viewModel = SettingsViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
