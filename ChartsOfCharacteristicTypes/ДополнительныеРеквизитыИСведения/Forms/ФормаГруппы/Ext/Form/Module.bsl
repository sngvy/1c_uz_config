﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Предопределенный Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Родитель.СписокВыбора.НайтиПоЗначению(Объект.Родитель) = Неопределено Тогда
        Объект.Родитель = Неопределено;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДополнительныеРеквизитыИСведения.Ссылка
	                      |ИЗ
	                      |	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
	                      |ГДЕ
	                      |	ДополнительныеРеквизитыИСведения.Родитель.Предопределенный
	                      |	И ДополнительныеРеквизитыИСведения.Предопределенный
	                      |	И ДополнительныеРеквизитыИСведения.Наименование ПОДОБНО ""Дополнительные сведения %""");
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		Элементы.Родитель.СписокВыбора.Добавить(Результат.Ссылка);
	КонецЦикла;
	
	
	Если Объект.Предопределенный Тогда
		Элементы.Родитель.ТолькоПросмотр = Истина;
		Элементы.Наименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Элементы.Родитель.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры
