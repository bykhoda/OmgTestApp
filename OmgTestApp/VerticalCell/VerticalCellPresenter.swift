//
//  VerticalCellPresenter.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//

import Foundation

protocol VerticalCellPresenterProtocol: AnyObject {
    var items: [Int] { get set }
    func willDisplayForItems(at indexPath: IndexPath)
    func didEndDisplayForItems(at indexPath: IndexPath)
}

final class VerticalCellPresenter: VerticalCellPresenterProtocol {
    private weak var cellView: VerticalCellView!
    
    //MARK: - Набор отображаемых indexPath-ов
    private var displayingIndexPaths = Set<IndexPath>()
    
    required init(cellView: VerticalCellView) {
        self.cellView = cellView
    }
    
    //MARK: - Массив элементов UICollectionView и обновление данных при изменении
    var items: [Int] = [] {
        didSet {
            cellView.updateForItem(at: Array(displayingIndexPaths))
        }
    }
    
    //MARK: - Добавление indexPath отображаемых элементов
    func willDisplayForItems(at indexPath: IndexPath) {
        displayingIndexPaths.insert(indexPath)
    }
    
    //MARK: - Удаление indexPath исчезнувших элементов
    func didEndDisplayForItems(at indexPath: IndexPath) {
        displayingIndexPaths.remove(indexPath)
    }
}
