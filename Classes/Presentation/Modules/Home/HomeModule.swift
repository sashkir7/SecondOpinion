//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol HomeModuleInput: class {
    var state: HomeState { get }
    func update(animated: Bool)
}

protocol HomeModuleOutput: class {}

final class HomeModule {

    var input: HomeModuleInput {
        return presenter
    }
    weak var output: HomeModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: HomeViewController
    private let presenter: HomePresenter

    init(state: HomeState = .init()) {
        let viewModel = HomeViewModel(state: state)
        let presenter = HomePresenter(state: state, dependencies: ServiceContainer())
        let viewController = HomeViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
