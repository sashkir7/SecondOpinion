//
//  Created by Alexander Kireev on 19/10/2020
//  Copyright © 2020 RonasIT. All rights reserved.
//

import RxSwift

final class ResetPasswordPresenter {

    typealias Dependencies = HasAuthService

    weak var view: ResetPasswordViewInput?
    weak var output: ResetPasswordModuleOutput?

    var state: ResetPasswordState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: ResetPasswordState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = state.email.isValidEmail
        update(animated: false)
    }
}

// MARK: -  ResetPasswordViewOutput

extension ResetPasswordPresenter: ResetPasswordViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func emailInputChanged(_ input: String) {
        state.email = input
        validate()
    }

    func resetPasswordActionTriggered() {
        dependencies.authService
            .resetPasswordObservable(withEmail: state.email.lowercased())
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onCompleted { [unowned self] in
                self.output?.resetPasswordModule(self, didCompleteWithEmail: self.state.email.lowercased())
            }
            .onError { [unowned self] error in
                print(error)
                self.output?.resetPasswordModule(self, didFailWith: error)
            }
            .onDispose { [weak self] in
                self?.state.isLoading = false
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)
    }
}

// MARK: -  ResetPasswordModuleInput

extension ResetPasswordPresenter: ResetPasswordModuleInput {

    func update(animated: Bool) {
        let viewModel = ResetPasswordViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
