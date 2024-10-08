﻿
// Процедура выводит сообщение пользователю.
//
// Параметры:
//  ТекстСообщения  - Строка - Сообщение
//  ТекущееПоле     - Строка - Поле для которого выводим сообщение
Процедура ВывестиСообщение(ТекстСообщения, ТекущееПоле = "") Экспорт
	
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Поле  = ТекущееПоле;
	Сообщение.Сообщить();
	
КонецПроцедуры

// Получает представление типа платформы
//
// Параметры:
//  ПлатформаОС - ТипПлатформы - Тип платформы.
// Возвращаемое значение:
//  Строка - Представление типа платформы 
Функция ПолучитьПредставлениеПлатформы(ПлатформаОС) Экспорт
	
	Результат = "-";
	
	Если ПлатформаОС = ТипПлатформы.Linux_x86 Тогда
		Результат = "Linux";
	ИначеЕсли ПлатформаОС = ТипПлатформы.Linux_x86_64 Тогда
		Результат = "Linux x64";
	ИначеЕсли ПлатформаОС = ТипПлатформы.Windows_x86 Тогда
		Результат = "Windows";
	ИначеЕсли ПлатформаОС = ТипПлатформы.Windows_x86_64 Тогда
		Результат = "Windows x64";
	ИначеЕсли ПлатформаОС = ТипПлатформы.MacOS_x86 Тогда
		Результат = "MacOS";
	ИначеЕсли ПлатформаОС = ТипПлатформы.MacOS_x86_64 Тогда
		Результат = "MacOS x64";
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции 