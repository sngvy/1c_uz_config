﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтатусЦветНомерНеНайден = БИТфонСервер.ПолучитьЦветСтатусаНомерНеНайден();
	СтатусЦветСвободен      = БИТфонСервер.ПолучитьЦветСтатусаСвободен();
	СтатусЦветРазговаривает = БИТфонСервер.ПолучитьЦветСтатусаРазговаривает();
	СтатусЦветНеДоступен    = БИТфонСервер.ПолучитьЦветСтатусаНеДоступен();
	СтатусЦветОжидание      = БИТфонСервер.ПолучитьЦветСтатусаОжидание();
КонецПроцедуры

&НаКлиенте
Процедура ДиректорияЗаписанныхФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	стрКаталогНач = Запись.ДиректорияЗаписанныхФайлов;
	длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	длг.Каталог = стрКаталогНач;
	Если длг.Выбрать() = Истина Тогда
		Запись.ДиректорияЗаписанныхФайлов = длг.Каталог;
		Если длг.Каталог <> стрКаталогНач Тогда
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДоступность();
	Элементы.ВерсияБитфона.Заголовок = "Версия БИТ.Phone " + БИТфонСервер.ПолучитьВерсиюБИТфон();
	ВнутренниеНомераАстериск.Параметры.УстановитьЗначениеПараметра("Владелец", Запись.Пользователь);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступность()
	Элементы.СтационарныйТелефон.Доступность = Запись.ИспользоватьСтационарныйТелефон;
    Элементы.АвтоподнятиеПриВхЗвонке.Доступность = Запись.ИспользоватьСтационарныйТелефон;
	//
	Элементы.ПрефиксВыходаНаВнешнююЛинию.Доступность = НЕ Запись.ИспользоватьПрямойНабор;
	//
	Элементы.НомерАвтопереводаНеизвестногоКонтрагента.Доступность = Запись.АвтопереводНаМенеджера;
	//
	Элементы.АстерискЛогин.Доступность = Запись.ИнтеграцияСАстериск;
	Элементы.АстерискПароль.Доступность = Запись.ИнтеграцияСАстериск;
	Элементы.АстерискСоздаватьСобытияПриВнутреннихЗвонках.Доступность = Запись.ИнтеграцияСАстериск;
	Элементы.АстерискДиректорияЗаписанныхФайлов.Доступность = Запись.ИнтеграцияСАстериск;
	Элементы.ВнутренниеНомераАстериск.Доступность = Запись.ИнтеграцияСАстериск;
	//
	ДоступноПодключениеСтатуса = Запись.ТипПодключенияСтатусов  <> ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.НеИспользовать"); 	
	Элементы.СтатусЦветНеДоступен.Доступность    = ДоступноПодключениеСтатуса;
	Элементы.СтатусЦветНомерНеНайден.Доступность = ДоступноПодключениеСтатуса;
	Элементы.СтатусЦветОжидание.Доступность      = ДоступноПодключениеСтатуса;
	Элементы.СтатусЦветРазговаривает.Доступность = ДоступноПодключениеСтатуса;
	Элементы.СтатусЦветСвободен.Доступность      = ДоступноПодключениеСтатуса;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтационарныйТелефонПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПрямойНаборПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура АвтопереводНаМенеджераПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ИнтеграцияСАстерискПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеНомераАстерискСоздать(Команда)
	Заполн = Новый Структура;
	Заполн.Вставить("Владелец", Запись.Пользователь);
	П = Новый Структура;
	П.Вставить("ЗначенияЗаполнения", Заполн);
	ОткрытьФормуМодально("Справочник.бтВнутренниеНомераАстериск.Форма.ФормаЭлементаБезВладельца", П);
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеНомераАстерискСкопировать(Команда)
	текущ =  Элементы.ВнутренниеНомераАстериск.ТекущаяСтрока;
	П = Новый Структура;
	П.Вставить("ЗначениеКопирования", текущ);
	ОткрытьФормуМодально("Справочник.бтВнутренниеНомераАстериск.Форма.ФормаЭлементаБезВладельца", П);
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеНомераАстерискИзменитьВнутр(СсылкаНаЭлемент)
	П = Новый Структура("Ключ", СсылкаНаЭлемент);
	ОткрытьФормуМодально("Справочник.бтВнутренниеНомераАстериск.Форма.ФормаЭлементаБезВладельца", П);
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеНомераАстерискИзменить(Команда)
	текущ =  Элементы.ВнутренниеНомераАстериск.ТекущаяСтрока;
	ВнутренниеНомераАстерискИзменитьВнутр(текущ);
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеНомераАстерискВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВнутренниеНомераАстерискИзменитьВнутр(ВыбраннаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ЦветСтатусаНеДоступен    = Новый ХранилищеЗначения(СтатусЦветНеДоступен);
	ТекущийОбъект.ЦветСтатусаНомерНеНайден = Новый ХранилищеЗначения(СтатусЦветНомерНеНайден);
	ТекущийОбъект.ЦветСтатусаОжидание      = Новый ХранилищеЗначения(СтатусЦветОжидание);
	ТекущийОбъект.ЦветСтатусаРазговаривает = Новый ХранилищеЗначения(СтатусЦветРазговаривает);
	ТекущийОбъект.ЦветСтатусаСвободен      = Новый ХранилищеЗначения(СтатусЦветСвободен);
КонецПроцедуры

&НаКлиенте
Процедура ТипПодключенияСтатусовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущийТипПодключенияСтатусов = Запись.ТипПодключенияСтатусов;
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.AMI") Тогда
		Если НЕ БИТфонСервер.ПолучитьФлагИнтеграцииСАстериск() Тогда
			Предупреждение("Подключение через AMI не доступно, так как не включена интеграция с Астериск!");
		Иначе
			Запись.ТипПодключенияСтатусов = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.AMI");
		КонецЕсли;	
	ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.НеИспользовать") Тогда 
		Запись.ТипПодключенияСтатусов = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.НеИспользовать");
	ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.SIP") Тогда	
		Запись.ТипПодключенияСтатусов = ПредопределенноеЗначение("Перечисление.бтТипПодключенияСтатуса.SIP");
	КонецЕсли;
	ОбновитьДоступность();
	
	Если ТекущийТипПодключенияСтатусов <> Запись.ТипПодключенияСтатусов Тогда
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПапкуСЛогФайлом(Команда)
	ЗапуститьПриложение("%APPDATA%\BIT");
КонецПроцедуры

