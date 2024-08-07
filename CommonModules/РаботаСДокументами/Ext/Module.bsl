﻿
&НаСервере
Процедура ЗагрузитьТаблицуИзХранилища(Данные, ТаблицаХранилище, тзДанные) Экспорт
	
	Если НЕ ТаблицаХранилище.Получить() =  Неопределено Тогда
		тзДанные = ТаблицаХранилище.Получить();
	Иначе
		//колонки для Должника
		ТипНаименования = Новый ОписаниеТипов("Строка", , 
		Новый КвалификаторыСтроки(Метаданные.Справочники.Контрагенты.ДлинаНаименования));
		КолонкаНаименование = тзДанные.Выгрузить().Колонки.Добавить("Наименование", ТипНаименования, "Наименование", 150);
		ТипКода = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50));
		КолонкаКод = тзДанные.Выгрузить().Колонки.Добавить("Идентификатор", ТипКода, "Идентификатор");
		
		//колонки для ДО
		КолонкаВалютаДоговора = тзДанные.Выгрузить().Колонки.Добавить("ВалютаДоговора", 
		Новый ОписаниеТипов("СправочникСсылка.Валюты"), "Валюта ДО", 150);
		ТипНомера = Новый ОписаниеТипов("Строка", , 
		Новый КвалификаторыСтроки(Метаданные.Справочники.ДолговыеОбязательства.ДлинаНаименования));
		НомерДО = тзДанные.Выгрузить().Колонки.Добавить("НомерДО", ТипКода, "Номер ДО", 150);
		
		//vk
		КолонкаСсылкаДО=тзДанные.Выгрузить().Колонки.Добавить("СсылкаДО", 
		Новый ОписаниеТипов("СправочникСсылка.ДолговыеОбязательства"), "Ссылка ДО", 150);
		
	КонецЕсли;
	//ДобавитьКолонкиКТабличномуПолю(Данные, тзДанные);
	
КонецПроцедуры  //ЗагрузитьТаблицуИзХранилища()

Процедура ПолучитьСписокВыбораКолонкиИмяДанных(СписокВыбора, Таблица) Экспорт
	
	СписокВыбора.Очистить();
	Для каждого Колонка Из Таблица.Выгрузить().Колонки Цикл
		Если Тип(Колонка) = Тип("КолонкаТабличногоПоля") Тогда
			Если НРег(Колонка.Имя) <> "номерстроки" Тогда
				СписокВыбора.Добавить(Колонка.Имя, Колонка.ТекстШапки);
			КонецЕсли;
		Иначе
			СписокВыбора.Добавить(Колонка.Имя, Колонка.Заголовок);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры   //ПолучитьСписокВыбораКолонкиИмяДанных()

&НаКлиенте
Процедура ЗаполнитьСписокРеквизитовПоляИмпорта(ПолеИмпорта, СписокРеквизитов) Экспорт
	СписокРеквизитов.Очистить();
	Для Счетчик = 1 По ПолеИмпорта.ШиринаТаблицы Цикл
		Если ПолеИмпорта.Область("R1C" + СтрЗаменить(Строка(Счетчик), Символы.НПП, "")).Текст <> "" Тогда
			НовСтрока = СписокРеквизитов.Добавить();
			Текст = ПолеИмпорта.Область("R1C" + СтрЗаменить(Строка(Счетчик), Символы.НПП, "")).Текст;
			//Текст = СтрЗаменить(Текст, Символы.ПС, " ");
			//Текст = СтрЗаменить(Текст, Символы.НПП, " ");
			НовСтрока.Значение = Текст; 
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры   //ВыборСоответсвийСвязи()

Функция НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, ИмяКолонкиТаблицыИмпорта, ПолеИмпорта) Экспорт
	Для НомерРеквизитаШапки = 1 По ПолеИмпорта.ШиринаТаблицы Цикл
		СтрНомер = СтрЗаменить(НомерРеквизитаШапки, Символы.НПП, "");
		Текст = СокрЛП(ПолеИмпорта.Область("R1C"+СтрНомер).Текст);
		//Текст = СтрЗаменить(Текст, Символы.ПС, " ");
		//Текст = СтрЗаменить(Текст, Символы.НПП, " ");
		//
		//Текст1 = СокрЛП(ИмяКолонкиТаблицыИмпорта);
		Если Текст = СокрЛП(ИмяКолонкиТаблицыИмпорта) Тогда
			ЗначениеИзТаблицы = ПолеИмпорта.Область("R"+СтрЗаменить(НомерСтрокиТаблицыИмпорта,Символ(160),"")+"C"+НомерРеквизитаШапки).Текст;
			Возврат СокрЛП(ЗначениеИзТаблицы);
		КонецЕсли;
	КонецЦикла;	
КонецФункции  //НайтиЗначениеВТаблицеИмпорта()


Функция НайтиЗначениеВТаблицеИмпорта1(НомерСтрокиТаблицыИмпорта, ИмяКолонкиТаблицыИмпорта, ПолеИмпорта, к, ТипДанных) Экспорт
	Для НомерРеквизитаШапки = 1 По ПолеИмпорта.ШиринаТаблицы Цикл
		Если СокрЛП(ПолеИмпорта.Область("R1C" + НомерРеквизитаШапки).Текст) = СокрЛП(ИмяКолонкиТаблицыИмпорта) Тогда
			
			Для я = 2 По ПолеИмпорта.ВысотаТаблицы Цикл
				
				ЗначениеЯчейки = ПолеИмпорта.Область("R" + СтрЗаменить(я, Символ(160), "") + "C" + НомерРеквизитаШапки).Текст;
				
				Если ТипДанных = "Строка" Тогда
					Результат = ЗначениеЯчейки;
				ИначеЕсли ТипДанных = "Число" Тогда
					
					Попытка
						Результат = Число(ЗначениеЯчейки);
					Исключение
						Результат = 0;
					КонецПопытки;
					
				ИначеЕсли ТипДанных = "Дата" Тогда
					
					Попытка
						Результат = Дата(ЗначениеЯчейки);
					Исключение
						Результат = Технический.ПреобразоватьДату(ЗначениеЯчейки);
					КонецПопытки;
					
				Иначе
					Продолжить;
				КонецЕсли;
				к.Добавить(Результат);
			КонецЦикла;			
			ЗначениеИзТаблицы = ПолеИмпорта.Область("R"+СтрЗаменить(НомерСтрокиТаблицыИмпорта,Символ(160),"")+"C"+НомерРеквизитаШапки).Текст;
			Возврат СокрЛП(ЗначениеИзТаблицы);
		КонецЕсли;
	КонецЦикла;	
КонецФункции  //НайтиЗначениеВТаблицеИмпорта()

Функция СформироватьСтрокуИзДанных(СтрокаДанных, НомерСтрокиТаблицыИмпорта, ПолеИмпорта)
	Результат = "";	
	МассивДанных = Новый СписокЗначений;
	МассивДанных.Добавить(СтрокаДанных);
	МассивДанных.Добавить("0");
	//Технический.ПреобразоватьСтрокуВСписок(СтрокаДанных);
	
	Если МассивДанных.Количество() > 1 Тогда	
		ПредРазделитель = "";	
		Для Индекс = 1 по МассивДанных.Количество() Цикл		
			ЭлементДанныхЗначение = Строка(МассивДанных.Получить(Индекс-1).Значение);
			КоличествоСимволов = Число(МассивДанных.Получить(Индекс).Значение);
			Попытка
			  Разделитель = Строка(МассивДанных.Получить(Индекс+1).Значение);
			Исключение
			  Разделитель = "";
			КонецПопытки;
			
			//ЭлементДанныхЗначение = Лев(ЭлементДанных.Значение,КоличествоСимволов);		
			ЭлементСтроки = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, ЭлементДанныхЗначение, ПолеИмпорта);
			//Результат = Результат + ?(Результат = "", "", " ") + ЭлементСтроки;	
			ЭлементДанныхЗначениеСокр = ?(КоличествоСимволов>0,Лев(ЭлементСтроки,КоличествоСимволов),ЭлементСтроки);			
			Результат = Результат + ?(Результат = "", "", ПредРазделитель) + ЭлементДанныхЗначениеСокр;			
			ПредРазделитель = Разделитель;			
			Индекс = Индекс+2;
		КонецЦикла;
	Иначе	
		ЭлементСтроки = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, МассивДанных.Получить(0).Значение, ПолеИмпорта);
		Результат = Результат + ?(Результат = "", "", " ") + ЭлементСтроки;
	КонецЕсли; 
	
	Возврат Результат;	
КонецФункции // СформироватьСтрокуИзДанных()

//ЗаполнитьДанные()

&НаКлиенте
Функция ВозвратФормаДляСправочника()

Возврат ПолучитьФорму("Обработка.УстановкаПараметровСвязи.ФормаДляСправочника")	
	

КонецФункции // ()

&НаСервере
Функция НайтиИЗаписатьДокументИлиСправочник(ИмяДанных, ТипДанных, ПараметрыСвязи,
	
	НомерСтрокиТаблицыИмпорта, ПолеИмпорта, к) экспорт
	
	Если Не ПараметрыСвязи = "" Тогда;
		
		//Если Лев(ТипДанных,12) = "Перечисление" Тогда 
		
		ТипДанных1 = метаданные.НайтиПоТипу(ЗначениеИзСтрокиВнутр(ТипДанных)).Имя;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ";
		Запрос.Текст = Запрос.Текст + ИмяДанных + ".Ссылка" + " КАК Значение";
		Запрос.Текст = Запрос.Текст + " ИЗ ";
		
		ТипОбъекта = "";
		Массив = Новый Массив;
        Массив.Добавить(Тип("СправочникСсылка.Валюты"));
        ДопустимыеТипыДляСправочников = Новый ОписаниеТипов(Массив);
	    Если  ДопустимыеТипыДляСправочников.СодержитТип(ЗначениеИзСтрокиВнутр(ТипДанных)) Тогда 
			
			ТипОбъекта = "Справочник";
			ИмяОбъекта = ТипДанных1;
			Запрос.Текст = Запрос.Текст + "Справочник."			
		ИначеЕсли Лев(ТипДанных,8) = "Документ" Тогда
			ТипОбъекта = "Документ";
			ИмяОбъекта = Сред(ТипДанных,18);
			ИмяОбъекта = СтрЗаменить(ИмяОбъекта," ","");
			Запрос.Текст = Запрос.Текст + "Документ."
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + ИмяОбъекта + " КАК " + ИмяДанных ;
		Запрос.Текст = Запрос.Текст + " ГДЕ ";
		
		Условие = "";
		//СписокУсловий = Технический.ПреобразоватьСтрокуВСписок(ПараметрыСвязи, "|"); //k
		СписокУсловий = Технический.ПреобразоватьСтрокуВСписок(ПараметрыСвязи, ";");
		НомерПараметра = 0;
		//СформироватьСтрокуИзДанных(СписокУсловий[0], НомерСтрокиТаблицыИмпорта, ПолеИмпорта)
		Для каждого СтрокаУсловия Из СписокУсловий Цикл
			ИмяИЗначение = Технический.ПреобразоватьСтрокуВСписок(СтрокаУсловия, "=");
			НомерПараметра = НомерПараметра + 1;
			ИмяПараметра = "Параметр" + НомерПараметра;
			Условие = Условие + ?(Условие = "", "", " И ") + ИмяДанных + "." + ИмяИЗначение[0] + " = &" + ИмяПараметра;
							ЗначениеИзТаблицы = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, ИмяИЗначение[1].Значение, ПолеИмпорта);
				ЗначениеИзТаблицы = ПреобразоватьЗначениеВТипРеквизита(ЗначениеИзТаблицы, ТипОбъекта, ИмяОбъекта, 
				ИмяИЗначение[0].Значение);
				Если ЗначениеИзТаблицы = Неопределено Тогда
					ЗначениеИзТаблицы = СформироватьСтрокуИзДанных(ИмяИЗначение[1].Значение, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
				КонецЕсли;
			
			Запрос.УстановитьПараметр(ИмяПараметра, ЗначениеИзТаблицы);
		КонецЦикла;
		Запрос.Текст = Запрос.Текст + Условие;
		
		// Выполнение запроса 
		//Сообщить("Текст Запроса: " + Запрос.Текст); 
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		ПолученноеЗначение = "";
		Если Выборка.Следующий() Тогда
			//Сообщить(" Количество = "+Выборка.Количество() + "   : " + Выборка.Значение);
			ПолученноеЗначение = Выборка.Значение;
		КонецЕсли;
		  Возврат ПолученноеЗначение
//СтрокаТаблицыЗначений[ИмяДанных] = ПолученноеЗначение;
	Иначе
		Сообщить("Для данных " + ИмяДанных + " не задано соответствие!");
	КонецЕсли;
 КонецФункции //НайтиИЗаписатьДокументИлиСправочник()

&НаСервере
Функция ПреобразоватьЗначениеВТипРеквизита(Значение, ТипОбъекта, ИмяОбъекта, ИмяРеквизита)
	Если ТипОбъекта = "Справочник" Тогда
		Если ИмяРеквизита = "Наименование" ИЛИ ИмяРеквизита = "Код" Тогда
			ТипЗначения = Тип("Строка");
		Иначе	
			ТипЗначения = Метаданные.Справочники[ИмяОбъекта].Реквизиты.Найти(ИмяРеквизита).Тип.Типы()[0];
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "Документ" Тогда
		Если ИмяРеквизита = "Номер" Тогда
			ТипЗначения = Тип("Строка");
		ИначеЕсли ИмяРеквизита = "Дата" Тогда
			ТипЗначения = Тип("Дата");
		Иначе	
			ТипЗначения = Метаданные.Справочники.ДолговыеОбязательства.Реквизиты.Найти(ИмяРеквизита).Тип.Типы()[0];
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗначения = Тип("Дата") Тогда
		Попытка
			Результат = Дата(Значение);
		Исключение
			Результат = '00010101';
		КонецПопытки;
	ИначеЕсли ТипЗначения = Тип("Число") Тогда
		Попытка
			Результат = Число(Значение);
		Исключение
			Результат = 0;
		КонецПопытки;
	Иначе
		Результат = Значение;
	КонецЕсли;
	Возврат Результат;	
КонецФункции

// Изменено 29.01.2019 Лебедева
// Для документов ЗагрузкаЗадолженности, АктуализацияЗадолженности, ПоступлениеПлатежей,
// ЗагрузкаИсторииПлатежей, ВводНачальныхОстатковВнесудебка, НачислениеЗадолженностиВнесудебка
&НаКлиенте
Процедура ВыборСоответсвийСвязи(Элемент, Элементы, СписокВыбора, Форма, ДокументОбъект, СписокРеквизитов) Экспорт

	ТекСтр = Форма.Элементы.ВыборСоответствий.ТекущиеДанные;
	Если Нрег(ТекСтр.ТипДанных) = "число" ИЛИ Нрег(ТекСтр.ТипДанных) = "дата" Тогда
		Элементы.ВыборСоответствий.ТекущиеДанные.ПараметрыСвязи = Форма.ВыбратьИзСписка(СписокВыбора);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИзменяемыйЭлемент", Элемент.ТекстРедактирования);
	Если Нрег(ТекСтр.ТипДанных) = "строка" Тогда
	
		ПараметрыФормы.Вставить("СписокПараметров", СписокВыбора);
	
	Иначе
	
		ПараметрыФормы.Вставить("СписокКолонок", РаботаСдокументамиСервер.ВозвратКоллекцииРеквизитовСправочника(ТекСтр.ТипДанных));
		ПараметрыФормы.Вставить("СписокПараметров", РаботаСДокументамиСервер.РасширитьСписокВыбора(СписокВыбора, СписокРеквизитов));
		ПараметрыФормы.Вставить("СписокВыбора", СписокВыбора);
		ПараметрыФормы.Вставить("ТипСтроки", "");
		
	КонецЕсли;

	ОП = Новый ОписаниеОповещения(
		"ЗаписатьРезультат",
		РаботаСДокументами,
		Новый Структура("ТекущаяСтрока", ТекСтр));
	ОткрытьФорму("Обработка.УстановкаПараметровСвязи.Форма.ФормаВыбораПараметров", ПараметрыФормы, Форма, , , , ОП);

	Модифицированность = Истина;

КонецПроцедуры 

&НаКлиенте
Функция ЗаписатьРезультат(Результат, ДанныеРезультата) Экспорт

	ДанныеРезультата.ТекущаяСтрока.ПараметрыСвязи = Результат;

КонецФункции // ()


&НаСервере
Функция ВозвратКоллекцииРеквизитовСправочника(ТипДанных) Экспорт
	ТипРеквизитаСтр = СтрЗаменить(ТипДанных," ","");
		
	СписокВсехПараметров = Новый СписокЗначений;
	Если Лев(ТипРеквизитаСтр,10) = "Справочник" Тогда
		СправочникРеквизита = Сред(ТипРеквизитаСтр,18);
		РеквизитОбъект = Метаданные.Справочники.Найти(СправочникРеквизита).Реквизиты;
		СписокВсехПараметров.Добавить("Код");
		СписокВсехПараметров.Добавить("Наименование");
		Если Метаданные.Справочники.Найти(СправочникРеквизита).Владельцы.Количество() > 0 Тогда
			СписокВсехПараметров.Добавить("Владелец");
		КонецЕсли;
	ИначеЕсли Лев(ТипРеквизитаСтр,8) = "Документ" Тогда
		СписокВсехПараметров.Добавить("Номер");
		СписокВсехПараметров.Добавить("Дата");
	КонецЕсли;

	Если Не РеквизитОбъект = Неопределено Тогда	
		Для Каждого СвойствоРеквизит ИЗ РеквизитОбъект Цикл
			НовСтрока = СписокВсехПараметров.Добавить();
			НовСтрока.Значение = СвойствоРеквизит.Имя;
		КонецЦикла;
	КонецЕсли;

	Возврат СписокВсехПараметров;	
КонецФункции

&НаСервере
Функция РасширитьСписокВыбора(СписокВыбора,СписокРеквизитов) Экспорт
	РасширенныйСписок = Новый СписокЗначений;	
	РасширенныйСписок.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
	
	Для Каждого Элемент ИЗ СписокРеквизитов Цикл
		НовСтрока = РасширенныйСписок.Добавить();
		НовСтрока.Значение = Элемент.Значение + "_";
		НовСтрока.Картинка = БиблиотекаКартинок.Справочник; 
	КонецЦикла;
	
	Возврат РасширенныйСписок;
КонецФункции


Процедура ЗанестиРезультатПодбораВТабличнуюЧасть(ТабличнаяЧасть, Результат,
		ВедущиеРеквизиты = "ДолговоеОбязательство") Экспорт	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Действие = Неопределено;
		Результат.Свойство("Действие", Действие);
		ТаблицаРезультат = Неопределено;
		Результат.Свойство("Таблица", ТаблицаРезультат);
		Если Действие = "Заменить" Тогда
			ТабличнаяЧасть.Загрузить(ТаблицаРезультат);
		ИначеЕсли Действие = "Добавить" Тогда
			Если ТипЗнч(ВедущиеРеквизиты) = Тип("Массив") Тогда
				ПараметрыИдентификации = ВедущиеРеквизиты;
			Иначе
				ПараметрыИдентификации = Новый Массив;
				ПараметрыИдентификации.Добавить(ВедущиеРеквизиты);
			КонецЕсли;
			Технический.ПрисоединитьТаблицу(ТабличнаяЧасть, ТаблицаРезультат, ПараметрыИдентификации);
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры  

////&НаСервере
////Функция ПолучитьПовторыДолговыхОбязательств(ДокументСсылка) Экспорт
////	
////	ПериодПлатежа = "";
////	
////	//Если ТипЗнч (ДокументСсылка)= Тип("ДокументСсылка.Реестр") ИЛИ ТипЗнч (ДокументСсылка)= Тип("ДокументСсылка.ПоступлениеПлатежей") Или ТипЗнч (ДокументСсылка)= Тип("ДокументСсылка.ПоступлениеПлатежейПоДаннымКлиента") Тогда
////		//ИмяТаблицыДО="ДолговыеОбязательства";
////	//	Если НЕ ТипЗнч (ДокументСсылка)= Тип("ДокументСсылка.Реестр") Тогда
////	//		ПериодПлатежа = "ТабличнаяЧастьДолговыеОбязательства.Период, ";
////	//	КонецЕсли; 
////	//ИначеЕсли ТипЗнч (ДокументСсылка)= Тип("ДокументСсылка.ЗагрузкаЗадолженностиПоДолговымОбязательствам") Тогда
////	//	ИмяТаблицыДО="Данные";
////	//ИначеЕсли
////		
////	Если ТипЗнч(ДокументСсылка)= Тип("ДокументСсылка.СкорингДолговыхОбязательств") Тогда
////		ИмяТаблицыДО = "Объекты"; //"РаспределениеДО"; 
////	Иначе
////		ВызватьИсключение("Получить повторы ДО в ТЧ: передан не корректный тип Документа или имя Таблицы");
////	КонецЕсли;
////	
////	Запрос = Новый Запрос;
////	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
////	Запрос.Текст = "ВЫБРАТЬ
////				   |	ТабличнаяЧастьДолговыеОбязательства.ДолговоеОбязательство, "+ПериодПлатежа+"
////				   |	ТабличнаяЧастьДолговыеОбязательства.ДолговоеОбязательство,
////				   |	ТабличнаяЧастьДолговыеОбязательства.Должник,
////				   |	КОЛИЧЕСТВО(*) КАК Количество
////				   |ИЗ
////				   |	Документ." + ДокументСсылка.Метаданные().Имя + "."+ИмяТаблицыДО+" КАК ТабличнаяЧастьДолговыеОбязательства
////				   |ГДЕ
////				   |	ТабличнаяЧастьДолговыеОбязательства.Ссылка = &ДокументСсылка
////				   |
////				   |СГРУППИРОВАТЬ ПО
////				   |	ТабличнаяЧастьДолговыеОбязательства.ДолговоеОбязательство, "+ПериодПлатежа+"
////				   |	ТабличнаяЧастьДолговыеОбязательства.Должник
////				   |
////				   |ИМЕЮЩИЕ
////				   |	КОЛИЧЕСТВО(*) > 1";	   
////					   
////	ТаблицаОшибочных = Запрос.Выполнить().Выгрузить();
////	Если ТаблицаОшибочных.Количество() > 0 Тогда	
////		Сообщить(Строка(ДокументСсылка) + ": следующие долговые обязательства встречаются более одного раза: ", 
////				СтатусСообщения.Важное);		
////		Для Каждого СтрокаОшибочных Из ТаблицаОшибочных Цикл
////			Сообщить("Должник " + ?(СтрокаОшибочных.Должник.Пустая(), "(ячейка не заполнена)", СтрокаОшибочных.Должник) + 
////					", долговое обязательство " + ?(СтрокаОшибочных.ДолговоеОбязательство.Пустая(), "(ячейка не заполнена)", 
////					СтрокаОшибочных.ДолговоеОбязательство) + ?(ПериодПлатежа = "", "", " (платеж за период " + 
////					СтрокаОшибочных.Период + ")"), СтатусСообщения.Важное);
////		КонецЦикла;
////		Возврат Истина;
////	КонецЕсли;
////	
////	Возврат Ложь;	
////КонецФункции

&НаСервере
// Находит и записывает перечисление.
//
// Параметры:
//  ТекСтрока - текущая строка;
//  НоваяСтрока - новая строка;
//  НомерСтрокиТаблицыИмпорта - номер строки таблицы импорта;
//  ПолеИмпорта  - поле импорта.
// 
Процедура НайтиИЗаписатьПеречислениеНов(ТекСтрока, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта) Экспорт
	//kev20мая (вся процедура)	
	//СписокПараметров = Технический.ПреобразоватьСтрокуВСписок(ТекСтрока.ПараметрыСвязи); 
	СписокПараметров = Технический.ПреобразоватьСтрокуВСписок(ТекСтрока.ПараметрыСвязи, ";");
	НазваниеКолонки = СписокПараметров[0].Значение;	
	Значение = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, НазваниеКолонки, ПолеИмпорта);
	Элемент = ТекСтрока;
	//ТекСтрока.ИмяКолонки = "_" + СтрЗаменить(ТекСтрока.ИмяДанных.Код, " ", "_");
	
	ИмяКолонки = СтрЗаменить(Строка(Элемент.Назначение)," ", "") + "_" + СтрЗаменить(Строка(Элемент.ВидРеквизита), " ", "") + "_" + СтрЗаменить(Строка(Элемент.КодСвойства), " ", "_");
	Синоним = Элемент.ИмяСвойства;
	Если Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.Код") Тогда
		ТипЗначения = Новый ОписаниеТипов("Строка");
	ИначеЕсли Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.Наименование") Тогда
		ТипЗначения = Новый ОписаниеТипов("Строка");
	ИначеЕсли Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.Процедура") Тогда
		ТипЗначения = Новый ОписаниеТипов("Строка");
	ИначеЕсли Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.ДополнительноеСведение") ИЛИ Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.ДополнительныйРеквизит") Тогда
		ТипЗначения = НайтиТипПВХ(Элемент.КодСвойства);
	ИначеЕсли Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.ОтветственныйСотрудник") Тогда
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	ИначеЕсли Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.ТипЗадолженности") ИЛИ Элемент.ВидРеквизита = ПредопределенноеЗначение("Перечисление.ВидыРеквизитов.ТипОбъекта") Тогда
		ТипЗначения = Новый ОписаниеТипов(СтрЗаменить(СтрЗаменить(Элемент.ТипДанных, ":", "."), " ", ""));
	КонецЕсли;
	ТипЗначенияКолонки = ТипЗначения.Типы()[0];
	
	//ТипЗначенияКолонки = ТипЗНЧ(НоваяСтрока[ТекСтрока.ИмяКолонки]);
	//ТипЗначенияКолонки = ТипЗНЧ(НоваяСтрока["_"+ТекСтрока.ИмяДанных.Код]);
	//kev25мая
	Если НЕ ТипЗначенияКолонки = Тип("Булево") Тогда
		//kev25мая-------------
		НазваниеПеречисления = Метаданные.НайтиПоТипу(ТипЗначенияКолонки).Имя;
	КонецЕсли; 
	
	//если заполнены соответствия
	Если СписокПараметров.Количество() > 1 Тогда //заполнены соответствия		
		Пары = Технический.ПреобразоватьСтрокуВСписок(СписокПараметров[1], ",");	
		стПарСоответствий = Новый Структура();	
		Для Каждого ТС Из Пары Цикл
			ОднаПара = Технический.ПреобразоватьСтрокуВСписок(ТС, "=");
			Если ПустаяСтрока(ОднаПара[1].Значение) Тогда
				Соответствие = ОднаПара[0].Значение;
			Иначе
				Соответствие = ОднаПара[1].Значение;	  		
			КонецЕсли;
			Соответствие = "_" + СтрЗаменить(Соответствие, " ", "___пробел___");
			
			стПарСоответствий.Вставить(Соответствие, ОднаПара[0]);
		КонецЦикла; 
		
		Попытка
			Результат = стПарСоответствий[ "_" + СтрЗаменить(Значение, " ", "___пробел___") ];
		Исключение
			Возврат;
		КонецПопытки;

		
		Если ТипЗначенияКолонки = Тип("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда
			КодСвойства = ТекСтрока.КодСвойства;;
			//КодСвойства = ТекСтрока.ИмяДанных.Код;
			Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(КодСвойства);
			НоваяСтрока[ИмяКолонки] = Справочники.тсЗначенияСвойствОбъектов.НайтиПоНаименованию(
			Результат.Значение,,, Свойство);
		ИначеЕсли ТипЗначенияКолонки = Тип("Булево") Тогда
			НоваяСтрока[ИмяКолонки] = Булево(Результат.Значение);	
		Иначе
			НоваяСтрока[ИмяКолонки] = Перечисления[НазваниеПеречисления][Результат.Значение];
		КонецЕсли;
		
	Иначе  //если не заполнены соответствия
		
		Если ТипЗначенияКолонки = Тип("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда //находим по наименованию или создаем новое (ЗначенияСвойствОбъектов)
			Если Значение = "" Тогда
				НоваяСтрока[ИмяКолонки] = Справочники.тсЗначенияСвойствОбъектов.ПустаяСсылка();
			Иначе		
				КодСвойства = ТекСтрока.КодСвойства;
				Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(СтрЗаменить(КодСвойства, "_", " "));			
				ЭлемСпрЗнач = Справочники.тсЗначенияСвойствОбъектов.НайтиПоНаименованию(Значение,,, Свойство);
				Если ЭлемСпрЗнач <> Справочники.тсЗначенияСвойствОбъектов.ПустаяСсылка() Тогда 
					НоваяСтрока[ИмяКолонки] = ЭлемСпрЗнач;
				Иначе
					НовоеЗначение = Справочники.тсЗначенияСвойствОбъектов.СоздатьЭлемент();
					НовоеЗначение.Наименование = Значение;
					НовоеЗначение.Владелец = Свойство;
					НовоеЗначение.Записать();
					
					НоваяСтрока[ИмяКолонки] = НовоеЗначение.Ссылка;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ТипЗначенияКолонки = Тип("Булево") Тогда
			Попытка
				НоваяСтрока[ИмяКолонки] = ?(НРег(Значение) = "истина", Истина, Ложь);
			Исключение
				НоваяСтрока[ИмяКолонки] = Ложь;
			КонецПопытки;
			
		Иначе //перечисление - пустая ссылка
			Попытка
				НоваяСтрока[ИмяКолонки] = Перечисления[НазваниеПеречисления][Значение];
			Исключение
				НоваяСтрока[ИмяКолонки] = Перечисления[НазваниеПеречисления].ПустаяСсылка();
			КонецПопытки;
		КонецЕсли;
	КонецЕсли; 	
КонецПроцедуры  //НайтиИЗаписатьПеречисление()

&НаСервере
Функция НайтиТипПВХ(КодСвойства)
	Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(КодСвойства);
	Возврат Свойство.ТипЗначения;
КонецФункции


&НаСервере
// Находит и записывает перечисление.
//
// Параметры:
//  ТекСтрока - текущая строка;
//  НоваяСтрока - новая строка;
//  НомерСтрокиТаблицыИмпорта - номер строки таблицы импорта;
//  ПолеИмпорта  - поле импорта.
// 
Процедура НайтиИЗаписатьПеречисление(ТекСтрока, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта) Экспорт
	//kev20мая (вся процедура)	
	СписокПараметров = Технический.ПреобразоватьСтрокуВСписок(ТекСтрока.ПараметрыСвязи, ";");
	НазваниеКолонки = СписокПараметров[0].Значение;	
	Значение = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, НазваниеКолонки, ПолеИмпорта);
	ТекСтрока.ИмяКолонки = "_" + СтрЗаменить(ТекСтрока.ИмяДанных.Код, " ", "_");
	ТипЗначенияКолонки = ТипЗНЧ(НоваяСтрока[ТекСтрока.ИмяКолонки]);
	//ТипЗначенияКолонки = ТипЗНЧ(НоваяСтрока["_"+ТекСтрока.ИмяДанных.Код]);
	//kev25мая
	Если НЕ ТипЗначенияКолонки = Тип("Булево") Тогда
	//kev25мая-------------
		НазваниеПеречисления = Метаданные.НайтиПоТипу(ТипЗначенияКолонки).Имя;
	КонецЕсли; 
	
	//если заполнены соответствия
	Если СписокПараметров.Количество() > 1 Тогда //заполнены соответствия		
		Пары = Технический.ПреобразоватьСтрокуВСписок(СписокПараметров[1], ",");	
		стПарСоответствий = Новый Структура();	
		Для Каждого ТС Из Пары Цикл
			ОднаПара = Технический.ПреобразоватьСтрокуВСписок(ТС, "=");
			Если ПустаяСтрока(ОднаПара[1].Значение) Тогда
				Соответствие = ОднаПара[0].Значение;
			Иначе
				Соответствие = ОднаПара[1].Значение;	  		
			КонецЕсли;
			Соответствие = "_" + СтрЗаменить(Соответствие, " ", "___пробел___");
			
			стПарСоответствий.Вставить(Соответствие, ОднаПара[0]);
		КонецЦикла; 
		
		Попытка
			Результат = стПарСоответствий[ "_" + СтрЗаменить(Значение, " ", "___пробел___") ];
		Исключение
			Возврат;
		КонецПопытки;
		
		Если ТипЗначенияКолонки = Тип("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда
			КодСвойства = Прав(ТекСтрока.ИмяКолонки, СтрДлина(ТекСтрока.ИмяКолонки)-1);
			//КодСвойства = ТекСтрока.ИмяДанных.Код;
			Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(КодСвойства);
			НоваяСтрока[ТекСтрока.ИмяКолонки] = Справочники.тсЗначенияСвойствОбъектов.НайтиПоНаименованию(
					Результат.Значение,,, Свойство);
		ИначеЕсли ТипЗначенияКолонки = Тип("Булево") Тогда
			НоваяСтрока[ТекСтрока.ИмяКолонки] = Булево(Результат.Значение);	
		Иначе
			НоваяСтрока[ТекСтрока.ИмяКолонки] = Перечисления[НазваниеПеречисления][Результат.Значение];
		КонецЕсли;
		
	Иначе  //если не заполнены соответствия
		
		Если ТипЗначенияКолонки = Тип("СправочникСсылка.тсЗначенияСвойствОбъектов") Тогда //находим по наименованию или создаем новое (ЗначенияСвойствОбъектов)
			Если Значение = "" Тогда
				НоваяСтрока[ТекСтрока.ИмяКолонки] = Справочники.тсЗначенияСвойствОбъектов.ПустаяСсылка();
			Иначе		
				КодСвойства = Прав(ТекСтрока.ИмяКолонки, СтрДлина(ТекСтрока.ИмяКолонки) - 1);
				Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(СтрЗаменить(КодСвойства, "_", " "));			
				ЭлемСпрЗнач = Справочники.тсЗначенияСвойствОбъектов.НайтиПоНаименованию(Значение,,, Свойство);
				Если ЭлемСпрЗнач <> Справочники.тсЗначенияСвойствОбъектов.ПустаяСсылка() Тогда 
					НоваяСтрока[ТекСтрока.ИмяКолонки] = ЭлемСпрЗнач;
				Иначе
					НовоеЗначение = Справочники.тсЗначенияСвойствОбъектов.СоздатьЭлемент();
					НовоеЗначение.Наименование = Значение;
					НовоеЗначение.Владелец = Свойство;
					НовоеЗначение.Записать();
					
					НоваяСтрока[ТекСтрока.ИмяКолонки] = НовоеЗначение.Ссылка;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ТипЗначенияКолонки = Тип("Булево") Тогда
			Попытка
			    НоваяСтрока[ТекСтрока.ИмяКолонки] = ?(НРег(Значение) = "истина", Истина, Ложь);
			Исключение
			  	НоваяСтрока[ТекСтрока.ИмяКолонки] = Ложь;
			КонецПопытки;
		
		Иначе //перечисление - пустая ссылка
			Попытка
			    НоваяСтрока[ТекСтрока.ИмяКолонки] = Перечисления[НазваниеПеречисления][Значение];
			Исключение
			  	НоваяСтрока[ТекСтрока.ИмяКолонки] = Перечисления[НазваниеПеречисления].ПустаяСсылка();
			КонецПопытки;
		КонецЕсли;
	КонецЕсли; 	
КонецПроцедуры  //НайтиИЗаписатьПеречисление()


&НаСервере
// Находит и записывает документ или справочник.
//
// Параметры:
//  ИмяДанных - имя данных;
//  ТипДанных - тип данных;
//  ПараметрыСвязи - параметры связи;
//  СтрокаТаблицыЗначений - строка таблицы значений;
//  НомерСтрокиТаблицыИмпорта - номер строки таблицы импорта;
//  ПолеИмпорта  - поле импорта.
// 
Процедура НайтиИЗаписатьДокументИлиСправочник81(ИмяДанных, ТипДанных, ПараметрыСвязи, СтрокаТаблицыЗначений,
		НомерСтрокиТаблицыИмпорта, ПолеИмпорта, ВладелецДолжник = Неопределено) Экспорт
	СоздаватьСправочник = Ложь;	
	Если Не ПараметрыСвязи = "" Тогда;	
		//Если Лев(ТипДанных,12) = "Перечисление" Тогда 	
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ " + ИмяДанных + ".Ссылка КАК Значение ИЗ ";
		
		ТипОбъекта = "";
		Если Лев(ТипДанных,10) = "Справочник" Тогда
			ТипОбъекта = "Справочник";
			ИмяОбъекта = Сред(ТипДанных,20);
			ИмяОбъекта = СтрЗаменить(ИмяОбъекта," ","");
			Если ИмяОбъекта = "Организация" Тогда
				ИмяОбъекта = "Организации";
			КонецЕсли;
			
			Если ИмяОбъекта = "Службысудебныхприставов" Тогда
				ИмяОбъекта = "ФССП_СлужбыСудебныхПриставов";
			КонецЕсли;
			
			Запрос.Текст = Запрос.Текст + "Справочник.";	
			СоздаватьСправочник = Истина;
			СправочникМенеджер = Справочники[ИмяОбъекта];
		ИначеЕсли Лев(ТипДанных,8) = "Документ" Тогда
			ТипОбъекта = "Документ";
			ИмяОбъекта = Сред(ТипДанных,18);
			ИмяОбъекта = СтрЗаменить(ИмяОбъекта," ","");
			Запрос.Текст = Запрос.Текст + "Документ.";
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + ИмяОбъекта + " КАК " + ИмяДанных + " ГДЕ ";
		
		Условие = "";
		Если ВладелецДолжник <> Неопределено Тогда
			Условие = ИмяДанных + ".Должник = &ВладелецДолжник";
			Запрос.УстановитьПараметр("ВладелецДолжник", ВладелецДолжник);
		КонецЕсли;
		
		//СписокУсловий = Технический.ПреобразоватьСтрокуВСписок(ПараметрыСвязи, "|"); //k
		СписокУсловий = Технический.ПреобразоватьСтрокуВСписок(ПараметрыСвязи, ";");
		НомерПараметра = 0;
		//СформироватьСтрокуИзДанных(СписокУсловий[0], НомерСтрокиТаблицыИмпорта, ПолеИмпорта)
		Для Каждого СтрокаУсловия Из СписокУсловий Цикл
			ИмяИЗначение = Технический.ПреобразоватьСтрокуВСписок(СтрокаУсловия, "=");
			НомерПараметра = НомерПараметра + 1;
			ИмяПараметра = "Параметр" + НомерПараметра;
			Условие = Условие + ?(Условие = "", "", " И ") + ИмяДанных + "." + ИмяИЗначение[0] + " = &" + ИмяПараметра;
			Если Прав(ИмяИЗначение[1].Значение,1) = "_" Тогда
				ИмяПоля = Сред(ИмяИЗначение[1].Значение, 1, СтрДлина(ИмяИЗначение[1].Значение) - 1);
				ЗначениеИзТаблицы = СтрокаТаблицыЗначений[ИмяПоля];
			Иначе
				ЗначениеИзТаблицы = НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, ИмяИЗначение[1].Значение, ПолеИмпорта);
				ЗначениеИзТаблицы = ПреобразоватьЗначениеВТипРеквизита(ЗначениеИзТаблицы, ТипОбъекта, ИмяОбъекта, 
						ИмяИЗначение[0].Значение);
				Если ЗначениеИзТаблицы = Неопределено Тогда
					ЗначениеИзТаблицы = СформироватьСтрокуИзДанных82(ИмяИЗначение[1].Значение, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
				КонецЕсли;
			КонецЕсли;
			Запрос.УстановитьПараметр(ИмяПараметра, ЗначениеИзТаблицы);
		КонецЦикла;
		Запрос.Текст = Запрос.Текст + Условие;
		
		// Выполнение запроса 
		//Сообщить("Текст Запроса: " + Запрос.Текст); 
		Выборка = Запрос.Выполнить().Выбрать();
		ПолученноеЗначение = "";
		Если Выборка.Следующий() Тогда
			//Сообщить(" Количество = "+Выборка.Количество() + "   : " + Выборка.Значение);
			ПолученноеЗначение = Выборка.Значение;
		Иначе
			Если СоздаватьСправочник Тогда
				Если ЗначениеИзТаблицы = "" Тогда
					ПолученноеЗначение = СправочникМенеджер.ПустаяСсылка();
				Иначе
					СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
					СправочникОбъект.Наименование = ЗначениеИзТаблицы;
					СправочникОбъект.Записать();
					ПолученноеЗначение = СправочникОбъект.Ссылка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		СтрокаТаблицыЗначений[ИмяДанных] = ПолученноеЗначение;
	Иначе
		Сообщить("Для данных " + ИмяДанных + " не задано соответствие!");
	КонецЕсли;	
КонецПроцедуры //НайтиИЗаписатьДокументИлиСправочник()

&НаСервере
Функция СформироватьСтрокуИзДанных82(СтрокаДанных, НомерСтрокиТаблицыИмпорта, ПолеИмпорта) Экспорт
	Результат = "";	
	МассивДанных = Технический.ПреобразоватьСтрокуВСписок(СтрокаДанных);
	
	Если МассивДанных.Количество() > 1 Тогда
		ПредРазделитель = "";	
		Для Индекс = 1 по МассивДанных.Количество() Цикл
			ЭлементДанныхЗначение = Строка(МассивДанных.Получить(Индекс-1).Значение);
			КоличествоСимволов = Число(МассивДанных.Получить(Индекс).Значение);
			Попытка
			    Разделитель = Строка(МассивДанных.Получить(Индекс+1).Значение);
			Исключение
			    Разделитель = "";
			КонецПопытки;
			
			//ЭлементДанныхЗначение = Лев(ЭлементДанных.Значение,КоличествоСимволов);		
			ЭлементСтроки = РаботаСДокументами.НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, ЭлементДанныхЗначение, ПолеИмпорта);
			//Результат = Результат + ?(Результат = "", "", " ") + ЭлементСтроки;	
			ЭлементДанныхЗначениеСокр = ?(КоличествоСимволов>0,Лев(ЭлементСтроки,КоличествоСимволов),ЭлементСтроки);	
			Результат = Результат + ?(Результат = "", "", ПредРазделитель) + ЭлементДанныхЗначениеСокр;	
			ПредРазделитель = Разделитель;	
			Индекс = Индекс+2;
		КонецЦикла;
	Иначе	
		ЭлементСтроки = РаботаСДокументами.НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, МассивДанных.Получить(0).Значение, ПолеИмпорта);
		Результат = Результат + ?(Результат = "", "", " ") + ЭлементСтроки;
	КонецЕсли; 
	
	Возврат Результат;	
КонецФункции 

&НаСервере
Функция СформироватьСтрокуИзДанных821(СтрокаДанных, НомерСтрокиТаблицыИмпорта, ПолеИмпорта, к, ТипДанных) Экспорт
	Результат = "";

	Для НомерСтрокиТаблицыИмпорта = 2 По ПолеИмпорта.ВысотаТаблицы Цикл
		Стр = СформироватьСтрокуИзДанных82(СтрокаДанных, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
		к.Добавить(Стр);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции 

// Проверяет заполненность табличной части с указанным именем по именам реквизитов, содержащихся в массиве
Функция ПроверитьЗаполнениеТабличнойЧасти(тзДанные, ИменаРеквизитов) Экспорт
	ВсеНормально = Истина;
	Для Каждого СтрокаТЧ Из тзДанные Цикл
		Для Каждого Реквизит Из ИменаРеквизитов Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ[Реквизит]) Тогда		
				Сообщить("В строке " + СтрокаТЧ.НомерСтроки + " не заполнен реквизит " + Реквизит);	
				ВсеНормально = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат ВсеНормально;
КонецФункции

// Проверяет действительно переданное значение является числом.
//
// Параметры:
//  Значение - переданное значение. 
//
// Возвращаемое значение:
//  булево.
//	
&НаСервере
Функция ПроверкаЭтоЧисло(Значение) Экспорт
	Попытка
		Результат = Число(значение);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции    //ПроверкаЭтоЧисло()


&НаСервере
Функция мПрочитатьТабличныйДокументИзExcel(ТабличныйДокумент, ИмяФайла, НомерЛистаExcel = 1) Экспорт
	
	xlLastCell = 11;
	Если Найти(ИмяФайла, "$") > 0 Тогда
		Сообщить("Временный файл!");
		Возврат Ложь;
	КонецЕсли;
	Попытка
		
		ВыбФайл = Новый Файл(ИмяФайла); 
	Исключение 		
		Сообщить("Файл не существует!");
		Возврат Ложь;
		
	КонецПопытки;
	
	Если НЕ ВыбФайл.Существует() Тогда
		Сообщить("Файл не существует!");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяФайла);
		//Состояние("Обработка файла Microsoft Excel...");
		Лист = Excel.Sheets(НомерЛистаExcel);
	Исключение
		Сообщить("Ошибка. Возможно неверно указан номер листа книги Excel.");
		Сообщить(ОписаниеОшибки());
		Возврат ложь;
		
	КонецПопытки;
	
	ОбъектыСервер.ОчиститьТабличныйДокумент(ТабличныйДокумент);
	
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	КлСтрок = ActiveCell.Row;
	КлСтолбцов = ActiveCell.Column;
	Для р = 1 По КлСтрок Цикл
		Если Не ЗначениеЗаполнено(Лист.Cells(р, 1).Value) Тогда
			р = р - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	КолСтрок = р;
	
	Для с = 1 По КлСтолбцов Цикл
		Если Не ЗначениеЗаполнено(Лист.Cells(1, с).Value) Тогда
			с = с - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	КолСтолбцов = с;
	
	//Для Column = 1 По ColumnCount Цикл
	//	ТабличныйДокумент.Область("C" + Формат(Column, "ЧГ=")).ШиринаКолонки = ExcelЛист.Columns(Column).ColumnWidth;
	//КонецЦикла;
	Область = Лист.Range(Лист.Cells(1,1), Лист.Cells(КолСтрок, КолСтолбцов));
	Данные = Область.Value.Выгрузить();
	НомСтл = 1;
	Для Каждого Элемент из Данные Цикл
		НомСтр = 1;
		Для Каждого Стр из Элемент Цикл
			ТабличныйДокумент.Область("R" + Формат(НомСтр, "ЧГ=") + "C" + Формат(НомСтл, "ЧГ=")).Текст = Стр;
			НомСтр = НомСтр + 1;
		КонецЦикла;
		НомСтл = НомСтл + 1;
	КонецЦикла;

	Excel.DisplayAlerts = False;
	Excel.WorkBooks.Close();
	Excel = 0;
	
	Возврат Истина;
	
КонецФункции // ()

&НаСервере
Функция ПрочитатьТабличныйДокументExcelизДвоичныхДанных(ТабличныйДокумент, ДвоичныеДанные, НомерЛистаExcel = 1) Экспорт
	
	ИмяФайла = ПолучитьИмяВременногоФайла(".xls");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	xlLastCell = 11;
	Попытка
		ВыбФайл = Новый Файл(ИмяФайла); 
	Исключение 		
		Сообщить("Файл не существует!");
		УдалитьФайлы(ИмяФайла);
		Возврат Ложь;	
	КонецПопытки;
	
	Если НЕ ВыбФайл.Существует() Тогда
		Сообщить("Файл не существует!");
		УдалитьФайлы(ИмяФайла);
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяФайла);
		//Состояние("Обработка файла Microsoft Excel...");
		Лист = Excel.Sheets(НомерЛистаExcel);
	Исключение
		Сообщить("Ошибка. Возможно неверно указан номер листа книги Excel.");
		Сообщить(ОписаниеОшибки());
		Excel.WorkBooks.Close();
		Excel = 0;
		УдалитьФайлы(ИмяФайла);
		Возврат ложь;
	КонецПопытки;
	
	ОбъектыСервер.ОчиститьТабличныйДокумент(ТабличныйДокумент);
	
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	КлСтрок = ActiveCell.Row;
	КлСтолбцов = ActiveCell.Column;
	Для р = 1 По КлСтрок Цикл
		Если Не ЗначениеЗаполнено(Лист.Cells(р, 1).Value) Тогда
			р = р - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	КолСтрок = р;
	
	Для с = 1 По КлСтолбцов Цикл
		Если Не ЗначениеЗаполнено(Лист.Cells(1, с).Value) Тогда
			с = с - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	КолСтолбцов = с;
	
	Область = Лист.Range(Лист.Cells(1,1), Лист.Cells(КолСтрок, КолСтолбцов));
	Данные = Область.Value.Выгрузить();
	НомСтл = 1;
	Для Каждого Элемент из Данные Цикл
		НомСтр = 1;
		Для Каждого Стр из Элемент Цикл
			ТабличныйДокумент.Область("R" + Формат(НомСтр, "ЧГ=") + "C" + Формат(НомСтл, "ЧГ=")).Текст = Стр;
			НомСтр = НомСтр + 1;
		КонецЦикла;
		НомСтл = НомСтл + 1;
	КонецЦикла;
	
	Excel.DisplayAlerts = False;
	Excel.WorkBooks.Close();
	Excel = 0;
	УдалитьФайлы(ИмяФайла);
	
	Возврат Истина;
	
КонецФункции // ()