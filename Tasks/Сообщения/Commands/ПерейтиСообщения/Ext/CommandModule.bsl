﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
		УсловияОтбора = Новый Структура("ДолговоеОбязательство", ПараметрКоманды);
	Иначе 
		УсловияОтбора = Новый Структура("Должник", ПараметрКоманды);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор", УсловияОтбора);
	ОткрытьФорму("Задача.Сообщения.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
