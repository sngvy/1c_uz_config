﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) 
	УсловияОтбора = Новый Структура("Объект", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", УсловияОтбора);
	ОткрытьФорму("РегистрНакопления.НачисленияПоГоспошлине.Форма.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
