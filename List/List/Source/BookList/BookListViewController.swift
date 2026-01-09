//
//  BookListViewController.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import UIKit
import Base

// 뷰 컨트롤러 -> 뷰모델
protocol BookListViewControllerListener: AnyObject {
    
}

final class BookListViewController: UIViewController, BookListViewControllable, BookListViewControllerPresentable {
    // MARK: Definition
    
    // MARK: Properties
    weak var listener: BookListViewControllerListener?

    // MARK: initializer
    deinit {
        print(#fileID, #line, #function)
    }
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: UI setting
    private func setupUI() {
        
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
}

