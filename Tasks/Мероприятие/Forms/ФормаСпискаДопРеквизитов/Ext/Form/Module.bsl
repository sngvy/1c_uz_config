﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	// Боевкин 13.10.2018
	Если Параметры.Свойство("Объект") И Не Параметры.Объект.Пустая() Тогда
		ЭлементОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = Параметры.Объект;		
	КонецЕсли;
	// Боевкин 13.10.2018
	
	//УстановитьОтбор(Список, "Объект", Параметры.Отбор.Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(Список, Поле, Значение, Использование = Истина)
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Поле);
	Для Каждого ЭлементОтбораСобытий Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл		
		Если ЭлементОтбораСобытий.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементОтбораСобытий.ПравоеЗначение = Значение;
			Если Использование <> Неопределено Тогда
				ЭлементОтбораСобытий.Использование = Использование;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элементы.Список.ТекущиеДанные[Поле.Имя]);
	КонецЕсли;
КонецПроцедуры
