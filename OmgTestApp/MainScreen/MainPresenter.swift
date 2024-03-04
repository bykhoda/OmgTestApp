//
//  MainPresenter.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//
import Foundation

protocol MainPresenterProtocol: AnyObject {
    var updateService: UpdateServiceProtocol! { get set }
    var elements: [VerticalItem] { get }
    func viewDidLoad()
    func updateData()
    func willDisplayCell(at indexPath: IndexPath)
    func didEndDisplayingCell(at indexPath: IndexPath)
}

final class MainPresenter: MainPresenterProtocol {
    private weak var view: MainView!
    var updateService: UpdateServiceProtocol!
    
    //MARK: - Набор отображаемых indexPath-ов
    private var displayedIndexPaths = Set<IndexPath>()
    
    required init(view: MainView) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateService.update()
    }
    
    //MARK: - Количество элементов массива
    var elements: [VerticalItem] {
        updateService.verticalItems
    }
    
    //MARK: - Обновление видимых данных
    func updateData() {
        view.reloadData(for: Array(displayedIndexPaths))
    }
    
    //MARK: - Вставка indexPath элементов, видимых на экране
    func willDisplayCell(at indexPath: IndexPath) {
        displayedIndexPaths.insert(indexPath)
    }
    
    //MARK: - Удаление indexPath элементов, исчезнувших с экрана
    func didEndDisplayingCell(at indexPath: IndexPath) {
        displayedIndexPaths.remove(indexPath)
    }
}
