﻿

&НаСервере
Процедура РассчитатьГрафикНаСервере()
	//ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
	//ЗначениеОбъект.ЗагрузитьГрафикНачислений();
	//ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
	
	Объект.ГрафикИндексации.Загрузить(РасчетЗадолженностиСудопроизводство.РассчитатьГрафикИндексации(Объект, Объект.ИсторияПлатежей.Выгрузить()));
	
	к = Объект.ГрафикИндексации.Количество();
	Если к > 0 Тогда
		Элементы.ГрафикНачисленияИПогашенияКУплате.ТекстПодвала = Строка(Объект.ГрафикИндексации[к-1].Куплате);
		Элементы.ГрафикНачисленияИПогашенияОстаткиОсновнойДолг.ТекстПодвала = Строка(Объект.ГрафикИндексации[к-1].ОстаткиОсновнойДолг);
		Элементы.ГрафикНачисленияИПогашенияОстаткиПроценты.ТекстПодвала = Строка(Объект.ГрафикИндексации[к-1].ОстаткиПроценты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьГрафик(Команда)
	Если Не ЗначениеЗаполнено(Объект.ДатаРешения) Тогда
		Сообщить("Заполните дату решения!");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.СуммаЗадолженности) Тогда
		Сообщить("Заполните сумму решения!");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.ДатаРасчета) Тогда
		Сообщить("Заполните дату расчета!");
		Возврат;
	КонецЕсли;	
	РассчитатьГрафикНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Объект.ДатаВыдачиЗайма = ТекущаяДата();
	//Объект.ДатаДоговора = ТекущаяДата();
	//Объект.ДатаПогашения = ТекущаяДата() + 10*24*3600;
	//Объект.ДатаРасчета = ТекущаяДата() + 20*24*3600;
	//Объект.СуммаВыданногоЗайма = 10000;
	//Объект.ПроцентнаяСтавка = 1;
	Объект.ДатаРасчета = ТекущаяДатаСеанса();
	//Объект.ДатаРешения = Дата("20190115");
	//Объект.СуммаЗадолженности = 100000; 
	Объект.КапитализацияПроцентов = Истина;
	Объект.ПереноситьОплатыНаНачалоМесяца = Истина;
	Объект.ИсключитьКрайниеМесяцы = Истина;
	Объект.Территория = "Свердловская область";


КонецПроцедуры


&НаСервере
Процедура ЗаймПриИзмененииНаСервере()
	//Объект.ДатаВыдачиЗайма = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0046     ");
	//Объект.ДатаДоговора = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0046     ");
	//Объект.ДатаПогашения = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0047     ");
	//Объект.ДатаРасчета = ТекущаяДата();
	//Объект.СуммаВыданногоЗайма = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0048     ");
	//Объект.ПроцентнаяСтавка = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0045     ");
	//
	//Объект.ОстаткиДата = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0043     ");
	//Объект.ДниПросрочки = ОбъектыСервер.ПолучитьЗначениеСвойства(Объект.Займ,"0069     ");
	//ЗаполнитьОстатки(Объект.Займ);

	// Вставить содержимое обработчика.
	
	//ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
	//ЗначениеОбъект.ЗаполнитьДанные();
	//ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИсторияПлатежей.Период КАК ДатаПлатежа,
	                      |	ИсторияПлатежей.Задолженность КАК СуммаПлатежа
	                      |ИЗ
	                      |	РегистрНакопления.ИсторияПлатежей КАК ИсторияПлатежей
	                      |ГДЕ
	                      |	ИсторияПлатежей.Объект = &Объект");
	Запрос.УстановитьПараметр("Объект", Объект.Займ);
	Результат = Запрос.Выполнить().Выгрузить();
	Объект.ИсторияПлатежей.Загрузить(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ЗаймПриИзменении(Элемент)
//	Объект.СуммаЗадолженности = ЭтаФорма.ВладелецФормы.Объект.ЦенаИска;
//	Объект.ДатаРешения = НачалоДня(ЭтаФорма.ВладелецФормы.Объект.Дата);
	ЗаймПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстатки(ДО)
	//Запрос = Новый Запрос();
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	ЗадолженностьПоОбъектамОстатки.ОсновнойДолгДООстаток КАК ОсновнойДолгДООстаток,
	//               |	ЗадолженностьПоОбъектамОстатки.ПроцентыДООстаток КАК ПроцентыДООстаток,
	//               |	ЗадолженностьПоОбъектамОстатки.ШтрафыДООстаток КАК ШтрафыДООстаток
	//               |ИЗ
	//               |	РегистрНакопления.ЗадолженностьПоОбъектам.Остатки КАК ЗадолженностьПоОбъектамОстатки
	//               |ГДЕ
	//               |	ЗадолженностьПоОбъектамОстатки.Объект = &Объект";
	//Запрос.УстановитьПараметр("Объект",ДО);
	//Рез = Запрос.Выполнить().Выбрать();
	//Пока Рез.Следующий() Цикл
	//	Объект.ОстаткиОД = Рез.ОсновнойДолгДООстаток;
	//	Объект.ОстаткиПросроченныеПроценты = Рез.ШтрафыДООстаток;
	//	Объект.ОстаткиПроценты = Рез.ПроцентыДООстаток;
	//КонецЦикла;	
	
КонецПроцедуры


&НаСервере
Процедура ПриОткрытииНаСервере()
	//Объект.ДатаРасчета = НачалоДня(ТекущаяДата());
	//Объект.ТекущийДоговор = РасчетЗадолженностиМФО.ПолучитьТекущийДоговор(Объект.Займ, НачалоДня(ТекущаяДата()));
	//Список = РасчетЗадолженностиМФО.СписокРеквизитовДоговорМикрозайма();
	//Для Каждого Реквизит Из Список Цикл
	//	Попытка
	//		Объект[Реквизит] = Объект.ТекущийДоговор[Реквизит];
	//	Исключение
	//		
	//	КонецПопытки;
	//КонецЦикла;
	//Объект.ИсторияПлатежей.Загрузить(РасчетЗадолженностиМФО.ПолучитьИсториюПлатежей(Объект.ТекущийДоговор));
	Объект.ИсторияПлатежей.Сортировать("ДатаПлатежа");
	Если ЗначениеЗаполнено(Объект.Займ) Тогда
		ЗаймПриИзмененииНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаймПриИзменении(Неопределено);
	ПриОткрытииНаСервере();
КонецПроцедуры
	
	

