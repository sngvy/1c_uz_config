﻿#Область СлужебныеПроцедурыИФункции

// HTTPСоединение для вызова веб-сервиса 1С.
//
// Возвращаемое значение:
//     HTTPСоединение - объект для вызовов сервиса.
//
Функция СервисКлассификатора1С(ВремяОжидания = 120) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Авторизация = АдресныйКлассификаторСлужебный.ПараметрыАутентификацииНаСайте();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Авторизация = Неопределено Тогда
		ИмяПользователя    = "неавторизованный";
		ПарольПользователя = "";
	Иначе
		ИмяПользователя    = Авторизация.Логин;
		ПарольПользователя = Авторизация.Пароль;
	КонецЕсли;
	
	ТекущийURLВебСервиса = "api.orgaddress.1c.ru";
	Прокси               = Неопределено;
	Порт                 = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернетаКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиентСервер");
		Прокси = МодульПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("https");
	КонецЕсли;

	ЗащищенноеСоединение         = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	ИспользоватьАутентификациюОС = Ложь;
	
	СохраненныйТекущийURLВебСервиса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АдресныйКлассификатор", "URLСервисаКлассификатора1С");
	Если ТипЗнч(СохраненныйТекущийURLВебСервиса) = Тип("Строка") И ЗначениеЗаполнено(СохраненныйТекущийURLВебСервиса) Тогда
		URLВебСервисаПоЧастям = СтрРазделить(СохраненныйТекущийURLВебСервиса, ":", Ложь);
		ТекущийURLВебСервиса = СокрЛП(URLВебСервисаПоЧастям[0]);
		Если URLВебСервисаПоЧастям.Количество() > 1 Тогда
			ТипЧисло = Новый ОписаниеТипов("Число");
			Порт = ТипЧисло.ПривестиЗначение(URLВебСервисаПоЧастям[1]);
			ЗащищенноеСоединение = Неопределено;
			Если Порт = 0 Тогда
				Порт = 80;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
			
			Соединение = Новый HTTPСоединение(
				ТекущийURLВебСервиса,
				Порт,
				ИмяПользователя,
				ПарольПользователя,
				Прокси,
				ВремяОжидания,
				ЗащищенноеСоединение,
				ИспользоватьАутентификациюОС);
			
			Сервер = Соединение.Сервер;
			Порт   = Соединение.Порт;
			
	Исключение
		
		ШаблонЗапроса = "%1:%2%3ping";
		URL = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗапроса, ТекущийURLВебСервиса, Порт,
			АдресныйКлассификаторКлиентСервер.ПрефиксВерсииЗапроса());
		РезультатДиагностики = ОбщегоНазначенияКлиентСервер.ДиагностикаСоединения(URL);
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
			           |по причине:
			           |%3
			           |
			           |Результат диагностики:
			           |%4'"),
			Сервер, Формат(Порт, "ЧГ="),
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			РезультатДиагностики.ОписаниеОшибки);
			
			ЗаписьЖурналаРегистрации(АдресныйКлассификаторКлиентСервер.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

Функция СведенияОЗагрузкеСубъектовРФ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Соответствие;
	
	// Веб-сервис 1С
	СервисРезультат = АдресныйКлассификаторСлужебный.ВерсияПоставщикаДанных();
	КлассификаторДоступен = (СервисРезультат.Данные = Истина);
	
	Результат.Вставить("КлассификаторДоступен", КлассификаторДоступен);
	
	ИспользоватьЗагруженные = Ложь;
	
	СведенияОЗагрузкеСубъектовРФ = АдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	Для каждого СведенияОбСубъектеРФ Из СведенияОЗагрузкеСубъектовРФ Цикл
		
		Сведения = Новый Структура();
		Если КлассификаторДоступен Тогда
			Сведения.Вставить("ИспользоватьЗагруженные", СведенияОбСубъектеРФ.Загружено И НЕ СведенияОбСубъектеРФ.Устарело);
		Иначе
			Сведения.Вставить("ИспользоватьЗагруженные", СведенияОбСубъектеРФ.Загружено);
		КонецЕсли;
		
		Если НЕ ИспользоватьЗагруженные И Сведения.ИспользоватьЗагруженные Тогда
			ИспользоватьЗагруженные = Истина;
		КонецЕсли;
		Сведения.Вставить("ДатаЗагрузки", СведенияОбСубъектеРФ.ДатаЗагрузки);
		Результат.Вставить(СведенияОбСубъектеРФ.КодСубъектаРФ, Сведения);
		
	КонецЦикла;
	
	Результат.Вставить("ИспользоватьЗагруженные", ИспользоватьЗагруженные);
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти
