﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПередЗаписьюОбъекта(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПередУдалениемОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
