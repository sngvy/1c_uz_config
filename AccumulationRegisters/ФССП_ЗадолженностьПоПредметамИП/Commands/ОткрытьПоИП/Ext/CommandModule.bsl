﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ИсполнительноеПроизводство", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	//ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("РегистрНакопления.ФССП_ЗадолженностьПоПредметамИП.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
