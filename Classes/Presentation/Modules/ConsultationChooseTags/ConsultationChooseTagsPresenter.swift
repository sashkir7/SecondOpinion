//
//  Created by Alexander Kireev on 23/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import RxSwift

final class ConsultationChooseTagsPresenter {

    typealias Dependencies = HasTagsService

    weak var view: ConsultationChooseTagsViewInput?
    weak var output: ConsultationChooseTagsModuleOutput?

    var state: ConsultationChooseTagsState

    private let dependencies: Dependencies
    private let disposeBag: DisposeBag = .init()

    init(state: ConsultationChooseTagsState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = !state.selectedTags.isEmpty
        update(animated: false)
    }
}

// MARK: -  ConsultationChooseTagsViewOutput

extension ConsultationChooseTagsPresenter: ConsultationChooseTagsViewOutput {

    func viewDidLoad() {
        dependencies.tagsService
            .fetchTagsObservable()
            .onSubscribe { [unowned self] in
                self.state.isLoading = true
                self.update(animated: false)
            }
            .onNext { [unowned self] tags in
                self.state.tags = tags
                self.update(animated: false)
            }
            .onDispose { [weak self] in
                self?.state.isLoading = false
                self?.update(animated: false)
            }
            .subscribeAndDisposed(by: disposeBag)

        update(animated: false)
    }

    func itemSelected(atIndex index: Int) {
        let selectedTag = state.tags[index]

        guard !state.selectedTags.contains(selectedTag) else {
            return
        }
        state.selectedTags.append(selectedTag)
        validate()
    }

    func itemDeselected(atIndex: Int) {
        let deselectedTag = state.tags[atIndex]
        state.selectedTags = state.selectedTags.filter { tag in
            tag != deselectedTag
        }
        validate()
    }

    func closeActionTriggered() {
        output?.consultationChooseTagsModuleDidCancel(self)
    }

    func nextActionTriggered() {
        let selectedTags = state.selectedTags.map { (tag: Tag) in tag.id }
        output?.consultationChooseTagsModuleDidComplete(self, withSelectedTags: selectedTags)
    }
}

// MARK: -  ConsultationChooseTagsModuleInput

extension ConsultationChooseTagsPresenter: ConsultationChooseTagsModuleInput {

    func update(animated: Bool) {
        let viewModel = ConsultationChooseTagsViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
