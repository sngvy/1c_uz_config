
Процедура ПриЗаписи(Отказ, Замещение) 
	//КазанцевЯА , в документе Корректировка регистров он там отсутствует реквизит на который идет проверка
	//Документ Корректировка регистров является также регистратором данного регистра, но не должен подстраиваться под логику,а вносить коррективы из ТЧ 
	МетаданныеОбъекта = ЭтотОбъект.Отбор.Регистратор.Значение.Метаданные();
	Если ТипЗнч(ЭтотОбъект.Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ЗавершениеРаботыОрганизации") тогда
		СписокДолговых = ЭтотОбъект.Отбор.Регистратор.Значение.Объекты.ВыгрузитьКолонку("Объект");
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ИсполнительныеДокументы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ИсполнительныеДокументы КАК ИсполнительныеДокументы
		|ГДЕ
		|	ИсполнительныеДокументы.Владелец В(&Владелец)");
		Запрос.УстановитьПараметр("Владелец", СписокДолговых);
		Результат = Запрос.Выполнить().Выбрать();
		Пока Результат.Следующий() Цикл
			РасчетЗадолженностиСудопроизводство.ОбновитьСуммыЗадолженностиПоИД(Результат.Ссылка);	
		КонецЦикла; 
		
		НЗ = РегистрыСведений.ЗадолженностьПоОбъектамОстатки.СоздатьНаборЗаписей();
		НЗ.Отбор.Объект.Установить(СписокДолговых);
		НЗ.Записать();
		
	ИначеЕсли МетаданныеОбъекта.Реквизиты.Найти("Займ") <> Неопределено Тогда

		ДолговоеОбязательство = ЭтотОбъект.Отбор.Регистратор.Значение.Займ;
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ИсполнительныеДокументы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ИсполнительныеДокументы КАК ИсполнительныеДокументы
		|ГДЕ
		|	ИсполнительныеДокументы.Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", ДолговоеОбязательство);
		Результат = Запрос.Выполнить().Выбрать();
		Пока Результат.Следующий() Цикл
			РасчетЗадолженностиСудопроизводство.ОбновитьСуммыЗадолженностиПоИД(Результат.Ссылка);
			МЗ = РегистрыСведений.ЗадолженностьПоОбъектамОстатки.СоздатьМенеджерЗаписи();
			МЗ.Объект = ДолговоеОбязательство;
			МЗ.ТипЗадолженности = ПланыВидовХарактеристик.ТипыЗадолженности.Сумма;
			Сумма = 0;  
			Для каждого Стр из ЭтотОбъект Цикл
				Сумма = Сумма + Стр.Сумма;
			КонецЦикла;	
			МЗ.СуммаДО = Сумма;
			МЗ.СуммаРегл = Сумма;
			МЗ.Записать();
			
		КонецЦикла;   
		
	КонецЕсли; 	
	
КонецПроцедуры
