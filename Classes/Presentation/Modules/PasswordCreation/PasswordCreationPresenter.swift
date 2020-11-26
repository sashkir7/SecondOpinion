//
//  Created by Dmitry Surkov on 19/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import RxSwift

final class PasswordCreationPresenter {

    typealias Dependencies = HasAuthService

    weak var view: PasswordCreationViewInput?
    weak var output: PasswordCreationModuleOutput?

    var state: PasswordCreationState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: PasswordCreationState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = state.newPassword == state.passwordConfirmation &&
                        state.newPassword.count > 7 &&
                        state.passwordConfirmation.count > 7
        update(animated: false)
    }
}

// MARK: -  PasswordCreationViewOutput

extension PasswordCreationPresenter: PasswordCreationViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func newPasswordInputChanged(_ input: String) {
        state.newPassword = input
        validate()
    }

    func passwordConfirmationInputChanged(_ input: String) {
        state.passwordConfirmation = input
        validate()
    }

    func createNewPasswordActionTriggered() {
        let parameters = RestoreParameters(password: state.passwordConfirmation, token: state.token)
        dependencies.authService
            .restorePasswordObservable(with: parameters)
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onCompleted { [unowned self] in
                self.output?.passwordCreationModuleDidComplete(self)
            }
            .onError { [unowned self] error in
                self.output?.passwordCreationModule(self, didFailWith: error)
            }
            .onDispose { [weak self] in
                self?.state.isLoading = false
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)
    }
}

// MARK: -  PasswordCreationModuleInput

extension PasswordCreationPresenter: PasswordCreationModuleInput {

    func update(animated: Bool) {
        let viewModel = PasswordCreationViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
