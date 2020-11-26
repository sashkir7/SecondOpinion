//
//  Created by Dmitry Surkov on 07/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import RxSwift

final class SplashPresenter {

    typealias Dependencies = HasProfileService

    weak var view: SplashViewInput?
    weak var output: SplashModuleOutput?

    var state: SplashState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: SplashState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: -  SplashViewOutput

extension SplashPresenter: SplashViewOutput {

    func viewDidLoad() {
        state.isLoading = true
        update(animated: false)

        dependencies.profileService.fetchProfileObservable()
            .onCompleted { [unowned self] in
                self.state.isLoading = false
                self.update(animated: false)

                self.output?.splashModuleDidValidateSession(self)
            }
            .onError { [unowned self] _ in
                self.state.isLoading = false
                self.update(animated: false)

                self.output?.splashModuleDidFail(self)
            }
            .subscribeAndDisposed(by: disposeBag)
    }
}

// MARK: -  SplashModuleInput

extension SplashPresenter: SplashModuleInput {

    func update(animated: Bool) {
        let viewModel = SplashViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
