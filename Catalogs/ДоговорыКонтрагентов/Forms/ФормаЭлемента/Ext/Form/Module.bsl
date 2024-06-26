﻿
&НаКлиенте
Процедура КонтрагентНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ТекКонтрагент = Контрагент;
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = новый Структура("ТаблицаКонтрагентов",ЗаполнитьКонтрагентов());
	Форма = ПолучитьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаКонтрагентов",ПараметрыФормы);
	//Чуров
	Результат = ОткрытьФорму(Форма);
	//Результат = Форма.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ЗаписатьИзменения(Результат);
	КонецЕсли;
	Контрагент = ПроверитьКонтрагентов();
	Если ТекКонтрагент <>Контрагент Тогда
		Модифицированность = Истина;	
	КонецЕсли; 
КонецПроцедуры 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтоНовыйОбъект = Объект.Ссылка.Пустая();
	
	Если Объект.Ссылка.Пустая() Тогда
		Пользователи.ЗаполнитьРеквизитыПоДаннымПользователя(Объект);
	КонецЕсли;
	
	ДополнительныеРеквизиты.Загрузить(Объект.ДополнительныеРеквизиты.Выгрузить());
	УправлениеЗаполнением.ДобавитьДополнительныеРеквизиты(ЭтаФорма);
	
	Контрагент = ПроверитьКонтрагентов();
	
	ЗаполнитьТабличныйДокумент();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныйДокумент()
	ОбъектыСервер.ЗаполнитьОтчетОбъекта(Объект.Ссылка, ТабличныйДокумент, Константы.ОтчетДляДоговора);	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Функция ЗаполнитьКонтрагентов()
	Возврат Объект.Контрагенты.Выгрузить().ВыгрузитьКолонку("Контрагент");
КонецФункции // ВыгрузитьКонтрагентов()

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ЗаписатьИзменения(ТаблицаЗначений)
	Объект.Контрагенты.Загрузить(ТаблицаЗначений.выгрузить());
КонецПроцедуры // ЗаписатьИзменения()

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		 Объект.Контрагенты.Очистить();
		 Если Не Контрагент.Пустая() Тогда
		 	Объект.Контрагенты.Добавить().Контрагент = Контрагент;
		 КонецЕсли; 
	КонецЕсли; 	
КонецПроцедуры

// <Описание функции>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ПроверитьКонтрагентов()
	
	Если Объект.Контрагенты.Количество() > 1 Тогда
		Строка = "";
		Для каждого СтрокаТЧ Из Объект.Контрагенты  Цикл
			Строка = Строка+СтрокаТЧ.Контрагент.Наименование+"; ";
		КонецЦикла; 
		Возврат Строка;
	ИначеЕсли Объект.Контрагенты.Количество() = 1 Тогда 
        Возврат Объект.Контрагенты[0].Контрагент;
	Иначе 
		Возврат справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции // ()

&НаКлиенте
Процедура КонтрагентОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Объект.Контрагенты.Количество()>1 Тогда
		СтандартнаяОбработка = Ложь;
		//Чуров
		//ПоказатьЗначение(,Объект.Контрагенты[0].Контрагент);
		ОткрытьЗначение(Объект.Контрагенты[0].Контрагент);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УправлениеСвойствами.ПередЗаписьюНаСервере2(ЭтаФорма, ТекущийОбъект, Отказ);
	УправлениеСвойствами.КонтрольУникальности(Справочники.ДоговорыКонтрагентов, ТекущийОбъект, "КодДоговора", ТекущийОбъект.КодДоговора, Отказ); 
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	Объект.Контрагенты.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Свойство = Неопределено;
	СвойствоВидСтроки = Неопределено;
	Код = Сред(Элемент.Имя, Найти(Элемент.Имя, "_") + 1);
	УправлениеСвойствами.ПолучитьСвойствоПоКоду(СтрЗаменить(Код, "_", " "), Свойство, СвойствоВидСтроки);
	
	Если СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Адрес") ИЛИ
			СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Телефон") Тогда
	    Строки = ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", Свойство));
		ТекСтрокаПараметры = Строки[0].Параметры;
						
		СписокСтрок = СтрЗаменить(ТекСтрокаПараметры, ";", Символы.ПС);
		ЗначенияПолей = Новый СписокЗначений();
		Если СтрЧислоСтрок(СписокСтрок) > 1 Тогда
			Для Индекс = 1 По СтрЧислоСтрок(СписокСтрок) Цикл
				Стр = СтрПолучитьСтроку(СписокСтрок, Индекс);
				Если Стр <> "" Тогда 
					СписокПодстрок = СтрЗаменить(Стр, "=", Символы.ПС);
					ЗначенияПолей.Добавить(СтрПолучитьСтроку(СписокПодстрок, 2), СтрПолучитьСтроку(СписокПодстрок, 1));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;			
		Если СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Адрес") Тогда
			ИмяФормыРедактирования = "ОбщаяФорма.ВводАдреса";
		ИначеЕсли СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.Телефон") Тогда
			ИмяФормыРедактирования = "ОбщаяФорма.ВводТелефона";
		КонецЕсли;
			
		Пар = Новый Структура;
		Пар.Вставить("ЗначенияПолей",                ЗначенияПолей);
		Пар.Вставить("Вид",                          ""); //"Адрес");
		Пар.Вставить("БылиВнесеныИзменения",         Ложь);
		Пар.Вставить("Представление",                Элемент.ТекстРедактирования);
		Пар.Вставить("РедактированиеТолькоВДиалоге", Не Элемент.РедактированиеТекста);
		Пар.Вставить("АдресТолькоРоссийский",        Ложь);
			
		//Чуров
		Результат = ОткрытьФорму(ИмяФормыРедактирования, Пар);	
		//Результат = ОткрытьФормуМодально(ИмяФормыРедактирования, Пар);	
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Строки[0].Значение = Результат.Представление;
			ЭтаФорма[Элемент.Имя] = Результат.Представление;
			ЗначенияПолей = Результат.ЗначенияПолей;
			Модифицированность = Истина;
			
			РезультатЗначение = "";
			Для Каждого Элемент Из ЗначенияПолей Цикл
				РезультатЗначение = РезультатЗначение + Элемент.Представление + "=" + Элемент.Значение + ";"; 
			КонецЦикла;
			
			Строки[0].Параметры = РезультатЗначение;
		КонецЕсли;
		
	ИначеЕсли СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.АдресФИАС") Тогда 
		
		Строки = ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", Свойство)); 
		ТекСтрока = Строки[0]; 
		
		ИмяФормыРедактирования = "Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВводАдреса"; 
		Если ТекСтрока.Параметры = "" Тогда 
			ЗнПолей = ""; 
		Иначе 
			ЗнПолей = бит_АдресныйКлассификатор.ПолучитьJSONИзXML(ТекСтрока.Параметры); 
		КонецЕсли; 
		Пар = Новый Структура; 
		Пар.Вставить("ЗначенияПолей", ЗнПолей); 
		Пар.Вставить("Вид", ""); //"Адрес"); 
		Пар.Вставить("БылиВнесеныИзменения", Ложь); 
		Пар.Вставить("Представление", Элемент.ТекстРедактирования); 
		Пар.Вставить("РедактированиеТолькоВДиалоге", Не Элемент.РедактированиеТекста); 
		Пар.Вставить("АдресТолькоРоссийский", Ложь); 
		
		Результат = ОткрытьФормуМодально(ИмяФормыРедактирования, Пар); 
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			Строки[0].Значение = Результат.Представление; 
			ЭтаФорма[Элемент.Имя] = Результат.Представление; 
			Модифицированность = Истина; 
			СтрокаJSON = Результат.Значение; 
			
			Если СтрокаJSON = "" Тогда 
				СтрокаJSON = бит_АдресныйКлассификатор.ПолучитьJSONИзXML(СтрокаJSON); 
			КонецЕсли; 
			
			Строки[0].Параметры = бит_АдресныйКлассификатор.ПолучитьСтрокуXML(СтрокаJSON); 
		КонецЕсли;
		
	ИначеЕсли СвойствоВидСтроки = ПредопределенноеЗначение("Перечисление.ВидыТипаСтрока.ПутьКФайлу") Тогда	
		#Если Не ВебКлиент Тогда
			СтандартнаяОбработка = Ложь;
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
			Диалог.Заголовок = "Выберите файл";
			Диалог.ПолноеИмяФайла = ЭтаФорма[Элемент.Имя];
			Диалог.МножественныйВыбор = Ложь;
			Если Диалог.Выбрать() Тогда
				ЭтаФорма[Элемент.Имя] = Диалог.ПолноеИмяФайла;
			КонецЕсли;	
		#Иначе
			СтандартнаяОбработка = Ложь;
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
			Диалог.Заголовок = "Выберите файл";
			Диалог.ПолноеИмяФайла = ЭтаФорма[Элемент.Имя];
			//Фильтр = "EXE (*.exe)|*.exe"; 
			//Диалог.Фильтр = Фильтр; 
			Диалог.МножественныйВыбор = Ложь;
			//Диалог.Каталог = "F:\";
			Диалог.Показать(Новый ОписаниеОповещения("ДополнительныеРеквизитыНачалоВыбораЗавершение", ЭтаФорма, Новый Структура("Диалог, Элемент", Диалог, Элемент)));
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	Элемент = ДополнительныеПараметры.Элемент;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ЭтаФорма[Элемент.Имя] = Диалог.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ДополнительныеРеквизитыОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Стр = СтрЗаменить(Элемент.Имя, "Реквизит_", "РеквизитСвойство_");
	Строки = ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", Вычислить(Стр)));
	СтрокаЗапуска = "";	
	Если Строки.Количество() > 0 Тогда
		СтрокаЗапуска = Строки[0].Значение;
	КонецЕсли;

	Попытка
		ЗапуститьПриложение(СтрокаЗапуска);
	Исключение
		//Чуров
		//ПоказатьЗначение(,СтрокаЗапуска);
			ОткрытьЗначение(СтрокаЗапуска);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	//ОбъектыСервер.УдалитьПометкуОбИзменении(Отказ, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ТипДоговораПриИзменении(Элемент)
	ДобавитьДополнительныеРеквизиты();
КонецПроцедуры

&НаСервере
Процедура ДобавитьДополнительныеРеквизиты()
	УправлениеЗаполнением.ДобавитьДополнительныеРеквизиты(ЭтаФорма);	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЭтоНовыйОбъект И Константы.ДетализацияПоДоговорам.Получить() Тогда
		//Принятие в работу Организации
		ДокОбъект = Документы.ПринятиеВРаботуОрганизации.СоздатьДокумент();	
		ДокОбъект.Дата = ТекущаяДатаСеанса();
		ДокОбъект.Автор = УдалитьОбщегоНазначения.ТекущийПользователь();		
		ДокОбъект.Организация = ДокОбъект.Автор.Организация;

		ДокОбъект.Объекты.Добавить().Объект = ТекущийОбъект.Ссылка;
		Попытка
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить(ОписаниеОшибки());
			Отказ = Истина;
			Возврат;
		КонецПопытки;
				
		ЭтоНовыйОбъект = Ложь;
	КонецЕсли;
КонецПроцедуры
