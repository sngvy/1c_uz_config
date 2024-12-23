﻿Функция СформироватьСклеиныйТекст(Знач Буфер, ИмяФайла, Номер = "") Экспорт

	ПереместитьФайл(
		ИмяФайла + ШаблоныДокументовСервер.ФорматУниверсальногоФайла(),
		ИмяФайла + ШаблоныДокументовСервер.ФорматZIPФайла());
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяФайла + ШаблоныДокументовСервер.ФорматZIPФайла(), "");
	СоздатьКаталог(ИмяФайла);
	ЧтениеZIP.ИзвлечьВсе(ИмяФайла);
	ПутьXML = ИмяФайла + ПолучитьРазделительПути();
	ПутьXML = ШаблоныДокументовСервер.ИмяФайлаССодержимымВАрхивеDOCX(ПутьXML);
	
	ЧтениеФайла = Новый ТекстовыйДокумент;
	ЧтениеФайла.Прочитать(ПутьXML);
	ТекстXML = ЧтениеФайла.ПолучитьТекст();
	
	НовыйТекст = Буфер;
	НачалоBody = 1;
	Если ЗначениеЗаполнено(НовыйТекст) Тогда
	
		НачалоBody = СтрНайти(ТекстXML, "<w:body>");
	
	КонецЕсли;
	КонецBody = СтрНайти(ТекстXML, "</w:body>", НаправлениеПоиска.СКонца);
	ДнинаКонецBody = 9;
	
	Если Номер <> "Первый" Тогда
	
		НовыйТекст = НовыйТекст + ТекстНовойСтроки();
	
	КонецЕсли;
	Если НачалоBody <> 0 И КонецBody <> 0 Тогда
	
		НовыйТекст = НовыйТекст + Сред(ТекстXML, НачалоBody, КонецBody - НачалоBody + ДнинаКонецBody + 1);
	
	КонецЕсли;
	
	Если Номер = "Последний" Тогда
	
		НовыйТекст = НовыйТекст + Прав(ТекстXML, СтрДлина(ТекстXML) - КонецBody - ДнинаКонецBody);
	
	КонецЕсли;
	
	Возврат НовыйТекст;

КонецФункции

Функция ЗаписатьСклеенныйФайл(Буфер, ИмяФайла, Номер) Экспорт

	ПереместитьФайл(
		ИмяФайла + ШаблоныДокументовСервер.ФорматУниверсальногоФайла(),
		ИмяФайла + ШаблоныДокументовСервер.ФорматZIPФайла());
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяФайла + ШаблоныДокументовСервер.ФорматZIPФайла(), "");
	СоздатьКаталог(ИмяФайла);
	ЧтениеZIP.ИзвлечьВсе(ИмяФайла);
	ПутьXML = ИмяФайла + ПолучитьРазделительПути();
	ПутьXML = ПутьXML + "word" + ПолучитьРазделительПути() + "document.xml";
	
	ЧтениеФайла = Новый ТекстовыйДокумент;
	ЧтениеФайла.Прочитать(ПутьXML);
	ТекстXML = ЧтениеФайла.ПолучитьТекст();
	
	НовыйТекст = Буфер;
	НачалоBody = 1;
	Если ЗначениеЗаполнено(НовыйТекст) Тогда
	
		НачалоBody = СтрНайти(ТекстXML, "<w:body>");
	
	КонецЕсли;
	КонецBody = СтрНайти(ТекстXML, "</w:body>", НаправлениеПоиска.СКонца);
	ДнинаКонецBody = 9;
	
	Если Номер <> "Первый" Тогда
	
		НовыйТекст = НовыйТекст + ТекстНовойСтроки();
	
	КонецЕсли;
	Если НачалоBody <> 0 И КонецBody <> 0 Тогда
	
		НовыйТекст = НовыйТекст + Сред(ТекстXML, НачалоBody, КонецBody - НачалоBody + ДнинаКонецBody + 1);
	
	КонецЕсли;
	
	Если Номер = "Последний" Тогда
	
		НовыйТекст = НовыйТекст + Прав(ТекстXML, СтрДлина(ТекстXML) - КонецBody - ДнинаКонецBody);
	
	КонецЕсли;
	
	Возврат НовыйТекст;

КонецФункции

Функция ОднаИсходящаяКорреспонденция(НаборШаблонов) Экспорт

	Возврат НаборШаблонов.ОднаИсходящаяКорреспонденция;

КонецФункции // ()

Функция ОбъектыПоНазначению(Объекты, Шаблон) Экспорт

	Если Объекты.Количество() = 0 Тогда
	
		Возврат Объекты;
	
	КонецЕсли;

	Назначение = Шаблон.Назначение;
	ТипНазначения = УЭДСервер.ПолучитьТипИзСтроки(Назначение);
	Если ТипЗнч(Объекты[0]) = ТипНазначения Тогда
	
		Возврат Объекты;
	
	КонецЕсли;
	
	Если ТипЗнч(Объекты[0]) <> Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
	
		ВызватьИсключение "Конвертация объектов производится только из Долговых обязательств"
						+ Символы.ПС + "Используемый тип: " + ТипЗнч(Объекты[0]);
	
	КонецЕсли;
	
	Возврат Справочники.тсВидыПечатныхДокументов.ОбъектыПоНазначению(
		Объекты,
		ТипНазначения
	);

КонецФункции // ()

Функция ТекстНовойСтроки()

	Возврат "<w:p w:rsidRDefault=""005874EA"" w:rsidR=""005874EA""><w:r><w:br w:type=""page""/></w:r></w:p>";

КонецФункции // ()

Функция НачатьИсходящуюКорреспонденцию(Шаблон, ДанныеРегистрации)

	ОбъектИсходящаяКорреспонденция = Справочники.ИсходящаяКорреспонденция.СоздатьЭлементПоШаблонуПечатнойФормы(Шаблон);
	ОбъектИсходящаяКорреспонденция.Объект = ДанныеРегистрации["Основание"];;
	
	Возврат ОбъектИсходящаяКорреспонденция;

КонецФункции // ()

Функция ЗарегистрироватьИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, Шаблон, ДанныеРегистрации)

	Результат = ОбъектИсходящаяКорреспонденция.Зарегестрировать(Шаблон, ДанныеРегистрации);
	Если Результат Тогда
	
		ОбъектИсходящаяКорреспонденция.Записать();
	
	КонецЕсли;
	
	Возврат ОбъектИсходящаяКорреспонденция;

КонецФункции // ()

Функция ДобавитьФайлВИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, Шаблон, ДанныеРегистрации)

	Результат = ОбъектИсходящаяКорреспонденция.ДобавитьФайл(Шаблон, ДанныеРегистрации);
	Если Результат Тогда
	
		ОбъектИсходящаяКорреспонденция.Записать();
	
	КонецЕсли;
	
	Возврат ОбъектИсходящаяКорреспонденция;

КонецФункции // ()

// НаборДокументов -- Массив - Комплект шаблонов по основанию
//  Комплект -- Массив - Свойства шаблона
//    ИсходящаяКомплектом -- Булево - Регистрация шаблонов одной корреспонденцией\раздельно
//    Основание -- СправочникСсылка.(ДолговыеОбязательства, Контрагенты ...) - Объект на основании которого формировался шаблон
//    Документ -- ДокументСсылка.ПрикреплениеФайлов
//    Настройки -- Структура - Детальные данные шаблона
//      ИсходящийНомер - Булево - Требуется ли прикреплять данный шаблон
//      ШаблонПечатнойФормы -- СправочникСсылка.тсШаблоныПечатныхФорм
//      РегистрационныйНомер -- Строка
//      ДатаРегистрации -- Дата
Процедура СоздатьИсходящуюКорреспонденцию(НаборДокументов) Экспорт

	Для каждого Комплект Из НаборДокументов Цикл
	
		ОбъектИсходящаяКорреспонденция = Неопределено;
		
		Для каждого СвойстваШаблона Из Комплект Цикл
		
			Если НЕ СвойстваШаблона["ИсходящаяКомплектом"] Тогда
			
				ОбъектИсходящаяКорреспонденция = Неопределено;
			
			КонецЕсли;
			
			ОбъектИсходящаяКорреспонденция = СформироватьИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, СвойстваШаблона);
		
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры

Функция СформироватьИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, СвойстваШаблона)

	ДанныеШаблона = СвойстваШаблона["Настройки"];
	Если НЕ ДанныеШаблона["ИсходящийНомер"] Тогда
	
		Возврат ОбъектИсходящаяКорреспонденция;
	
	КонецЕсли;
	
	Шаблон = ДанныеШаблона["ШаблонПечатнойФормы"];
	
	ДанныеРегистрации = Новый Структура;
	ДанныеРегистрации.Вставить("Номер", ДанныеШаблона["РегистрационныйНомер"]);
	ДанныеРегистрации.Вставить("Дата", ДанныеШаблона["ДатаРегистрации"]);
	ДанныеРегистрации.Вставить("Основание", СвойстваШаблона["Основание"]);
	ДанныеРегистрации.Вставить("ДокументПрикрепление", СвойстваШаблона["Документ"]);
	
	Если ОбъектИсходящаяКорреспонденция = Неопределено Тогда
	
		ОбъектИсходящаяКорреспонденция = НачатьИсходящуюКорреспонденцию(Шаблон, ДанныеРегистрации);
		ОбъектИсходящаяКорреспонденция = ЗарегистрироватьИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, Шаблон, ДанныеРегистрации);
	
	КонецЕсли;
	
	Возврат ДобавитьФайлВИсходящуюКорреспонденцию(ОбъектИсходящаяКорреспонденция, Шаблон, ДанныеРегистрации);

КонецФункции // ()

Функция РегистрационныйНомерКомплекта(Основание, ПечатнаяФорма) Экспорт

	Если НЕ ПечатнаяФорма.ОднаИсходящаяКорреспонденция Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	Шаблоны = ПечатнаяФорма.ШаблоныПечатныхФорм;
	Если Шаблоны.Количество() = 0 Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	ТипПисьма = Неопределено;
	Для каждого Шаблон Из Шаблоны Цикл
	
		Если Шаблон.ШаблонПечатнойФормы.Пустая() Тогда
		
			Возврат Неопределено;
		
		КонецЕсли;
		Если НЕ Шаблон.ИсходящийНомер Тогда
		
			Продолжить;
		
		КонецЕсли;

		ТипПисьма = Шаблон.ШаблонПечатнойФормы.ТипПисьма;
		Прервать;
	
	КонецЦикла;
	
	РегистрационныйНомер = РегистрацияКорреспонденции.СледующийНомер(
		ТипПисьма,
		Основание);
	
	Возврат РегистрационныйНомер;

КонецФункции // ()