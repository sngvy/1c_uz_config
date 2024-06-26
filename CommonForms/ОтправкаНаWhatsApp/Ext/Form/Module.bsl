﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Проверить установку UWP клиента
	Shell = Новый COMОбъект("WScript.Shell");
	TEMP = Shell.ExpandEnvironmentStrings("%TEMP%");
	ФайлСписка = "applist.txt";
	ПолныйПуть = TEMP + "\" + ФайлСписка;
	ЗапуститьПриложение("powershell " + "Get-AppxPackage | Select Name | Format-Table -AutoSize" + " > " + ПолныйПуть,,Истина,);
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ПолныйПуть);	
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		СтрокаПоискаНайдена = СтрНайти(Стр, "5319275A.WhatsAppDesktop                   ");
		Если СтрокаПоискаНайдена > 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если СтрокаПоискаНайдена = 1 Тогда
		Возврат;
	Иначе
		Ответ = Вопрос("Клиент WhatsApp не установлен на данном ПК. Установить?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Интеграция с WhatsApp");
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ФормаУстановкиИОбновленияВЦ = ПолучитьФорму("ОбщаяФорма.УстановкаWhatsApp");
			ФормаУстановкиИОбновленияВЦ.Открыть();
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
			ЭтаФорма.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьКлиент(Команда) Экспорт
	// Проверить установку UWP клиента
	Shell = Новый COMОбъект("WScript.Shell");
	TEMP = Shell.ExpandEnvironmentStrings("%TEMP%");
	ФайлСписка = "applist.txt";
	ПолныйПуть = TEMP + "\" + ФайлСписка;
	ЗапуститьПриложение("powershell " + "Get-AppxPackage | Select Name | Format-Table -AutoSize" + " > " + ПолныйПуть,,Истина,);
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ПолныйПуть);	
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		СтрокаПоискаНайдена = СтрНайти(Стр, "5319275A.WhatsAppDesktop                   ");
		Если СтрокаПоискаНайдена > 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если СтрокаПоискаНайдена = 1 Тогда
		// Запустить WhatsApp
		ПоказатьОповещениеПользователя("Интеграция с WhatsApp",,"Запуск приложения...",БиблиотекаКартинок.NC_ПодсистемаИнтеграцияСWhatsApp);
		КомандаОткрытьВЦ = "explorer " + "shell:AppsFolder\5319275A.WhatsAppDesktop_cv1g1gvanyjgm!App";
		ЗапуститьПриложение(КомандаОткрытьВЦ);
		//
	Иначе
		Ответ = Вопрос("Клиент WhatsApp не установлен на данном ПК. Установить?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Интеграция с WhatsApp");
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ФормаУстановкиИОбновленияВЦ = ПолучитьФорму("ОбщаяФорма.УстановкаWhatsApp");
			ФормаУстановкиИОбновленияВЦ.Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	Если ЗначениеЗаполнено(ЭтаФорма.Номер) И ЗначениеЗаполнено(ЭтаФорма.Договор) И ЗначениеЗаполнено(ЭтаФорма.Сообщение) Тогда
		// Отправить сообщение через API	
		Для Счетчик = 1 По 100 Цикл
			Состояние("Отправка сообщения", Счетчик, "Пожалуйста, подождите...", БиблиотекаКартинок.NC_ПодсистемаИнтеграцияСWhatsApp);
		КонецЦикла;
		КомандаОтправить = "whatsapp://send/?phone="+Номер+"&text="+Сообщение;
		ЗапуститьПриложение(КомандаОтправить);
		Оповестить("ШаблонИзмененВЦ");
		//
	Иначе
		Предупреждение("Не заполнены обязательные поля!",,"Интеграция с WhatsApp");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоискДолжника(Команда) Экспорт
	// Проверить установку UWP клиента
	Shell = Новый COMОбъект("WScript.Shell");
	TEMP = Shell.ExpandEnvironmentStrings("%TEMP%");
	ФайлСписка = "applist.txt";
	ПолныйПуть = TEMP + "\" + ФайлСписка;
	ЗапуститьПриложение("powershell " + "Get-AppxPackage | Select Name | Format-Table -AutoSize" + " > " + ПолныйПуть,,Истина,);
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ПолныйПуть);	
	Для НомерСтроки = 1 По Текст.КоличествоСтрок() Цикл
		Стр = Текст.ПолучитьСтроку(НомерСтроки);
		СтрокаПоискаНайдена = СтрНайти(Стр, "5319275A.WhatsAppDesktop                   ");
		Если СтрокаПоискаНайдена > 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если СтрокаПоискаНайдена = 1 Тогда
		// Найти контакт через API
		КомандаПоиск = "whatsapp://send/?phone="+Номер;
		ЗапуститьПриложение(КомандаПоиск);
		//
	Иначе
		Ответ = Вопрос("Клиент WhatsApp не установлен на данном ПК. Установить?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Интеграция с WhatsApp");
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ФормаУстановкиИОбновленияВЦ = ПолучитьФорму("ОбщаяФорма.УстановкаWhatsApp");
			ФормаУстановкиИОбновленияВЦ.Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Шаблоны(Команда)
	Если ЗначениеЗаполнено(ЭтаФорма.Номер) И ЗначениеЗаполнено(ЭтаФорма.Договор) Тогда
		// Открыть форму списка шаблонов
		ФормаСпискаШаблонов = ПолучитьФорму("Справочник.ШаблоныТекстаДляАвтоинформирования.Форма.ФормаСписка");
		ФормаСпискаШаблонов.СкрытоеПолеНомерДО = ЭтаФорма.Договор;
		ФормаСпискаШаблонов.Открыть();
	Иначе
		Предупреждение("Не заполнены обязательные поля!",,"Интеграция с WhatsApp");
	КонецЕсли;
КонецПроцедуры
