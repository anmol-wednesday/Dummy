//
//  CatCollectionViewCell.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {

	lazy var containerView: UIView = {
		let someView = UIView()
		someView.translatesAutoresizingMaskIntoConstraints = false
		someView.backgroundColor = .white
		someView.layer.cornerRadius = 16
		return someView
	}()
	
	lazy var catImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 16
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		addSubview(containerView)
		containerView.addSubview(catImageView)
		
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -16),
			self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
			self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -8),
			self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
			
			catImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			catImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
			catImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			catImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
		])
	}
}
