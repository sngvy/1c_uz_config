﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ID", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	//ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("РегистрНакопления.ФССП_ЗадолженностьПоИП.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
