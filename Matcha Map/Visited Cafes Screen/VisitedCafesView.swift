//
//  RegisterView.swift
//  App12
//
//  Created by Sakib Miazi on 6/2/23.
//

import UIKit

class VisitedCafesView: UIView {
    var visitedCafesTableView: UITableView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupVisitedCafesTableView()
        
        initConstraints()
    }
    
    
    //MARK: the table view to show the list of cafes...
    func setupVisitedCafesTableView() {
        visitedCafesTableView = UITableView()
        visitedCafesTableView.register(VisitedCafesTableViewCell.self, forCellReuseIdentifier: "visitedCafes")
        visitedCafesTableView.translatesAutoresizingMaskIntoConstraints = false
        visitedCafesTableView.separatorStyle = .none
        self.addSubview(visitedCafesTableView)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            visitedCafesTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            visitedCafesTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            visitedCafesTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            visitedCafesTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
