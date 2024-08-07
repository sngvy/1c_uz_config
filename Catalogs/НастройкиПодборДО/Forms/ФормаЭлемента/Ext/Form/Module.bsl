﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Пользователь = ПараметрыСеанса.ТекущийПользователь;		       
		Попытка
			Данные = Новый ХранилищеЗначения(Параметры.Настройка);
		Исключение
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Ссылка.Пустая() Тогда
		ПоместитьВХранилищеДанные();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоместитьВХранилищеДанные()
	Об = РеквизитФормыВЗначение("Объект");                  
	Об.ЗаписатьСодержимоеХранилища(Данные);
	Об.Записать();
	ЗначениеВРеквизитФормы(Об, "Объект");
КонецПроцедуры
