# frozen_string_literal: true

module Constants
  MAIN_MENU_ITEMS = [
    '1. Создать станцию',
    '2. Создать поезд',
    '3. Создать вагон',
    '4. Создать маршрут',
    '5. Рабочее меню',
    '6. Погрузочное меню',
    '7. Информационное меню',
    '8. Выход'
  ].freeze
  TRAIN_MENU_ITEMS = [
    '1. Пассажирский',
    '2. Грузовой',
    '3. Основное меню'
  ].freeze
  WAGON_MENU_ITEMS = [
    '1. Пассажирский',
    '2. Грузовой',
    '3. Основное меню'
  ].freeze
  ROUTE_MENU_ITEMS = [
    '1. Введите название, начальную и конечную станции',
    '2. Добавить промежуточную станцию',
    '3. Удалить промежуточную станцию',
    '4. Основное меню'
  ].freeze
  WORK_MENU_ITEMS = [
    '1. Выбрать поезд и назначить маршрут',
    '2. Прицепить вагон',
    '3. Отцепить вагон',
    '4. Движение вперед',
    '5. Движение назад',
    '6. Основное меню'
  ].freeze
  INFORMATION_MENU_ITEMS = [
    '1. Просмотреть список станций',
    '2. Просмотреть список поездов на станции',
    '3. Посмотреть список маршрутов',
    '4. Посмотреть общий список станций и поездов',
    '5. Главное меню'
  ].freeze
  LOAD_MENU_ITEMS = [
    '1. Посадка пассажира',
    '2. Загрузка вагона',
    '3. Главное меню'
  ].freeze
end