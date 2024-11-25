//
//  ContactsTableViewCell.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import UIKit

class VisitedCafesTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var cafeNameLabel: UILabel!
    var starRating: StarRatingView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupStarRating()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        cafeNameLabel = UILabel()
        cafeNameLabel.font = UIFont.systemFont(ofSize: 20)
        cafeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(cafeNameLabel)
    }
    
    func setupStarRating() {
        starRating = StarRatingView(rating: 0)
        starRating.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(starRating)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            cafeNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            cafeNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            starRating.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 110),
            starRating.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            starRating.heightAnchor.constraint(equalToConstant: 40),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
