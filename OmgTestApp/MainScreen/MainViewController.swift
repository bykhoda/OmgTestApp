//
//  ViewController.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//

import UIKit

protocol MainView: AnyObject {
    func reloadData(for indexPaths: [IndexPath])
}

final class MainViewController: UIViewController, MainView {
    
    private var verticalTableView = UITableView()
    private var presenter: MainPresenterProtocol!
    private var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupViews()
        presenter.viewDidLoad()
    }
    
    //MARK: - Конфигурация MainViewController
    private func configure() {
        presenter = MainPresenter(view: self)
        let service = UpdateService(presenter: presenter)
        presenter.updateService = service
    }
    
    //MARK: - Установка констреинтов, делегатов
    private func setupViews() {
        view.addSubview(verticalTableView)
        verticalTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verticalTableView.dataSource = self
        verticalTableView.delegate = self
        verticalTableView.register(VerticalCell.self, forCellReuseIdentifier: VerticalCell.reuseIdentifier)
    }
    
    //MARK: - Обновление видимых данных UITableView
    func reloadData(for indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = verticalTableView.cellForRow(at: indexPath) as? VerticalCell {
                cell.verticalPresenter.items = presenter.elements[indexPath.row].horizontalItems
            }
        }
    }
}

//MARK: - Реализация методов делегата UITableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VerticalCell.reuseIdentifier, for: indexPath) as! VerticalCell
        let newItems = presenter.elements[indexPath.row].horizontalItems
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.verticalPresenter.items = newItems
        return cell
    }
    
    //MARK: - Передача текущего indexPath для ячеек, которые видны на экране
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }
    
    //MARK: - Передача текущего indexPath и отступ ячейки, когда ячейка перестаёт отображаться
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? VerticalCell else { return }
        presenter.didEndDisplayingCell(at: indexPath)
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

