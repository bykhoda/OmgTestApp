//
//  HorizontalCell.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//
import UIKit

protocol HorizontalCellView: AnyObject {
    func configure(with number: Int)
}

final class HorizontalCell: UICollectionViewCell, HorizontalCellView {
    static let reuseIdentifier = "HorizontalCollectionViewCell"
    var horizontalPresenter: HorizontalCellPresenterProtocol!
    
    private let numberLabel = UILabel()
    private var originalTransform: CGAffineTransform?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Переиспользование ячейки, чтобы данные ячеек "не переливались"
    override func prepareForReuse() {
        super.prepareForReuse()
        numberLabel.text = nil
    }
    
    //MARK: - Установка констреинтов и UI
    private func setupViews() {
        contentView.addSubview(numberLabel)
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.borderWidth = 3
        numberLabel.layer.borderColor = UIColor.lightGray.cgColor
        numberLabel.backgroundColor = .white
        numberLabel.textColor = .black
        numberLabel.layer.masksToBounds = true
        horizontalPresenter = HorizontalCellPresenter(cellView: self)
        configure(with: horizontalPresenter.item)
        
        numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Обновление текста UILabel при получении item
    func configure(with number: Int) {
        numberLabel.text = "\(number)"
    }
    
    //MARK: - Установка UIGestureRecognizer и его делегата
    private func setupGestureRecognizers() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.minimumPressDuration = 0
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Анимация ячейки с помощью CoreAnimation
    @objc private func handleTap(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            DispatchQueue.global(qos: .userInteractive).async {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.duration = 0.1
                animation.fromValue = 1.0
                animation.toValue = 0.8
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
                }
                
                self.layer.add(animation, forKey: nil)
                CATransaction.commit()
            }
        case .ended, .cancelled:
            DispatchQueue.global(qos: .userInteractive).async {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.duration = 0.1
                animation.fromValue = 0.8
                animation.toValue = 1.0
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.transform = self.originalTransform ?? .identity
                }
                
                self.layer.add(animation, forKey: nil)
                CATransaction.commit()
            }
        default:
            break
        }
    }

}

//MARK: - Метод делегата UIGestureRecognizer
extension HorizontalCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}




