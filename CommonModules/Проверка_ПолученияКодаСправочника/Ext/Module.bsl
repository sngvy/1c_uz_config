﻿Функция Старт(ДанныеДляПроверки, НачалоДанных) Экспорт

	ЗначенияЯчеек = ДанныеДляПроверки["ЗначенияЯчеек"];
	
	НаборДанных = Новый Массив;
	Значения = Новый Соответствие;
	
	Для НомерСтроки = 0 По ЗначенияЯчеек.Количество() - 1 Цикл
		
		НомераСтрок = Значения.Получить(ЗначенияЯчеек[НомерСтроки]);
		Если НомераСтрок = Неопределено Тогда
		
			НомераСтрок = Новый Массив;

		КонецЕсли;
	
		НомераСтрок.Добавить(НачалоДанных + НомерСтроки);
		Значения.Вставить(ЗначенияЯчеек[НомерСтроки], НомераСтрок);
		
	КонецЦикла;
	
	Для каждого Элемент Из Значения Цикл
	
		Если Элемент.Значение.Количество() = 1 Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		ДанныеОбработки = Новый Структура;
		ДанныеОбработки.Вставить("ЗначениеЯчейки", Элемент.Ключ);
		ДанныеОбработки.Вставить("НомерСтроки", СтрСоединить(Элемент.Значение, ", "));
		ДанныеОбработки.Вставить("ДанныеСтрок", Элемент.Значение);
		ДанныеОбработки.Вставить("Значение", Элемент.Ключ);
		НаборДанных.Добавить(ДанныеОбработки);
	
	КонецЦикла;
	
	Возврат НаборДанных;

КонецФункции // ()

Функция Исполнить(ДанныеДляПроверки, НачалоДанных) Экспорт

	ЗначенияЯчеек = ДанныеДляПроверки["ЗначенияЯчеек"];
	КоличествоКолонок = ЗначенияЯчеек.Количество();
	Если КоличествоКолонок = 0 Тогда
	
		Возврат Новый Массив;
	
	КонецЕсли;
	
	КоличествоЗначений = ЗначенияЯчеек[0].Количество();
	
	НаборДанных = Новый Массив;
	УникальныеЗначения = Новый Соответствие;
	Номер = 0;
	Пока Номер < КоличествоЗначений Цикл
	
		НомерСтроки = Номер;
		Номер = Номер + 1;
		
		НовыйКод = СобратьНовыйКод(ЗначенияЯчеек, НомерСтроки, КоличествоКолонок);
		
		ЕстьКодСправочника = УникальныеЗначения.Получить(НовыйКод);
		Если ЕстьКодСправочника <> Неопределено Тогда
		
			ПовторяющиесяЗначения = ЗаполнитьИнформациюОПовторе(НовыйКод, НачалоДанных + НомерСтроки);
			НаборДанных.Добавить(ПовторяющиесяЗначения);
			
			Продолжить;
		
		КонецЕсли;
		
		УникальныеЗначения.Вставить(НовыйКод, Истина);
	
	КонецЦикла;
	
	Возврат НаборДанных;

КонецФункции

Функция СобратьНовыйКод(ЗначенияЯчеек, НомерСтроки, КоличествоКолонок)

	НовыйКод = "";
	Номер = 0;
	Пока Номер < КоличествоКолонок Цикл
	
		НовыйКод = НовыйКод + ЗначенияЯчеек[Номер][НомерСтроки]; 
		Номер = Номер + 1;
	
	КонецЦикла;
	
	Возврат НовыйКод;

КонецФункции // ()

Функция ЗаполнитьИнформациюОПовторе(НовыйКод, Номер)

	ДанныеОбработки = Новый Структура;
	ДанныеОбработки.Вставить("ЗначениеЯчейки", НовыйКод);
	ДанныеОбработки.Вставить("НомерСтроки", Номер);
	ДанныеОбработки.Вставить("ДанныеСтрок", Номер);
	ДанныеОбработки.Вставить("Значение", НовыйКод);
	
	Возврат ДанныеОбработки;

КонецФункции // ()


