﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.Дерево.Видимость = Ложь;
	
	Если Параметры.Отбор.Свойство("Объект") Тогда
		Объект = Параметры.Отбор.Объект;
	Иначе
		Объект = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДеревоКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоКлиент()
	ОбновитьДерево(); 
	//	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтаФорма,"Дерево","*",Ложь); 
	КоличествоОшибок = 0;
	Для Каждого Элемент Из Дерево.ПолучитьЭлементы() Цикл
		Попытка
			Элементы.Дерево.Развернуть(Элемент.ПолучитьИдентификатор(), Истина); 
		Исключение
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры



&НаСервере
Процедура ОбновитьДерево()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОтветственныеСотрудники.ТипСотрудника КАК ТипСотрудника,
	                      |	ОтветственныеСотрудники.Пользователь КАК Пользователь,
	                      |	ИСТИНА КАК РуководительГруппы
	                      |ИЗ
	                      |	РегистрСведений.ОтветственныеСотрудники КАК ОтветственныеСотрудники
	                      |ГДЕ
	                      |	ОтветственныеСотрудники.Объект = &Объект
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	СотрудникиВПомощь.ТипСотрудника,
	                      |	СотрудникиВПомощь.Пользователь,
	                      |	ЛОЖЬ
	                      |ИЗ
	                      |	РегистрСведений.СотрудникиВПомощь КАК СотрудникиВПомощь
	                      |ГДЕ
	                      |	СотрудникиВПомощь.Объект = &Объект
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТипСотрудника,
	                      |	РуководительГруппы УБЫВ,
	                      |	Пользователь");
	Запрос.УстановитьПараметр("Объект", Объект);
	Результат = Запрос.Выполнить().Выбрать();
	
	ЭлементыДерева = Дерево.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	Пока Результат.Следующий() Цикл
		Если Результат.РуководительГруппы Тогда
			Нов = ЭлементыДерева.Добавить();		
			НовРП = Нов.ПолучитьЭлементы();
		Иначе
			Нов = НовРП.Добавить();		
		КонецЕсли;
		Нов.ТипСотрудника = Результат.ТипСотрудника;
		Нов.Пользователь = Результат.Пользователь;
		Нов.РуководительГруппы = Результат.РуководительГруппы;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	Форма = ПолучитьФорму("РегистрСведений.ОтветственныеСотрудники.Форма.ФормаЗаписиДерево");
	
	Для Каждого Элемент Из Список.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект") Тогда
			Форма.Объект = Элемент.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;  
	
	Форма.ОткрытьМодально();
	Элементы.Список.Обновить();
	ОбновитьДеревоКлиент();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКопированием(Команда)
	ТекущиеДанные = Неопределено;
	Если Элементы.Список.Видимость Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;		
	ИначеЕсли Элементы.Дерево.Видимость Тогда
		ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;		
	КонецЕсли;
	
	Форма = ПолучитьФорму("РегистрСведений.ОтветственныеСотрудники.Форма.ФормаЗаписиДерево");
	Если ТекущиеДанные <> Неопределено Тогда
		Форма.Объект = ?(ТекущиеДанные.Свойство("Объект"), ТекущиеДанные.Объект, Объект);
		Форма.Пользователь = ТекущиеДанные.Пользователь;
		Форма.ТипСотрудника = ТекущиеДанные.ТипСотрудника;
	КонецЕсли;
	Форма.ОткрытьМодально();
	Элементы.Список.Обновить();
	ОбновитьДеревоКлиент();
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГлавнымГруппы(Команда)
	ТекущиеДанные = Неопределено;
	Если Элементы.Список.Видимость Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;		
	ИначеЕсли Элементы.Дерево.Видимость Тогда
		ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;		
	КонецЕсли;
		
	Если ТекущиеДанные <> Неопределено Тогда
		Если Не ТекущиеДанные.РуководительГруппы Тогда
			НазначитьГлавнымГруппыСервер(?(ТекущиеДанные.Свойство("Объект"), ТекущиеДанные.Объект, Объект), 
					ТекущиеДанные.Пользователь, ТекущиеДанные.ТипСотрудника);
			Элементы.Список.Обновить();
			ОбновитьДеревоКлиент();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НазначитьГлавнымГруппыСервер(ТекОбъект, ТекПользователь, ТекТипСотрудника)
	
	НаборРук = РегистрыСведений.ОтветственныеСотрудники.СоздатьМенеджерЗаписи();
	НаборРук.Объект = ТекОбъект;
	НаборРук.ТипСотрудника = ТекТипСотрудника;
	НаборРук.Прочитать();
	
	НаборПом = РегистрыСведений.СотрудникиВПомощь.СоздатьМенеджерЗаписи();
	НаборПом.Объект = ТекОбъект;
	НаборПом.ТипСотрудника = ТекТипСотрудника;
	НаборПом.Пользователь = ТекПользователь;
	НаборПом.Прочитать();
	Если НаборПом.Выбран() И НаборРук.Выбран() Тогда
	
		НаборПом.Пользователь = НаборРук.Пользователь;
		НаборПом.Записать();
	
	КонецЕсли;
	
	Если НаборРук.Выбран() Тогда
	
		НаборРук.Пользователь = ТекПользователь;
		НаборРук.Записать();
	
	КонецЕсли;
	
	//НаборПом.Пользователь = НаборРук.Пользователь;
	//Попытка
	//	НаборПом.Записать();
	//Исключение
	//КонецПопытки;
	//
	//НаборРук.Пользователь = ТекПользователь;
	//Попытка
	//	НаборРук.Записать();
	//Исключение
	//КонецПопытки;	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ТекущиеДанные = Неопределено;
	Если Элементы.Список.Видимость Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;		
	ИначеЕсли Элементы.Дерево.Видимость Тогда
		ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;		
	КонецЕсли;
		
	Если ТекущиеДанные <> Неопределено Тогда
		Форма = ПолучитьФорму("РегистрСведений.ОтветственныеСотрудники.Форма.ФормаЗаписиДерево",, ЭтаФорма);
		
		Форма.Объект = ?(ТекущиеДанные.Свойство("Объект"), ТекущиеДанные.Объект, Объект);
		Форма.Пользователь = ТекущиеДанные.Пользователь;
		Форма.ТипСотрудника = ТекущиеДанные.ТипСотрудника;
		Форма.ИсходныйРуководительГруппы = ТекущиеДанные.РуководительГруппы;
		
		Форма.ИсходныйОбъект = Форма.Объект;
		Форма.ИсходныйПользователь = Форма.Пользователь;
		Форма.ИсходныйТипСотрудника = Форма.ТипСотрудника;
			
		Форма.ОткрытьМодально();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	ТекущиеДанные = Неопределено;
	Если Элементы.Список.Видимость Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;		
	ИначеЕсли Элементы.Дерево.Видимость Тогда
		ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;		
	КонецЕсли;
		
	Если ТекущиеДанные <> Неопределено Тогда
		УдалитьСотрудникаСервер(?(ТекущиеДанные.Свойство("Объект"), ТекущиеДанные.Объект, Объект), 
				ТекущиеДанные.Пользователь, ТекущиеДанные.ТипСотрудника, ТекущиеДанные.РуководительГруппы);
		Элементы.Список.Обновить();
		ОбновитьДеревоКлиент();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьСотрудникаСервер(ТекОбъект, ТекПользователь, ТекТипСотрудника, Знач ТекРуководительГруппы)
	Если ТекРуководительГруппы Тогда
		//попытаться заменить на другого
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		                      |	СотрудникиВПомощь.Пользователь
		                      |ИЗ
		                      |	РегистрСведений.СотрудникиВПомощь КАК СотрудникиВПомощь
		                      |ГДЕ
		                      |	СотрудникиВПомощь.Объект = &Объект
		                      |	И СотрудникиВПомощь.ТипСотрудника = &ТипСотрудника");
		Запрос.УстановитьПараметр("Объект", ТекОбъект);
		Запрос.УстановитьПараметр("ТипСотрудника", ТекТипСотрудника);
		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда
			НазначитьГлавнымГруппыСервер(ТекОбъект, Результат.Пользователь, ТекТипСотрудника);
			ТекРуководительГруппы = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	//выполнить удаление
	Если ТекРуководительГруппы Тогда
		Набор = РегистрыСведений.ОтветственныеСотрудники.СоздатьМенеджерЗаписи();
	Иначе
		Набор = РегистрыСведений.СотрудникиВПомощь.СоздатьМенеджерЗаписи();	
		Набор.Пользователь = ТекПользователь;
	КонецЕсли;	
	Набор.Объект = ТекОбъект;
	Набор.ТипСотрудника = ТекТипСотрудника;
	Набор.Прочитать();
	//Попытка
	//	Набор.Удалить();
	//Исключение
	//КонецПопытки;	
	Если Набор.Выбран() Тогда
	
		Набор.Удалить();
	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотра(Команда)
	Элементы.Дерево.Видимость = Не Элементы.Дерево.Видимость;
	Элементы.Список.Видимость = Не Элементы.Список.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Изменить(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Изменить(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	Элементы.Список.Обновить();
	ОбновитьДеревоКлиент();
КонецПроцедуры
