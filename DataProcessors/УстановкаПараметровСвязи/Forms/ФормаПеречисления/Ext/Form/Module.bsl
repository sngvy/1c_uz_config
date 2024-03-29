﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Результат = ИзменяемыйЭлемент;
	Элементы.КолонкаТаблицы.СписокВыбора.ЗагрузитьЗначения(СписокКолонок.ВыгрузитьЗначения());
	
	ПроцедураПриОткрытии();	
КонецПроцедуры

&НаСервере
Процедура ПроцедураПриОткрытии()
	Перечисление = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоКоду(КодСвойства);	
	Список = Технический.ПреобразоватьСтрокуВСписок(ИзменяемыйЭлемент, ";");
	Попытка
		КолонкаТаблицы = Список[0];
	Исключение
	КонецПопытки;
	
	//Если ТипЗнч(Перечисление) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
	Если Нрег(Перечисление.ТипЗначения) = "значения свойств объектов" Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ЗначенияСвойствОбъектов.Ссылка
		                      |ИЗ
		                      |	Справочник.тсЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		                      |ГДЕ
		                      |	ЗначенияСвойствОбъектов.Владелец = &Свойство");
		Запрос.УстановитьПараметр("Свойство", Перечисление);
		МассивЗначений = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ИначеЕсли Нрег(Перечисление.ТипЗначения) = "булево" Тогда
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить("Истина");
		МассивЗначений.Добавить("Ложь");
	Иначе
		МассивЗначений = Перечисление.Метаданные().ЗначенияПеречисления;
	КонецЕсли;
	
	Для Каждого ЗначениеМассива Из МассивЗначений Цикл
		СтрокаСЗП = СоответствияЗначенийПеречисления.Добавить();
		СтрокаСЗП.ВСистеме = ЗначениеМассива;
	КонецЦикла;
	
	Попытка
		МассивСоответствий = Технический.ПреобразоватьСтрокуВСписок(Список[1], ",");
		Для Каждого ЭлементМассиваСоответствий Из МассивСоответствий Цикл
			МассивЗначениеИмя = Технический.ПреобразоватьСтрокуВСписок(ЭлементМассиваСоответствий, "=");
			Для Каждого СтрокаСоответствий Из СоответствияЗначенийПеречисления Цикл
				Если СтрокаСоответствий.ВСистеме = МассивЗначениеИмя[0].Значение Тогда
					СтрокаСоответствий.ВТаблице = МассивЗначениеИмя[1].Значение;
				КонецЕсли;
			КонецЦикла;
			//СтрокаСоответствий = СоответствияЗначенийПеречисления.НайтиСтроки(Найти(МассивЗначениеИмя[0].Значение);
			//Если СтрокаСоответствий <> Неопределено Тогда
			//	СтрокаСоответствий.ВТаблице = МассивЗначениеИмя[1].Значение;
			//КонецЕсли;
		КонецЦикла;
	Исключение
	КонецПопытки;	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Если ЗначениеЗаполнено(КолонкаТаблицы) ИЛИ СоответствияЗначенийПеречисления.Количество() = 0 Тогда	
		Результат = СформироватьСтрокуВозврата();
		РезультатЗакрытия = Результат;
		//Оповестить("ЗакрытиеФормыУстановкаПараметровСвязиПеречисление",Результат);
		ЭтаФорма.Закрыть(РезультатЗакрытия);

	Иначе
		Сообщить("Поле ""Колонка таблицы"" должно быть заполнено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция СформироватьСтрокуВозврата()
	СтрокаВозврата = СокрЛП(КолонкаТаблицы) + ";";
	Для каждого Соответствие Из СоответствияЗначенийПеречисления Цикл
		Если СокрЛП(Соответствие.ВТаблице) = "" Тогда
			Продолжить;
		КонецЕсли;
		СтрокаВозврата = СтрокаВозврата + ?(Прав(СтрокаВозврата, 1) = ";", "", ",") + 
				Соответствие.ВСистеме + "=" + СокрЛП(Соответствие.ВТаблице);
	КонецЦикла;
	Возврат СтрокаВозврата;
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КодСвойства = Параметры.КодСвойства;
	СписокКолонок = Параметры.СписокКолонок;
	ИзменяемыйЭлемент = Параметры.ИзменяемыйЭлемент;	
КонецПроцедуры

