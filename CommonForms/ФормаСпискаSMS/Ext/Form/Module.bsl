
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтборОбъект = Параметры.Отбор.Объект;
	Если ТипЗнч(ОтборОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
		Контакты = ПолучитьВсеДоПоДолжнику(ОтборОбъект);	
	Иначе
		Контакты = ОтборОбъект;
	КонецЕсли;
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контакт");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.Использование = Истина;
    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
    ЭлементОтбора.ПравоеЗначение = Контакты;
КонецПроцедуры

Функция ПолучитьВсеДоПоДолжнику(Должник)
	
	Контакты = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДолговыеОбязательства.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
		|ГДЕ
		|	ДолговыеОбязательства.Должник = &Должник";
	
	Запрос.УстановитьПараметр("Должник", Должник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Контакты.Добавить(Выборка.Ссылка);	
	КонецЦикла;	
	
	Возврат Контакты;
КонецФункции // ПолучитьВсеДоПоКонтрагенту()
