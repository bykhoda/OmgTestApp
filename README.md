# OmgTestApp

## Описание
В качестве архитектуры для написания приложения использоал MVP (Model-View-Presenter), для написания UI использовал UIKit:
* Модель данных и UI. Все элементы горизонтальных рядов были помещены в UICollectionView, которая в свою очередь представляет из себя один из рядов UITableView. Поэтому был добавлен словарь для настройки и установки отступов. 
* Загрузка данных и таймер. Приложение генерирует данные для ячеек, затем запускается таймер, меняется режим RunLoop на .common для синхронизации его работы в момент скролла.
* Обновление данных. Происходит за счёт изменения данных в видимых ячейках, передавая indexPath из методов willDisplay и didEndDisplaying, тем самым не затрачивая ресурсы на дополнительную прорисовку дополнительных элементов вне экрана. 
* Анимация. Для создания анимации использовал CoreAnimation и распознаватели жестов.

Для вёрстки UI использовал вспомогательный фреймворк SnapKit.

## Пример работы:
![DE73D7F9-CB09-4F9D-B928-1201F0EEC471](https://github.com/bykhoda/OmgTestApp/assets/127774028/3842a311-4402-4e65-b735-e3b7ef34e251)
______
