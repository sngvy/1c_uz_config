﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//НаборЗаписей = РегистрыСведений.ЗаданияДляРассылки.СоздатьНаборЗаписей();
	//Для Каждого Элемент ИЗ ЭтотОбъект.Объекты Цикл	
	//	Если ЗначениеЗаполнено(Элемент.Контакт) И ЗначениеЗаполнено(Элемент.Текст) Тогда
	//		Запись = НаборЗаписей.Добавить();
	//		Запись.Автор = ЭтотОбъект.Ссылка;
	//		Запись.Номер = Элемент.НомерСтроки;
	//		Запись.Объект = Элемент.Объект;
	//		Запись.Действие = ЭтотОбъект.Действие;
	//		Запись.Контакт = Элемент.Контакт;
	//		Запись.Текст = Элемент.Текст;
	//		Запись.Статус = Перечисления.СтатусыРассылки.НеОпределен;
	//		//		Запись.ТекстовыйСтатус = "Не отправлено";
	//		Запись.Шаблон = ЭтотОбъект.Шаблон;
	//		Запись.Дата = ЭтотОбъект.Дата + ЭтотОбъект.ДнейНаВыполнение*3600*24;
	//		Запись.GUID = Строка(Новый УникальныйИдентификатор);
	//		Если ЭтотОбъект.УчетнаяЗаписьОтправителя = Справочники.УчетныеЗаписиSMS4B.ПустаяСсылка() ИЛИ ЭтотОбъект.УчетнаяЗаписьОтправителя = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка() Тогда
	//			Если ЭтотОбъект.Действие = Перечисления.ВариантыДействийДляСкоринга.SMSОповещение Тогда
	//				Запись.Отправитель = Константы.УчеткаSMSРассылок.Получить();
	//			ИначеЕсли ЭтотОбъект.Действие = Перечисления.ВариантыДействийДляСкоринга.EMailРассылка Тогда
	//				Запись.Отправитель = Константы.УчеткаEMailРассылок.Получить();
	//			КонецЕсли;
	//		Иначе
	//			Запись.Отправитель = ЭтотОбъект.УчетнаяЗаписьОтправителя;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;	
	//НаборЗаписей.Записать(Ложь);
	//Движения.СостоянияПоАвтоинформированию.Записывать = Истина;
	//
	//ФайлТСИ = Новый ТекстовыйДокумент();
	//УчеткаEmail = Константы.УчеткаEMailРассылок.Получить();
	//Почта = Справочники.ШаблоныТекстаДляАвтоинформирования.СоздатьОбъектПочта(УчеткаEmail);
	//МассивПолучателей = Новый Массив();
	//ДатаАктуальности = Формат(ТекущаяДата() + ДнейНаВыполнение * 3600 * 24, "ДФ=yyyyMMdd");
	//	
	//Для Каждого Элемент Из ЭтотОбъект.Объекты Цикл
	//	ОтказДействия = Ложь;
	//	Если Элемент.Действие.Пустая() ИЛИ Элемент.Объект.Пустая() ИЛИ Элемент.Шаблон.Пустая() Тогда
	//		ОтказДействия = Истина;
	//	КонецЕсли;
	//	
	//	Если ОтказДействия Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	
	//	УИД = Новый УникальныйИдентификатор();
	//	Если Элемент.Действие = Перечисления.ВариантыДействийДляСкоринга.ПроизвольноеДействие Тогда
	//		Действие = Элемент.Шаблон;
	//		Справочники.ШаблоныТекстаДляАвтоинформирования.ВыполнитьПроизвольноеДействие(Элемент.Шаблон.Действие);
	//		
	//	//ИначеЕсли Элемент.Действие = Перечисления.ВариантыДействийДляСкоринга.EMailРассылка Тогда
	//	//	//Блок отвечает за рассылку e-mail из под ЦУЗ
	//	//	МассивПолучателей.Очистить();
	//	//	
	//	//	//Блок надо заменить процедурой		
	//	//	ТелефонАдрес = "";
	//	//	Если Элемент.ВидКИ.ЭтоДополнительноеСведение Тогда
	//	//		Запись = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	//	//		Запись.Объект = Элемент.Должник;
	//	//		Запись.Свойство = Элемент.ВидКИ;
	//	//		Запись.Прочитать();
	//	//		ТелефонАдрес = Запись.Значение;
	//	//	Иначе
	//	//		Свойства = Элемент.Должник.ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Свойство", Элемент.ВидКИ));
	//	//		Если Свойства.Количество() > 0 Тогда
	//	//			ТелефонАдрес = Свойства[0].Значение;
	//	//		КонецЕсли;
	//	//	КонецЕсли;
	//	//	
	//	//	Если ЗначениеЗаполнено(ТелефонАдрес) Тогда
	//	//		МассивПолучателей.Добавить(ТелефонАдрес);
	//	//	КонецЕсли;
	//	//	//блок

	//	//	Справочники.ШаблоныТекстаДляАвтоинформирования.ОтправитьEMail(Почта, УчеткаEmail, Элемент.Шаблон,
	//	//			Элемент.Организация, Элемент.Должник, Элемент.ДолговоеОбязательство, МассивПолучателей, ОтказДействия);
	//		
	//	Иначе	 
	//		Действие = Элемент.Действие;
	//		Документы.ЗаданияДляАвтоинформирования.ДобавитьЗаписьВФайлТСИ(ФайлТСИ, Элемент.Объект, Элемент.Шаблон, Строка(УИД), 
	//				Элемент.Действие, ВидКИ, ОтказДействия, ДатаАктуальности);
	//	КонецЕсли; 
	//	
	//	
	//	Если Не ОтказДействия Тогда	
	//		Движение = Движения.СостоянияПоАвтоинформированию.Добавить();
	//		Движение.Регистратор = ЭтотОбъект.Ссылка;
	//		Движение.Период = Дата;
	//		Движение.Объект = Элемент.Объект;
	//		Движение.Действие = Действие;					
	//		Движение.УИД = УИД;		
	//	КонецЕсли;	
	//КонецЦикла;
	//
	//Если ФайлТСИ.КоличествоСтрок() > 0 Тогда
	//	Документы.ЗаданияДляАвтоинформирования.ЗаписатьФайлТСИ(ФайлТСИ, ЭтотОбъект.Ссылка);
	//КонецЕсли;
	//
	//Если Почта <> Неопределено Тогда
	//	Почта.Отключиться();
	//КонецЕсли;
КонецПроцедуры

Процедура ОтправитьEMailСообщение(Почта, УчеткаEmail, ТекстСообщения)
	Письмо = Новый ИнтернетПочтовоеСообщение();
	Письмо.Тема = "ЖЖЖ"; 
	Текст = Письмо.Тексты.Добавить(ТекстСообщения);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Письмо.ИмяОтправителя = "ППП";
	//Письмо.Отправитель.Адрес = "mav@trsoft.ru"; 
	Письмо.Отправитель.ОтображаемоеИмя = "ФФФ"; 
	//Письмо.ОбратныйАдрес.Добавить("mav@trsoft.ru");
	Письмо.Получатели.Добавить("san_pancho@mail.ru");
	
	Почта.Послать(Письмо);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	//Если Не Действие.Пустая() ИЛИ Не ВидКИ.Пустая() ИЛИ Не Шаблон.Пустая() Тогда
	//	ТЗ = Объекты.Выгрузить();
	//	Если Не Действие.Пустая() Тогда
	//		ТЗ.ЗаполнитьЗначения(Действие, "Действие");		
	//	КонецЕсли;	
	//	Если Не ЭтотОбъект.ВидКИ.Пустая() Тогда
	//		ТЗ.ЗаполнитьЗначения(ВидКИ, "ВидКИ");
	//	КонецЕсли;	
	//	Если Не ЭтотОбъект.Шаблон.Пустая() Тогда
	//		ТЗ.ЗаполнитьЗначения(Шаблон, "Шаблон");
	//	КонецЕсли;	
	//	Объекты.Загрузить(ТЗ);
	//КонецЕсли;
	//++КазанцевЯА
	Если ПометкаУдаления Тогда	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РассылкаСМССообщения.СообщениеSMS КАК СообщениеSMS
		|ИЗ
		|	Документ.РассылкаСМС.Сообщения КАК РассылкаСМССообщения
		|ГДЕ
		|	РассылкаСМССообщения.Ссылка = &Ссылка";		
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СообщениеSMS = Выборка.СообщениеSMS.ПолучитьОбъект();
			СообщениеSMS.УстановитьПометкуУдаления(Истина);
			СообщениеSMS.Записать();
		КонецЦикла;	 
	КонецЕсли;
	//--КазанцевЯА
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)	
	ОбъектыСервер.ОбработкаЗаполненияДокументов(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//Если ЭтотОбъект.Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
	//	Отказ = Истина; 
	//КонецЕсли;
	//Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
	//	НаборЗаписей = РегистрыСведений.ЗаданияДляРассылки.СоздатьНаборЗаписей();
	//	НаборЗаписей.Отбор.Автор.Установить(ЭтотОбъект.Ссылка);
	//	НаборЗаписей.Прочитать();
	//	ЧислоЗаписей = НаборЗаписей.Количество();
	//	НаборЗаписей.Отбор.Статус.Установить(Перечисления.СтатусыРассылки.НеОпределен);
	//	НаборЗаписей.Прочитать();
	//	Если НаборЗаписей.Количество() > ЧислоЗаписей Тогда
	//		Сообщить("По данному документу уже началась рассылка");
	//		Отказ = Истина;
	//	Иначе
	//		НаборЗаписей = РегистрыСведений.ЗаданияДляРассылки.СоздатьНаборЗаписей();
	//		НаборЗаписей.Отбор.Автор.Установить(ЭтотОбъект.Ссылка);
	//		НаборЗаписей.Записать(Истина);
	//	КонецЕсли;
	//КонецЕсли;
	//ЭтотОбъект.ВсеДанныеЗаполнены = Истина;
	//Для Каждого Элемент из ЭтотОбъект.Объекты Цикл
	//	Если Не ЗначениеЗаполнено(Элемент.Текст) ИЛИ Не ЗначениеЗаполнено(Элемент.Контакт) Тогда
	//		ЭтотОбъект.ВсеДанныеЗаполнены = Ложь;	
	//	КонецЕсли;
	//КонецЦикла;
КонецПроцедуры

