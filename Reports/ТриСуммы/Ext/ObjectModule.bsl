﻿
Процедура ЗаполнитьТабличныйДокумент(ТабДок) Экспорт
	
	Макет = ЭтотОбъект.ПолучитьМакет("МакетДолг");
	ТабДок.Очистить();	
	
	Область = Макет.ПолучитьОбласть("ШапкаДолг");	
	
	Если ТипЗнч(Объект) <> Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
		ТабДок.Вывести(Область); 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.ОсновнойДолгРеглОстаток, 0) КАК ОсновнойДолг,
	                      |	ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.ПроцентыРеглОстаток, 0) КАК Проценты,
	                      |	ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.ШтрафыРеглОстаток, 0) КАК Штрафы,
	                      |	ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.ПениРеглОстаток, 0) КАК Пени,
	                      |	-ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.Составляющая8РеглОстаток, 0) КАК Переплата,
	                      |	ЕСТЬNULL(ЗадолженностьПоОбъектамВнесудебнаяОстатки.СуммаДООстаток, 0) КАК Итого
	                      |ИЗ
	                      |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗадолженностьПоОбъектамВнесудебная.Остатки(, Объект = &Объект) КАК ЗадолженностьПоОбъектамВнесудебнаяОстатки
	                      |		ПО ((ВЫРАЗИТЬ(ЗадолженностьПоОбъектамВнесудебнаяОстатки.Объект КАК Справочник.ДолговыеОбязательства)) = ДолговыеОбязательства.Ссылка)
	                      |ГДЕ
	                      |	ДолговыеОбязательства.Ссылка = &Объект");
	Запрос.УстановитьПараметр("Объект", Объект);
	ДРезультат = Запрос.Выполнить().Выбрать();
	ДРезультат.Следующий();
	
	Область.Параметры.ДОсновнойДолг = Формат(ДРезультат.ОсновнойДолг, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ДПроценты = Формат(ДРезультат.Проценты, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ДШтрафы = Формат(ДРезультат.Штрафы, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ДПени = Формат(ДРезультат.Пени, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ДИтого = Формат(ДРезультат.Итого, "ЧДЦ=2; ЧН=0");	
	
	Если ДРезультат.Переплата = 0 Тогда
		Область.Параметры.ДПереплата = "";
		Область.Параметры.ДСтрПереплата = "";
		Область.Параметры.ДВалюта = "";			
	Иначе
		Область.Параметры.ДПереплата = Формат(ДРезультат.Переплата, "ЧДЦ=2; ЧН=0");
		Область.Параметры.ДСтрПереплата = "Переплата:";
		Область.Параметры.ДВалюта = Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное + ".";		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИсковыеТребованияОстатки.Займ КАК Займ,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.СуммаОсновнойДолгОстаток, 0) КАК ОсновнойДолг,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.СуммаПроцентыОстаток, 0) КАК Проценты,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.СуммаШтрафыОстаток, 0) КАК Штрафы,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.СуммаПениОстаток, 0) КАК Пени,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.ЦенаИскаОстаток, 0) КАК Итого,
	                      |	ЕСТЬNULL(ИсковыеТребованияОстатки.СуммаГоспошлинаОстаток, 0) КАК Госпошлина
	                      |ИЗ
	                      |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ИсковыеТребования.Остатки(, Займ = &Займ) КАК ИсковыеТребованияОстатки
	                      |		ПО (ИсковыеТребованияОстатки.Займ = ДолговыеОбязательства.Ссылка)
	                      |ГДЕ
	                      |	ДолговыеОбязательства.Ссылка = &Займ");
	Запрос.УстановитьПараметр("Займ", Объект);
	ИскРезультат = Запрос.Выполнить().Выбрать();
	ИскРезультат.Следующий();
	
	Область.Параметры.ИскОсновнойДолг = Формат(ИскРезультат.ОсновнойДолг, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ИскПроценты = Формат(ИскРезультат.Проценты, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ИскШтрафы = Формат(ИскРезультат.Штрафы, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ИскПени = Формат(ИскРезультат.Пени, "ЧДЦ=2; ЧН=0");
	Область.Параметры.ИскГоспошлина = Формат(ИскРезультат.Госпошлина, "ЧДЦ=2; ЧН=0");
	Попытка
		Область.Параметры.ИскИтого = Формат(ИскРезультат.Итого + ИскРезультат.Госпошлина, "ЧДЦ=2; ЧН=0");
	Исключение
	КонецПопытки; 
	
	Если ДРезультат.Итого <> Неопределено И ДРезультат.Итого <> Неопределено Тогда	
		РазницаПодачи =  ДРезультат.Итого - ИскРезультат.Итого;
		
		Если РазницаПодачи < 0 и ДРезультат.Итого <> 0  тогда
			Область.Параметры.Аларм = "Внимание! Общая сумма платежей больше, чем общая задолженность. Переплата: "+ (-РазницаПодачи)+" руб."
		КонецЕсли;	
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗадолженностьПоСудебнымРешениямОстатки.Займ КАК Займ,
	                      |	ЗадолженностьПоСудебнымРешениямОстатки.ТипЗадолженности КАК ТипЗадолженности,
	                      |	ЗадолженностьПоСудебнымРешениямОстатки.СуммаОстаток КАК СуммаОстаток
	                      |ИЗ
	                      |	РегистрНакопления.ЗадолженностьПоСудебнымРешениям.Остатки(, Займ = &Займ) КАК ЗадолженностьПоСудебнымРешениямОстатки");
	Запрос.УстановитьПараметр("Займ", Объект);
	РешРезультат = Запрос.Выполнить().Выгрузить();
	
	СписокСоставляющих = СписокСоставляющих();
	Для Каждого Элемент Из СписокСоставляющих Цикл
		стр = Новый Структура("ТипЗадолженности", Элемент);
		Строки = РешРезультат.НайтиСтроки(стр);
		Если Строки.Количество() > 0 Тогда
			Сумма = Строки[0].СуммаОстаток;
		Иначе
			Сумма = 0;
		КонецЕсли;
		Область.Параметры["Реш" + Элемент.ИмяПредопределенныхДанных] = Формат(Сумма, "ЧДЦ=2; ЧН=0"); 
	КонецЦикла;
		
	стр = Новый Структура("ТипЗадолженности", ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Переплата);
	Строки = РешРезультат.НайтиСтроки(стр);
	Если Строки.Количество() > 0 Тогда
		СуммаПереплата = Строки[0].СуммаОстаток;
	Иначе
		СуммаПереплата = 0;
	КонецЕсли;
		
	Если СуммаПереплата = 0 Тогда
		Область.Параметры.РешПереплата = "";
		Область.Параметры.РешСтрПереплата = "";
		Область.Параметры.РешВалюта = "";			
	Иначе
		Область.Параметры.РешПереплата = Формат(СуммаПереплата, "ЧДЦ=2; ЧН=0");
		Область.Параметры.РешСтрПереплата = "Переплата:";
		Область.Параметры.РешВалюта = Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное + ".";		
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗадолженностьПоСудебнымРешениямОстатки.Займ КАК Займ,
	               |	ЗадолженностьПоСудебнымРешениямОстатки.СуммаОстаток КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.ЗадолженностьПоСудебнымРешениям.Остатки(&ТекущаяДата) КАК ЗадолженностьПоСудебнымРешениямОстатки
	               |ГДЕ
	               |	ЗадолженностьПоСудебнымРешениямОстатки.Займ = &Займ";
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		СуммаИтого = Результат.СуммаОстаток;
	Иначе
		СуммаИтого = 0;
	КонецЕсли;
	
	Область.Параметры.РешИтого = Формат(СуммаИтого, "ЧДЦ=2; ЧН=0");	
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(СУММА(ЗадолженностьПоОбъектамВнесудебная.СуммаРегл), 0) КАК СуммаРегл
	                      |ИЗ
	                      |	РегистрНакопления.ЗадолженностьПоОбъектамВнесудебная КАК ЗадолженностьПоОбъектамВнесудебная
	                      |ГДЕ
	                      |	ЗадолженностьПоОбъектамВнесудебная.Объект = &Объект
	                      |	И ЗадолженностьПоОбъектамВнесудебная.ВидДвиженияЗадолженности = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияЗадолженности.Оплата)");
	Запрос.УстановитьПараметр("Объект", Объект);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Сумма1 = Результат.СуммаРегл;
	Иначе
		Сумма1 = 0;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(СУММА(ЗадолженностьПоСудебнымРешениям.Сумма), 0) КАК СуммаРешения
	                      |ИЗ
	                      |	РегистрНакопления.ЗадолженностьПоСудебнымРешениям КАК ЗадолженностьПоСудебнымРешениям
	                      |ГДЕ
	                      |	ЗадолженностьПоСудебнымРешениям.Займ = &Займ
	                      |	И ЗадолженностьПоСудебнымРешениям.ВидДвиженияЗадолженности = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияЗадолженности.Оплата)");
	Запрос.УстановитьПараметр("Займ", Объект);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Сумма2 = Результат.СуммаРешения;
	Иначе
		Сумма2 = 0;
	КонецЕсли;
	
	Область.Параметры.Сумма1 = Формат(Сумма1, "ЧДЦ=2; ЧН=0");
	Область.Параметры.Сумма2 = Формат(Сумма2, "ЧДЦ=2; ЧН=0");
	
	Область.Параметры.Валюта = Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное;
	
	ТабДок.Вывести(Область);

КонецПроцедуры

Функция СписокСоставляющих()
	Массив = Новый Массив;
	
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Госпошлина);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Проценты);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.ОсновнойДолг);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Пени);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Штрафы);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженностиПоРешению.Переплата);
	
	Возврат Массив;
	
КонецФункции