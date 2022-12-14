
Перем ТекстИзменений;

Процедура ПередЗаписью(Отказ)
	Если Не ЗначениеЗаполнено(ЭтотОбъект.ДатаСоздания) Тогда
		ЭтотОбъект.ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
	//
	ЭтотОбъект.ВладелецКонтрагент = "";
	Для Каждого Элемент Из ЭтотОбъект.Контрагенты Цикл
		ЭтотОбъект.ВладелецКонтрагент = ЭтотОбъект.ВладелецКонтрагент + ", " + Элемент.Контрагент.Наименование; 		
	КонецЦикла;	
	ЭтотОбъект.ВладелецКонтрагент = Сред(ЭтотОбъект.ВладелецКонтрагент, 3);
	Попытка 
		ЭтотОбъект.Контрагент = ЭтотОбъект.Контрагенты[0].Контрагент;
	Исключение		
	КонецПопытки;	
	//
	ТекстИзменений = ОбъектыСервер.ПроверитьИзмененияВОбъекте(ЭтотОбъект);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Справочники.Пользователи.ОтслеживаниеИзменений(Отказ, Ссылка, ТекстИзменений);
КонецПроцедуры
