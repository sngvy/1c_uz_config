﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.РедактированиеЗначенийСвойств",
			Новый Структура("Ссылка", ОбъектыСервер.РазыменоватьСсылку(ПараметрКоманды, "Должник")), ПараметрыВыполненияКоманды.Источник, ПараметрКоманды);
КонецПроцедуры
