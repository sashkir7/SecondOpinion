//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class HomePresenter {

    typealias Dependencies = Any

    weak var view: HomeViewInput?
    weak var output: HomeModuleOutput?

    var state: HomeState

    private let dependencies: Dependencies

    init(state: HomeState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: -  HomeViewOutput

extension HomePresenter: HomeViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }
}

// MARK: -  HomeModuleInput

extension HomePresenter: HomeModuleInput {

    func update(animated: Bool) {
        let viewModel = HomeViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
