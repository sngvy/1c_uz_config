﻿
Функция Исполнить(Клиент) Экспорт

	Элемент = СоздатьДокумент();
	Элемент.Дата = ТекущаяДатаСеанса();
	
	Элемент.Записать(РежимЗаписиДокумента.Проведение);

КонецФункции // ()
