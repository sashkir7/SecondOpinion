//
//  Created by Alexander Kireev on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import RxSwift

final class LoginPresenter {

    typealias Dependencies = HasAuthService

    weak var view: LoginViewInput?
    weak var output: LoginModuleOutput?

    var state: LoginState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: LoginState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = state.email.isValidEmail &&
            state.password.isValidPassword
        update(animated: false)
    }
}

// MARK: -  LoginViewOutput

extension LoginPresenter: LoginViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func emailInputChanged(_ input: String) {
        state.email = input
        validate()
    }

    func passwordInputChanged(_ input: String) {
        state.password = input
        validate()
    }

    func resetPasswordActionTriggered() {
        output?.loginModuleDidRequestResetPassword(self)
    }

    func logInActionTriggered() {
        dependencies.authService
            .signInObservable(withEmail: state.email.lowercased(), password: state.password)
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onCompleted { [unowned self] in
                self.output?.loginModuleDidComplete(self)
            }
            .onError { [unowned self] error in
                self.state.isLoading = false
                self.output?.loginModule(self, didFailWith: error)
            }
            .onDispose { [weak self] in
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)
    }
}

// MARK: -  LoginModuleInput

extension LoginPresenter: LoginModuleInput {

    func update(animated: Bool) {
        let viewModel = LoginViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
