﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокВыбораРеквизитаИмяДанных();
	ЗаполнитьТаблицуИмпорта();
	РаботаСДокументами.ЗаполнитьСписокРеквизитовПоляИмпорта(ПолеИсходнойТаблицы, СписокВыбора);
	Элементы.ВыборСоответствийПараметрыСвязи.СписокВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
	
	//Заполнение базовых реквизитов в таблицу ВЫБОР СООТВЕТСТВИЙ		
	Если Объект.Ссылка.Пустая() И Объект.ВыборСоответствий.Количество() = 0 Тогда
		//Это новый документ добавленный не копированием
		Для Каждого Элемент Из СписокРеквизитов Цикл
			Если Элемент.Значение = "Объект" Тогда
				НоваяСтрока = Объект.ВыборСоответствий.Добавить();
				НоваяСтрока.ИмяДанных = "Должник";
				НоваяСтрока.ТипДанных = "Справочник ссылка: Контрагенты";
				НоваяСтрока.НомерКартинки = 7;
				
				НоваяСтрока = Объект.ВыборСоответствий.Добавить();
				НоваяСтрока.ИмяДанных = "Долговое обязательство";
				НоваяСтрока.ТипДанных = "Справочник ссылка: Долговые обязательства";
				НоваяСтрока.НомерКартинки = 7;
			Иначе
				НоваяСтрока = Объект.ВыборСоответствий.Добавить();
				НоваяСтрока.ИмяДанных = Элемент.Представление;
				НоваяСтрока.ТипДанных = ВозвратТипЗначенияКолонки(Элемент.Значение);
				//НоваяСтрока.ИмяКолонки = Элемент.Значение;
				НоваяСтрока.НомерКартинки = 7;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	#Если Вебклиент Тогда
		Элементы.ПолеИсходнойТаблицы.ОтображатьЗаголовки = Ложь;
		Элементы.ПолеИсходнойТаблицы.ОтображатьСетку = Ложь;
	#КонецЕсли	
	КонтрольИменТиповЗадолженностиКлиент.УстановитьЗначениеКолонок(Элементы.Объекты.ПодчиненныеЭлементы, "Объекты");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораРеквизитаИмяДанных()
	ТзДанныеЭлементы = Элементы.Объекты.ПодчиненныеЭлементы;
	Для Каждого Элемент Из ТзДанныеЭлементы Цикл	
		Имя = Сред(Элемент.Имя, СтрДлина("Объекты") + 1);
		Попытка    
			Если Элемент.Заголовок = "" Тогда
				Синоним = Метаданные.Документы.АктуализацияЗадолженности.ТабличныеЧасти.Объекты.Реквизиты.Найти(Имя).Синоним;
			Иначе 
				Синоним = Элемент.Заголовок;
			КонецЕсли;		
			Элементы.ВыборСоответствий.ПодчиненныеЭлементы.ВыборСоответствийИмяДанных.СписокВыбора.Добавить(Синоним);			
			СписокРеквизитов.Добавить(Имя,Синоним);
		Исключение
		КонецПопытки;
	КонецЦикла; 		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПоместитьВХранилищеДанные();
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УправлениеЗагрузкамиДанных.ПоместитьТабличнуюЧастьВХранилище(ПолеИсходнойТаблицы, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВыборСоответствийИмяДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекСтр = Элементы.ВыборСоответствий.ТекущиеДанные;
	ТекСтр.ИмяДанных = ВыбранноеЗначение;
	
	Для Каждого Элемент Из СписокРеквизитов Цикл 
		Если Элемент.Представление = ВыбранноеЗначение Тогда	
			ТекСтр.ТипДанных = ВозвратТипЗначенияКолонки(Элемент.Значение);
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыборСоответствийПараметрыСвязиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборСоответсвийСвязи(Элемент, ЭтаФорма, Объект.Ссылка, СписокРеквизитов);
КонецПроцедуры

&НаСервере
Функция ВозвратТипЗначенияКолонки(ВыбранноеЗначение)
	Переменная = Объект.Объекты.Выгрузить().Колонки.Найти(ВыбранноеЗначение).ТипЗначения.Типы()[0];
	Если 	  Переменная = Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат "Справочник ссылка: Контрагенты";
	ИначеЕсли Переменная = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Возврат "Справочник ссылка: Договоры контрагентов";	
	ИначеЕсли Переменная = Тип("СправочникСсылка.УслугиПоДоговору") Тогда
		Возврат "Справочник ссылка: Услуги по договору";	
	ИначеЕсли Переменная = Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
		Возврат "Справочник ссылка: Долговые обязательства";
	ИначеЕсли Переменная = Тип("СправочникСсылка.ИсполнительныеДокументы") Тогда
		Возврат "Справочник ссылка: Исполнительные документы";	
	ИначеЕсли Переменная = Тип("СправочникСсылка.Валюты") Тогда
		Возврат "Справочник ссылка: Валюты";
	Иначе
		Возврат Объект.Объекты.Выгрузить().Колонки.Найти(ВыбранноеЗначение).ТипЗначения;
	КонецЕсли;	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуИмпорта()
	ПолеИсходнойТаблицы.Очистить();
	УправлениеЗагрузкамиДанных.ИзвлечьТабличнуюЧастьВЭлементИзХранилища(ПолеИсходнойТаблицы, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПоместитьВХранилищеДанные()
	Документ = РеквизитФормыВЗначение("Объект");		
	Документ.Записать();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаКлиенте
// Выбирает соответствия связи для текущего элемента.
//
// Параметры:
//	Элемент - текущий элемент; 
//  Форма - имя формы; 
//  ДокументОбъект - документ; -
//  СписокРеквизитов - список реквизитов. -
// 
Процедура ВыборСоответсвийСвязи(Элемент, Форма, ДокументОбъект, СписокРеквизитов)

	РаботаСДокументами.ВыборСоответсвийСвязи(Элемент, Элементы, СписокВыбора, Форма, ДокументОбъект, СписокРеквизитов);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	Объект.Объекты.Очистить();	
	ЗаполнитьДанные(Объект.Ссылка, ПолеИсходнойТаблицы);
КонецПроцедуры

&НаСервере
// Заполняет данные.
//
// Параметры:
//  ДокументОбъект - документ; -
//  ПолеИмпорта  - поле импорта;
// 
Процедура ЗаполнитьДанные(ДокументОбъект, ПолеИмпорта)
	Для НомерСтрокиТаблицыИмпорта = 2 По ПолеИмпорта.ВысотаТаблицы Цикл
		ПустаяСтрокаТаблицы = Истина;
		Для Номер = 1 По ПолеИсходнойТаблицы.ШиринаТаблицы Цикл
			Если ЗначениеЗаполнено(ПолеИсходнойТаблицы.Область(НомерСтрокиТаблицыИмпорта, Номер).Текст) Тогда
				ПустаяСтрокаТаблицы = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПустаяСтрокаТаблицы Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.Объекты.Добавить(); 
		Для Каждого ТекСтрока Из Объект.ВыборСоответствий Цикл
			Если Не ЗначениеЗаполнено(ТекСтрока.ПараметрыСвязи) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекСтрока.ТипДанных = "Строка" Тогда
				Для Каждого Элемент Из СписокРеквизитов Цикл
					Если Элемент.Представление = Строка(ТекСтрока.ИмяДанных) Тогда
						НоваяСтрока[Элемент.Значение] = РаботаСДокументами.СформироватьСтрокуИзДанных82(ТекСтрока.ПараметрыСвязи, 
								НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
						Прервать;
					КонецЕсли
				КонецЦикла;	
				
			ИначеЕсли ТекСтрока.ТипДанных = "Число" Тогда
				Попытка
					Результат = Число(СтрЗаменить(РаботаСДокументами.НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, 
							ТекСтрока.ПараметрыСвязи, ПолеИмпорта), " ", ""));
				Исключение
					Результат = 0;
				КонецПопытки;
				
				Для Каждого Элемент Из СписокРеквизитов Цикл
					Если Элемент.Представление = Строка(ТекСтрока.ИмяДанных) Тогда
						НоваяСтрока[Элемент.Значение] = Результат;
						Прервать;
					КонецЕсли
				КонецЦикла;
				
			ИначеЕсли ТекСтрока.ТипДанных = "Дата" Тогда
				Попытка
					Результат = Дата(РаботаСДокументами.НайтиЗначениеВТаблицеИмпорта(НомерСтрокиТаблицыИмпорта, 
							ТекСтрока.ПараметрыСвязи, ПолеИмпорта));
				Исключение
					Результат = Технический.ПреобразоватьДату(РаботаСДокументами.НайтиЗначениеВТаблицеИмпорта(
							НомерСтрокиТаблицыИмпорта, ТекСтрока.ПараметрыСвязи, ПолеИмпорта));
				КонецПопытки;
						
				Для Каждого Элемент Из СписокРеквизитов Цикл
					Если Элемент.Представление = Строка(ТекСтрока.ИмяДанных) Тогда
						НоваяСтрока[Элемент.Значение] = Результат;
						Прервать;
					КонецЕсли
				КонецЦикла;
					
			//ИначеЕсли Найти(ТекСтрока.ТипДанных,  "Перечисление ссылка:") = 1 
			//		Или НРег(ТекСтрока.ТипДанных) = Нрег(Строка(Тип("СправочникСсылка.тсЗначенияСвойствОбъектов"))) 
			//		Или ТекСтрока.ТипДанных = "Булево" Тогда
			//	НайтиИЗаписатьПеречисление(ТекСтрока, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
				       
			Иначе	
			    Для Каждого Элемент Из СписокРеквизитов Цикл
					Если ТекСтрока.ИмяДанных = "Должник" Тогда
						РаботаСДокументами.НайтиИЗаписатьДокументИлиСправочник81("Объект", ТекСтрока.ТипДанных, 
								ТекСтрока.ПараметрыСвязи, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);
						ВладелецДолжник = НоваяСтрока.Объект;
						// Боевкин 07.07.2017 
						// НоваяСтрока.Объект = Неопределено;
						////////////////////////////////////
						Прервать;
					ИначеЕсли ТекСтрока.ИмяДанных = "Долговое обязательство" Тогда
						РаботаСДокументами.НайтиИЗаписатьДокументИлиСправочник81("Объект", ТекСтрока.ТипДанных, 
								ТекСтрока.ПараметрыСвязи, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта, 
								ВладелецДолжник);
						Прервать;
					ИначеЕсли Элемент.Представление = Строка(ТекСтрока.ИмяДанных) Тогда
						РаботаСДокументами.НайтиИЗаписатьДокументИлиСправочник81(Элемент.Значение, ТекСтрока.ТипДанных, 
								ТекСтрока.ПараметрыСвязи, НоваяСтрока, НомерСтрокиТаблицыИмпорта, ПолеИмпорта);		
						Прервать;
					КонецЕсли;		
				КонецЦикла;				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	ОбъектыСервер.РасширитьТабличнуюЧасть(Объект.Объекты);
КонецПроцедуры

&НаСервере
// Преобразовывает значение в тип реквизита.
//
// Параметры:
//  Значение - значение произвольного типа;
//  ТипОбъекта  - тип объекта Справочник или Документ;
//  ИмяОбъекта  - имя объекта;
//  ИмяРеквизита - имя реквизита.
// 
// Возвращаемое значение:
// результат преобразования произвольного типа.
//
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
			ТипЗначения = Метаданные.Справочники[ИмяОбъекта].Реквизиты.Найти(ИмяРеквизита).Тип.Типы()[0];
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
	
КонецФункции // ПреобразоватьЗначениеВТипРеквизита()

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "ГруппаВыборСоответствий" Тогда
		РаботаСДокументами.ЗаполнитьСписокРеквизитовПоляИмпорта(ПолеИсходнойТаблицы, СписокВыбора);
		Элементы.ВыборСоответствийПараметрыСвязи.СписокВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектыСервер.ОграничитьТипОбъекта(Элементы.ОбъектыОбъект);

	Если Объект.Ссылка.Пустая() Тогда
		Пользователи.ЗаполнитьРеквизитыПоДаннымПользователя(Объект);
		Объект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ОбъектыСервер.РасширитьТабличнуюЧасть(Объект.Объекты);
КонецПроцедуры

&НаКлиенте
Процедура ВыборСоответствийПередНачаломИзменения(Элемент, Отказ)
	Если Элементы.ВыборСоответствий.ТекущиеДанные.ТипДанных = "Число" ИЛИ
			Элементы.ВыборСоответствий.ТекущиеДанные.ТипДанных = "Дата" Тогда
		Элементы.ВыборСоответствийПараметрыСвязи.КнопкаВыбора = Ложь;
	Иначе
		Элементы.ВыборСоответствийПараметрыСвязи.КнопкаВыбора = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборСоответствийПараметрыСвязиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ВыбранноеЗначение = УправлениеЗагрузкойКлиент.ВыборСоответствийДляДокументовПоЗадолженности(Элемент, ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиСоответствий(Команда)
	ОткрытьФорму("Справочник.ФорматыЗагрузки.Форма.ФормаЭлемента",, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкиСоответствий(Команда)
	Форма = ПолучитьФорму("Справочник.ФорматыЗагрузки.Форма.ФормаВыбора",, ЭтаФорма);
	//Чуров
	//Результат = ОткрытьФорму(Форма);
	Результат = Форма.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ЗагрузитьВыборСоответствий(Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВыборСоответствий(Результат)
	Объект.ВыборСоответствий.Загрузить(Результат.ВыборСоответствий.Выгрузить());
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДанные(Команда)
	Объект.Объекты.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ВыборСоответствийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбъектыСервер.РасширитьТабличнуюЧасть(Объект.Объекты);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыОбъектПриИзменении(Элемент)
	ОбъектыКлиент.РасширитьТекущуюСтроку(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыПолеПриИзменении(Элемент)
	ОбъектыКлиент.РасширитьТекущуюСтрокуОбъект(Элемент);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПрочитатьФайлСКлиента()

	ДанныеПрочитанногоФайла = Неопределено;
	Попытка
	
		ДанныеПрочитанногоФайла = Ждать УправлениеЗагрузкойКлиент.ИмпортироватьФайл();
	
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(ДанныеПрочитанногоФайла) Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ПолеИсходнойТаблицы = ДанныеПрочитанногоФайла["ТабличныйДокумент"];
	ФайлИмпорта = ДанныеПрочитанногоФайла["ПутьФайлаНаКлиенте"];

КонецПроцедуры

&НаКлиенте
Процедура ФайлИмпортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПрочитатьФайлСКлиента();
	
	//#Если Вебклиент Тогда
	//	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//	Диалог.Заголовок = "Выберите файл платежей...";
	//	Диалог.МножественныйВыбор = Ложь;
	//	Диалог.Фильтр = "Табличный документ(*.xls, *.xlsx, *.ods)|*.xls?;*.ods|";
	//	//МассивПутейДокументов = Новый Массив;
	//	Диалог.Показать(Новый ОписаниеОповещения("ФайлИмпортаНачалоВыбораЗавершение", ЭтаФорма, Новый Структура("Диалог", Диалог)));
	//#Иначе
	//	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//	Диалог.Заголовок = "Выберите файл платежей...";
	//	Диалог.МножественныйВыбор = Ложь;
	//	Диалог.Фильтр = "Табличный документ(*.xls, *.xlsx, *.ods)|*.xls?;*.ods|";
	//	//МассивПутейДокументов = Новый Массив;
	//	Если Диалог.Выбрать() Тогда
	//		ФайлИмпорта = Диалог.ПолноеИмяФайла;
	//		ДД = Новый ДвоичныеДанные(ФайлИмпорта);
	//		ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД);
	//		
	//	КонецЕсли;
	//	
	//#КонецЕсли
	
КонецПроцедуры

//&НаКлиенте
//Процедура ФайлИмпортаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
//	
//	Диалог = ДополнительныеПараметры.Диалог;
//	
//	
//	Если (ВыбранныеФайлы <> Неопределено) Тогда
//		ФайлИмпорта = Диалог.ПолноеИмяФайла;
//		ДД = Новый ДвоичныеДанные(ФайлИмпорта);
//		ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД);
//		
//	КонецЕсли;

//КонецПроцедуры


//&НаСервере
//Процедура ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД)
//	Попытка
//		ПолеИсходнойТаблицы.Прочитать(ФайлИмпорта);
//	Исключение
//		//Сообщить(ОписаниеОшибки());
//		//Загружено = РаботаСДокументами.мПрочитатьТабличныйДокументИзExcel(ПолеИсходнойТаблицы, ФайлИмпорта, 1);
//		Загружено = РаботаСДокументами.ПрочитатьТабличныйДокументExcelизДвоичныхДанных(ПолеИсходнойТаблицы, ДД, 1);
//	КонецПопытки	
//КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	Загружено = РаботаСДокументами.мПрочитатьТабличныйДокументИзExcel(ПолеИсходнойТаблицы, ФайлИмпорта, 1);
КонецПроцедуры

&НаСервере
Функция ВозвратКоллекцииРеквизитовСправочника(ТипДанных)
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
Функция РасширитьСписокВыбора(СписокВыбора)
	РасширенныйСписок = Новый СписокЗначений;	
	РасширенныйСписок.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
	
	Для Каждого Элемент ИЗ СписокРеквизитов Цикл
		НовСтрока = РасширенныйСписок.Добавить();
		НовСтрока.Значение = Элемент.Значение + "_";
		НовСтрока.Картинка = БиблиотекаКартинок.Справочник; 
	КонецЦикла;
	
	Возврат РасширенныйСписок;
КонецФункции
