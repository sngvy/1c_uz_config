
&НаКлиенте
Процедура ПередЗаписью(Отказ)
	Если Объект.Родитель.Пустая() Тогда
		Отказ = Истина;
		Сообщить("Поля Владелец, ТипЭлемента и Группа свойств должны быть заполнены!");
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЭтоДополнительноеСведениеСтарое = Объект.ЭтоДополнительноеСведение;
	ИначеЕсли ЭтоДополнительноеСведениеСтарое <> Объект.ЭтоДополнительноеСведение Тогда
		//Чуров
		Если Не ВыполняетсяЗапись Тогда
			Отказ = Истина;
        	ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтаФорма), "Изменение типа элемента займет много времени. Хотите продолжить?", РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		// Ответ = Неопределено;
		//Ответ = Вопрос("Изменение типа элемента займет много времени. Хотите продолжить?", РежимДиалогаВопрос.ДаНет);
		//Если Ответ = КодВозвратаДиалога.Нет Тогда
		//	Отказ = Истина;
		//	Возврат;
		//КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЭтоДополнительноеСведениеСтарое = Объект.ЭтоДополнительноеСведение;
		Записать();
    КонецЕсли;	
КонецПроцедуры


&НаСервере
Процедура ПереместитьСвойствоТЧ (Справочник,ТекущийОбъект)
	// лезем в справочник Типы долговых обязательств
	// получим элементы справочника в которых есть текущее свойство
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Свойство", ТекущийОбъект.Ссылка);
	Если ТекущийОбъект.ЭтоДополнительноеСведение Тогда // переносим из тч допрекв в доп сведения
		Запрос.Текст = "ВЫБРАТЬ
				|	ДополнительныеРеквизиты.Ссылка
				|ИЗ
				|	" + Справочник + ".ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
				|ГДЕ
				|	ДополнительныеРеквизиты.Свойство = &Свойство";
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
				|	ДополнительныеСведения.Ссылка
				|ИЗ
				|	" + Справочник + ".ДополнительныеСведения КАК ДополнительныеСведения
				|ГДЕ
				|	ДополнительныеСведения.Свойство = &Свойство";
	КонецЕсли;			   
	
	Выборка = Запрос.Выполнить().Выбрать();
	// Залезем в найденные элементы и перенесем свойство из одной ТЧ в другую
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ИмяТЧОткуда = ?(ТекущийОбъект.ЭтоДополнительноеСведение, "ДополнительныеРеквизиты", "ДополнительныеСведения");
		ИмяТЧКуда = ?(НЕ ТекущийОбъект.ЭтоДополнительноеСведение, "ДополнительныеРеквизиты", "ДополнительныеСведения");
		
		Строки = СправочникОбъект[ИмяТЧОткуда].НайтиСтроки(Новый Структура("Свойство", ТекущийОбъект.Ссылка));
		Для каждого Строка Из Строки Цикл
			НоваяСтрока = СправочникОбъект[ИмяТЧКуда].Добавить();
			НоваяСтрока.Свойство = Строка.Свойство;
			НоваяСтрока.Обязательное = Строка.Обязательное;
			НоваяСтрока.Заголовок = Строка.Заголовок;
			СправочникОбъект[ИмяТЧОткуда].Удалить(Строка);
		КонецЦикла; 
		СправочникОбъект.Записать();
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект)
	//Запись в НаборСвойств
	ИмяТЧОткуда = ?(ТекущийОбъект.ЭтоДополнительноеСведение, "ДополнительныеРеквизиты", "ДополнительныеСведения");
	ИмяТЧКуда = ?(НЕ ТекущийОбъект.ЭтоДополнительноеСведение, "ДополнительныеРеквизиты", "ДополнительныеСведения");

	Если ЭтоДополнительноеСведениеСтарое <> Объект.ЭтоДополнительноеСведение Тогда // изменился тип свойства
		Если ТекущийОбъект.СправочникВладелец = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты Тогда
			ПереместитьСвойствоТЧ("Справочник.ЮрФизЛицо", ТекущийОбъект);	
		ИначеЕсли ТекущийОбъект.СправочникВладелец = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства Тогда
			ПереместитьСвойствоТЧ("Справочник.ТипыДолговыхОбязательств", ТекущийОбъект);
		ИначеЕсли ТекущийОбъект.СправочникВладелец = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДоговорыКонтрагентов Тогда
			ПереместитьСвойствоТЧ("Справочник.ТипыДоговоровКонтрагентов", ТекущийОбъект);	
		ИначеЕсли ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Задача_Мероприятие Тогда
			ИмяПредопределенногоЭлемента = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолучитьИмяПредопределенного(ТекущийОбъект.СправочникВладелец);
			ИмяСправочника = СтрЗаменить(ИмяПредопределенногоЭлемента, "_", "");
			Попытка
				СправочникОбъект = Справочники.НаборыСвойств[ИмяСправочника].ПолучитьОбъект();
			Исключение
				Сообщить("Ошибка выполнения операции!");
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			
			Строки = СправочникОбъект[ИмяТЧОткуда].НайтиСтроки(Новый Структура("Свойство", ТекущийОбъект.Ссылка));
			Для Каждого Строка Из Строки Цикл
				НоваяСтрока = СправочникОбъект[ИмяТЧКуда].Добавить();
				НоваяСтрока.Свойство = Строка.Свойство;
				СправочникОбъект[ИмяТЧОткуда].Удалить(Строка);
			КонецЦикла; 
			СправочникОбъект.Записать();
		КонецЕсли;
	ИначеЕсли ЭтоНовыйОбъект Тогда
		Если ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты 
				И ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства
				И ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДоговорыКонтрагентов
		    	И ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Задача_Мероприятие 
				И ТекущийОбъект.СправочникВладелец <> ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.Документы_СообщениеБанкротства Тогда
			
			ИмяПредопределенногоЭлемента = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолучитьИмяПредопределенного(ТекущийОбъект.СправочникВладелец);
			ИмяСправочника = СтрЗаменить(ИмяПредопределенногоЭлемента, "_", "");
			Попытка				
				СправочникОбъект = Справочники.НаборыСвойств[ИмяСправочника].ПолучитьОбъект();
			Исключение
				Сообщить("Ошибка выполнения операции!");
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			НоваяСтрока = СправочникОбъект[ИмяТЧКуда].Добавить();
			НоваяСтрока.Свойство = ТекущийОбъект.Ссылка;
			СправочникОбъект.Записать();
		КонецЕсли;
	Конецесли;		
		
	
	//ПЕРЕНОС ЗНАЧЕНИЯ СВОЙСТВА
	Если Не Отказ И ЭтоДополнительноеСведениеСтарое <> Объект.ЭтоДополнительноеСведение Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Свойство", ТекущийОбъект.Ссылка);
		
		Если ЭтоДополнительноеСведениеСтарое Тогда
			//Из сведения в реквизит
			Запрос.Текст = "ВЫБРАТЬ
						   |	ДополнительныеСведения.Объект,
						   |	ДополнительныеСведения.Значение,
						   |	ДополнительныеСведения.Свойство
						   |ИЗ
						   |	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
						   |ГДЕ
						   |	ДополнительныеСведения.Свойство = &Свойство";
			Результат =	Запрос.Выполнить().Выбрать();		   
			Пока Результат.Следующий() Цикл
				ОбъектСправочника = Результат.Объект.ПолучитьОбъект();
				НоваяСтрока = ОбъектСправочника.ДополнительныеРеквизиты.Добавить();
				НоваяСтрока.Свойство = ТекущийОбъект.Ссылка;
				НоваяСтрока.Значение = Результат.Значение;
				Попытка
					ОбъектСправочника.Записать()
				Исключение
					Отказ = Истина;
					Возврат;
				КонецПопытки;
			КонецЦикла;
			
			Набор = РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
			Набор.Отбор.Свойство.Установить(ТекущийОбъект.Ссылка);
			Набор.Прочитать();
			Набор.Очистить();
			Попытка
				Набор.Записать();
			Исключение
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			
		Иначе
			//Из реквизита в сведение
			ИмяПредопределенногоЭлемента = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолучитьИмяПредопределенного(ТекущийОбъект.СправочникВладелец);
			ИмяСправочника = СтрЗаменить(ИмяПредопределенногоЭлемента, "_", ".");
			Запрос.Текст = "ВЫБРАТЬ
			               |	ДополнительныеРеквизиты.Ссылка,
			               |	ДополнительныеРеквизиты.Свойство,
			               |	ДополнительныеРеквизиты.Значение,
						   |	ДополнительныеРеквизиты.НомерСтроки
			               |ИЗ
			               |	" + ИмяСправочника + ".ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
			               |ГДЕ
			               |	ДополнительныеРеквизиты.Свойство = &Свойство";
			Запрос.УстановитьПараметр("Свойство", ТекущийОбъект.Ссылка);
			Результат = Запрос.Выполнить().Выбрать();
			Пока Результат.Следующий() Цикл
				Набор = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
				Набор.Объект = Результат.Ссылка;
				Набор.Свойство = Результат.Свойство;
				Набор.Значение = Результат.Значение;
				Попытка
					Набор.Записать();
				Исключение
					Отказ = Истина;
					Возврат;
				КонецПопытки;
				
				ОбъектСправочник = Результат.Ссылка.ПолучитьОбъект();
				ОбъектСправочник.ДополнительныеРеквизиты.Удалить(Результат.НомерСтроки - 1);
				Попытка
					ОбъектСправочник.Записать();
				Исключение
					Отказ = Истина;
					Возврат;
				КонецПопытки;		
			КонецЦикла;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Элементы.СправочникВладелец.ТолькоПросмотр = Истина;
	ЭтоДополнительноеСведениеСтарое = Объект.ЭтоДополнительноеСведение;
	
	////СтруктураОповещения = Новый Структура;
	////СтруктураОповещения.Вставить("Ссылка", Объект.Ссылка);
	////СтруктураОповещения.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	////
	////Оповестить("ЗаписаноДополнительноеСвойство", СтруктураОповещения);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	////Если Объект.Родитель.Пустая() Тогда			
	////	Элементы.ТипЭлемента.Доступность = Ложь;
	////	Элементы.Родитель.Доступность = Ложь;
	////Иначе
	////	Если Объект.Родитель.Предопределенный Тогда
	////		Если Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеРеквизиты_Контрагенты") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты");		
	////			ТипЭлемента = Объект.Родитель;
	////			Элементы.Родитель.Доступность = Ложь;
	////		ИначеЕсли Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеРеквизиты_ДолговыеОбязательства") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства");
	////			ТипЭлемента = Объект.Родитель;
	////			Элементы.Родитель.Доступность = Ложь;
	////			
	////		ИначеЕсли Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_Контрагенты") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты");
	////			ТипЭлемента = Объект.Родитель;
	////			Объект.Родитель = Неопределено;
	////		ИначеЕсли Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_ДолговыеОбязательства") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства");
	////			ТипЭлемента = Объект.Родитель;
	////			Объект.Родитель = Неопределено;
	////		ИначеЕсли Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты") ИЛИ
	////				Объект.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства") Тогда
	////			Владелец = Объект.Родитель;
	////			ТипЭлемента = Неопределено;
	////			Элементы.Родитель.Доступность = Ложь;
	////			Объект.Родитель = Неопределено;
	////			
	////		ИначеЕсли Объект.Родитель.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_Контрагенты") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты");		
	////			ТипЭлемента = Объект.Родитель.Родитель;
	////		ИначеЕсли Объект.Родитель.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_ДолговыеОбязательства") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства");				
	////			ТипЭлемента = Объект.Родитель.Родитель;
	////		КонецЕсли;
	////	Иначе	
	////		Если Объект.Родитель.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_Контрагенты") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_Контрагенты");		
	////		ИначеЕсли Объект.Родитель.Родитель = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДополнительныеСведения_ДолговыеОбязательства") Тогда
	////			Владелец = ПредопределенноеЗначение("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Справочник_ДолговыеОбязательства");
	////		КонецЕсли;
	////		ТипЭлемента = Объект.Родитель.Родитель;
	////	КонецЕсли;
	////	
	////	ТипЭлементаПриИзменении(Неопределено);
	ТипЗначенияПриИзменении(Неопределено);		
	////	Модифицированность = Ложь;
	////КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипЭлементаПриИзменении(Элемент)
	Если Найти(Строка(Объект.ТипЭлемента), "Дополнительные реквизиты ") = 1 Тогда
		Элементы.Родитель.Доступность = Ложь;
		Объект.Родитель = Объект.ТипЭлемента;	
		Объект.ЭтоДополнительноеСведение = Ложь;
	Иначе			
		Элементы.Родитель.Доступность = Истина;	
        Объект.Родитель = Неопределено;	
		Объект.ЭтоДополнительноеСведение = Истина;
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Объект.Ссылка.Пустая() И
			Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда
		УстановитьОтбор("Владелец", Объект.Ссылка);	
	Иначе
		Элементы.Список.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.Родитель.Родитель.Родитель.Пустая() Тогда // это доп реквизит
		Объект.СправочникВладелец = Объект.Родитель.Родитель;
		Объект.ТипЭлемента = Объект.Родитель;
		Элементы.Родитель.Доступность = Ложь;
		Объект.ЭтоДополнительноеСведение = Ложь;
	Иначе
	    Объект.СправочникВладелец = Объект.Родитель.Родитель.Родитель;
		Объект.ТипЭлемента = Объект.Родитель.Родитель;
		Объект.ЭтоДополнительноеСведение = Истина;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.Родитель.Родитель.Родитель.Пустая() Тогда // это доп реквизит, но не факт если выбранна группа
			Объект.СправочникВладелец = Объект.Родитель.Родитель;
			Объект.ТипЭлемента = Объект.Родитель;
			
			Если Найти(Строка(Объект.ТипЭлемента), "Дополнительные реквизиты ") = 1 Тогда
				Элементы.Родитель.Доступность = Ложь;
				Объект.Родитель = Объект.ТипЭлемента;	
				Объект.ЭтоДополнительноеСведение = Ложь;
			Иначе			
				Элементы.Родитель.Доступность = Истина;	
		        Объект.Родитель = Неопределено;	
				Объект.ЭтоДополнительноеСведение = Истина;
			КонецЕсли;
			
		Иначе
		    Объект.СправочникВладелец = Объект.Родитель.Родитель.Родитель;
			Объект.ТипЭлемента = Объект.Родитель.Родитель;
			Объект.ЭтоДополнительноеСведение = Истина;
		КонецЕсли;
	Иначе
	    Элементы.СправочникВладелец.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЭтоДополнительноеСведениеСтарое = Объект.ЭтоДополнительноеСведение;
	ЭтоНовыйОбъект = Объект.Ссылка.Пустая();
	
	Элементы.СписокЗначений.Видимость = Объект.СписокДоступныхЗначений;
	Если Объект.СписокДоступныхЗначений Тогда  
		Элементы.СписокЗначенийЗначение.ОграничениеТипа = Объект.ТипЗначения;
	Иначе
		Объект.СписокЗначений.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(Поле, Значение)
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Поле);	
	Для Каждого ЭлементОтбораСобытий Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл		
		Если ЭлементОтбораСобытий.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементОтбораСобытий.ПравоеЗначение = Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	ОписаниеТиповСудебныеПриставы = Новый ОписаниеТипов("СправочникСсылка.СудебныеПриставы");
	ОписаниеТиповСудьи = Новый ОписаниеТипов("СправочникСсылка.Судьи");
	Если Строка(Объект.ТипЗначения) = "" Тогда
		Если Элементы.ТипЗначения.ВыделенныйТекст = "Значения свойств объектов" Тогда
			Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.тсЗначенияСвойствОбъектов");
		Иначе
			Объект.ТипЗначения = Новый ОписаниеТипов(Элементы.ТипЗначения.ВыделенныйТекст);
		КонецЕсли;
	КонецЕсли;
	
	Если Строка(Объект.ТипЗначения) = "Строка" ИЛИ
		Строка(Объект.ТипЗначения) = Строка(ОписаниеТиповСудебныеПриставы) ИЛИ
		Строка(Объект.ТипЗначения) = Строка(ОписаниеТиповСудьи) Тогда
		Элементы.ГруппаВидКИ.Доступность = Истина;
		Если Объект.ВидСтроки.Пустая() Тогда
			Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Строка");
		КонецЕсли;
		ВидСтрокиПриИзменении(Неопределено);
	Иначе
		Элементы.ГруппаВидКИ.Доступность = Ложь;
		Объект.ВидСтроки = Неопределено;
		Объект.ВидКИ = Неопределено;
		Объект.РедактируемоеЗначение = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидСтрокиПриИзменении(Элемент)
	Если Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Адрес") Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Строка",, 
				Новый КвалификаторыСтроки(1024, ДопустимаяДлина.Переменная));
	ИначеЕсли Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Телефон") Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Строка",, 
				Новый КвалификаторыСтроки(400, ДопустимаяДлина.Переменная));
	КонецЕсли;
			
	Если Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Адрес") ИЛИ
			Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.АдресФИАС") ИЛИ
			Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Телефон") ИЛИ
			Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Строка") ИЛИ
			Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СудебныеПриставы") ИЛИ
			Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Судьи") Тогда
		Элементы.ВидКИ.Доступность = Истина;
	Иначе
		Элементы.ВидКИ.Доступность = Ложь;
		Объект.ВидКИ = Неопределено;
	КонецЕсли;
	
	Если Объект.ВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Строка") Тогда
		Элементы.РедактируемоеЗначение.Доступность = Истина;
	Иначе
		Элементы.РедактируемоеЗначение.Доступность = Ложь;
		Объект.РедактируемоеЗначение = Неопределено;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда
		УстановитьОтбор("Владелец", Объект.Ссылка);	
		Элементы.Список.Видимость = Истина;
	Иначе
		Элементы.Список.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТестТипПриИзменении(Элемент)
	Объект.ТипЗначения = Новый ОписаниеТипов(ТестТип);
	ТипЗначенияПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СписокДоступныхЗначенийПриИзменении(Элемент)
	Элементы.СписокЗначений.Видимость = Объект.СписокДоступныхЗначений;
	Если Объект.СписокДоступныхЗначений Тогда  
		Элементы.СписокЗначенийЗначение.ОграничениеТипа = Объект.ТипЗначения;
	Иначе
		Объект.СписокЗначений.Очистить();
	КонецЕсли;
КонецПроцедуры
