﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ДатаДоговора = ТекущаяДатаСеанса();
		Объект.ДатаВыдачиЗайма = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗаполнитьГрафикПлатежей();
	РасчетЗадолженностиМФО.СформироватьТекстГиперссылкиИнтервалыПроцентнойСтавки(ЭтотОбъект, Ложь);
	УправлениеФормой();
КонецПроцедуры

&НаСервере
Процедура ПерерасчетНаСервере()
	РасчетЗадолженностиМФО.РассчитатьГрафикПоЗайму(Объект.Займ, Объект.ДатаВыдачиЗайма);
КонецПроцедуры

&НаКлиенте
Процедура Перерасчет(Команда)
	ЭтаФорма.Записать();
	ПерерасчетНаСервере();
	Оповестить("ГрафикНачисленийПерерасчитан");
КонецПроцедуры

&НаСервере
Процедура РассчитатьГрафикНаСервере()
	Объект.ГрафикПлатежей.Очистить();
	ТаблицаПлатежей = Новый Массив;
	Список = РасчетЗадолженностиМФО.РассчитатьСписокПлатежей(Объект);
	График = РасчетЗадолженностиМФО.РассчитатьГрафикПлановыхПогашений(Объект, Список);
	Для Каждого стр из График Цикл
		стрТаб = Объект.ГрафикПлатежей.Добавить();
		ЗаполнитьЗначенияСвойств(стрТаб, стр);
	КонецЦикла;
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьГрафик(Команда)
	Если Не ЗначениеЗаполнено(Объект.ПрограммаРасчета) Тогда
		Сообщить("Сперва заполните программу расчета!");
		Возврат;
	КонецЕсли;	
	Если Не ЗначениеЗаполнено(Объект.Срок) Тогда
		Сообщить("Сперва укажите срок выдачи!");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.СуммаВыданногоЗайма) Тогда
		Сообщить("Сперва укажите сумму!");
		Возврат;
	КонецЕсли;	
	Если Не ЗначениеЗаполнено(Объект.ПроцентнаяСтавка) Тогда
		Сообщить("Сперва укажите процентную ставку!");
		Возврат;
	КонецЕсли;		
	РассчитатьГрафикНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	УправлениеФормой();	
КонецПроцедуры

&НаКлиенте
Процедура Калькулятор(Команда)
	ФормаКалькулятор = ПолучитьФорму("Обработка.КалькуляторПлановыхПлатежей.Форма.Форма",, ЭтаФорма);
	Для Каждого Элемент Из ГрафикПлатежей Цикл
		стр = ФормаКалькулятор.Объект.СписокПлатежей.Добавить();
		стр.ДатаПлатежа = Элемент.Дата;
		стр.СуммаПлатежа = Элемент.СуммаПлатежа;
		
		стр = ФормаКалькулятор.Объект.ГрафикПлатежей.ДОбавить();
		ЗаполнитьЗначенияСвойств(стр, Элемент);
	КонецЦикла;
	ОткрытьФорму(ФормаКалькулятор);
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	Элементы.ГруппаОстатки.Видимость = Объект.УчитыватьОстаткиНаДатуЦессии;
	Элементы.СпособПогашения.ТолькоПросмотр = (Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Аннуитетный) ИЛИ (Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Индивидуальный);	
	Элементы.ДатаПогашенияЗадолженности.ТолькоПросмотр = Истина;
	Элементы.ПериодичностьСрокаЗайма.ТолькоПросмотр = (Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Индивидуальный);
	Элементы.Калькулятор.Видимость = (Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Индивидуальный);
	Элементы.РассчитатьГрафик.Видимость = Не (Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Индивидуальный);
	Элементы.ФормаПерерасчет.Доступность = (Объект.ГрафикПлатежей.Количество() > 0);
	Элементы.ГруппаПлавающаяПроцентнаяСтавкаЗависимаяОтСрока.Видимость = (Объект.ВидПроцентнойСтавки = Перечисления.ВидыПроцентнойСтавки.ПлавающаяПроцентнаяСтавкаЗависимаяОтСрока);
	Элементы.ГруппаПлавающаяПроцентнаяСтавкаЗависимаяОтСтавки.Видимость = (Объект.ВидПроцентнойСтавки = Перечисления.ВидыПроцентнойСтавки.ПлавающаяПроцентнаяСтавкаЗависимаяОтСтавки);
	Элементы.ГруппаФиксированнаяПроцентнаяСтавка.Видимость = (Объект.ВидПроцентнойСтавки = Перечисления.ВидыПроцентнойСтавки.ФиксированнаяПроцентнаяСтавка);
	Элементы.UIDНБКИ.ТолькоПросмотр = ЗначениеЗаполнено(Объект.UIDНБКИ);
	Элементы.СоздатьUIDСделки.Доступность = Не ЗначениеЗаполнено(Объект.UIDНБКИ);
КонецПроцедуры

&НаСервере
Процедура ВидПлатежаПриИзмененииНаСервере()
	Если Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Аннуитетный Тогда
		Объект.СпособПогашения = Перечисления.СпособыПогашенияЗаймов.Равномерно;
	ИначеЕсли Объект.ВидПлатежа = Перечисления.ВидыПлатежей.Индивидуальный Тогда
		Объект.СпособПогашения = Перечисления.СпособыПогашенияЗаймов.Равномерно;
		Объект.ПериодичностьСрокаЗайма = Перечисления.ПериодичностьСрокаЗайма.День;
		ЗаполнитьДатуПогашения();
	КонецЕсли;
	
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ВидПлатежаПриИзменении(Элемент)
	ВидПлатежаПриИзмененииНаСервере();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура ПрограммаРасчетаПриИзменении(Элемент)
	ЗаполнитьПоПрограмме();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();	
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура СрокПриИзменении(Элемент)
	ЗаполнитьДатуПогашения();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьСрокаЗаймаПриИзменении(Элемент)
	ЗаполнитьДатуПогашения();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();	
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыдачиЗаймаПриИзменении(Элемент)
	ЗаполнитьДатуПогашения();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВыданногоЗаймаПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура ДатаДоговораПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура ВидПроцентнойСтавкиПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ПроцентнаяСтавкаПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПроцентнойСтавкиПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура СпособПогашенияПриИзменении(Элемент)
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьОстаткиНаДатуЦессииПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПрограмме()
	Если ЗначениеЗаполнено(Объект.ПрограммаРасчета) Тогда
		Объект.ВидПлатежа = Объект.ПрограммаРасчета.ВидПлатежа;
		Объект.ВидПроцентнойСтавки = Объект.ПрограммаРасчета.ВидПроцентнойСтавки;
		Объект.ПериодичностьПроцентнойСтавки = Объект.ПрограммаРасчета.ПериодичностьПроцентнойСтавки;
		Объект.ПериодичностьСрокаЗайма = Объект.ПрограммаРасчета.ПериодичностьСрокаЗайма;
		Объект.КоличествоПериодичностей = Объект.ПрограммаРасчета.КоличествоПериодичностей;
		Объект.СпособПогашения = Объект.ПрограммаРасчета.СпособПогашения;
		Если Объект.ВидПроцентнойСтавки = Перечисления.ВидыПроцентнойСтавки.ПлавающаяПроцентнаяСтавкаЗависимаяОтСрока Тогда
			Объект.ИнтервалыПроцентнойСтавки.Загрузить(Объект.ПрограммаРасчета.ИнтервалыПроцентнойСтавки.Выгрузить());
			РасчетЗадолженностиМФО.СформироватьТекстГиперссылкиИнтервалыПроцентнойСтавки(ЭтотОбъект, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатуПогашения()
	Объект.ДатаПогашения = РасчетЗадолженностиМФО.РассчитатьДатуПогашения(Объект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГрафикПлатежей()
	ГрафикПлатежей.Очистить();
	ИтогоСуммаПлатежа = 0;
	ИтогоОсновнойДолг = 0;
	ИтогоПроценты = 0;
	Статус = 0;
	ПлановаяСумма = Объект.СуммаВыданногоЗайма;
	Для Каждого стр из Объект.ГрафикПлатежей Цикл
		Если стр.СуммаПлатежа > 0 Тогда
			стрТаб = ГрафикПлатежей.Добавить();
			ЗаполнитьЗначенияСвойств(стрТаб, стр);
			
			стрТаб.СтатусПлатежа = РассчитатьСтатусПлатежа(СтрТаб, ПлановаяСумма);
			ПлановаяСумма = стрТаб.КУплате;

			ИтогоСуммаПлатежа 	= ИтогоСуммаПлатежа + стр.СуммаПлатежа;
			ИтогоОсновнойДолг 	= ИтогоОсновнойДолг + стр.ОплатаОсновнойДолг;
			ИтогоПроценты		= ИтогоПроценты		+ стр.ОплатаПроценты;
		КонецЕсли;
	КонецЦикла;
	Элементы.ГрафикСуммаПлатежа.ТекстПодвала  		= Формат(ИтогоСуммаПлатежа, "ЧДЦ=2; ЧН=' '");
	Элементы.ГрафикОплатаОсновнойДолг.ТекстПодвала  = Формат(ИтогоОсновнойДолг, "ЧДЦ=2; ЧН=' '");
	Элементы.ГрафикОплатаПроценты.ТекстПодвала = Формат(ИтогоПроценты, "ЧДЦ=2; ЧН=' '");
КонецПроцедуры

&НаСервере
Функция РассчитатьСтатусПлатежа(СтрокаТЧ, ПредыдущаяСумма)
	
	//статусы 9 - серый; 0 - Зеленый, 2 - желтый, 1 - красный
	Статус = 9;
	Если СтрокаТЧ.Дата > НачалоДня(ТекущаяДатаСеанса()) Тогда
		Статус = 9;
	Иначе
		ОстатокОДФакт = ПолучитьОстатокФактический(Объект.Ссылка);
		Если ОстатокОДФакт = "" Тогда
			Статус = 9;
		Иначе	
			Если СтрокаТЧ.КУплате >= ОстатокОДФакт Тогда
				Статус = 0;
			Иначе	
				Статус = ?(ПредыдущаяСумма <= ОстатокОДФакт, 1, 2);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Статус;
	
КонецФункции

&НаСервере
Функция ПолучитьОстатокФактический(СсылкаДоговора)
	ОстатокОДФактический = ""; 
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РасчетыПоДоговорамОстатки.ОсновнойДолгОстаток, """") КАК ОсновнойДолгОстаток,
	|	РасчетыПоДоговорамОстатки.Займ КАК Займ
	|ИЗ
	|	РегистрНакопления.РасчетыПоДоговорам.Остатки(&Дата, Займ = &Займ) КАК РасчетыПоДоговорамОстатки";
	
	Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Займ", СсылкаДоговора.Займ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОстатокОДФактический = ВыборкаДетальныеЗаписи.ОсновнойДолгОстаток;			
	КонецЦикла;
	
	Возврат ОстатокОДФактический; 
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ГрафикНачисленийПерерасчитан" Тогда
		ЗаполнитьГрафикПлатежей();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ГрафикНачисленийПерерасчитан");
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовСрокаЗаймаПриИзменении(Элемент)
	ЗаполнитьДатуПогашения();
	Объект.ГрафикПлатежей.Очистить();
	ЗаполнитьГрафикПлатежей();
КонецПроцедуры


&НаКлиенте
Процедура ДекорацияИнтервалыПроцентнойСтавкиНажатие(Элемент)
	
	ОткрытьФормуРедактированияПроцентныхСтавок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияПроцентныхСтавок()
	
	ПоместитьТаблицуВоВременноеХранилище("ИнтервалыПроцентнойСтавки");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилища",						АдресВременногоХранилища);
	
	ПараметрыФормы.Вставить("ПроцентнаяСтавкаПериодичность",				Объект.ПериодичностьПроцентнойСтавки);
	ПараметрыФормы.Вставить("ПроцентнаяСтавкаПериодичностьИнтервалов",		Объект.ПериодичностьСрокаЗайма);
	ПараметрыФормы.Вставить("ВключитьВРасчетПроцентовДеньВыдачи", 	  		Ложь);//Объект.ВключитьВРасчетПроцентовДеньВыдачи);
	
	ПараметрыФормы.Вставить("ДатаНачала",		Объект.ДатаВыдачиЗайма);
	ПараметрыФормы.Вставить("ДатаОкончания",	Объект.ДатаПогашения);	
	
	//Если Не ЗначениеЗаполнено(РеквизитыФинансовогоПродукта) Тогда
	//	ПараметрыФормы.Вставить("ТолькоПросмотр", Ложь);
	//Иначе	
	//	ПараметрыФормы.Вставить("ТолькоПросмотр", РеквизитыФинансовогоПродукта.ПроцентнаяСтавкаЗапретитьИзменение);
	//КонецЕсли;	
	ПараметрыФормы.Вставить("ТолькоПросмотр", Ложь);
	
	ОткрытьФорму("Справочник.ПрограммыРасчетаЗайма.Форма.ФормаРедактированияИнтервалов"
					,ПараметрыФормы
					,ЭтотОбъект,,,,
					Новый ОписаниеОповещения("ОбработкаПослеЗакрытияФормыредактированияПроцентныхСтавок", ЭтотОбъект),
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьТаблицуВоВременноеХранилище(ИмяТаблицы)
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Объект[ИмяТаблицы].Выгрузить(), УникальныйИдентификатор);		
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПослеЗакрытияФормыредактированияПроцентныхСтавок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если Результат.ЕстьИзменияВДанных Тогда 		
		
		Модифицированность = Истина;
		
		Объект.ПериодичностьПроцентнойСтавки 			= Результат.ПроцентнаяСтавкаПериодичность;
		Объект.ПериодичностьСрокаЗайма				 	= Результат.ПроцентнаяСтавкаПериодичностьИнтервалов;
		
		ОбновитьРеквизиты();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизиты()
	
	ТаблицаСтавок = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	Если ТаблицаСтавок = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ИнтервалыПроцентнойСтавки.Загрузить(ТаблицаСтавок);
	
	РасчетЗадолженностиМФО.СформироватьТекстГиперссылкиИнтервалыПроцентнойСтавки(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура СоздатьUIDСделкиАсинх()  
	ОбещаниеАдаптеры  = ПолучитьИнформациюОСетевыхАдаптерахАсинх();
	РезАдаптеры = Ждать ОбещаниеАдаптеры;
	Адаптер = РезАдаптеры[0];	
	АдресСетевойКарты = Адаптер.MACАдрес;
	УУИД = ОбъектыСервер.СформироватьUUIDver1(ОбщегоНазначенияКлиент.ДатаСеанса(), АдресСетевойКарты);
	Объект.UIDНБКИ = УУИД + "-" + ОбъектыСервер.СгенерироватьКонтрольныйСимвол(УУИД); 
КонецПроцедуры

&НаКлиенте
Процедура СоздатьUIDСделки(Команда)
	СоздатьUIDСделкиАсинх();	
КонецПроцедуры



