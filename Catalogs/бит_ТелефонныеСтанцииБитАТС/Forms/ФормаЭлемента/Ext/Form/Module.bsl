
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		бит_ТелефонияКлиент.УстановитьЭлементОтбораДинамическогоСписка(Номера, "Владелец", Объект.Ссылка);
	Иначе
		бит_ТелефонияКлиент.УстановитьЭлементОтбораДинамическогоСписка(Номера, "Владелец", ПредопределенноеЗначение("Справочник.бит_ТелефонныеСтанцииБитАТС.ПустаяСсылка"));
		Элементы.ГруппаНомераАТС.Доступность = Ложь;
	КонецЕсли;
	
	// загрузка данных из старой версии
	Если Объект.УдалитьНомера.Количество() > 0 Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Перенос номеров из старой версии панели телефонии...", ЭтаФорма);
		Для Каждого строкаТаблНомеров Из Объект.УдалитьНомера Цикл
			СоздатьЭлементАТССервер(Объект.Ссылка,
				ПредопределенноеЗначение("Справочник.бит_НомераБитАТС.ПустаяСсылка"),
				строкаТаблНомеров.Номер,
				строкаТаблНомеров.Наименование,
				Ложь);
		КонецЦикла;
		бит_ТелефонияКлиент.ВывестиСообщение("Перенесено записей: " + Строка(Объект.УдалитьНомера.Количество()), ЭтаФорма);
		ОчиститьСтаруюТЧНомеровСервер();
		Прочитать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОчиститьСтаруюТЧНомеровСервер()
	об = Объект.Ссылка.ПолучитьОбъект();
	об.Заблокировать();
	об.УдалитьНомера.Очистить();
	об.Записать();
КонецПроцедуры
	
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		бит_ТелефонияКлиент.УстановитьЭлементОтбораДинамическогоСписка(Номера, "Владелец", Объект.Ссылка);
		Элементы.ГруппаНомераАТС.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПроверитьНаличиеНомеровАТССервер(ссылкаАТС)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НомераБитАТС.Ссылка
	               |ИЗ
	               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	               |ГДЕ
	               |	бит_НомераБитАТС.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
	Возврат НЕ Запрос.Выполнить().Пустой();
КонецФункции

&НаКлиенте
Процедура ПоказатьВопросПерезаписиНомеров(ИмяОповещения, ПараметрОповещения)
	бит_ТелефонияКлиентПереопределяемый.ПоказВопрос("Существующие записи в справочнике будут заменены при совпадении номеров. Продолжить?",
						РежимДиалогаВопрос.ДаНет, , , , ИмяОповещения, ПараметрОповещения);
КонецПроцедуры

// Возвращает ссылку на найденный элемент.
// Группа ищется по наименованию, элемент по номеру телефона.
&НаСервере
Функция ПроверитьНаличиеЭлементаНомеровАТССервер(ссылкаАТС, родительСсылка, стрПараметр, флагГруппа)
	Запрос = Новый Запрос;
	Если флагГруппа Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_НомераБитАТС.Ссылка
		               |ИЗ
		               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
		               |ГДЕ
		               |	бит_НомераБитАТС.Владелец = &Владелец
		               |	И бит_НомераБитАТС.Родитель = &Родитель
		               |	И бит_НомераБитАТС.ЭтоГруппа = ИСТИНА
		               |	И бит_НомераБитАТС.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
		Запрос.УстановитьПараметр("Родитель", родительСсылка);
		Запрос.УстановитьПараметр("Наименование", стрПараметр);
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_НомераБитАТС.Ссылка
		               |ИЗ
		               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
		               |ГДЕ
		               |	бит_НомераБитАТС.Владелец = &Владелец
		               |	И бит_НомераБитАТС.Родитель = &Родитель
		               |	И бит_НомераБитАТС.ЭтоГруппа = ЛОЖЬ
		               |	И бит_НомераБитАТС.Номер = &Номер";
		Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
		Запрос.УстановитьПараметр("Родитель", родительСсылка);
		Запрос.УстановитьПараметр("Номер", стрПараметр);
	КонецЕсли;
	табл = Запрос.Выполнить().Выгрузить();
	ссылкаНайден = Справочники.бит_НомераБитАТС.ПустаяСсылка();
	Если табл.Количество() > 0 Тогда
		ссылкаНайден = табл[0].Ссылка;
	КонецЕсли;
	Возврат ссылкаНайден;
КонецФункции

&НаСервере
Процедура ИзменитьЭлементАТССервер(ссылкаНомер, стрНомер, стрНаименование)
	обНомер = ссылкаНомер.ПолучитьОбъект();
	обНомер.Наименование = стрНаименование;
	Если НЕ ссылкаНомер.ЭтоГруппа Тогда
		обНомер.Номер = стрНомер;
	КонецЕсли;
	обНомер.Записать();
КонецПроцедуры

&НаСервере
Функция СоздатьЭлементАТССервер(ссылкаАТС, родительСсылка, стрНомер, стрНаименование, флагГруппа)
	ссылкаЭл = Неопределено;
	Если флагГруппа Тогда
		обГруппа = Справочники.бит_НомераБитАТС.СоздатьГруппу();
		обГруппа.Наименование	= стрНаименование;
		обГруппа.Владелец		= ссылкаАТС;
		обГруппа.Родитель		= родительСсылка;
		обГруппа.Записать();
		ссылкаЭл = обГруппа.Ссылка;
	Иначе
		обНомер = Справочники.бит_НомераБитАТС.СоздатьЭлемент();
		обНомер.Наименование	= стрНаименование;
		обНомер.Номер			= стрНомер;
		обНомер.Владелец		= ссылкаАТС;
		обНомер.Родитель		= родительСсылка;
		обНомер.Записать();
		ссылкаЭл = обНомер.Ссылка;
	КонецЕсли;
	Возврат ссылкаЭл;
КонецФункции

&НаСервере
Процедура ЗагрузитьГруппуНомеровИзСоотв(СоотвНаборНомеров, РодительСсылка, загружено)
	Для Каждого соотвНомер Из СоотвНаборНомеров Цикл
		ключНомер	= соотвНомер.Ключ;
		поляОбНомер	= соотвНомер.Значение;
		полеИмя		= поляОбНомер["name"];
		полеНомер	= поляОбНомер["number"];
		полеДочерние= поляОбНомер.Получить("members");
		//
		Если полеНомер = Неопределено Тогда
			полеНомер = "";
		КонецЕсли;
		//
		Если полеДочерние = Неопределено Тогда
			номерСсылка = ПроверитьНаличиеЭлементаНомеровАТССервер(Объект.Ссылка, РодительСсылка, полеНомер, Ложь);
			Если номерСсылка = ПредопределенноеЗначение("Справочник.бит_НомераБитАТС.ПустаяСсылка") Тогда
				СоздатьЭлементАТССервер(Объект.Ссылка, РодительСсылка, полеНомер, полеИмя, Ложь);
			Иначе
				ИзменитьЭлементАТССервер(номерСсылка, полеНомер, полеИмя);
			КонецЕсли;
			загружено = загружено + 1;
		Иначе
			// группа
			группаСсылка = ПроверитьНаличиеЭлементаНомеровАТССервер(Объект.Ссылка, РодительСсылка, полеИмя, Истина);
			Если группаСсылка = ПредопределенноеЗначение("Справочник.бит_НомераБитАТС.ПустаяСсылка") Тогда
				группаСсылка = СоздатьЭлементАТССервер(Объект.Ссылка, РодительСсылка, "", полеИмя, Истина);
			Иначе
				ИзменитьЭлементАТССервер(группаСсылка, "", полеИмя);
			КонецЕсли;
			загружено = загружено + 1;
			ЗагрузитьГруппуНомеровИзСоотв(полеДочерние, группаСсылка, загружено);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНомераИзJsonСервер(стрJSON, загружено)
	наборНомеров = бит_ТелефонияКлиентСервер.ЗаполнитьСоответствиеИзJSON(стрJSON);
	ЗагрузитьГруппуНомеровИзСоотв(наборНомеров, Справочники.бит_НомераБитАТС.ПустаяСсылка(), загружено);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИнформациюСАТС(Знач стрАдресАТС, Знач стрПользовательАТС, Знач стрПарольАТС, Знач стрТипИнформ)
	
	Если НЕ ЗначениеЗаполнено(стрАдресАТС) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Не задан адрес", ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	ПараметрыПодключенияВК = Новый Структура();
	ПараметрыПодключенияВК.Вставить("АдресАТС", стрАдресАТС);
	ПараметрыПодключенияВК.Вставить("ПользовательАТС", стрПользовательАТС);
	ПараметрыПодключенияВК.Вставить("ПарольАТС", стрПарольАТС);
	ПараметрыПодключенияВК.Вставить("ТипИнформации", стрТипИнформ);
	бит_АТСКлиент.ПодключениеКомпонентыУправлениеАТС("БитАТС_ТелефонныеСтанции_ПодключениеВК", ПараметрыПодключенияВК);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИнформациюСАТСЗавершение(обКонтроллерАТС, стрАдресАТС, стрПользовательАТС, стрПарольАТС, стрТипИнформ)
	
	стрJSON = "";
	
	ошибка = Ложь;
	Попытка
		стрJSON = обКонтроллерАТС.GetPBXInfoJSON(стрАдресАТС, стрПользовательАТС, стрПарольАТС, стрТипИнформ);
		обКонтроллерАТС = Неопределено;
		ошибка = Ложь;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение( ОписаниеОшибки(), ЭтаФорма );
		ошибка = Истина;
	КонецПопытки;
	
	//
	
	Если стрТипИнформ = "users" Тогда
		
		загружено_элементов = 0;
		Если ошибка Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("Ошибка загрузки номеров с АТС " + Объект.Адрес, ЭтаФорма);
		Иначе
			ЗагрузитьНомераИзJsonСервер(стрJSON, загружено_элементов);
		КонецЕсли;
		Элементы.Номера.Обновить();
		бит_ТелефонияКлиент.ВывестиСообщение("Загружено записей: " + Строка(загружено_элементов), ЭтаФорма);
		
	ИначеЕсли стрТипИнформ = "trunks" Тогда
		
		Если ошибка Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("Ошибка загрузки транков с адреса '" + Объект.Адрес + "'", ЭтаФорма);
		Иначе
			наборТранков = бит_ТелефонияКлиентСервер.ЗаполнитьСоответствиеИзJSON(стрJSON);
			Для Каждого соотвТранк Из наборТранков Цикл
				ключТранк	= соотвТранк.Ключ;
				поляОбТранк	= соотвТранк.Значение;
				полеИмя		= поляОбТранк["name"];
				полеПир		= поляОбТранк["peer"];
				бит_ТелефонияКлиент.ВывестиСообщение(полеИмя + ": " + полеПир, ЭтаФорма);
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли стрТипИнформ = "" Тогда	// просто проверка подключения
		Если ошибка Тогда
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Ошибка подключения к АТС.");
		Иначе
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Соединение успешно.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераСАТС(Команда)
	
	Если ( ПроверитьНаличиеНомеровАТССервер(Объект.Ссылка) ) Тогда
		ПоказатьВопросПерезаписиНомеров("БитАТС_ТелефонныеСтанции_ЗагрузитьНомераСАТС", "");
	Иначе
		ЗагрузитьНомераСАТСЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераСАТСЗавершение()
	
	ЗагрузитьИнформациюСАТС(Объект.Адрес,
		Объект.Пользователь,
		Объект.Пароль,
		"users");
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераИзАналитикиАТС(Команда)
	АдресЗагрузки = "https://<AnalyticsHost>/ip_zup/hs/CallsData/ExportEmployeesCOToJson";
	бит_ТелефонияКлиентПереопределяемый.ПоказВводСтроки(АдресЗагрузки, "Адрес загрузки", "БитАТС_ТелефонныеСтанции_ВвестиАдресСервера");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераССервераПослеВводаАдреса(АдресЗагрузки)
	
	Если НЕ ЗначениеЗаполнено(АдресЗагрузки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ( ПроверитьНаличиеНомеровАТССервер(Объект.Ссылка) ) Тогда
		ПоказатьВопросПерезаписиНомеров("БитАТС_ТелефонныеСтанции_ЗагрузитьНомераССервера", АдресЗагрузки);
	Иначе
		ЗагрузитьНомераССервераЗавершение(АдресЗагрузки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераССервераЗавершение(АдресЗагрузки)
	
	загружено_элементов = 0;
	стрJSON = "";
	загружено = бит_ТелефонияКлиент.СкачатьПоHTTPS(АдресЗагрузки, 120, Истина, стрJSON);
	
	Если загружено Тогда
		ЗагрузитьНомераИзJsonСервер(стрJSON, загружено_элементов);
	Иначе
		бит_ТелефонияКлиент.ВывестиСообщение("Ошибка загрузки номеров с адреса " + АдресЗагрузки, ЭтаФорма);
	КонецЕсли;
	
	Элементы.Номера.Обновить();
	
	бит_ТелефонияКлиент.ВывестиСообщение("Загружено записей: " + Строка(загружено_элементов), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ЗагрузитьИнформациюСАТС(Элементы.Адрес.ТекстРедактирования,
		Элементы.Пользователь.ТекстРедактирования,
		Элементы.Пароль.ТекстРедактирования,
		"");
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьТранкиАТС(Команда)
	
	ЗагрузитьИнформациюСАТС(Объект.Адрес,
		Объект.Пользователь,
		Объект.Пароль,
		"trunks");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
&НаСервере
Функция ПроверкаНомерЭтоГруппа(НомерСсылка)
	Возврат НомерСсылка.ЭтоГруппа;
КонецФункции

&НаСервере
Функция ПолучитьНомераГруппы(ГруппаНомеровСсылка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НомераБитАТС.Ссылка
	               |ИЗ
	               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	               |ГДЕ
	               |	бит_НомераБитАТС.Родитель = &Родитель";
	Запрос.УстановитьПараметр("Родитель", ГруппаНомеровСсылка);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

&НаСервере
Процедура ЗадатьГруппуДоступаНомеров(массивНомеров, ГруппаДоступаСсылка)
	Для Каждого элНомеров Из массивНомеров Цикл
		Если ПроверкаНомерЭтоГруппа(элНомеров) Тогда
			массивНомеровГруппы = ПолучитьНомераГруппы(элНомеров);
			ЗадатьГруппуДоступаНомеров(массивНомеровГруппы, ГруппаДоступаСсылка);
		Иначе
			обНомер = элНомеров.ПолучитьОбъект();
			обНомер.ГруппаДоступа = ГруппаДоступаСсылка;
			обНомер.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗадатьГруппуДоступаВыделенныхНомеровСервер(ГруппаДоступаСсылка)
	ЗадатьГруппуДоступаНомеров(Элементы.Номера.ВыделенныеСтроки, ГруппаДоступаСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьГруппуДоступа(Команда)
	Если Элементы.Номера.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущГруппаДоступа = Неопределено;
	
	Если Элементы.Номера.ВыделенныеСтроки.Количество() = 1 Тогда
		ВыделСтрока = Элементы.Номера.ВыделенныеСтроки[0];
		Если НЕ ПроверкаНомерЭтоГруппа(ВыделСтрока) Тогда
			ТекущГруппаДоступа = ВыделСтрока.ГруппаДоступа;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормыВыбораГруппы = Новый Структура;
	ПараметрыФормыВыбораГруппы.Вставить("ТекущаяСтрока", ТекущГруппаДоступа);
	ФормаВыбораГруппыДоступа = ПолучитьФорму("Справочник.бит_ГруппыДоступаБитАТС.ФормаВыбора", ПараметрыФормыВыбораГруппы, Элементы.Номера);
	
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(ФормаВыбораГруппыДоступа);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьГруппуДоступа(Команда)
	Если Элементы.Номера.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗадатьГруппуДоступаВыделенныхНомеровСервер(ПредопределенноеЗначение("Справочник.бит_ГруппыДоступаБитАТС.ПустаяСсылка"));
	
	Элементы.Номера.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура НомераОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ЗадатьГруппуДоступаВыделенныхНомеровСервер(ВыбранноеЗначение);
		Элементы.Номера.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "БитАТС_ТелефонныеСтанции_ПодключениеВК" Тогда
		обКонтроллерАТС = Параметр.Результат;
		Если обКонтроллерАТС <> Неопределено Тогда
			допПараметры = Параметр.ПараметрОповещения;
			ЗагрузитьИнформациюСАТСЗавершение(обКонтроллерАТС,
				допПараметры.АдресАТС, допПараметры.ПользовательАТС, допПараметры.ПарольАТС,
				допПараметры.ТипИнформации);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "БитАТС_ТелефонныеСтанции_ЗагрузитьНомераСАТС" Тогда
		Если Параметр.Результат = КодВозвратаДиалога.Да Тогда
			ЗагрузитьНомераСАТСЗавершение();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "БитАТС_ТелефонныеСтанции_ВвестиАдресСервера" Тогда
		Если ЗначениеЗаполнено(Параметр.Результат) Тогда
			ЗагрузитьНомераССервераПослеВводаАдреса(Параметр.Результат);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "БитАТС_ТелефонныеСтанции_ЗагрузитьНомераССервера" Тогда
		Если Параметр.Результат = КодВозвратаДиалога.Да Тогда
			ЗагрузитьНомераССервераЗавершение(Параметр.ПараметрОповещения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
