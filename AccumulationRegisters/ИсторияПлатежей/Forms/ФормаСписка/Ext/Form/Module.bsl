﻿
&НаКлиенте
Процедура ДобавитьНачисление(Команда)
	// Создаем новый док
	Форма = ПолучитьФорму("Документ.ЗагрузкаИсторииПлатежей.Форма.ФормаДокумента");
	Строка = Форма.Объект.Объекты.Добавить();Строка.Объект = Список.Отбор.Элементы[0].ПравоеЗначение;
	Форма.ОткрытьМодально();
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьСписание(Команда)
	// Создаем новый док
	Форма = ПолучитьФорму("Документ.СписаниеЗадолженностиПоИстории.Форма.ФормаДокумента");
	Строка = Форма.Объект.Объекты.Добавить();Строка.Объект = Список.Отбор.Элементы[0].ПравоеЗначение;
	Форма.ОткрытьМодально();
КонецПроцедуры

