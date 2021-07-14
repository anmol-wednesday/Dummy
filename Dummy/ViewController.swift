//
//  ViewController.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var collectionView: UICollectionView!
	var catData = [Cat]() {
		didSet {
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
			}
		}
	}
	var imageCacher = [Int: UIImage]()
	let networking = Networking()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		self.networking.getCatData { response in
			self.catData = response
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.size.width, height: 250)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return catData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! CatCollectionViewCell
		let cat = catData[indexPath.row]
		
		if imageCacher[indexPath.row] == nil {
			guard let url = URL(string: cat.url) else {
				return cell
			}
			DispatchQueue.global().async { [weak self] in
				self?.networking.getCatImageData(using: url) { imageData in
					self?.imageCacher.updateValue(UIImage(data: imageData)!, forKey: indexPath.row)
					DispatchQueue.main.async {
						cell.catImageView.image = self?.imageCacher[indexPath.row]
					}
				}
			}
		} else {
			DispatchQueue.main.async {
				cell.catImageView.image = self.imageCacher[indexPath.row]
			}
		}
		return cell
	}
	
	func setupView() {
		
		title = "The Cat API"
		navigationController?.navigationBar.backgroundColor = .white
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.addSubview(collectionView)
		collectionView.backgroundColor = .white
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: "catCell")
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
