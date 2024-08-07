﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МОДУЛЯ 

 // Формирует структуру возврата владельцу
 //
 &НаКлиенте
 Функция СформироватьСтруктуруПараметраПередачиВладельцу()
 
 	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("Текст",Текст);
	СтруктураВозврата.Вставить("ИмяТаблицы",ИмяТаблицы);
    СтруктураВозврата.Вставить("НомерСтроки",НомерСтроки);
    СтруктураВозврата.Вставить("ИмяКолонки",ИмяКолонки);
	
	Возврат СтруктураВозврата;
 
 КонецФункции 


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ                                                          

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Текст") Тогда 	
		Текст = Параметры.Текст;	
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяТаблицы") Тогда 	
		ИмяТаблицы = Параметры.ИмяТаблицы;	
	КонецЕсли;
	
	Если Параметры.Свойство("НомерСтроки") Тогда 	
		НомерСтроки = Параметры.НомерСтроки;	
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяКолонки") Тогда 	
		ИмяКолонки = Параметры.ИмяКолонки;	
	КонецЕсли;
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ОкончаниеРедактированияТекста",СформироватьСтруктуруПараметраПередачиВладельцу()); 
	
КонецПроцедуры
