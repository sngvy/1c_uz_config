﻿
Перем ТекстИзменений;

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.ДатаСоздания) Тогда
		ЭтотОбъект.ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	//
	ЭтотОбъект.ВладелецКонтрагент = "";
	Для Каждого Элемент Из ЭтотОбъект.Контрагенты Цикл
		ЭтотОбъект.ВладелецКонтрагент = ЭтотОбъект.ВладелецКонтрагент + ", " + Элемент.Контрагент.Наименование;
	КонецЦикла;	
	ЭтотОбъект.ВладелецКонтрагент = Сред(ЭтотОбъект.ВладелецКонтрагент, 3);
	// Прошлый код закоментирован
	Если ЭтотОбъект.Контрагенты.Количество() > 0 Тогда
	
		ЭтотОбъект.Контрагент = ЭтотОбъект.Контрагенты[0].Контрагент;
	
	КонецЕсли;
	//Попытка 
	//	ЭтотОбъект.Контрагент = ЭтотОбъект.Контрагенты[0].Контрагент;
	//Исключение		
	//КонецПопытки;	
	//
	ТекстИзменений = ОбъектыСервер.ПроверитьИзмененияВОбъекте(ЭтотОбъект);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.Пользователи.ОтслеживаниеИзменений(Отказ, Ссылка, ТекстИзменений);
КонецПроцедуры
