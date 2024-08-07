﻿////////////////////////////////////////////////////////////////////////////////
//                   МОДУЛЬ ФОРМЫ ВЫБОРА ПОЛЬЗОВАТЕЛЯ WINDOWS                 //
////////////////////////////////////////////////////////////////////////////////

// Процедура обработчик события "ПриОткрытии" формы
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	ТаблицаДоменовИПользователей = ПользователиОС();
	#ИначеЕсли ТонкийКлиент Тогда
	ТаблицаДоменовИПользователей = Новый ФиксированныйМассив (ПользователиОС());
	#КонецЕсли
	
	ЗаполнитьСписокДоменов();
	
КонецПроцедуры

// Процедура заполняет список доменов
//
&НаКлиенте
Процедура ЗаполнитьСписокДоменов ()
	
	СписокДоменов.Очистить();
	
	Для Каждого Запись Из ТаблицаДоменовИПользователей Цикл
		Домен = СписокДоменов.Добавить();
		Домен.ИмяДомена = Запись.ИмяДомена;
	КонецЦикла;
	
КонецПроцедуры

// Процедура обработчик события ПриАктивизации строки таблицы доменов
// 
&НаКлиенте
Процедура ТаблицаДоменовПриАктивизацииСтроки(Элемент)
	
	ИмяДомена = Элемент.ТекущиеДанные.ИмяДомена;
	
	Для Каждого Запись Из ТаблицаДоменовИПользователей Цикл
		Если Запись.ИмяДомена = ИмяДомена Тогда
			СписокПользователейТекущегоДомена.Очистить();
			Для Каждого Пользователь Из Запись.Пользователи Цикл
				ПользовательДомена = СписокПользователейТекущегоДомена.Добавить();
				ПользовательДомена.ИмяПользователя = Пользователь;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура обработчик события ПриВыборе строки таблицы пользователей.
// Формирует строку для использования аутентификации пользователя Windows.
//
&НаКлиенте
Процедура ТаблицаПользователейДоменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СкомпоноватьРезультатИЗакрытьФорму();
	
КонецПроцедуры

// Обработчик события нажатия на кнопку "Выбрать пользователя Windows" формы.
// Проверяет, что пользователь выбран и если так, то закрывает форму со строкой
// window-аутентификации для выбранного пользователя.
//
&НаКлиенте
Процедура КомандаОкВыполнить()
	
	ИмяДомена = Элементы.ТаблицаДоменов.ТекущиеДанные.ИмяДомена;
	ИмяПользователя = Элементы.ТаблицаПользователейДомена.ТекущиеДанные.ИмяПользователя;
	
	Если СокрЛП(ИмяДомена) <> "" И СокрЛП(ИмяПользователя) <> "" Тогда
		СкомпоноватьРезультатИЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

// Процедура компонует результат выбора в виде строки \\ДОМЕН\ИМЯ_ПОЛЬЗОВАТЕЛЯ_ДОМЕНА
// и закрывает форму, возвращая это значение, в качестве результата работы формы.
//
&НаКлиенте
Процедура СкомпоноватьРезультатИЗакрытьФорму()
	
	ИмяДомена = Элементы.ТаблицаДоменов.ТекущиеДанные.ИмяДомена;
	ИмяПользователя = Элементы.ТаблицаПользователейДомена.ТекущиеДанные.ИмяПользователя;
	СтрокаПользователяWindows = "\\" + ИмяДомена + "\" + ИмяПользователя;
	Закрыть(СтрокаПользователяWindows);
	ОповеститьОВыборе(СтрокаПользователяWindows);
КонецПроцедуры
