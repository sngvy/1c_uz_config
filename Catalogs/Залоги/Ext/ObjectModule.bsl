﻿
Перем ТекстИзменений;

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстИзменений = ОбъектыСервер.ПроверитьИзмененияВОбъекте(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.Пользователи.ОтслеживаниеИзменений(Отказ, Ссылка, ТекстИзменений);
КонецПроцедуры
