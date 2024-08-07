﻿
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьСервер();
КонецПроцедуры

&НаСервере
Процедура СформироватьСервер()
	ОбъектОбработки = РеквизитФормыВЗначение("Отчет");
	Макет = ОбъектОбработки.ПолучитьМакет("Макет");
	ТабДок.Очистить();
	
	//Печать шапки
	Область = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Период");
	ТекстПериод = "За период";
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ТекстПериод = ТекстПериод + " от " + Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстПериод = ТекстПериод + " до " + Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	
	Область.Параметры.Период = ТекстПериод;
	
	ТабДок.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Шапка1");
	ТабДок.Вывести(Область);	
	
			
	Область = Макет.ПолучитьОбласть("ДействияПоВозврату");
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОбъектыВРаботеОстатки.Объект КАК Объект,
	                      |	""МероприятияПоДО"" КАК ВидДействия,
	                      |	Мероприятие.Ссылка КАК Действие,
	                      |	Мероприятие.ДатаВыполнения КАК Дата,
	                      |	Мероприятие.Исполнитель КАК Сотрудник
	                      |ПОМЕСТИТЬ ВсеДействия
	                      |ИЗ
	                      |	РегистрНакопления.ОбъектыВРаботе.Остатки(&ТекущаяДата) КАК ОбъектыВРаботеОстатки
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.Мероприятие КАК Мероприятие
	                      |		ПО ОбъектыВРаботеОстатки.Объект = Мероприятие.Объект
	                      |ГДЕ
	                      |	Мероприятие.Выполнена = ИСТИНА
	                      |	И Мероприятие.ПометкаУдаления = ЛОЖЬ
	                      |	И Мероприятие.ДатаВыполнения >= &НачалоПериода
	                      |	И Мероприятие.ДатаВыполнения <= &КонецПериода
	                      |	И Мероприятие.ТипМероприятия.ВключатьВОтчетФССП = ИСТИНА
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ОбъектыВРаботеОстатки.Объект,
	                      |	""МероприятияПоДолжникам"",
	                      |	Мероприятие.Ссылка,
	                      |	Мероприятие.ДатаВыполнения,
	                      |	Мероприятие.Исполнитель
	                      |ИЗ
	                      |	РегистрНакопления.ОбъектыВРаботе.Остатки(&ТекущаяДата) КАК ОбъектыВРаботеОстатки
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.Мероприятие КАК Мероприятие
	                      |		ПО ОбъектыВРаботеОстатки.Объект.Должник = Мероприятие.Объект
	                      |ГДЕ
	                      |	Мероприятие.Выполнена = ИСТИНА
	                      |	И Мероприятие.ПометкаУдаления = ЛОЖЬ
	                      |	И Мероприятие.ДатаВыполнения >= &НачалоПериода
	                      |	И Мероприятие.ДатаВыполнения <= &КонецПериода
	                      |	И Мероприятие.ТипМероприятия.ВключатьВОтчетФССП = ИСТИНА
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ОбъектыВРаботеОстатки.Объект,
	                      |	""Документы"",
	                      |	ИсходящаяКорреспонденция.Ссылка,
	                      |	ИсходящаяКорреспонденция.ДатаРегистрации,
	                      |	ИсходящаяКорреспонденция.Автор
	                      |ИЗ
	                      |	РегистрНакопления.ОбъектыВРаботе.Остатки(&ТекущаяДата) КАК ОбъектыВРаботеОстатки
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИсходящаяКорреспонденция КАК ИсходящаяКорреспонденция
	                      |		ПО ОбъектыВРаботеОстатки.Объект = ИсходящаяКорреспонденция.Объект
	                      |ГДЕ
	                      |	ИсходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	                      |	И ИсходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	                      |	И ИсходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	                      |	И ИсходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВсеДействия.Объект.Должник) КАК ЧислоДолжников
	                      |ИЗ
	                      |	ВсеДействия КАК ВсеДействия");
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);	
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо1 = Строка(Результат.ЧислоДолжников);
	Иначе
		Область.Параметры.КолВо1 = "0";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходящаяКорреспонденция.Объект
	               |ПОМЕСТИТЬ ВсеДокументы
	               |ИЗ
	               |	Справочник.ВходящаяКорреспонденция КАК ВходящаяКорреспонденция
	               |ГДЕ
	               |	ВходящаяКорреспонденция.ТипПисьма = &ЧерезПредставителя
	               |	И ВходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	               |	И ВходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	               |	И ВходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	               |	И ВходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ВсеДокументы.Объект) КАК ЧислоЗаявлений
	               |ИЗ
	               |	ВсеДокументы КАК ВсеДокументы";
	Запрос.УстановитьПараметр("ЧерезПредставителя", Справочники.ТипыВходящихПисем.ЗаявлениеОВзаимодействииЧерезПредставителя);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо2 = Строка(Результат.ЧислоЗаявлений);
	Иначе
		Область.Параметры.КолВо2 = "0";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходящаяКорреспонденция.Объект
	               |ПОМЕСТИТЬ ВсеДокументы
	               |ИЗ
	               |	Справочник.ВходящаяКорреспонденция КАК ВходящаяКорреспонденция
	               |ГДЕ
	               |	ВходящаяКорреспонденция.ТипПисьма = &ОбОтказе
	               |	И ВходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	               |	И ВходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	               |	И ВходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	               |	И ВходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ВсеДокументы.Объект) КАК ЧислоЗаявлений
	               |ИЗ
	               |	ВсеДокументы КАК ВсеДокументы";
	Запрос.УстановитьПараметр("ОбОтказе", Справочники.ТипыВходящихПисем.ЗаявлениеОбОтказеОтВзаимодействия);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо3 = Строка(Результат.ЧислоЗаявлений);
	Иначе
		Область.Параметры.КолВо3 = "0";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходящаяКорреспонденция.Ссылка
	               |ПОМЕСТИТЬ ВсеДокументы
	               |ИЗ
	               |	Справочник.ВходящаяКорреспонденция КАК ВходящаяКорреспонденция
	               |ГДЕ
	               |	(ВходящаяКорреспонденция.ТипПисьма = &Жалоба
	               |			ИЛИ ВходящаяКорреспонденция.ТипПисьма = &Обращение)
	               |	И ВходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	               |	И ВходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	               |	И ВходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	               |	И ВходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ВсеДокументы.Ссылка) КАК ЧислоЗаявлений
	               |ИЗ
	               |	ВсеДокументы КАК ВсеДокументы";
	Запрос.УстановитьПараметр("Жалоба", Справочники.ТипыВходящихПисем.ЖалобаФизическогоЛица);
	Запрос.УстановитьПараметр("Обращение", Справочники.ТипыВходящихПисем.ОбращениеФизическогоЛица);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо4 = Строка(Результат.ЧислоЗаявлений);
	Иначе
		Область.Параметры.КолВо4 = "0";
	КонецЕсли;	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходящаяКорреспонденция.Ссылка
	               |ПОМЕСТИТЬ ВсеДокументы
	               |ИЗ
	               |	Справочник.ВходящаяКорреспонденция КАК ВходящаяКорреспонденция
	               |ГДЕ
	               |	(ВходящаяКорреспонденция.ТипПисьма = &Жалоба
	               |			ИЛИ ВходящаяКорреспонденция.ТипПисьма = &Обращение)
	               |	И ВходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	               |	И ВходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	               |	И ВходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	               |	И ВходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	               |	И ВходящаяКорреспонденция.Рассмотрено = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ВсеДокументы.Ссылка) КАК ЧислоРассмотренных
	               |ИЗ
	               |	ВсеДокументы КАК ВсеДокументы";
	Запрос.УстановитьПараметр("Жалоба", Справочники.ТипыВходящихПисем.ЖалобаФизическогоЛица);
	Запрос.УстановитьПараметр("Обращение", Справочники.ТипыВходящихПисем.ОбращениеФизическогоЛица);	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо5 = Строка(Результат.ЧислоРассмотренных);
	Иначе
		Область.Параметры.КолВо5 = "0";
	КонецЕсли;	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходящаяКорреспонденция.Ссылка,
	               |	ВходящаяКорреспонденция.Объект
	               |ПОМЕСТИТЬ ВсеДокументы
	               |ИЗ
	               |	Справочник.ВходящаяКорреспонденция КАК ВходящаяКорреспонденция
	               |ГДЕ
	               |	(ВходящаяКорреспонденция.ТипПисьма = &Жалоба
	               |			ИЛИ ВходящаяКорреспонденция.ТипПисьма = &Обращение)
	               |	И ВходящаяКорреспонденция.ПометкаУдаления = ЛОЖЬ
	               |	И ВходящаяКорреспонденция.ДатаРегистрации >= &НачалоПериода
	               |	И ВходящаяКорреспонденция.ДатаРегистрации <= &КонецПериода
	               |	И ВходящаяКорреспонденция.НомерЗакреплен = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ВсеДокументы.Ссылка) КАК ЧислоЗаявлений,
	               |	ВсеДокументы.Объект
	               |ПОМЕСТИТЬ ОбъектыИЧисло
	               |ИЗ
	               |	ВсеДокументы КАК ВсеДокументы
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВсеДокументы.Объект
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ОбъектыИЧисло.ЧислоЗаявлений - 1) КАК ЧислоПовторных
	               |ИЗ
	               |	ОбъектыИЧисло КАК ОбъектыИЧисло
	               |ГДЕ
	               |	ОбъектыИЧисло.ЧислоЗаявлений > 1";
	Запрос.УстановитьПараметр("Жалоба", Справочники.ТипыВходящихПисем.ЖалобаФизическогоЛица);
	Запрос.УстановитьПараметр("Обращение", Справочники.ТипыВходящихПисем.ОбращениеФизическогоЛица);		
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Область.Параметры.КолВо6 = Строка(Результат.ЧислоПовторных);
	Иначе
		Область.Параметры.КолВо6 = "0";
	КонецЕсли;	
	
	ТабДок.Вывести(Область);
КонецПроцедуры
