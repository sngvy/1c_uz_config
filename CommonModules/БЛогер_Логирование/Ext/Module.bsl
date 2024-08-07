﻿////////////////////////////////////////////////////////////////////////////////
// Работат с Логированием
//   Выполняется НаКлиенте и НаСервере
//   Внимание!!! - Логер может использоваться только в созданом контексте
// На клиенте поддерживается три уровня - Отладка, Инфо, Ошибка

#Область ПрограммныйИнтерфейс

Функция Создать(СтатусНаКлиенте = Неопределено, МодульЛогера = Неопределено) Экспорт

	Возврат НачальныйЛогер(МодульЛогера, СтатусНаКлиенте);

КонецФункции // ()

Функция Установить(Логер, Знач Текст, СтатусТекста) Экспорт

	ЗаменитьСообщение(Логер);
	Добавить(Логер, Текст, СтатусТекста);
	
	Возврат Логер;

КонецФункции // ()

Функция Добавить(Логер, Знач Текст, СтатусТекста) Экспорт

	Сообщатель = Логер["Логер"];
	Запись = СтруктураЗаписи();
	Запись["Статус"] = СтатусТекста;
	
	#Если Сервер Тогда
		Запись["Дата"] = ТекущаяДатаСеанса();
	#КонецЕсли
	
	#Если Клиент Тогда
		Запись["Дата"] = ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли

	Запись["Текст"] = Текст;
	Сообщатель.Записать(Запись);
	
	ДобавитьСообщение(Логер, Текст, СтатусТекста);

КонецФункции // ()

Функция Вывести(Логер, ДатаСообщения = Неопределено) Экспорт

	Запись = ПолучитьЗаписьДляПользователя(Логер, ДатаСообщения);
	Если Запись <> Неопределено Тогда
	
		Сообщатель = Логер["Логер"];
		Сообщатель.Вывести(Запись);
	
	КонецЕсли;

КонецФункции // ()

Функция Сообщение(Логер, ДатаСообщения = Неопределено) Экспорт

	Запись = ПолучитьЗаписьДляПользователя(Логер, ДатаСообщения);
	Если Запись = Неопределено Тогда
	
		Возврат "";
	
	КонецЕсли;
	
	Возврат Запись["Текст"];

КонецФункции // ()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Конфигурация

Функция Модуль()

	Возврат ОбщиеНастройкиКонфигурации.ИспользуемыйЛогер();

КонецФункции

&НаСервере
Функция ТекущийСтатус()

	ЗначениеСтатуса = Константы.БЛогер_ТекущийУровень.Получить();
	Если ЗначениеСтатуса.Пустая() Тогда
	
		Константы.БЛогер_ТекущийУровень.Установить(
			Перечисления.БЛогер_Уровни.Выключен
		);
	
	КонецЕсли;
	
	Возврат НомерСтатуса(
		Константы.БЛогер_ТекущийУровень.Получить()
	);

КонецФункции // ()

Функция НомерСтатуса(Статус)

	#Если Сервер Тогда
		Возврат Перечисления.БЛогер_Уровни.УровеньСтатуса(
			Статус
		);
	#КонецЕсли
	
	#Если Клиент Тогда
		
		Если Статус = ПредопределенноеЗначение("Перечисление.БЛогер_Уровни.Инфо") Тогда
		
			Возврат 0;
		
		КонецЕсли;
		
		Если Статус = ПредопределенноеЗначение("Перечисление.БЛогер_Уровни.Ошибка") Тогда
		
			Возврат 1;
		
		КонецЕсли;
		
		Возврат 2;
		
	#КонецЕсли

КонецФункции // ()

Функция СтруктураЗаписи()

	Запись = Новый Структура;
	Запись.Вставить("Статус", Неопределено);
	Запись.Вставить("Номер",  Неопределено);
	Запись.Вставить("Дата",   Неопределено);
	Запись.Вставить("Текст",  Неопределено);
	
	Возврат Запись;

КонецФункции // ()

Функция СтруктураЛогера()

	Логер = Новый Структура;
	Логер.Вставить("Логер",     Неопределено);
	Логер.Вставить("Запись",    Неопределено);
	Логер.Вставить("Статус",    Неопределено);
	
	Возврат Логер;

КонецФункции // ()

#КонецОбласти

#Область Настройка

Функция НачальныйЛогер(МодульЛогера = Неопределено, СтатусНаКлиенте = Неопределено)

	УстанавливаемыйЛогер = МодульЛогера;
	Если УстанавливаемыйЛогер = Неопределено Тогда
	
		УстанавливаемыйЛогер = Логер();
	
	КонецЕсли;
	
	Логер = СтруктураЛогера();
	Логер["Логер"] = УстанавливаемыйЛогер;
	Логер["Статус"] = Статус(СтатусНаКлиенте);
	Логер["Запись"] = Новый Массив;
	
	Возврат Логер;

КонецФункции // ()

Функция Логер()

	Возврат Модуль();

КонецФункции

Функция Статус(СтатусНаКлиенте = Неопределено)

	#Если Клиент Тогда
		Если СтатусНаКлиенте = Неопределено Тогда
		
			СтатусНаКлиенте =
				ПредопределенноеЗначение("Перечисление.БЛогер_Уровни.Отладка");
		
		КонецЕсли;
		
		Возврат НомерСтатуса(СтатусНаКлиенте);
	#КонецЕсли

	#Если Сервер Тогда
		Возврат ТекущийСтатус();
	#КонецЕсли

КонецФункции

#КонецОбласти

Функция ПолучитьЗаписьДляПользователя(Логер, ДатаСообщения)

	Если ДатаСообщения = Неопределено Тогда
	
		#Если Сервер Тогда
			ДатаСообщения = ТекущаяДатаСеанса();
		#КонецЕсли
		
		#Если Клиент Тогда
			ДатаСообщения = ОбщегоНазначенияКлиент.ДатаСеанса();
		#КонецЕсли
	
	КонецЕсли;
	
	Запись = СформироватьСообщения(Логер, ДатаСообщения);
	
	Возврат Запись;

КонецФункции // ()

Процедура ЗаменитьСообщение(Логер)

	Логер["Запись"] = Новый Массив;

КонецПроцедуры

Процедура ДобавитьСообщение(Логер, Текст, СтатусТекста)

	Записи = Логер["Запись"];
	
	Запись = СтруктураЗаписи();
	Запись["Статус"] = СтатусТекста;
	Запись["Номер"] = НомерСтатуса(СтатусТекста);
	Запись["Текст"] = Текст;
	
	Записи.Добавить(Запись);

КонецПроцедуры

Функция СформироватьСообщения(Логер, ДатаСообщения)

	Сообщения = Новый Структура;
	Сообщения.Вставить("Экран", Неопределено);
	
	Сообщения = СоставитьТекстСообщений(Логер, Сообщения);
	
	Если ПустаяСтрока(Сообщения["Экран"]) Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	Запись = Новый Структура;
	Запись.Вставить("Дата", ДатаСообщения);
	Запись.Вставить("Статус", Логер["Статус"]);
	Запись.Вставить("Текст", Сообщения["Экран"]);
	
	Возврат Запись;

КонецФункции

Функция СоставитьТекстСообщений(Логер, Сообщения)

	Записи = Логер["Запись"];
	ТекущийСтатус = Логер["Статус"];
	
	СообщенияПользователю = Новый Массив;
	
	Для каждого Запись Из Записи Цикл
	
		Текст = СобратьТекстЗаписи(Логер, Запись);
		Если Запись["Номер"] <= ТекущийСтатус Тогда
		
			СообщенияПользователю.Добавить(Текст);
		
		КонецЕсли;
	
	КонецЦикла;
	
	Сообщения["Экран"] = СтрСоединить(СообщенияПользователю, Символы.ПС);
	
	Возврат Новый ФиксированнаяСтруктура(Сообщения);

КонецФункции // ()

Функция СобратьТекстЗаписи(Логер, Запись)

	Возврат Логер.ТекстСообщения(Запись);

КонецФункции // ()

#КонецОбласти


