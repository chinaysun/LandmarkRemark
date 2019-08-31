//
//  NewMarkViewController.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import RxSwift
import UIKit

final class NewMarkViewController: UIViewController {

    private let viewModel: NewMarkViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save")
        button.isEnabled = false

        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leave your footprint here..."
        
        return label
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.enablesReturnKeyAutomatically = true
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    init(location: Location) {
        self.viewModel = NewMarkViewModel(location: location)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(textView)
        
        layout()
        prepareNavigationBar()
        prepareBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func prepareNavigationBar() {
        navigationItem.backBarButtonItem = .empty
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func prepareBindings() {
        textView.rx.didChange
            .compactMap { [weak self] _ in self?.textView.text }
            .map { !$0.isEmpty }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.screenTitle
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        // TODO: - Fixing somehow dismiss is not working here since home viewController
        // is not remaining on the view hirearchy stack
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.saveComment(self.textView.text)
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
