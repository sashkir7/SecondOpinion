//
//  Created by Alexander Kireev on 06/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class WelcomePresenter {

    typealias Dependencies = Any

    weak var view: WelcomeViewInput?
    weak var output: WelcomeModuleOutput?

    var state: WelcomeState

    private let dependencies: Dependencies

    init(state: WelcomeState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: -  SignInViewOutput

extension WelcomePresenter: WelcomeViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func signUpActionTriggered() {
        output?.welcomeModuleDidRequestSignUp(self)
    }

    func logInActionTriggered() {
        output?.welcomeModuleDidRequestLogIn(self)
    }
}

// MARK: -  SignInModuleInput

extension WelcomePresenter: WelcomeModuleInput {

    func update(animated: Bool) {
        let viewModel = WelcomeViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
