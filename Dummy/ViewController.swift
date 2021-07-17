//
//  ViewController.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
	
	var collectionView: UICollectionView!
	var subject = PublishSubject<[Cat]>()
	let disposeBag = DisposeBag()
//	var catData = [Cat]() {
//		didSet {
//			DispatchQueue.main.async { [weak self] in
//				self?.collectionView.reloadData()
//			}
//		}
//	}
	var imageCacher = [String: UIImage]()
	let networking = Networking()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		self.networking.getCatData { response in
			self.subject.onNext(response)
		}
		bindToCollectionView()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.size.width, height: 250)
	}
	
	func bindToCollectionView() {
		subject.bind(to: collectionView.rx.items(cellIdentifier: "catCell", cellType: CatCollectionViewCell.self)) { _ , item, cell in
			guard let url = URL(string: item.url) else { return }
			self.networking.getCatImageData(using: url) { imageData in
				DispatchQueue.main.async {
					cell.catImageView.image = UIImage(data: imageData)
				}
			}
		}.disposed(by: disposeBag)
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
		collectionView.rx.setDelegate(self).disposed(by: disposeBag)
		collectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: "catCell")
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
