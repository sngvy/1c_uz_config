﻿Функция ПредупреждениеОбПользовательскойОшибке(ТекстСообщения) Экспорт

	Возврат 
		"Ошибка заполнения: "
		+ Символы.ПС
		+ ОшибкаЗаполненияОписать(ТекстСообщения)
	;

КонецФункции

Функция ПредупреждениеОшибкаСистемы(ТекстСообщения) Экспорт

	Возврат 
		"Ошибка системы: "
		+ Символы.ПС
		+ ОшибкаЗаполненияОписать(ТекстСообщения)
		+ Символы.ПС
		+ "Обратитесь в службу поддержки"
	;

КонецФункции

Функция СформироватьТекстОшибки(ИнформацияОбОшибке, ДополнительноеОписание) Экспорт

	ОписаниеОшибки = Новый Структура;
	
	ОписаниеОшибки.Вставить("Выражение", ДополнительноеОписание + ": " + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	ОписаниеОшибки.Вставить("Стек", Неопределено);
	// ToDo - Сделать для уровней логирования
	Если Истина Тогда
	
		ОписаниеОшибки["Стек"] = СформироватьСтекОшибок(ИнформацияОбОшибке);
	
	КонецЕсли;
	
	Возврат ОписаниеОшибки;

КонецФункции // ()

Функция СформироватьСтекОшибки(ИнформацияОбОшибке, ДополнительноеОписание) Экспорт

	ОписаниеОшибки = Новый Структура;
	
	ОписаниеОшибки.Вставить("Выражение", ДополнительноеОписание);
	ОписаниеОшибки.Вставить("Стек", СформироватьСтекОшибок(ИнформацияОбОшибке));
	
	Возврат ОписаниеОшибки;

КонецФункции // ()

Процедура ТекстовоеСообщить(ТекстСообщения) Экспорт

	Если ПустаяСтрока(ТекстСообщения) Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();

КонецПроцедуры

Функция ОшибкаЗаполненияОписать(ТекстСообщения)

	Возврат "Есть некорректные данные: " + ТекстСообщения;

КонецФункции

Функция СформироватьСтекОшибок(ИнформацияОбОшибке)

	Аккумулятор = Новый Массив;
	ЗаполнитьОписаниеОшибки(ИнформацияОбОшибке, Аккумулятор);
	
	Возврат СтрСоединить(Аккумулятор, Символы.ПС);

КонецФункции // ()

Процедура ЗаполнитьОписаниеОшибки(Причина, Аккумулятор)

	Если Причина = Неопределено Тогда
	
		Возврат;
	
	КонецЕсли;

	Аккумулятор.Добавить("В модуле: " + Причина.ИмяМодуля);
	Аккумулятор.Добавить("На строке: " + Причина.НомерСтроки);
	Аккумулятор.Добавить("По причине: " + Причина.Описание);
	Аккумулятор.Добавить("Конструкция с ошибкой: " + Причина.ИсходнаяСтрока);
	Аккумулятор.Добавить(Символы.ПС);
	
	ЗаполнитьОписаниеОшибки(Причина.Причина, Аккумулятор)

КонецПроцедуры

