﻿# Если Клиент Тогда

Процедура ПриЗаписи(Отказ, Замещение)
	
	//СвойствоУчетПоВсемОрганизациям = ПланыВидовХарактеристик.НастройкиПользователей.УчетПоВсемОрганизациям;
	//СвойствоОсновнаяОрганизация = ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяОрганизация;
	//
	//Для Каждого Запись ИЗ ЭтотОбъект Цикл
	//	Если Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь Тогда
	//		Если Запись.Настройка = СвойствоУчетПоВсемОрганизациям Тогда
	//			глЗначениеПеременнойУстановить("УчетПоВсемОрганизациям", Запись.Значение, Истина);
	//		ИначеЕсли Запись.Настройка = СвойствоОсновнаяОрганизация Тогда
	//			глЗначениеПеременнойУстановить("ОсновнаяОрганизация", Запись.Значение, Истина);
	//		КонецЕсли;		
	//	КонецЕсли;
	//КонецЦикла;
	
	
КонецПроцедуры

# КонецЕсли