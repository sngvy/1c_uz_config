﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
КонецПроцедуры

//Функция ОтправитьEMailСообщение(Почта, УчеткаEmail, ТекстСообщения)
//	Письмо = Новый ИнтернетПочтовоеСообщение();	
//	Письмо.Тема = "ЖЖЖ"; 
//	Текст = Письмо.Тексты.Добавить(ТекстСообщения);
//	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
//	Письмо.ИмяОтправителя = "ППП";
//	//Письмо.Отправитель.Адрес = "mav@trsoft.ru"; 
//	Письмо.Отправитель.ОтображаемоеИмя = "ФФФ"; 
//	//Письмо.ОбратныйАдрес.Добавить("mav@trsoft.ru");
//	Письмо.Получатели.Добавить("san_pancho@mail.ru");
//	
//	//Для каждого ФайлОтправки Из ФайлыОтправки Цикл		
//	//	ПроверкаФайл = Новый Файл(ФайлОтправки);		
//	//	Если ПроверкаФайл.Существует() Тогда
//	//		Письмо.Вложения.Добавить(ПроверкаФайл.ПолноеИмя, "Файл предложения от Кампании");  				
//	//	КонецЕсли;
//	//КонецЦикла; 	
//	
//	Почта.Послать(Письмо);
//КонецФункции

//Процедура ПриЗаписи(Отказ)
//	//Если Не Действие.Пустая() ИЛИ Не ВидКИ.Пустая() ИЛИ Не Шаблон.Пустая() Тогда
//	//	ТЗ = Объекты.Выгрузить();
//	//	Если Не Действие.Пустая() Тогда
//	//		ТЗ.ЗаполнитьЗначения(Действие, "Действие");		
//	//	КонецЕсли;	
//	//	Если Не ЭтотОбъект.ВидКИ.Пустая() Тогда
//	//		ТЗ.ЗаполнитьЗначения(ВидКИ, "ВидКИ");
//	//	КонецЕсли;	
//	//	Если Не ЭтотОбъект.Шаблон.Пустая() Тогда
//	//		ТЗ.ЗаполнитьЗначения(Шаблон, "Шаблон");
//	//	КонецЕсли;	
//	//	Объекты.Загрузить(ТЗ);
//	//КонецЕсли;
//КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)	
	ОбъектыСервер.ОбработкаЗаполненияДокументов(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);	
КонецПроцедуры

//Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
//	Если ЭтотОбъект.Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
//		Отказ = Истина; 
//	КонецЕсли;
//	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
//		НаборЗаписей = РегистрыСведений.УдалитьЗаданияДляРассылки.СоздатьНаборЗаписей();
//		НаборЗаписей.Отбор.Автор.Установить(ЭтотОбъект.Ссылка);
//		НаборЗаписей.Прочитать();
//		ЧислоЗаписей = НаборЗаписей.Количество();
//		НаборЗаписей.Отбор.Статус.Установить(Перечисления.СтатусыРассылки.НеОпределен);
//		НаборЗаписей.Прочитать();
//		Если НаборЗаписей.Количество() > ЧислоЗаписей Тогда
//			Сообщить("По данному документу уже началась рассылка");
//			Отказ = Истина;
//		Иначе
//			НаборЗаписей = РегистрыСведений.УдалитьЗаданияДляРассылки.СоздатьНаборЗаписей();
//			НаборЗаписей.Отбор.Автор.Установить(ЭтотОбъект.Ссылка);
//			НаборЗаписей.Записать(Истина);
//		КонецЕсли;
//	КонецЕсли;
//	ЭтотОбъект.ВсеДанныеЗаполнены = Истина;
//	Для Каждого Элемент из ЭтотОбъект.Объекты Цикл
//		Если Не ЗначениеЗаполнено(Элемент.Текст) ИЛИ Не ЗначениеЗаполнено(Элемент.Контакт) Тогда
//			ЭтотОбъект.ВсеДанныеЗаполнены = Ложь;	
//		КонецЕсли;
//	КонецЦикла;
//КонецПроцедуры

