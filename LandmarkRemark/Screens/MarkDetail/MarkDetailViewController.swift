//
//  MarkDetailViewController.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit

struct MarkDetailViewControllerModel {
    
    let heading: String
    let title: String
    let note: String
}

final class MarkDetailViewController: UIViewController {
    
    private let model: MarkDetailViewControllerModel
    private let horizontalPadding: CGFloat = 16
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var noteTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textAlignment = .justified
        view.textColor = .gray
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
        view.isEditable = false
        
        return view
    }()
    
    init(model: MarkDetailViewControllerModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(noteTextView)
        
        layout()
        prepareViewModel()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalPadding),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalPadding),
            noteTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            noteTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalPadding),
            noteTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalPadding),
            noteTextView.bottomAnchor.constraint(equalTo: viewSafeBottomAnchor)
        ])
    }
    
    private func prepareViewModel() {
        title = model.heading
        titleLabel.text = model.title
        noteTextView.text = model.note
    }
}
