//
//  VoucherViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit

class PromoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var promotions: [Promotion] = []
    let promotionDataManager = PromotionDataManager()
    var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: K.promoCellNibName, bundle: nil), forCellWithReuseIdentifier: K.promoCell)
        
        promotionDataManager.fetchPromotions { [weak self] (promotions, error) in
            guard let self = self else { return }
            
            if let error = error {
            } else if let promotions = promotions {
                self.promotions = promotions
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func addBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.blurEffectView = blurEffectView
    }
}


// MARK: UICollectionViewDataSource

extension PromoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let promotion = promotions[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.promoCell, for: indexPath) as? PromoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: promotion)
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension PromoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let promotion = promotions[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let promoVC = storyboard.instantiateViewController(withIdentifier: K.promoDetailVCId) as! PromoDetailViewController
        
        if let presentationController = promoVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        
        addBlurEffect()
        promoVC.setPromotion(promotion)
        promoVC.delegate = self
        present(promoVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PromoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 25) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

// MARK: PromoDetailViewControllerDelegate

extension PromoViewController: PromoDetailViewControllerDelegate {
    func promoDetailViewControllerDismissed() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
}
