﻿
&НаКлиенте
Процедура СписокОператоровПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Пользователи.Ссылка КАК Значение,
	                      |	ВЫБОР
	                      |		КОГДА ГруппыОператоровОператоры.Ссылка ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Пометка
	                      |ИЗ
	                      |	Справочник.Пользователи КАК Пользователи
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыОператоров.Операторы КАК ГруппыОператоровОператоры
	                      |		ПО (ГруппыОператоровОператоры.Оператор = Пользователи.Ссылка)
	                      |			И (ГруппыОператоровОператоры.Ссылка = &Ссылка)
	                      |ГДЕ
	                      |	Пользователи.НомерОператора <> 0");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		СписокОператоров.Добавить(Результат.Значение,,Результат.Пометка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Операторы.Очистить();
	Для Каждого Элемент Из СписокОператоров Цикл
		Если Элемент.Пометка Тогда
			Объект.Операторы.Добавить().Оператор = Элемент.Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокОператоровПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
