//
//  VerticalCell.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//

import UIKit
import SnapKit

protocol VerticalCellView: AnyObject {
    func updateForItem(at indexPaths: [IndexPath])
}

final class VerticalCell: UITableViewCell, VerticalCellView {
    static let reuseIdentifier = "VerticalCell"
    var verticalPresenter: VerticalCellPresenterProtocol!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Словарь "Ряд : отступ"
    private var storedOffsets = [Int: CGPoint]()
    
    //MARK: - UICollectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(HorizontalCell.self, forCellWithReuseIdentifier: HorizontalCell.reuseIdentifier)
        return collectionView
    }()
    
    //MARK: - Отступ текущей ячейки
    var collectionViewOffset: CGFloat {
        get {
            collectionView.contentOffset.x
        }
        set {
            let x = newValue >= 0 ? newValue : 0
            let point = CGPoint(x: x, y: 0)
            collectionView.setContentOffset(point, animated: false)
        }
    }
    
    //MARK: - Установка констреинтов, делегатов ячейки
    private func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        verticalPresenter = VerticalCellPresenter(cellView: self)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo((UIScreen.main.bounds.width - 40) / 3)
            make.edges.equalTo(contentView)
        }
    }
    
    //MARK: - Обновление данных для видимых элементов
    func updateForItem(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? HorizontalCell {
                cell.horizontalPresenter.item = verticalPresenter.items[indexPath.row]
            }
        }
    }
}

//MARK: - Методы делегата UICollectionView
extension VerticalCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        verticalPresenter.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCell.reuseIdentifier, for: indexPath) as! HorizontalCell
        let item = verticalPresenter.items[indexPath.row]
        cell.horizontalPresenter.item = item
        return cell
    }
    
    //MARK: - Передача indexPath, отображаемых ячеек
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        verticalPresenter.willDisplayForItems(at: indexPath)
    }
    
    //MARK: - Передача indexPath, исчезнувших ячеек
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        verticalPresenter.didEndDisplayForItems(at: indexPath)
    }
}

//MARK: - Метод делегата layout-а ячейки
extension VerticalCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 3
        return CGSize(width: width, height: width)
    }
}

