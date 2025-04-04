﻿
&НаКлиенте
Процедура Сформировать(Команда)  
	СформироватьНовуюВерсию();

	//Если Не Отчет.ТипМероприятия.Пустая() И ЗначениеЗаполнено(Отчет.ДатаС) И ЗначениеЗаполнено(Отчет.ДатаПо) И 
	//		ЗначениеЗаполнено(Отчет.ДатаНа) Тогда			
	//	//СформироватьНаСервере(); 
	//		Иначе
	//	Вопрос("Не заполнены обязательные реквизиты!", РежимДиалогаВопрос.ОК);
	//КонецЕсли;
КонецПроцедуры 

&НаСервере
Процедура СформироватьНовуюВерсию()
	ТабДок.Очистить();
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	
	//
	Область = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Вывести(Область);
	
	//
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Мероприятие.ТипМероприятия КАК ТипМероприятия,
	                      |	ВЫБОР
	                      |		КОГДА ТИПЗНАЧЕНИЯ(Мероприятие.Объект) = ТИП(Справочник.ДолговыеОбязательства)
	                      |			ТОГДА Мероприятие.Объект.Должник
	                      |		ИНАЧЕ Мероприятие.Объект
	                      |	КОНЕЦ КАК Должник,
	                      |	Мероприятие.Объект КАК Объект
	                      |ПОМЕСТИТЬ НевыполненныеМероприятияПоОбъектам
	                      |ИЗ
	                      |	Задача.Мероприятие КАК Мероприятие
	                      |ГДЕ
	                      |	НЕ Мероприятие.Выполнена
	                      |	И НЕ Мероприятие.ТипМероприятия.ПометкаУдаления
	                      |	И НЕ Мероприятие.ПометкаУдаления
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	Объект
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	НевыполненныеМероприятияПоОбъектам.ТипМероприятия КАК ТипМероприятия,
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НевыполненныеМероприятияПоОбъектам.Должник) КАК КолВо,
	                      |	СУММА(ЗадолженностьПоОбъектамОстатки.СуммаДО) КАК Сумма
	                      |ИЗ
	                      |	НевыполненныеМероприятияПоОбъектам КАК НевыполненныеМероприятияПоОбъектам
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадолженностьПоОбъектамОстатки КАК ЗадолженностьПоОбъектамОстатки
	                      |		ПО НевыполненныеМероприятияПоОбъектам.Объект = ЗадолженностьПоОбъектамОстатки.Объект
	                      |ГДЕ
	                      |	ЗадолженностьПоОбъектамОстатки.ТипЗадолженности = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыЗадолженности.Сумма)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	НевыполненныеМероприятияПоОбъектам.ТипМероприятия
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТипМероприятия УБЫВ");
	Результат1 = Запрос.Выполнить().Выбрать();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Мероприятие.ТипМероприятия КАК ТипМероприятия,
	               |	ВЫБОР
	               |		КОГДА ТИПЗНАЧЕНИЯ(Мероприятие.Объект) = ТИП(Справочник.ДолговыеОбязательства)
	               |			ТОГДА Мероприятие.Объект.Должник
	               |		ИНАЧЕ Мероприятие.Объект
	               |	КОНЕЦ КАК Должник,
	               |	Мероприятие.Объект КАК Объект
	               |ПОМЕСТИТЬ ВыполненныеМероприятияПоОбъектам
	               |ИЗ
	               |	Задача.Мероприятие КАК Мероприятие
	               |ГДЕ
	               |	Мероприятие.Выполнена
	               |	И НЕ Мероприятие.ТипМероприятия.ПометкаУдаления
	               |	И НЕ Мероприятие.ПометкаУдаления
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Объект
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВыполненныеМероприятияПоОбъектам.ТипМероприятия КАК ТипМероприятия,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВыполненныеМероприятияПоОбъектам.Должник) КАК КолВо,
	               |	СУММА(ЗадолженностьПоОбъектамОстатки.СуммаДО) КАК Сумма
	               |ИЗ
	               |	ВыполненныеМероприятияПоОбъектам КАК ВыполненныеМероприятияПоОбъектам
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадолженностьПоОбъектамОстатки КАК ЗадолженностьПоОбъектамОстатки
	               |		ПО ВыполненныеМероприятияПоОбъектам.Объект = ЗадолженностьПоОбъектамОстатки.Объект
	               |ГДЕ
	               |	ЗадолженностьПоОбъектамОстатки.ТипЗадолженности = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыЗадолженности.Сумма)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВыполненныеМероприятияПоОбъектам.ТипМероприятия";
	Результат2 = Запрос.Выполнить().Выбрать();
	
	Пока Результат1.Следующий() Цикл
		
		Область = Макет.ПолучитьОбласть("Строка");
		
		Область.Параметры.ТипМероприятия = Результат1.ТипМероприятия;
		Область.Параметры.КолВо1 = Результат1.КолВо;
		Область.Параметры.Сумма1 = Результат1.Сумма;  
		
		ПараметрыВывода = Новый Структура; 
		ПараметрыВывода.Вставить("ТипМероприятия", Результат1.ТипМероприятия); 
		
		Если Результат2.НайтиСледующий(ПараметрыВывода) Тогда				
			Область.Параметры.ТипМероприятия2 = Результат2.ТипМероприятия;
			Область.Параметры.КолВо2 = Результат2.КолВо;
			Область.Параметры.Сумма2 = Результат2.Сумма;
			
		КонецЕсли;   
		ТабДок.Вывести(Область);
	КонецЦикла;   
	
	Пока Результат2.Следующий() Цикл	
		Область = Макет.ПолучитьОбласть("Строка");		
		Область.Параметры.ТипМероприятия2 = Результат2.ТипМероприятия;
		Область.Параметры.КолВо2 = Результат2.КолВо;
		Область.Параметры.Сумма2 = Результат2.Сумма;
		
		ТабДок.Вывести(Область);
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура СформироватьНаСервере()
	ТабДок.Очистить();
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	
	//
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.ТипМероприятия = Отчет.ТипМероприятия;
	Область.Параметры.Дата1 = Формат(Отчет.ДатаС, "ДФ=dd.MM.yyyy");
	Область.Параметры.Дата2 = Формат(Отчет.ДатаПо, "ДФ=dd.MM.yyyy");
	Область.Параметры.Дата3 = Формат(Отчет.ДатаНа, "ДФ=dd.MM.yyyy");	
	ТабДок.Вывести(Область);
	
	//
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Мероприятия.Объект КАК ОбъектКА
	                      |ПОМЕСТИТЬ ОбъектыКА
	                      |ИЗ
	                      |	Задача.Мероприятие КАК Мероприятия
	                      |ГДЕ
	                      |	Мероприятия.ТипМероприятия = &Тип
	                      |	И Мероприятия.Выполнена
	                      |	И Мероприятия.ДатаВыполнения МЕЖДУ &ДатаС И &ДатаПо
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Мероприятия.Объект
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Услуги1.Ссылка КАК ОбъектУ,
	                      |	ОбъектыКА.ОбъектКА
	                      |ПОМЕСТИТЬ ОбъектыУ
	                      |ИЗ
	                      |	ОбъектыКА КАК ОбъектыКА
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДолговыеОбязательства КАК Услуги1
	                      |		ПО ОбъектыКА.ОбъектКА = Услуги1.Должник
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ОбъектыВРаботе.Остатки(
	                      |				&ДатаПо,
	                      |				Организация = &Организация
	                      |					И Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	                      |					И ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ВРаботеУслуги
	                      |		ПО (Услуги1.Ссылка = ВРаботеУслуги.Объект)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(*) КАК КолВо1
	                      |ИЗ
	                      |	ОбъектыКА КАК ОбъектыКА
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(СУММА(ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток), 0) КАК Сумма1
	                      |ИЗ
	                      |	ОбъектыУ КАК ОбъектыУ
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗадолженностьПоОбъектам.Остатки(&ДатаПо, ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ЗадолженностьПоОбъектамОстатки
	                      |		ПО ОбъектыУ.ОбъектУ = ЗадолженностьПоОбъектамОстатки.Объект
	                      |			И (ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток > 0)");
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос.УстановитьПараметр("Тип", Отчет.ТипМероприятия);
	Запрос.УстановитьПараметр("ДатаС", Отчет.ДатаС);
	Запрос.УстановитьПараметр("ДатаПо", Отчет.ДатаПо);
	Запрос.УстановитьПараметр("ДатаНа", Отчет.ДатаНа);
	Запрос.УстановитьПараметр("Организация", Отчет.Организация);
	Если Отчет.Организация.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", "Истина");
	КонецЕсли;
	Результат1 = Запрос.ВыполнитьПакет();
	
	//
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТипыМероприятий.Ссылка,
	               |	ТипыМероприятий.Наименование
	               |ПОМЕСТИТЬ ТипыМ
	               |ИЗ
	               |	Справочник.ТипыМероприятий КАК ТипыМероприятий
	               |ГДЕ
	               |	ТипыМероприятий.Родитель.Код = ""0012     ""
	               |	И НЕ ТипыМероприятий.Наименование ПОДОБНО ""6* %""
	               |	И ТипыМероприятий.НеОтображатьВПланировщике = ЛОЖЬ
	               |	И ТипыМероприятий.ЭтоГруппа = ЛОЖЬ
	               |	И ТипыМероприятий.ПометкаУдаления = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ОбъектыУ.ОбъектКА,
	               |	ЕСТЬNULL(СУММА(ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток), 0) КАК Сумма
	               |ПОМЕСТИТЬ СуммаПоКА
	               |ИЗ
	               |	ОбъектыУ КАК ОбъектыУ
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ОбъектыВРаботе.Остатки(
	               |				&ДатаНа,
	               |				Организация = &Организация
	               |					И Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	               |					И ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ВРаботеУслуги
	               |		ПО ОбъектыУ.ОбъектУ = ВРаботеУслуги.Объект
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗадолженностьПоОбъектам.Остатки(&ДатаНа, ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ЗадолженностьПоОбъектамОстатки
	               |		ПО ОбъектыУ.ОбъектУ = ЗадолженностьПоОбъектамОстатки.Объект
	               |			И (ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток > 0)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОбъектыУ.ОбъектКА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ОбъектыКА.ОбъектКА КАК ОбъектКА,
	               |	МАКСИМУМ(Мероприятия.ТипМероприятия) КАК ТипМ
	               |ПОМЕСТИТЬ ТипыМПоКА
	               |ИЗ
	               |	ОбъектыКА КАК ОбъектыКА
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ОбъектыВРаботе.Остатки(
	               |				&ДатаНа,
	               |				Организация = &Организация
	               |					И Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	               |					И ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.Контрагенты)) КАК ВРаботеУслуги
	               |		ПО ОбъектыКА.ОбъектКА = ВРаботеУслуги.Объект
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.Мероприятие КАК Мероприятия
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТипыМ КАК ТипыМ
	               |			ПО (ТипыМ.Ссылка = Мероприятия.ТипМероприятия)
	               |				И (Мероприятия.ДатаВыполнения = ДАТАВРЕМЯ(1, 1, 1)
	               |					ИЛИ Мероприятия.ДатаВыполнения >= &ДатаНа)
	               |				И (Мероприятия.Дата < &ДатаНа)
	               |				И (Мероприятия.ПометкаУдаления = ЛОЖЬ)
	               |				И (Мероприятия.БизнесПроцесс.ПометкаУдаления = ЛОЖЬ)
	               |		ПО ОбъектыКА.ОбъектКА = Мероприятия.Объект
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОбъектыКА.ОбъектКА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА ТипыМПоКА.ТипМ ЕСТЬ NULL 
	               |				ТОГДА 0
	               |			ИНАЧЕ 1
	               |		КОНЕЦ) КАК КолВо2,
	               |	ЕСТЬNULL(СУММА(ЕСТЬNULL(СуммаПоКА.Сумма, 0)), 0) КАК Сумма2,
	               |	ТипыМ.Ссылка КАК ТипМероприятия2
	               |ИЗ
	               |	ТипыМ КАК ТипыМ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ТипыМПоКА КАК ТипыМПоКА
	               |			ЛЕВОЕ СОЕДИНЕНИЕ СуммаПоКА КАК СуммаПоКА
	               |			ПО ТипыМПоКА.ОбъектКА = СуммаПоКА.ОбъектКА
	               |		ПО ТипыМ.Ссылка = ТипыМПоКА.ТипМ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТипыМ.Ссылка,
	               |	ТипыМ.Наименование
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТипыМ.Наименование";
	Если Отчет.Организация.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", "Истина");
	КонецЕсли;
	Результат2 = Запрос.Выполнить().Выбрать();
	
	//
	ФлагПерваяСтрока = Истина;
	Пока Результат2.Следующий() Цикл
		Область = Макет.ПолучитьОбласть("Строка");
		
		Если ФлагПерваяСтрока Тогда			
			Область.Параметры.ТипМероприятия = Отчет.ТипМероприятия;
			Область.Параметры.КолВо1 = Результат1[Результат1.ВГраница() - 1].Выгрузить()[0].КолВо1;
			Область.Параметры.Сумма1 = Результат1[Результат1.ВГраница()].Выгрузить()[0].Сумма1;
			ФлагПерваяСтрока = Ложь;
		КонецЕсли;
			
		Область.Параметры.ТипМероприятия2 = Результат2.ТипМероприятия2;
		Область.Параметры.КолВо2 = Результат2.КолВо2;
		Область.Параметры.Сумма2 = Результат2.Сумма2;
		
		ТабДок.Вывести(Область);
	КонецЦикла;
	
	//Пустая строка
	Область = Макет.ПолучитьОбласть("Строка");
	ТабДок.Вывести(Область);
	
	//Подвал
	Область = Макет.ПолучитьОбласть("Строка");
	Область.Параметры.ТипМероприятия2 = "Переданы в юр.отдел";
	Область.Параметры.КолВо2 = 0;
	ТабДок.Вывести(Область);
	
	//
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбъектыУ.ОбъектКА) КАК КолВо2
	               |ИЗ
	               |	ОбъектыУ КАК ОбъектыУ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбъектыВРаботе.Остатки(
	               |				&ДатаНа,
	               |				Организация = &Организация
	               |					И Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	               |					И ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ВРаботеУслуги
	               |		ПО ОбъектыУ.ОбъектУ = ВРаботеУслуги.Объект
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗадолженностьПоОбъектам.Остатки(&ДатаНа, ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ЗадолженностьПоОбъектамОстатки
	               |		ПО ОбъектыУ.ОбъектУ = ЗадолженностьПоОбъектамОстатки.Объект
	               |			И (ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток > 0)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДолговыеОбязательства.ДополнительныеРеквизиты КАК Услуги
	               |		ПО ОбъектыУ.ОбъектУ = Услуги.Ссылка
	               |			И (Услуги.Значение = ЛОЖЬ)
	               |			И (Услуги.Свойство = &Свойство)
	               |ГДЕ
	               |	(ВРаботеУслуги.Объект ЕСТЬ NULL 
	               |			ИЛИ ЕСТЬNULL(ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток, 0) <= 0)";
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду("!!!!"));
	Область = Макет.ПолучитьОбласть("Строка");
	Область.Параметры.ТипМероприятия2 = "Процесс завершен оплатой";
	Область.Параметры.КолВо2 = Запрос.Выполнить().Выгрузить()[0].КолВо2;
	ТабДок.Вывести(Область);
	
	//
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбъектыУ.ОбъектКА) КАК КолВо2
	               |ИЗ
	               |	ОбъектыУ КАК ОбъектыУ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбъектыВРаботе.Остатки(
	               |				&ДатаНа,
	               |				Организация = &Организация
	               |					И Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	               |					И ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ВРаботеУслуги
	               |		ПО ОбъектыУ.ОбъектУ = ВРаботеУслуги.Объект
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗадолженностьПоОбъектам.Остатки(&ДатаНа, ТИПЗНАЧЕНИЯ(Объект) = ТИП(Справочник.ДолговыеОбязательства)) КАК ЗадолженностьПоОбъектамОстатки
	               |		ПО ОбъектыУ.ОбъектУ = ЗадолженностьПоОбъектамОстатки.Объект
	               |			И (ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток > 0)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДолговыеОбязательства.ДополнительныеРеквизиты КАК Услуги
	               |		ПО ОбъектыУ.ОбъектУ = Услуги.Ссылка
	               |			И (Услуги.Значение = ИСТИНА)
	               |			И (Услуги.Свойство = &Свойство)
	               |ГДЕ
	               |	(ВРаботеУслуги.Объект ЕСТЬ NULL 
	               |			ИЛИ ЕСТЬNULL(ЗадолженностьПоОбъектамОстатки.СуммаРеглОстаток, 0) <= 0)";
	
	Область = Макет.ПолучитьОбласть("Строка");
	Область.Параметры.ТипМероприятия2 = "Процесс завершен корректировкой";
	Область.Параметры.КолВо2 = Запрос.Выполнить().Выгрузить()[0].КолВо2;
	ТабДок.Вывести(Область);
КонецПроцедуры
