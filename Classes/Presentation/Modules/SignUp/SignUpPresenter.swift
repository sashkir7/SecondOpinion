//
//  Created by Dmitry Surkov on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import RxSwift

final class SignUpPresenter {

    typealias Dependencies = HasAuthService

    weak var view: SignUpViewInput?
    weak var output: SignUpModuleOutput?

    var state: SignUpState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: SignUpState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = state.firstName.isValidName &&
                        state.lastName.isValidName &&
                        state.email.isValidEmail &&
                        state.password.isValidPassword
        update(animated: false)
    }
}

// MARK: -  SignUpViewOutput

extension SignUpPresenter: SignUpViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func firstNameInputChanged(_ input: String) {
        state.firstName = input
        validate()
    }

    func lastNameInputChanged(_ input: String) {
        state.lastName = input
        validate()
    }

    func emailInputChanged(_ input: String) {
        state.email = input
        validate()
    }

    func passwordInputChanged(_ input: String) {
        state.password = input
        validate()
    }

    func createAccountActionTriggered() {
        state.isLoading = true
        update(animated: false)

        let parameters = SignUpParameters(
            firstName: state.firstName,
            lastName: state.lastName,
            email: state.email,
            password: state.password
        )

        dependencies.authService.signUpObservable(with: parameters)
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onCompleted { [unowned self] in
                self.output?.signUpModuleDidComplete(self)
            }
            .onError { [unowned self] error in
                self.output?.signUpModule(self, didFailWith: error)
            }
            .onDispose { [weak self] in
                self?.state.isLoading = false
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)
    }

    func termsAndConditionsActionTriggered() {
        output?.signUpModuleDidRequestTermsAndConditions(self)
    }
}

// MARK: -  SignUpModuleInput

extension SignUpPresenter: SignUpModuleInput {

    func update(animated: Bool) {
        let viewModel = SignUpViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
