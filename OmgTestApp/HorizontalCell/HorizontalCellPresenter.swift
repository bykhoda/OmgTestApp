//
//  HorizontalCellPresenter.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//

protocol HorizontalCellPresenterProtocol: AnyObject {
    var item: Int { get set }
}

final class HorizontalCellPresenter: HorizontalCellPresenterProtocol {
    private weak var cellView: HorizontalCellView!
    
    required init(cellView: HorizontalCellView) {
        self.cellView = cellView
    }
    
    //MARK: - Получаемый номер
    var item: Int = 0 {
        didSet {
            cellView.configure(with: item)
        }
    }
}
