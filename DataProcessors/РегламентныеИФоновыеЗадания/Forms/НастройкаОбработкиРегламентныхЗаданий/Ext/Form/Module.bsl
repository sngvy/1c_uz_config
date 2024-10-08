﻿///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ МЕТОДЫ
//
// Сначала выполняемые НаКлиенте, затем НаСервере

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	ЗаписатьИзмененияНаСервере();
	Модифицированность = Ложь;
	РегламентныеЗаданияКлиент.ОтключитьГлобальныйОбработчикОжидания("УведомлятьОНекорректномСостоянииОбработкиРегламентныхЗаданий");
	Если УведомлятьОНекорректномСостоянииОбработкиРегламентныхЗаданий Тогда
		РегламентныеЗаданияКлиент.ПодключитьГлобальныйОбработчикОжидания("УведомлятьОНекорректномСостоянииОбработкиРегламентныхЗаданий",
		                                                                 ПериодУведомленияОСостоянииОбработкиРегламентныхЗаданий * 60,
		                                                                 Истина);
	КонецЕсли;
	
КонецПроцедуры // ЗаписатьИзменения()

&НаСервере
Процедура ЗаписатьИзмененияНаСервере()
	
	Настройки = УдалитьРегламентныеЗаданияСервер.ПолучитьНастройкиОбработкиРегламентныхЗаданий();
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	УдалитьРегламентныеЗаданияСервер.УстановитьНастройкиОбработкиРегламентныхЗаданий(Настройки);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	
КонецПроцедуры // ЗаписатьИзменения()

// Процедура АктивизироватьОкно выполняет активизацию окна после паузы.
//  Подключается, как обработчик ожидания в процедуре
// ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданийВыполнить.
//
&НаКлиенте
Процедура АктивизироватьОкно()
	
	Активизировать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ
//
// Источники: форма, панели, команды, элементы панелей, элементы формы,
//            поля, элементы полей

// Обработчик события ПриСозданииНаСервере формы выполняет заполнение
// реквизитов формы из источников.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ УдалитьОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Настройки = УдалитьРегламентныеЗаданияСервер.ПолучитьНастройкиОбработкиРегламентныхЗаданий();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		Элементы.БлокировкаОбработкиРегламентныхЗаданий.Видимость = Ложь;
		Элементы.ИмяПользователяДляЗапуска.Видимость = Ложь;
		Элементы.ПарольПользователяДляЗапуска.Видимость = Ложь;
		Элементы.БлокировкаОбработкиРегламентныхЗаданий.Видимость = Ложь;
	Иначе
		// Заполним список выбора имени пользователя.
		УдалитьРегламентныеЗаданияСервер.ДобавитьВСписокЗначенийИменаПользователей(Элементы.ИмяПользователяДляЗапуска.СписокВыбора);
	КонецЕсли;
		
КонецПроцедуры // ПриСозданииНаСервере()

// Обработчик события ПередЗакрытием формы уведомляет о модифицированности
// формы, если есть и предлагает выполнить запись изменений.
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		КодВозврата = Вопрос(НСтр("ru = 'Записать изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Если КодВозврата = КодВозвратаДиалога.Да Тогда
			ЗаписатьИзменения();
		ИначеЕсли КодВозврата = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданийВыполнить()
	
	Результат = РегламентныеЗаданияКлиент.ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий();
	Если Результат.Отказ Тогда
		Предупреждение(Результат.ОписаниеОшибки);
	ИначеЕсли Результат.ВыполненаПопыткаОткрытия Тогда
		ПодключитьОбработчикОжидания("АктивизироватьОкно", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданийВыполнить()

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьИзменения();
	Закрыть();
	
КонецПроцедуры // СохранитьИЗакрытьВыполнить()

&НаКлиенте
Процедура ИмяПользователяДляЗапускаПриИзменении(Элемент)
	
	Элементы.ПарольПользователяДляЗапуска.Доступность = НЕ ПустаяСтрока(ИмяПользователяДляЗапуска);
	Если НЕ Элементы.ПарольПользователяДляЗапуска.Доступность Тогда
		ПарольПользователяДляЗапуска = "";
	КонецЕсли;
	
КонецПроцедуры // ИмяПользователяДляЗапускаПриИзменении()

&НаКлиенте
Процедура ИмяПользователяДляЗапускаОчистка(Элемент, СтандартнаяОбработка)
	
	ИмяПользователяДляЗапускаПриИзменении(Элемент);
	
КонецПроцедуры // ИмяПользователяДляЗапускаОчистка()

&НаКлиенте
Процедура ПериодУведомленияОСостоянииОбработкиРегламентныхЗаданийПриИзменении(Элемент)
	
	Если ПериодУведомленияОСостоянииОбработкиРегламентныхЗаданий <= 0 Тогда
		ПериодУведомленияОСостоянииОбработкиРегламентныхЗаданий = 1;
	КонецЕсли;
	
КонецПроцедуры // ПериодУведомленияОСостоянииОбработкиРегламентныхЗаданийПриИзменении()

