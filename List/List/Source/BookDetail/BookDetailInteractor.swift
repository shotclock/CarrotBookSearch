//
//  BookDetailInteractor.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import Foundation
import Base
import DomainInterface

// 뷰모델 -> 라우터
protocol BookDetailRoutable: Routable {
    func routeToExternalURL(_ url: URL)
}

// 뷰모델 -> 뷰 컨트롤러
protocol BookDetailViewControllerPresentable: AnyObject {
    var listener: BookDetailViewControllerListener? { get set }
    
    func updateBookDetail(to data: BookDetail)
}

final class BookDetailInteractor: Interactor<BookDetailViewControllerPresentable>, BookDetailInteractable {
    struct Usecase {
        let fetchBookDetailUsecase: FetchBookDetailUsecase
    }
    
    weak var router: BookDetailRoutable?
    weak var listener: BookDetailListener?
    
    private let usecases: Usecase
    private let isbn13: String
    
    init(presenter: BookDetailViewControllerPresentable?,
         usecases: Usecase,
         isbn13: String) {
        self.isbn13 = isbn13
        self.usecases = usecases
        super.init(presenter: presenter)
        
        presenter?.listener = self
    }
    
    override func attached() {
        super.attached()
        
        fetchBookDetail()
    }
    
    override func detached() {
        super.detached()
        
        // TaskCancel 추가
    }
    
    private func fetchBookDetail() {
        Task { @MainActor in
            do {
                let data = try await usecases.fetchBookDetailUsecase.execute(isbn13: isbn13)
                
                presenter?.updateBookDetail(to: data)
            } catch {
                // error
                print(error.localizedDescription)
            }
        }
    }
}

extension BookDetailInteractor: BookDetailViewControllerListener {
    func didTapOpenLinkButton(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        router?.routeToExternalURL(url)
    }
}
