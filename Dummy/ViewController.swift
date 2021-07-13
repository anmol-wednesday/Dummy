//
//  ViewController.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	var collectionView: UICollectionView!
	var catData: [Cat]? {
		didSet {
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
			}
		}
	}
	var imageCacher = [String: Data]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return catData?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! CatCollectionViewCell
		let cat = catData![indexPath.row]
		guard let url = URL(string: catData![indexPath.row].url) else {
			return cell
		}
		
		if imageCacher[cat.url] == nil {
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				getCatImageData(using: url) { imageData in
					self?.imageCacher.updateValue(imageData, forKey: cat.url)
					DispatchQueue.main.async {
						cell.catImageView.image = UIImage(data: imageData)
					}
				}
			}
		} else {
			DispatchQueue.main.async { [weak self] in
				cell.catImageView.image = UIImage(data: (self?.imageCacher[cat.url])!)
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.size.width, height: 200)
	}
	
	func setupView() {
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
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			getCatData { response in
				self?.catData = response
				print(response)
			}
		}
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
