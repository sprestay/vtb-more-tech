//
//  OffersViewController.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 09.10.2020.
//

import UIKit
import GravitySliderFlowLayout

// MARK: Обычно мы так не пишем :)

class OffersViewController: UIViewController {
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productSubtitleLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var images = [UIImage]()
    let titles = [String]()
    let subtitles = [String]()
    let prices = [String]()
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.95
    let collectionViewCellWidthCoefficient: CGFloat = 0.95
    let priceButtonCornerRadius: CGFloat = 10
    let gradientFirstColor = UIColor(named: "ff8181")?.cgColor
    let gradientSecondColor = UIColor(named: "a81382")?.cgColor
    let cellsShadowColor = UIColor.white // UIColor(named: "2a002a")?.cgColor
    let productCellIdentifier = "ProductCollectionViewCell"

    public var carBrand: String!
    public var carModel: String!
    
    public var beautyCarBrand: String!
    public var beautyCarModel: String!

    var car: CarModel!
    
    private var itemsNumber = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.TabBarBackgroundColor)
        self.collectionView.backgroundColor = UIColor.appColor(.TabBarBackgroundColor)
        
//        print(carBrand)
//        print(carModel)
        
        priceButton.vtbStyleButton()
        
        self.productTitleLabel.isHidden = false
        self.productSubtitleLabel.isHidden = false
        self.productSubtitleLabel.isHidden = false
        self.priceButton.isHidden = false
        
        if let car = Marketplace.shared.getCarData(carBrand: carBrand.lowercased(), carModel: carModel.lowercased()) {
            self.car = car
            self.images = car.images
//            self.titleLabel.text = carBrand + " " + carModel
            
            navigationItem.title = beautyCarBrand;
            
            let attributedTitle = NSMutableAttributedString(string: beautyCarModel, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), .font: UIFont.systemFont(ofSize: 30, weight: .medium)])
            
            self.titleLabel.attributedText = attributedTitle
            self.productSubtitleLabel.text = "Цена автомобиля указана в базовой комплектации"
            
            
            self.titleLabel.lineBreakMode = .byWordWrapping
            self.productTitleLabel.text = car.price + " ₽"
            self.productTitleLabel.textColor = #colorLiteral(red: 0.9686265588, green: 0.9647503495, blue: 0.9645444751, alpha: 1)
            self.productTitleLabel.font = UIFont.systemFont(ofSize: 25)
        } else {
            let attributedTitle = NSMutableAttributedString(string: "Автомобиль не найден", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), .font: UIFont.systemFont(ofSize: 30, weight: .medium)])
            attributedTitle.append(NSMutableAttributedString(string: "\nПопробуйте другое фото", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), .font: UIFont.systemFont(ofSize: 20, weight: .light)]))
            self.titleLabel.attributedText = attributedTitle
            self.productTitleLabel.isHidden = true
            self.productSubtitleLabel.isHidden = true
            self.productSubtitleLabel.isHidden = true
            self.priceButton.isHidden = true
        }
        self.titleLabel.numberOfLines = 2
        
        configureCollectionView()
        configurePriceButton()
    }
    
    private func configureCollectionView() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
//        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: 400, height: 300))
        collectionView.collectionViewLayout = gravitySliderLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.numberOfPages = 0
    }
    
    private func configurePriceButton() {
        priceButton.layer.cornerRadius = priceButtonCornerRadius
    }
    
    private func configureProductCell(_ cell: ProductCollectionViewCell, for indexPath: IndexPath) {
        cell.clipsToBounds = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
        gradientLayer.cornerRadius = 21
        gradientLayer.masksToBounds = true
        cell.layer.insertSublayer(gradientLayer, at: 0)
        
        cell.layer.shadowColor = CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 255)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
        cell.productImage.backgroundColor = .white
        
        if images.count != 0 {
            cell.productImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * collectionViewCellWidthCoefficient, height: self.view.frame.height * collectionViewCellHeightCoefficient)
                    cell.productImage.contentMode = .scaleAspectFit
            //        cell.productImage.layer.layoutIfNeeded()
            //        cell.productImage.layer.cornerRadius = 21
            //        cell.productImage.layer.masksToBounds = true
            //        cell.productImage.clipsToBounds = true
                    cell.productImage.image = images[indexPath.row % images.count]
        }
        
        cell.newLabel.layer.cornerRadius = 8
        cell.newLabel.clipsToBounds = true
        cell.newLabel.layer.borderColor = UIColor.white.cgColor
        cell.newLabel.layer.borderWidth = 1.0
        cell.newLabel.text = "AAA"
    }
    
    private func animateChangingTitle(for indexPath: IndexPath) {
//        UIView.transition(with: productTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
//        }, completion: nil)
//        UIView.transition(with: productSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productSubtitleLabel.text = self.subtitles[indexPath.row % self.subtitles.count]
//        }, completion: nil)
//        UIView.transition(with: priceButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.priceButton.setTitle(self.prices[indexPath.row % self.prices.count], for: .normal)
//        }, completion: nil)
    }
    
    @IBAction func didPressPriceButton(_ sender: Any) {
        let formVC = InputsFormViewController()
        navigationController?.pushViewController(formVC, animated: true)
    }
    
}

extension OffersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
        self.configureProductCell(cell, for: indexPath)
        return cell
    }
}

var prevIndex = 0

extension OffersViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 10, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 10, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if images.count != 0 {
            if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
                let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
                let indexPathThird = collectionView.indexPathForItem(at: locationThird),
                indexPathFirst.row == indexPathSecond.row &&
                indexPathSecond.row == indexPathThird.row &&
                indexPathFirst.row != pageControl.currentPage {
                
                pageControl.currentPage = indexPathFirst.row % images.count
                self.animateChangingTitle(for: indexPathFirst)
            }
        }
    }
}
