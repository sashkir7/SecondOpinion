//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import RxSwift

final class ConsultationUploadFilesPresenter {

    typealias Dependencies = HasConsultationService & HasMediaService

    weak var view: ConsultationUploadFilesViewInput?
    weak var output: ConsultationUploadFilesModuleOutput?

    var state: ConsultationUploadFilesState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: ConsultationUploadFilesState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func createConsultation() {
        dependencies.consultationService
            .createConsultation(with: state.createdConsultationParameters)
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onCompleted { [unowned self] in
                self.output?.consultationUploadFilesModuleDidComplete(self)
            }
            .onError { [unowned self] error in
                self.state.isLoading = false
                self.output?.consultationUploadFilesModule(self, didFailWith: error)
            }
            .onDispose { [weak self] in
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)
    }

    private func addFiles() {
        output?.consultationUploadFilesModuleShowActionSheet(self)
    }
}

// MARK: -  ConsultationUploadFilesViewOutput

extension ConsultationUploadFilesPresenter: ConsultationUploadFilesViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func closeActionTriggered() {
        output?.consultationUploadFilesModuleDidCancel(self)
    }

    func skipOrAddFileActionTriggered() {
        state.uploadFiles.isEmpty ?
            createConsultation() :
            addFiles()
    }

    func addOrConfirmActionTriggered() {
        state.uploadFiles.isEmpty ?
            addFiles() :
            createConsultation()
    }
}

// MARK: -  ConsultationUploadFilesModuleInput

extension ConsultationUploadFilesPresenter: ConsultationUploadFilesModuleInput {

    func update(animated: Bool) {
        let viewModel = ConsultationUploadFilesViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }

    func update(withSeletedImage image: UIImage) {

        dependencies.mediaService
            .uploadImageObservable(image, maxDimension: 100000, mimeType: .jpeg)
            .subscribe {
                print($0)
            }

//        state.uploadFiles.append(image)
//        update(animated: false)
    }
}

//
