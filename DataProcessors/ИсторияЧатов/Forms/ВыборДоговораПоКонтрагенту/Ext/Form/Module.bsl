﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрыватьПриВыборе = Истина;
	
	ДолговыеОбязательства.Параметры.УстановитьЗначениеПараметра("Клиент", Параметры.Клиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДолговыеОбязательстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Закрыть(Элементы.ДолговыеОбязательства.ТекущиеДанные.Ссылка);
	
КонецПроцедуры


