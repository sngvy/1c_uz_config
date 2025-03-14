﻿
&НаСервере
Функция ПолучитьответОтСервиса(ТаблицаДанных, ДопНастройкиAhunter) Экспорт
	
	ПодготовленнаяТаблицаДанных = ПолучитьМассивАдресов(ТаблицаДанных);
	МассивПакетовJSONАдресов = ПолучитьJSONИзТаблицыАдресов(ПодготовленнаяТаблицаДанных);
	СтруктураАдресов = ПолучитьТЗ_С_ОбработаннымАдресом(МассивПакетовJSONАдресов, ДопНастройкиAhunter); 
	Таблица_Нормализованных_Адресов = ПолучитьТаблицуАдресов(ПодготовленнаяТаблицаДанных, СтруктураАдресов, ДопНастройкиAhunter);
	Возврат Таблица_Нормализованных_Адресов;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивАдресов(ТаблицаДанных)
	
	СоответствиеОбъектАдрес = Новый Соответствие;
	
	Для Счетчик = 0 По ТаблицаДанных.Количество() - 1 Цикл
		
		Адрес = ТаблицаДанных[Счетчик].АдресДляНормализации;
	
		Если Адрес = Null Тогда	
			Сообщение("" + ТаблицаДанных[Счетчик].Договор + " Адрес не заполнен. Запрос для этого адреса не обработан!");
			ТаблицаДанных[Счетчик].АдресДляНормализации = "";
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ТаблицаДанных;  

КонецФункции 

//Разбиваем Таблицу адресов на пакеты по лимитированному количеству штук для оптимизации запроса.
//Идем по Таблице от начала и до конца и как только насчитываем лимит то формируем один пакет
//Т.е. формируем готовые тела запросов
//Так же если элементы таблицы заканчиваются не достигнув очередного лимита, то передаем то что есть
&НаСервере
Функция ПолучитьJSONИзТаблицыАдресов(ТаблицаДанных)
	
	СтруктураRecords  = Новый Структура;
	МассивIDItems     = Новый Массив;
	СтруктураIdItems2 = Новый Структура;
	
	ЛимитАдресовДляОдногоПакета = 50;
	ПакетыАдресов = Новый Массив;
	
	СчетчикПакета = 0;
	Для СчетчикЦикла = 0 По ТаблицаДанных.Количество() - 1 Цикл
		
		СтруктураIdItems = Новый Структура;
		МассивАдресов    = Новый Массив;
		СтруктураАдрес   = Новый Структура;
		
		СтруктураАдрес.Вставить("type", "address");
		СтруктураАдрес.Вставить("body", ТаблицаДанных[СчетчикЦикла].АдресДляНормализации);
		МассивАдресов.Добавить(СтруктураАдрес);
		
		СтруктураIdItems.Вставить("id", Строка(СчетчикЦикла));
		СтруктураIdItems.Вставить("items", МассивАдресов);
		МассивIDItems.Добавить(СтруктураIdItems);
		СтруктураRecords.Вставить("records", МассивIDItems);
		
		СчетчикПакета = СчетчикПакета + 1;
		
		Если СчетчикПакета = ЛимитАдресовДляОдногоПакета ИЛИ 
			СчетчикЦикла = ТаблицаДанных.Количество() - 1 Тогда
						
			СтрокаJSON = ПолучитьСтрокуJSON(СтруктураRecords);
			ПакетыАдресов.Добавить(СтрокаJSON);
			
			СтруктураRecords  = Новый Структура;
			МассивIDItems     = Новый Массив;
			СтруктураIdItems2 = Новый Структура;
			СчетчикПакета = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПакетыАдресов;
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуJSON(СтруктураRecords)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	тПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, " ", Истина);  
	ЗаписьJSON.УстановитьСтроку(тПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, СтруктураRecords);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	Возврат СтрокаJSON;

КонецФункции 

// Посылаем запросы к сервису отдавая по одному подготовленному пакету
&НаСервере
Функция ПолучитьТЗ_С_ОбработаннымАдресом(ПакетыАдресов, ДопНастройкиAhunter)
	
	Сервер  = "http://ahunter.ru";      
	Ресурс  = "/site/cleanse/chunk";
	Token   = Константы.ТокенAhunter.Получить();
	Output  = "json|pretty|acodes|adict|afiasall|agar|aareas|acountry";
	Input   = "json";	
	Country = ?(ДопНастройкиAhunter.Страна = Перечисления.ПараметрСтранаДляAhunter.Россия, "rus", "kaz");
	
	ДобавитьДопНастройкиВЗапрос(Output, ДопНастройкиAhunter);
	
	РесурсСЗаголовками = Ресурс + "?" + "user=" + Token + "&" + "output=" + Output + "&" + "input=" + Input + "&" + "country=" + Country;
	Соединение = Новый HTTPСоединение("ahunter.ru",,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	
	МассивОтветныхПакетовДанных = Новый Массив;
	
	Для Счетчик = 0 По ПакетыАдресов.Количество() - 1 Цикл
	
		Запрос = Новый HTTPЗапрос(РесурсСЗаголовками);
	 	Запрос.УстановитьТелоИзСтроки(ПакетыАдресов[Счетчик]);
	 	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			Сообщение("Ответ от сервиса вернул ошибку " + Ответ.КодСостояния);
			Продолжить;
		КонецЕсли;
		
		Результат = Ответ.ПолучитьТелоКакСтроку();
		
		Если СтрНайти(Результат, "NOT_ENOUGH_MONEY") > 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "На счете недостаточно денег. Проверьте баланс в личном кабинете!";
			Сообщение.Сообщить();	
			Прервать;
		КонецЕсли;
	 
	 	ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());

		СтруктураДанных = ПолучитьСтруктуруJSON(Результат);
		МассивОтветныхПакетовДанных.Добавить(СтруктураДанных); 
	
	КонецЦикла;
	
	ИтоговаяСтруктура = ОбъеденитьСтруктурыВОдну(МассивОтветныхПакетовДанных);

	Возврат ИтоговаяСтруктура;

КонецФункции

// Далее склеиваем все ответные пакеты от сервиса в одну структуру
&НаСервере
Функция ОбъеденитьСтруктурыВОдну(МассивОтветныхПакетовДанных)

	ИтоговаяСтруктура = Новый Структура;
	МассивДанных = Новый Массив;
	Для СчетчикВнешний = 0 По МассивОтветныхПакетовДанных.Количество() - 1 Цикл 
		
		Для СчетчикВнутренний = 0 По МассивОтветныхПакетовДанных[СчетчикВнешний].records.Количество() - 1 Цикл
			МассивДанных.Добавить(МассивОтветныхПакетовДанных[СчетчикВнешний].records[СчетчикВнутренний]);
		КонецЦикла;
	
	КонецЦикла;
	ИтоговаяСтруктура.Вставить("records", МассивДанных);
	
Возврат ИтоговаяСтруктура;
КонецФункции 

&НаСервере
Процедура ДобавитьДопНастройкиВЗапрос(ПараметрOutput, ДопНастройкиAhunter)

	Если ДопНастройкиAhunter.TimeZone Тогда
		ПараметрOutput = ПараметрOutput + "|timezone";
	КонецЕсли;
	
	Если ДопНастройкиAhunter.Quality Тогда
		ПараметрOutput = ПараметрOutput + "|aqual";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуАдресов(ТаблицаДанных, СтруктураДанных, ДопНастройкиAhunter)
	
	ЕстьQuality  = ДопНастройкиAhunter.Quality;
	ЕстьTimeZone = ДопНастройкиAhunter.TimeZone;
	
	ТЗ = Новый ТаблицаЗначений();
	
	ТЗ.Колонки.Добавить("Договор");
	ТЗ.Колонки.Добавить("СтранаКод");
	ТЗ.Колонки.Добавить("Страна");
	ТЗ.Колонки.Добавить("Region");
	ТЗ.Колонки.Добавить("Admin_area");
	ТЗ.Колонки.Добавить("Admin_okrug");
	ТЗ.Колонки.Добавить("District");
	ТЗ.Колонки.Добавить("City");
	ТЗ.Колонки.Добавить("Place");
	ТЗ.Колонки.Добавить("Site");
	ТЗ.Колонки.Добавить("Street");  
	ТЗ.Колонки.Добавить("House");
	ТЗ.Колонки.Добавить("Building");
	ТЗ.Колонки.Добавить("Structure");
	ТЗ.Колонки.Добавить("Flat");
	ТЗ.Колонки.Добавить("Zip");
	ТЗ.Колонки.Добавить("Okato");
	
	Если ЕстьQuality Тогда
		ТЗ.Колонки.Добавить("Quality");
		ТЗ.Колонки.Добавить("FiasQuality");
	КонецЕсли; 
	
	Если ЕстьTimeZone Тогда
		ТЗ.Колонки.Добавить("TimeZone");
	КонецЕсли; 
	
	Для Индекс = 0 По СтруктураДанных.records.Количество() - 1 Цикл
		
		МассивДанныхАдреса = СтруктураДанных.records[Индекс].items[0].result.addresses;	
		
		Если МассивДанныхАдреса.Количество() = 0 ИЛИ СтруктураДанных.records[Индекс].items[0].body = "" Тогда
			
			Строка = ТЗ.Добавить();
			Строка.Договор = ТаблицаДанных[Индекс].Договор;
			Если ЕстьQuality Тогда
				Строка.FiasQuality = Ложь;
			КонецЕсли;
			Продолжить;
			
		КонецЕсли;
		
		СтруктураCountry = МассивДанныхАдреса[0].country;
		СтруктураFields  = МассивДанныхАдреса[0].fields;
		СтруктураCodes   = МассивДанныхАдреса[0].codes;
		
		Если ЕстьQuality Тогда
			СтруктураQuality  = МассивДанныхАдреса[0].quality;
		КонецЕсли;
		
		Если ЕстьTimeZone Тогда
			СтруктураTimeZone = МассивДанныхАдреса[0].time_zone;
		КонецЕсли;
		
		Строка = ТЗ.Добавить();
		
		Строка.Договор = ТаблицаДанных[Индекс].Договор;
		
		Если МассивДанныхАдреса[0].Свойство("areas") Тогда
			СтруктураAreas     = МассивДанныхАдреса[0].areas;
			Строка.Admin_area  = ПолучитьAdminArea (СтруктураAreas);
			Строка.Admin_okrug = ПолучитьAdminOkrug(СтруктураAreas);
		КонецЕсли;
		
		Строка.СтранаКод = СтруктураCountry.code;
		Строка.Страна    = СтруктураCountry.name;
		Строка.Region    = ПолучитьполеNameИType(СтруктураFields, 0, ДопНастройкиAhunter.Суффиксы);		
		Строка.District  = ПолучитьполеNameИType(СтруктураFields, 1, ДопНастройкиAhunter.Суффиксы);
		Строка.City      = ПолучитьполеNameИType(СтруктураFields, 2, ДопНастройкиAhunter.Суффиксы);
		Строка.Place     = ПолучитьполеNameИType(СтруктураFields, 3, ДопНастройкиAhunter.Суффиксы);
		Строка.Site      = ПолучитьполеNameИType(СтруктураFields, 4, ДопНастройкиAhunter.Суффиксы);
		Строка.Street    = ПолучитьполеNameИType(СтруктураFields, 5, Истина);
		Строка.House     = ПолучитьполеNameИType(СтруктураFields, 6, ДопНастройкиAhunter.Суффиксы);
		Строка.Building  = ПолучитьполеNameИType(СтруктураFields, 7, ДопНастройкиAhunter.Суффиксы);
		Строка.Structure = ПолучитьполеNameИType(СтруктураFields, 8, ДопНастройкиAhunter.Суффиксы);
		Строка.Flat      = ПолучитьполеNameИType(СтруктураFields, 9, ДопНастройкиAhunter.Суффиксы);
		Строка.Zip       = ПолучитьполеNameИType(СтруктураFields, 10,  Ложь);
		
		Строка.Okato 	 = СтруктураCodes.okato;
		
		Если ЕстьQuality Тогда
			Строка.Quality  = СтруктураQuality.precision;
		КонецЕсли;
		
		Если ЕстьTimeZone Тогда
			Строка.TimeZone = СтруктураTimeZone.utc_zone;
		КонецЕсли;
		
		FlatИHouse = ПроверитьФИАС(Строка, СтруктураCodes, ТЗ, Индекс);
		
		Если ЕстьQuality Тогда
			Строка.FiasQuality = ОценкаКачестваПолученногоFias(Строка, FlatИHouse);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТЗ;

КонецФункции 

&НаСервере
Функция ОценкаКачестваПолученногоFias(Строка, FlatИHouse)
	// Для Казахстана пропускаем все адреса
	Если Строка.Страна = "КАЗАХСТАН" Тогда
		Возврат Истина;
	КонецЕсли;
	
	КачествоФиас 	 = Ложь;
	ЕстьКвартираФИАС = FlatИHouse.Flat;
	ЕстьДомФИАС 	 = FlatИHouse.House;
	
	КачествоФиас = ЕстьКвартираФИАС И ЗначениеЗаполнено(Строка.Flat);
	
	Если НЕ КачествоФиас Тогда
		КачествоФиас = ЕстьДомФИАС И 
					   ЗначениеЗаполнено(Строка.House) И
					   НЕ ЗначениеЗаполнено(Строка.Flat);	
	КонецЕсли;
	
	Если НЕ КачествоФиас Тогда
		Сообщение("" + Строка.Договор + " Внимание ФИАС может быть неточным!" +  
		"Попробуйте уточнить адрес для лучшего результата ФИАС!");
	КонецЕсли;
				   
	Возврат КачествоФиас;

КонецФункции 

&НаСервере
Функция ПроверитьФИАС(Строка, СтруктураCodes, ТЗ, Индекс)

		ЕстьКвартираФИАС = ПроверитьСвойство(СтруктураCodes, "fias_flat");
		ЕстьДомФИАС = Ложь;
		
		Если ЕстьКвартираФИАС Тогда
			ДобавитьКолонкуЕслиНет(ТЗ, "fias_flat");
			ЗполнитьКолонку(Строка.fias_flat, СтруктураCodes.fias_flat); 
		Иначе
			ЕстьДомФИАС = ПроверитьСвойство(СтруктураCodes, "fias_house");
			
			Если ЕстьДомФИАС Тогда
				ДобавитьКолонкуЕслиНет(ТЗ, "fias_house");
				ЗполнитьКолонку(Строка.fias_house, СтруктураCodes.fias_house); 
			КонецЕсли;
		КонецЕсли;
		
		ДанныеПоНаличиюFiasFlatИHouse = Новый Структура;
		ДанныеПоНаличиюFiasFlatИHouse.Вставить("Flat",  ЕстьКвартираФИАС);
		ДанныеПоНаличиюFiasFlatИHouse.Вставить("House", ЕстьДомФИАС);
		
		Возврат ДанныеПоНаличиюFiasFlatИHouse;
		
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруJSON(ТекстJSON)
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	Структура = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	Возврат Структура;
	
КонецФункции

&НаСервере
Функция ПолучитьполеNameИType(Массив, Индекс, НуженСуффикс)
	
	Если Массив[Индекс].Свойство("name") Тогда
		Суффикс = ?(НуженСуффикс, " " + Массив[Индекс].type, "");
		Возврат Массив[Индекс].name + Суффикс;	
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьAdminArea(Структура)
	
	Если Структура.Свойство("admin_area") = Истина Тогда
		Ответ = Структура.admin_area.name + " " + Структура.admin_area.type;
		Возврат Ответ;
	КонецЕсли;

	Возврат "";
	
КонецФункции

&НаСервере
Функция ПолучитьAdminOkrug(Структура)
	
	Если Структура.Свойство("admin_okrug") = Истина Тогда
		Ответ = Структура.admin_okrug.name + " " + Структура.admin_okrug.type;
		Возврат Ответ;	
	КонецЕсли;

	Возврат "";
	
КонецФункции

&НаСервере
Функция ПроверитьСвойство(Коды, ИмяСвойства)
	
	СвойствоНайдено = Ложь;
	
	Если Коды.Свойство(ИмяСвойства) Тогда
		СвойствоНайдено = Истина;
	КонецЕсли;
	
	Возврат СвойствоНайдено;
	
КонецФункции

&НаСервере
Процедура ДобавитьКолонкуТаблицы(ТЗ, Имяколонки)
	
	ТЗ.Колонки.Добавить(ИмяКолонки);
	
КонецПроцедуры

&НаСервере
Процедура ЗполнитьКолонку(СвойствоТЗ, СвойствоИзЗапроса)

	СвойствоТЗ = СвойствоИзЗапроса;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКолонкуЕслиНет(ТЗ, Свойство)
	
	УжеСодержитСвойство = ТЗ.Колонки.Найти(Свойство);
	Если УжеСодержитСвойство = Неопределено Тогда
		ДобавитьКолонкуТаблицы(ТЗ, Свойство);
	КонецЕсли;
	
КонецПроцедуры

Процедура Сообщение(Текст)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
			
КонецПроцедуры

&НаСервере
Функция ПроверитьКачествоАдреса(Страна, ПараметрКачества) Экспорт
	
	Если Страна = "РОССИЯ" Тогда
		КачествоНормализации = ПараметрКачества;
	ИначеЕсли Страна = "КАЗАХСТАН" Тогда
		КачествоНормализации = Истина;
	Иначе	
		КачествоНормализации = Ложь;	
	КонецЕсли;
	
	Возврат КачествоНормализации;
КонецФункции