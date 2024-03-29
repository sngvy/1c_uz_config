﻿Функция Создать(Владелец, Наименование = "") Экспорт

	Транспорт = СоздатьЭлемент();
	Транспорт.Наименование = Наименование;
	Транспорт.Владелец = Владелец;
	
	Возврат Транспорт;

КонецФункции // ()

Функция ПолучитьНовый(Наименование = Неопределено) Экспорт

	Наименование = ?(Наименование = Неопределено, "<>", Наименование);
	Транспорт = Создать(Наименование);
	Транспорт.Записать();
	
	Возврат Транспорт.Ссылка;

КонецФункции // ()

Процедура ИзменитьНаименование(Транспорт, Наименование) Экспорт

	Объект = Транспорт.ПолучитьОбъект();
	Объект.Наименование = Наименование;
	Объект.Записать();

КонецПроцедуры

// Возвращает набор типов имущества по которым определяются возможные свойства
//
// Возвращаемое значение:
//   Массив из ПланВидовХарактеристикСсылка.Имущество  - Допустимые типы для Свойств
//
Функция ДопустимыеВариантыСвойст() Экспорт

	Имущество = ПланыВидовХарактеристик.Имущество;
	Возврат Имущество.ПолучитьВарианты(Имущество.Транспорт);

КонецФункции // ()