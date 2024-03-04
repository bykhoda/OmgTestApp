//
//  UpdateService.swift
//  OmgTestApp
//
//  Created by Danila Bykhovoy on 01.03.2024.
//
import UIKit

protocol UpdateServiceProtocol {
    var verticalItems: [VerticalItem] { get set }
    func update()
}

final class UpdateService: UpdateServiceProtocol {
    private weak var presenter: MainPresenterProtocol!
    private var timer: Timer?
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: Массив VerticalItem
    var verticalItems: [VerticalItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func update() {
        generateData()
        startTimer()
    }
    
    //MARK: - Генерирование VerticalItems с рандомными номерами по 15 элементов в каждом ряду
    private func generateData() {
        for _ in 0..<100 {
            let horizontalRange = 0..<15
            let horizontalItems = horizontalRange.map { _ in Int.random(in: 1...100) }
            let verticalItem = VerticalItem(horizontalItems: horizontalItems)
            verticalItems.append(verticalItem)
        }
    }
    
    //MARK: - Запуск таймера и установка режима RunLoop на .common
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateRandomNumber()
        }
        let runloop = RunLoop.main
        runloop.add(timer!, forMode: .common)
    }
    
    //MARK: - Обновление массива данных на background-потоке
    private func updateRandomNumber() {
        DispatchQueue.global(qos: .background).async {
            for index in 0..<self.verticalItems.count {
                var updatedHorizontalItems = self.verticalItems[index].horizontalItems
                if let randomIndex = updatedHorizontalItems.indices.randomElement() {
                    updatedHorizontalItems[randomIndex] = Int.random(in: 1...100)
                }
                self.verticalItems[index].horizontalItems = updatedHorizontalItems
            }
        }
    }

    //MARK: - Обновление данных
    private func reloadData() {
        presenter.updateData()
    }
}
