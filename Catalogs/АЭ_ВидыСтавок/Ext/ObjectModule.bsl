﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда 
		Если Не ИспользоватьКоэффициент Тогда
			
			КоэффициентЧислитель   = 1;
			КоэффициентЗнаменатель = 1;
			
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли