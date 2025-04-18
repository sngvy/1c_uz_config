﻿///////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СИНХРОНИЗАЦИИ С АТС
///////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ВНЕШНИЙ ИНТЕРФЕЙС

// Проверяет соединение к базе данных на АТС.
//
// Параметры:
//   ссылка на узел обмена (входящий),
//   строка ошибок (исходящий).
//
// Возвращаемое значение:
//   Булево - успешность подключения.
//
Функция ПроверитьСоединениеКБазеДанных(УзелОбмена, Ошибка) ЭКСПОРТ
	
	СоединениеУспешно = Истина;
	
	// подключение к БД
	вс = Неопределено;
	ид = ПодключитьсяКБазеДанных(УзелОбмена, вс, Ошибка);
	Если ид = Неопределено Тогда
		СоединениеУспешно = Ложь;
	Иначе
		СоединениеУспешно = Истина;
		ОтключитьсяОтБазыДанных(вс, ид);
	КонецЕсли;
	
	Возврат СоединениеУспешно;
	
КонецФункции
	
// Выгружает на АТС изменения наименований и телефонов контрагентов, номеров перевода.
//
// Параметры:
//   ссылка на узел обмена (входящий),
//   строка состояния выполнения (исходящий),
//   строка ошибок (исходящий),
//   флаг выгрузки по одному изменению или всех.
//
Функция ВыполнитьВыгрузкуИзмененийНаАТС(УзелОбмена, Сообщение, Ошибка, флагВыгружатьВсе) ЭКСПОРТ

	естьИзменения = ПроверитьИзмененияВУзле(УзелОбмена);
	Если НЕ естьИзменения Тогда
		Если флагВыгружатьВсе Тогда
			Сообщение = Сообщение + Символы.ПС;
		КонецЕсли;
		Сообщение = Сообщение + "Изменений в узле обмена нет.";
		Возврат Ложь;
	КонецЕсли;
	
	// подключение к БД
	вс = Неопределено;
	ид = ПодключитьсяКБазеДанных(УзелОбмена, вс, Ошибка);
	Если ид = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "Не удалось подключиться к базе данных узла обмена '" + Строка(УзелОбмена) + "'.";
		Возврат Ложь;
	КонецЕсли;

	// тип хранения контактной информации
	контИнформВРегистреСведений = бит_ТелефонияСерверПереопределяемый.КонтактнаяИнформацияВРегистреСведений();
	
	выгружено = ОбновитьИзмененияМенеджеров(УзелОбмена, вс, ид, Сообщение, Ошибка, флагВыгружатьВсе);
	Если выгружено И Не флагВыгружатьВсе Тогда
		ОтключитьсяОтБазыДанных(вс, ид);
		Возврат Истина;
	КонецЕсли;
	
	выгружено = ОбновитьИзмененияКонтрагентов(УзелОбмена, вс, ид, Сообщение, Ошибка, флагВыгружатьВсе);
	Если выгружено И Не флагВыгружатьВсе Тогда
		ОтключитьсяОтБазыДанных(вс, ид);
		Возврат Истина;
	КонецЕсли;
	
	выгружено = ОбновитьИзмененияКонтактныхЛиц(УзелОбмена, вс, ид, Сообщение, Ошибка, флагВыгружатьВсе);
	Если выгружено И Не флагВыгружатьВсе Тогда
		ОтключитьсяОтБазыДанных(вс, ид);
		Возврат Истина;
	КонецЕсли;
	
	Если контИнформВРегистреСведений Тогда
		выгружено = ОбновитьИзмененияКонтактнойИнформацииУТ10(УзелОбмена, вс, ид, Сообщение, Ошибка, флагВыгружатьВсе);
		Если выгружено И Не флагВыгружатьВсе Тогда
			ОтключитьсяОтБазыДанных(вс, ид);
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;

	ОтключитьсяОтБазыДанных(вс, ид);
	
	Возврат Ложь;
	
КонецФункции

// Проверяет на АТС номер телефона контрагента и сообщает номер его менеджера.
//
// Параметры:
//   ссылка на узел обмена (входящий),
//   номер телефона контрагента (входящий),
//   строка состояния выполнения (исходящий),
//   строка ошибок (исходящий).
//
Процедура ПроверитьНомерНаАТС(УзелОбмена, НомерКонтрагента, Сообщение, Ошибка) ЭКСПОРТ
	
	// подключение к БД
	вс = Неопределено;
	ид = ПодключитьсяКБазеДанных(УзелОбмена, вс, Ошибка);
	Если ид = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "Не удалось подключиться к базе данных.";
		Возврат;
	КонецЕсли;
	
	стрСокрНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(НомерКонтрагента));
	
	базаИд = УзелОбмена.ИдентификаторБазы;
	стрЗапрос = "";
	Попытка
		стрКонтрагентИд = "";
		стрКонтрагентИмя = "";
		стрМенеджерИд = "";
		стрМенеджерНомер = "";
		//
		колвоСтрок = 0;
		флагОстанов = Ложь;
		//
		Если НЕ флагОстанов Тогда
			стрКонтрагентИд = вс.GetClientIdByNumber(ид, базаИд, стрСокрНомер);
			найден = (стрКонтрагентИд <> Неопределено);
			Если найден Тогда
				Сообщение = Сообщение + Символы.ПС + "Номер найден, ID контрагента '" + стрКонтрагентИд + "'";
			Иначе
				Сообщение = Сообщение + Символы.ПС + "Номер не найден";
				флагОстанов = Истина;
			КонецЕсли;
		КонецЕсли;
		//
		Если НЕ флагОстанов Тогда
			стрКонтрагентИмя = вс.GetClientName(ид, базаИд, стрКонтрагентИд);
			стрМенеджерИд = вс.GetClientManager(ид, базаИд, стрКонтрагентИд);
			найден = (стрКонтрагентИмя <> Неопределено);
			Если найден Тогда
				Сообщение = Сообщение + Символы.ПС + "Контрагент найден, наименование '" + стрКонтрагентИмя + "', ID менеджера '" + стрМенеджерИд + "'";
			Иначе
				Сообщение = Сообщение + Символы.ПС + "Контрагент не найден";
				флагОстанов = Истина;
			КонецЕсли;
		КонецЕсли;
		//
		Если НЕ флагОстанов Тогда
			стрМенеджерНомер = вс.GetManagerNumber(ид, базаИд, стрМенеджерИд); 
			найден = (стрМенеджерНомер <> Неопределено);
			Если найден Тогда
				Сообщение = Сообщение + Символы.ПС + "Номер менеджера '" + стрМенеджерНомер + "'";
			Иначе
				Сообщение = Сообщение + Символы.ПС + "Номер менеджера не найден";
				флагОстанов = Истина;
			КонецЕсли;
		КонецЕсли;
		//
	Исключение
		Ошибка = Ошибка + Символы.ПС +
			"Ошибка запроса проверки номера - " + ОписаниеОшибки();
	КонецПопытки;

	ОтключитьсяОтБазыДанных(вс, ид);
КонецПроцедуры

// Удаляет на АТС все данные в таблицах номеров телефонов, менеджеров и названий контрагентов.
//
// Параметры:
//   ссылка на узел обмена (входящий),
//   строка состояния выполнения (исходящий),
//   строка ошибок (исходящий).
//
Процедура ОчиститьБазуДанныхНаАТС(УзелОбмена, Сообщение, Ошибка) ЭКСПОРТ
	
	// подключение к БД
	вс = Неопределено;
	ид = ПодключитьсяКБазеДанных(УзелОбмена, вс, Ошибка);
	Если ид = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "Не удалось подключиться к базе данных.";
		Возврат;
	КонецЕсли;

	базаИд = УзелОбмена.ИдентификаторБазы;
	колвоСтрок = 0;
	Попытка
		// удаление контрагентов
		колвоСтрок = вс.ClearClientsTable(ид, базаИд);
		Сообщение = Сообщение + Символы.ПС + "Удалено контрагентов: " + Строка(колвоСтрок);
		//
		// удаление менеджеров
		колвоСтрок = вс.ClearManagersTable(ид, базаИд);
		Сообщение = Сообщение + Символы.ПС + "Удалено менеджеров: " + Строка(колвоСтрок);
		//
		// удаление номеров контрагентов
		колвоСтрок = вс.ClearClientNumbersTable(ид, базаИд);
		Сообщение = Сообщение + Символы.ПС + "Удалено номеров контрагентов: " + Строка(колвоСтрок);
	Исключение
		Ошибка = Ошибка + Символы.ПС +
			"Ошибка очистки базы - " + ОписаниеОшибки();
	КонецПопытки;

	ОтключитьсяОтБазыДанных(вс, ид);
КонецПроцедуры

// Возвращает строку - версию механизма синхронизации с АТС.
Функция ПолучитьВерсиюМеханизмаСинхронизации() ЭКСПОРТ
	Возврат "2.0";
КонецФункции

// Возвращает строку - версию механизма синхронизации с АТС.
Функция ПолучитьВерсиюВебСервиса(УзелОбмена, Ошибка) ЭКСПОРТ
	версияВС = "";
	
	Если НЕ ЗначениеЗаполнено(УзелОбмена) Тогда
		Ошибка = "Не задан узел обмена.";
		Возврат версияВС;
	КонецЕсли;
	
	Попытка
		стрХост = УзелОбмена.ХостБД;
		всСсылка = бит_АТСВебСервисы.ПолучитьВебСервисКлиентМенеджер(стрХост);
		версияВС = всСсылка.GetVersion();
	Исключение
		Ошибка = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат версияВС;
КонецФункции

// Процедура регламентного задания
Процедура СинхронизацияСАТС() ЭКСПОРТ
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ОбменАТС.Ссылка
	               |ИЗ
	               |	ПланОбмена.бит_ОбменАТС КАК бит_ОбменАТС
	               |ГДЕ
	               |	бит_ОбменАТС.ПометкаУдаления = ЛОЖЬ";
	табл = Запрос.Выполнить().Выгрузить();
	Для Каждого запись Из табл Цикл
		узелОбмена = запись.Ссылка;
		Если ЗначениеЗаполнено(узелОбмена)
			И ЗначениеЗаполнено(узелОбмена.ХостБД)
			И ЗначениеЗаполнено(узелОбмена.НаименованиеБД)
		Тогда
			стрСообщение = "";
			стрОшибка = "";
			ВыполнитьВыгрузкуИзмененийНаАТС(узелОбмена, стрСообщение, стрОшибка, Истина);
			Если ЗначениеЗаполнено(стрОшибка) Тогда
				ЗаписьЖурналаРегистрации("БИТ.АТС", УровеньЖурналаРегистрации.Ошибка,
					, "Ошибка выгрузки данных на БИТ.АТС", стрОшибка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

Функция КоличествоИзмененийВУзле(Узел) ЭКСПОРТ
	колВоИзм = 0;
	Если НЕ ЗначениеЗаполнено(Узел) Тогда
		Возврат колВоИзм;
	КонецЕсли;
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного);
	Пока выборка.Следующий() Цикл
		колВоИзм = колВоИзм + 1;
	КонецЦикла;
	Возврат колВоИзм;
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// возвращает идентификатор соединения с БД
Функция ПодключитьсяКБазеДанных(УзелОбмена, всСсылка, Ошибка)
	
	идПодключения = Неопределено;
	всСсылка = Неопределено;
	
	Если НЕ ЗначениеЗаполнено(УзелОбмена) Тогда
		Ошибка = Ошибка + Символы.ПС + "Не задан узел обмена.";
		Возврат идПодключения;
	КонецЕсли;
	
	Если НЕ ( ЗначениеЗаполнено(УзелОбмена.НаименованиеБД)
			И ЗначениеЗаполнено(УзелОбмена.ХостБД) ) Тогда
		Ошибка = Ошибка + Символы.ПС + "Не все обязательные поля заполнены для узла обмена '" + Строка(УзелОбмена) + "'.";
		Возврат идПодключения;
	КонецЕсли;
	
	Попытка
		
		стрХост = УзелОбмена.ХостБД;
		стрНаименованиеБД = УзелОбмена.НаименованиеБД;
		стрПользователь = УзелОбмена.ПользовательБД;
		стрПароль = УзелОбмена.ПарольБД;
		
		всСсылка = бит_АТСВебСервисы.ПолучитьВебСервисКлиентМенеджер(стрХост);
		
		идПодключения = всСсылка.Open(стрНаименованиеБД, стрПользователь, стрПароль);
		
	Исключение
		Ошибка = Ошибка + ОписаниеОшибки();
		всСсылка = Неопределено;
		идПодключения = Неопределено;
	КонецПопытки;
	Возврат идПодключения;
КонецФункции

// отключение от БД
Процедура ОтключитьсяОтБазыДанных(всСсылка, идПодключения)
	Если всСсылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	всСсылка.Close(идПодключения);
	всСсылка = Неопределено;
	идПодключения = Неопределено;
КонецПроцедуры

// возвращает строку - уникальный идентификатор менеджера
Функция ПолучитьИдентификаторМенеджера(менеджерСсылка)
	стрИдМенеджера = "";
	Если менеджерСсылка <> Неопределено Тогда
		стрИдМенеджера = Строка(менеджерСсылка.УникальныйИдентификатор());
	КонецЕсли;
	Возврат стрИдМенеджера;
КонецФункции

// возвращает строку - уникальный идентификатор контрагента
Функция ПолучитьИдентификаторКонтрагента(контрагентСсылка)
	стрИдКонтрагента = "";
	Если контрагентСсылка <> Неопределено Тогда
		стрИдКонтрагента = Строка(контрагентСсылка.УникальныйИдентификатор());
	КонецЕсли;
	Возврат стрИдКонтрагента;
КонецФункции

// возвращает строку - номер телефона пользователя базы
Функция ПолучитьНомерПользователя(ПользовательСсылка)
	стрНомер = "";
	//
	Если НЕ ЗначениеЗаполнено(стрНомер) Тогда
		// получение из настроек БИТ.Phone
		менеджЗапись = РегистрыСведений.бит_БитфонНастройки.СоздатьМенеджерЗаписи();
		менеджЗапись.Пользователь = ПользовательСсылка;
		менеджЗапись.Прочитать();
		Если менеджЗапись.Выбран() Тогда
			стрНомер = менеджЗапись.СвойНомер;
		КонецЕсли;
	КонецЕсли;
	//
	Если НЕ ЗначениеЗаполнено(стрНомер) Тогда
		// получение из настроек подключения к БИТ.АТС
		менеджЗапись = РегистрыСведений.бит_БитАТСНастройки.СоздатьМенеджерЗаписи();
		менеджЗапись.Пользователь = ПользовательСсылка;
		менеджЗапись.Прочитать();
		Если менеджЗапись.Выбран() Тогда
			стрНомер = менеджЗапись.НомерСвязанногоТелефона;
		КонецЕсли;
	КонецЕсли;
	//
	Возврат стрНомер;
КонецФункции

// Проверяет наличие в БД менеджера с заданным ключом и обновляет его номер при необходимости.
// Если менеджер не найден - создает.
//
// Параметры:
//   номер базы 1С (входящий, число),
//   ссылка на менеджера (входящий, элемент справочника Пользователи),
//   строка сообщения об ошибке (исходящий, строка).
//
// Возвращаемое значение:
//   успешность выполнения, булево.
//
Функция ПроверитьНаличиеМенеджераВБазеДанных(всСсылка, идПодключения, базаИд, менеджерСсылка, Ошибка)
	Если всСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "ПроверитьНаличиеМенеджераВБазеДанных() пустая ссылка на базу данных";
		Возврат Ложь;
	КонецЕсли;
	//
	Если менеджерСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "Менеджер - пустая ссылка";
		Возврат Ложь;
	КонецЕсли;
	//
	стрМенеджерИд = ПолучитьИдентификаторМенеджера(менеджерСсылка);
	стрМенеджерНомер = ПолучитьНомерПользователя(менеджерСсылка);
	//
	найден = Ложь;
	Попытка
		найден = всСсылка.CheckManager(идПодключения, базаИд, стрМенеджерИд, стрМенеджерНомер);
	Исключение
		найден = Ложь;
		Ошибка = Ошибка + Символы.ПС +
			"Ошибка проверки менеджера " + Строка(менеджерСсылка) + " - " + ОписаниеОшибки();
	КонецПопытки;
	Возврат найден;
КонецФункции

// Проверяет наличие в БД контрагента с заданным ключом и обновляет наименование при необходимости.
// Если контрагент не найден - создает.
//
// Параметры:
//   номер базы 1С (входящий, число),
//   ссылка на контрагента (входящий),
//   строка сообщения об ошибке (исходящий, строка).
//
// Возвращаемое значение:
//   успешность выполнения, булево.
//
Функция ПроверитьНаличиеКонтрагентаВБазеДанных(всСсылка, идПодключения, базаИд, контрагентСсылка, Ошибка)
	Если всСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "ПроверитьНаличиеКонтрагентаВБазеДанных() пустая ссылка на базу данных";
		Возврат Ложь;
	КонецЕсли;
	//
	Если контрагентСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "Контрагент - пустая ссылка";
		Возврат Ложь;
	КонецЕсли;
	//
	стрИд = ПолучитьИдентификаторКонтрагента(контрагентСсылка);
	стрНаименование = ОчиститьНедопустимыеСимволыSQLЗапроса(контрагентСсылка.Наименование);
	//
	менеджерСсылка = бит_ТелефонияСерверПереопределяемый.ПолучитьОсновногоМенеджераКонтрагента(контрагентСсылка);
	стрМенеджерИд = ПолучитьИдентификаторМенеджера(менеджерСсылка);
	стрМенеджерНомер = ПолучитьНомерПользователя(менеджерСсылка);
	//
	найден = Ложь;
	Попытка
		найден = всСсылка.CheckClient(идПодключения, базаИд, стрИд, стрНаименование, стрМенеджерИд, стрМенеджерНомер);
	Исключение
		найден = Ложь;
		Ошибка = Ошибка + Символы.ПС +
			"Ошибка проверки контрагента " + Строка(контрагентСсылка) + " - " + ОписаниеОшибки();
	КонецПопытки;
	Возврат найден;
КонецФункции

// Проверяет наличие в БД номера телефона контрагента и обновляет привязку к контрагенту при необходимости.
// Если номер телефона не найден - создает.
//
// Параметры:
//   номер базы 1С (входящий, число),
//   номер телефона (строка),
//   ссылка на контрагента (входящий),
//   строка информационного сообщения,
//   строка сообщения об ошибке (исходящий, строка).
//
// Возвращаемое значение:
//   успешность выполнения, булево.
//
Функция ПроверитьНаличиеНомераТелефонаВБазеДанных(всСсылка, идПодключения, базаИд, стрНомерКонтрагента, контрагентСсылка, Сообщение, Ошибка)
	Если всСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "ПроверитьНаличиеНомераТелефонаВБазеДанных() пустая ссылка на базу данных";
		Возврат Ложь;
	КонецЕсли;
	//
	Если контрагентСсылка = Неопределено Тогда
		Ошибка = Ошибка + Символы.ПС + "ПроверитьНаличиеНомераТелефонаВБазеДанных() контрагент - пустая ссылка";
		Возврат Ложь;
	КонецЕсли;
	//
	стрНомер = бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(стрНомерКонтрагента);
	стрНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(стрНомер);
	Если НЕ ЗначениеЗаполнено(стрНомер) Тогда
		Возврат Истина;
	КонецЕсли;
	//
	стрИдКонтрагента = ПолучитьИдентификаторКонтрагента(контрагентСсылка);
	стрНаименованиеКонтрагента = ОчиститьНедопустимыеСимволыSQLЗапроса(контрагентСсылка.Наименование);
	//
	менеджерСсылка = бит_ТелефонияСерверПереопределяемый.ПолучитьОсновногоМенеджераКонтрагента(контрагентСсылка);
	стрМенеджерИд = ПолучитьИдентификаторМенеджера(менеджерСсылка);
	стрМенеджерНомер = ПолучитьНомерПользователя(менеджерСсылка);
	//
	найден = Ложь;
	Попытка
		найден = всСсылка.CheckClientNumber(идПодключения, базаИд, стрИдКонтрагента, стрНомер, стрНаименованиеКонтрагента, стрМенеджерИд, стрМенеджерНомер);
	Исключение
		найден = Ложь;
		Ошибка = Ошибка + Символы.ПС +
			"Ошибка проверки телефона контрагента " + Строка(контрагентСсылка) + " номер " + стрНомер + " - " + ОписаниеОшибки();
	КонецПопытки;
	Если найден Тогда
		Сообщение = Сообщение + Символы.ПС + "Номер телефона " + стрНомер + " контрагента " + Строка(контрагентСсылка) + " изменен";
	КонецЕсли;	
	Возврат найден;
КонецФункции

// Возвращаемое значение:
//   успешность выполнения, булево.
Функция ОбновитьНомераТелефоновКонтрагента(всСсылка, идПодключения, базаИд, контрагентСсылка, массивНомеровКонтрагента, Сообщение, Ошибка)
	Если всСсылка = Неопределено ИЛИ
		контрагентСсылка = Неопределено ИЛИ
		массивНомеровКонтрагента = Неопределено
	Тогда
		Возврат Ложь;
	КонецЕсли;
	//
	обновлено = Истина;
	Для Каждого стрНомерКонтрагента Из массивНомеровКонтрагента Цикл
		проверен = ПроверитьНаличиеНомераТелефонаВБазеДанных(всСсылка, идПодключения, базаИд, стрНомерКонтрагента, контрагентСсылка, Сообщение, Ошибка);
		Если НЕ проверен Тогда
			обновлено = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат обновлено;
КонецФункции

Функция УдалитьНомераТелефоновКонтрагента(всСсылка, идПодключения, базаИд, контрагентСсылка, массивНомеровКонтрагента, Сообщение, Ошибка)
	Если всСсылка = Неопределено ИЛИ
		контрагентСсылка = Неопределено ИЛИ
		массивНомеровКонтрагента = Неопределено
	Тогда
		Возврат Ложь;
	КонецЕсли;
	//
	стрНаименованиеКонтрагента = контрагентСсылка.Наименование;
	//
	удалены = Истина;
	Для Каждого стрНомерКонтрагента Из массивНомеровКонтрагента Цикл
		стрНомер = бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(стрНомерКонтрагента);
		стрНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(стрНомер);
		Если НЕ ЗначениеЗаполнено(стрНомер) Тогда
			Продолжить;
		КонецЕсли;
		колвоСтрок = 0;
		Попытка
			колвоСтрок = всСсылка.DeleteClientNumber(идПодключения, базаИд, стрНомер);
			Если колвоСтрок > 0 Тогда
				Сообщение = Сообщение + Символы.ПС + "Номер телефона " + стрНомер + " контрагента " + Строка(контрагентСсылка) + " удален";
			КонецЕсли;	
		Исключение
			удалены = Ложь;
			Ошибка = Ошибка + Символы.ПС +
				"Ошибка удаления телефона контрагента " + стрНаименованиеКонтрагента + " номер " + стрНомер +
				" - " + ОписаниеОшибки();
			Прервать;
		КонецПопытки;
	КонецЦикла;
	//
	Возврат удалены;
КонецФункции

// Проверяет изменения в узле обмена
// Возвращаемое значение:
//   булево, Истина (есть изменения) или Ложь.
Функция ПроверитьИзмененияВУзле(Узел)
	Если НЕ ЗначениеЗаполнено(Узел) Тогда
		Возврат Ложь;
	КонецЕсли;
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного);
	Возврат выборка.Следующий();
КонецФункции

//
Функция ОбновитьИзмененияМенеджеров(Узел, всСсылка, идПодключения, Сообщение, Ошибка, флагВыгружатьВсе)
	количествоИзменений = 0;
	//
	метаданныеНомера = Новый Массив;
	метаданныеНомера.Добавить(Метаданные.РегистрыСведений.бит_БитфонНастройки);
	метаданныеНомера.Добавить(Метаданные.РегистрыСведений.бит_БитАТСНастройки);
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного, метаданныеНомера);
	Пока выборка.Следующий() Цикл
		наборЗаписейРС = выборка.Получить();
		удалитьРегИзм = Истина;
		Если наборЗаписейРС.Количество() > 0 Тогда
			Для Каждого записьРС Из наборЗаписейРС Цикл
				удалитьРегИзм = ПроверитьНаличиеМенеджераВБазеДанных(всСсылка, идПодключения, Узел.ИдентификаторБазы, записьРС.Пользователь, Ошибка);
				Если удалитьРегИзм Тогда
					Если флагВыгружатьВсе Тогда
						Сообщение = Сообщение + Символы.ПС;
					КонецЕсли;
					Сообщение = Сообщение + "Настройки пользователя " + Строка(записьРС.Пользователь) + " изменены";
				Иначе
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			пользовУдаленнЗаписи = наборЗаписейРС.Отбор.Пользователь.Значение;
			ПроверитьНаличиеМенеджераВБазеДанных(всСсылка, идПодключения, Узел.ИдентификаторБазы, пользовУдаленнЗаписи, Ошибка);
			Для Каждого метаданнРС Из метаданныеНомера Цикл
				Если ТипЗнч(наборЗаписейРС) = Тип("РегистрСведенийНаборЗаписей." + метаданнРС.Имя) Тогда
					Если флагВыгружатьВсе Тогда
						Сообщение = Сообщение + Символы.ПС;
					КонецЕсли;
					Сообщение = Сообщение + метаданнРС.Синоним + " пользователя " + Строка(пользовУдаленнЗаписи) + " удалены";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		//
		Если удалитьРегИзм Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Узел, наборЗаписейРС);
		КонецЕсли;
		//
		количествоИзменений = количествоИзменений + 1;
		//
		Если Не флагВыгружатьВсе Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//
	Если количествоИзменений = 0 И флагВыгружатьВсе Тогда
		Сообщение = Сообщение + Символы.ПС + "Изменений менеджеров нет";
	КонецЕсли;
	//
	Возврат (количествоИзменений > 0);
КонецФункции

//
Функция ОбновитьИзмененияКонтрагентов(Узел, всСсылка, идПодключения, Сообщение, Ошибка, флагВыгружатьВсе)
	количествоИзменений = 0;
	//
	метаданныеКонтрагенты = Метаданные.НайтиПоПолномуИмени("Справочник." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов());
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного, метаданныеКонтрагенты);
	Пока выборка.Следующий() Цикл
		объект = выборка.Получить();
		//
		удалитьРегИзм = Истина;
		Если ТипЗнч(объект) <> Тип("УдалениеОбъекта") Тогда
			Если НЕ объект.ЭтоГруппа Тогда
				контрагентСсылка = объект.Ссылка;
				Если контрагентСсылка.ПометкаУдаления Тогда
					массивНомеров = бит_ТелефонияСерверПереопределяемый.НайтиНомераКонтрагента(контрагентСсылка);
					Если флагВыгружатьВсе Тогда
						Сообщение = Сообщение + Символы.ПС;
					КонецЕсли;
					Сообщение = Сообщение + "Контрагент " + контрагентСсылка.Наименование + " помечен на удаление";
					удалитьРегИзм = УдалитьНомераТелефоновКонтрагента(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, массивНомеров, Сообщение, Ошибка);
				Иначе
					// проверка контрагента в базе, при необходимости создание
					удалитьРегИзм = ПроверитьНаличиеКонтрагентаВБазеДанных(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, Ошибка);
					Если удалитьРегИзм Тогда
						Если флагВыгружатьВсе Тогда
							Сообщение = Сообщение + Символы.ПС;
						КонецЕсли;
						Сообщение = Сообщение + "Контрагент " + контрагентСсылка.Наименование + " изменен";
						массивНомеров = бит_ТелефонияСерверПереопределяемый.НайтиНомераКонтрагента(контрагентСсылка);
						удалитьРегИзм = ОбновитьНомераТелефоновКонтрагента(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, массивНомеров, Сообщение, Ошибка);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		//
		Если удалитьРегИзм Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Узел, объект);
		КонецЕсли;
		//
		количествоИзменений = количествоИзменений + 1;
		//
		Если Не флагВыгружатьВсе Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//
	Если количествоИзменений = 0 И флагВыгружатьВсе Тогда
		Сообщение = Сообщение + Символы.ПС + "Изменений контрагентов нет";
	КонецЕсли;
	//
	Возврат (количествоИзменений > 0);
КонецФункции

//
Функция ОбновитьИзмененияКонтактныхЛиц(Узел, всСсылка, идПодключения, Сообщение, Ошибка, флагВыгружатьВсе)
	количествоИзменений = 0;
	//
	метаданныеКонтактныеЛица = Метаданные.НайтиПоПолномуИмени("Справочник." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтактныхЛиц());
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного, метаданныеКонтактныеЛица);
	Пока выборка.Следующий() Цикл
		объект = выборка.Получить();
		//
		удалитьРегИзм = Истина;
		Если ТипЗнч(объект) <> Тип("УдалениеОбъекта") Тогда
			Если НЕ объект.ЭтоГруппа Тогда
				// получение контрагента по контактному лицу
				контактноеЛицоСсылка = объект.Ссылка;
				контрагентСсылка = бит_ТелефонияСерверПереопределяемый.ПолучитьКонтрагентаКонтактногоЛица(контактноеЛицоСсылка);
				Если контактноеЛицоСсылка.ПометкаУдаления Тогда
					массивНомеров = бит_ТелефонияСерверПереопределяемый.НайтиНомераКонтактногоЛица(контактноеЛицоСсылка);
					Если флагВыгружатьВсе Тогда
						Сообщение = Сообщение + Символы.ПС;
					КонецЕсли;
					Сообщение = Сообщение + "Контактное лицо " + Строка(контактноеЛицоСсылка) + " контрагента " + Строка(контрагентСсылка) + " помечено на удаление";
					удалитьРегИзм = УдалитьНомераТелефоновКонтрагента(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, массивНомеров, Сообщение, Ошибка);
				Иначе
					// проверка контрагента в базе, при необходимости создание
					удалитьРегИзм = ПроверитьНаличиеКонтрагентаВБазеДанных(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, Ошибка);
					Если удалитьРегИзм Тогда
						Если флагВыгружатьВсе Тогда
							Сообщение = Сообщение + Символы.ПС;
						КонецЕсли;
						Сообщение = Сообщение + "Контактное лицо " + Строка(контактноеЛицоСсылка) + " контрагента " + Строка(контрагентСсылка) + " изменено";
						массивНомеров = бит_ТелефонияСерверПереопределяемый.НайтиНомераКонтактногоЛица(контактноеЛицоСсылка);
						удалитьРегИзм = ОбновитьНомераТелефоновКонтрагента(всСсылка, идПодключения, Узел.ИдентификаторБазы, контрагентСсылка, массивНомеров, Сообщение, Ошибка);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		//
		Если удалитьРегИзм Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Узел, объект);
		КонецЕсли;
		//
		количествоИзменений = количествоИзменений + 1;
		//
		Если Не флагВыгружатьВсе Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//
	Если количествоИзменений = 0 И флагВыгружатьВсе Тогда
		Сообщение = Сообщение + Символы.ПС + "Изменений контактных лиц нет";
	КонецЕсли;
	//
	Возврат (количествоИзменений > 0);
КонецФункции

//
Функция ОбновитьИзмененияКонтактнойИнформацииУТ10(Узел, всСсылка, идПодключения, Сообщение, Ошибка, флагВыгружатьВсе)
	количествоИзменений = 0;
	//
	выборка = ПланыОбмена.ВыбратьИзменения(Узел, Узел.НомерОтправленного, Метаданные.РегистрыСведений["КонтактнаяИнформация"]);
	Пока выборка.Следующий() Цикл
		наборЗаписейРС = выборка.Получить();
		удалитьРегИзм = Истина;
		Для Каждого записьРС Из наборЗаписейРС Цикл
			Если записьРС.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
				стрНомерКонтрагента = "";
				контрагентСсылка = Неопределено;
				Если ТипЗнч(записьРС.Объект) = Тип("СправочникСсылка." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов()) Тогда
					контрагентСсылка = записьРС.Объект;
					Если НЕ контрагентСсылка.ПометкаУдаления Тогда
						стрНомерКонтрагента = записьРС.Представление;
					КонецЕсли;
				ИначеЕсли ТипЗнч(записьРС.Объект) = Тип("СправочникСсылка." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтактныхЛиц()) Тогда
					контактноеЛицоСсылка = записьРС.Объект;
					контрагентСсылка = бит_ТелефонияСерверПереопределяемый.ПолучитьКонтрагентаКонтактногоЛица(контактноеЛицоСсылка);
					Если НЕ контактноеЛицоСсылка.ПометкаУдаления Тогда
						стрНомерКонтрагента = записьРС.Представление;
					КонецЕсли;
				КонецЕсли;
				Если (контрагентСсылка <> Неопределено) И ЗначениеЗаполнено(стрНомерКонтрагента) Тогда
					удалитьРегИзм = ПроверитьНаличиеНомераТелефонаВБазеДанных(всСсылка, идПодключения, Узел.ИдентификаторБазы, стрНомерКонтрагента, контрагентСсылка,
										Сообщение, Ошибка);
					Если НЕ удалитьРегИзм Тогда
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		//
		Если удалитьРегИзм Тогда
			ПланыОбмена.УдалитьРегистрациюИзменений(Узел, наборЗаписейРС);
		КонецЕсли;
		//
		количествоИзменений = количествоИзменений + 1;
		//
		Если Не флагВыгружатьВсе Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//
	Если количествоИзменений = 0 И флагВыгружатьВсе Тогда
		Сообщение = Сообщение + Символы.ПС + "Изменений номеров телефонов контактной информации нет";
	КонецЕсли;
	//
	Возврат (количествоИзменений > 0);
КонецФункции

//
Функция ОчиститьНедопустимыеСимволыSQLЗапроса(стрНаименование)
	стрОчищНаименование = СтрЗаменить(стрНаименование, "'", "");
	Возврат стрОчищНаименование;
КонецФункции

#КонецОбласти
