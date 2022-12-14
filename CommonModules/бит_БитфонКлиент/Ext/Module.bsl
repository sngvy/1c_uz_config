///////////////////////////////////////////////////////////////////////////////
// Общий клиентский модуль БИТ.Phone
// Содержит функции, не зависящие от конфигурации.
///////////////////////////////////////////////////////////////////////////////

// Формирует полный номер телефона с префиксами выхода в город и на междугороднюю линию.
// Из номера удаляются лишние символы.
// Если номер уже с префиксами, то сначала префиксы удаляются.
//
// Параметры:
//  стрНомерИсх - Строка - номер телефона.
//
// Возвращаемое значение:
//   Строка - сформированный полный номер с префиксами, очищенный от лишних символов.
//
Функция СформироватьНомерСПрефиксами(стрНомерИсх) ЭКСПОРТ
	флагПрямойНабор		= бит_БитфонСервер.ПолучитьФлагИспользоватьПрямойНабор();
	стрПрефиксВнешЛинии	= бит_БитфонСервер.ПолучитьПрефиксВыходаНаВнешнююЛинию();
	Возврат бит_ТелефонияКлиент.СформироватьНомерСПрефиксами(стрНомерИсх, флагПрямойНабор, стрПрефиксВнешЛинии);
КонецФункции

// Возвращает имя файла для записи разговора.
// Имя файла формируется на основе текущей даты.
// Если такой файл уже существует, он удаляется.
//
// Возвращаемое значение:
//   Строка - полное имя файла (с путем).
//
Функция ПолучитьИмяФайлаДляЗаписи() ЭКСПОРТ
	стрКаталогЗаписей = бит_БитфонСервер.ПолучитьДиректориюЗаписанныхФайлов();
	Если ЗначениеЗаполнено(стрКаталогЗаписей) Тогда
		форматФайлаЗаписи = бит_БитфонСервер.ПолучитьФорматЗаписи();
		Если форматФайлаЗаписи = ПредопределенноеЗначение("Перечисление.бит_ФорматЗаписи.gsm") Тогда
			стрРасширениеФайлаЗаписи = "wav";
		Иначе
			стрРасширениеФайлаЗаписи = Строка(форматФайлаЗаписи);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(стрРасширениеФайлаЗаписи) Тогда
			стрРасширениеФайлаЗаписи = "wav";
		КонецЕсли;
		стрИмяФайла = стрКаталогЗаписей + "\" + бит_ТелефонияКлиент.ПолучитьИмяФайлаЗаписиСДатой(ТекущаяДата()) + "." + стрРасширениеФайлаЗаписи;
		файлЗаписи = Новый Файл(стрИмяФайла);
		Если файлЗаписи.Существует() Тогда
			УдалитьФайлы(стрИмяФайла);
		КонецЕсли;
		Возврат стрИмяФайла;
	Иначе
		бит_ТелефонияКлиент.ВывестиСообщение("Не найдено значение директории для записанных файлов в настройках");
		Возврат "";
	КонецЕсли;
КонецФункции

// Открывает форму настроек для текущего пользователя.
//
// Параметры:
//   стрСписокУстройствВыводаЗвука - строка, входящий параметр, список устройств вывода звука на компьютере,
//                                   разделители списка - точка с запятой,
//                                   элемент списка имеет вид Устройство:Драйвер.
//
Процедура ОткрытьФормуНастроек(стрСписокУстройствВыводаЗвука) ЭКСПОРТ
	СтарыеНастройки = Новый Структура();
	СтарыеНастройки.Вставить("СобственныйНомер",		бит_БитфонСервер.ПолучитьСвойНомер());
	СтарыеНастройки.Вставить("ГлубинаИсторииЗвонков",	бит_БитфонСервер.ПолучитьГлубинуИсторииЗвонков());
	СтарыеНастройки.Вставить("УровеньЛоггирования",		бит_БитфонСервер.ПолучитьУровеньЛоггирования());
	СтарыеНастройки.Вставить("ПолучениеСтатусов",		бит_БитфонСервер.ПолучитьФлагПолучениеСтатусовАбонентов());
	СтарыеНастройки.Вставить("РежимНесколькихВход",		бит_БитфонСервер.ПолучитьФлагПриниматьНесколькоВходящих());
	СтарыеНастройки.Вставить("РазворачПриВхЗвонке",		бит_БитфонСервер.ПолучитьФлагРазворачиватьОкноПриВходящемЗвонке());
	СтарыеНастройки.Вставить("УстройствоЗвукаВхЗвонка",	бит_БитфонСервер.ПолучитьУстройствоВыводаЗвукаВходящегоЗвонка());
	//
	ПараметрыФормыНастроек = бит_БитфонСервер.ПолучитьПараметрыОткрытияФормыНастроек();
	ПараметрыФормыНастроек.Вставить("СписокУстройствВывода", стрСписокУстройствВыводаЗвука);
	фрмНастройки = ПолучитьФорму("РегистрСведений.бит_БитфонНастройки.Форма.ФормаЗаписиБезПользователя", ПараметрыФормыНастроек);
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(фрмНастройки, "БитФон_ОбновлениеНастроек", СтарыеНастройки);
КонецПроцедуры

Функция ПолучитьИмяФормыБитфона()
	Возврат "Обработка.бит_Битфон.Форма";
КонецФункции

// Воспроизводит запись разговора.
// Если путь к записи - интернет-ссылка, ссылка открывается в браузере по умолчанию.
// Если путь к записи - путь к файлу:
//   - Запись воспроизводится системным проигрывателем по умолчанию, если не используется стационарный телефон.
//   - Если включен режим использования стационарного телефона, запись воспроизводится на стационарном телефоне.
//
// Параметры:
//  стрПутьКЗаписи - Строка - полное имя файла или ссылка на запись разговора.
//
Процедура ВоспроизвестиЗаписьРазговора(стрПутьКЗаписи) ЭКСПОРТ
	
	Если НЕ ЗначениеЗаполнено(стрПутьКЗаписи) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Запись не найдена");
		Возврат;
	КонецЕсли;
	
	стрПутьКЗаписиНижРег = НРег(стрПутьКЗаписи);
	
	Если Найти(стрПутьКЗаписиНижРег, "http://") = 0 Тогда
		Если бит_БитфонСервер.ПолучитьФлагИспользоватьСтационарныйТелефон() Тогда
			бит_ТелефонияКлиент.ОткрытьФормуВыполнитьДействие(ПолучитьИмяФормыБитфона(), "БитФон_ВоспроизвестиЗаписьНаСтационарномТелефоне", стрПутьКЗаписи);
		Иначе
			бит_ТелефонияКлиентПереопределяемый.ЗапускПрограммы(стрПутьКЗаписи);
		КонецЕсли;
	Иначе
		бит_ТелефонияКлиентПереопределяемый.ЗапускПрограммы(стрПутьКЗаписи);
	КонецЕсли;
	
КонецПроцедуры

// Открывает основную форму и начинает исходящий вызов на заданный номер.
//
// Параметры:
//  Контакт - Сссылка на контрагента, или ссылка на контактное лицо, или строка с номером.
//
Процедура ОткрытьБитфонНачатьРазговор(Контакт) ЭКСПОРТ
	бит_ТелефонияКлиентПереопределяемый.ВыбратьНомерКонтактаИОповестить(Контакт, ПолучитьИмяФормыБитфона(), "БитФон_НачатьРазговор");
КонецПроцедуры

// Открывает основную форму и показывает окно отправки SMS.
//
// Параметры:
//  Контакт - Сссылка на контрагента, или ссылка на контактное лицо, или строка с номером.
//
Процедура ОткрытьБитфонОтправитьSMS(Контакт) ЭКСПОРТ
	бит_ТелефонияКлиентПереопределяемый.ВыбратьНомерКонтактаИОповестить(Контакт, ПолучитьИмяФормыБитфона(), "БитФон_ОтправитьSMS");
КонецПроцедуры

// Отправляет по электронной почте письмо в техподдержку.
// В приложении к письму добавляется архив с лог-файлами.
//
Процедура ОтправитьЗапросВТехподдержкуСАрхивомЛога() ЭКСПОРТ
	фрмОтправкаЗапроса = ПолучитьФорму("Обработка.бит_Битфон.Форма.ОтправкаЗапросаВТехподдержку");
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(фрмОтправкаЗапроса);
КонецПроцедуры

//
// Работа с ВК софтфона
//

// Подключает внешнюю компоненту софтфона.
// При необходимости компонента устанавливается.
//
Процедура ПодключитьСофтфон(ИмяОповещения, ПараметрОповещения=Неопределено) ЭКСПОРТ
#Если ВебКлиент Тогда
	бит_ТелефонияКлиент.ВывестиСообщение("Работа софтфона в режиме веб-клиента не поддерживается");
	Возврат;
#КонецЕсли
	Попытка
		стрИмяФайлаВК = ? ( бит_ТелефонияКлиент.Клиент64бит(), "NativeSoftPhone64.dll", "NativeSoftPhone.dll");
		бит_ТелефонияКлиентПереопределяемый.ПодключениеВнешнейКомпоненты(
								"ОбщийМакет.бит_Софтфон",
								стрИмяФайлаВК,
								"бит_БитфонСервер",
								"SoftPhoneNative",
								"БИТ.Phone",
								ИмяОповещения,
								ПараметрОповещения);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

// Начальная инициализация объекта софтфона и регистрация на АТС.
//
// Параметры:
//  Софтфон - ссылка на объект софтфона.
//
Процедура ИнициализироватьСофтфонРегистрацияНаАТС(Софтфон) ЭКСПОРТ
	
	Если Софтфон = Неопределено Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не создан объект Софтфона.");
		Возврат;
	КонецЕсли;
	
	ПараметрыСоединения = бит_БитфонСервер.ПолучитьПараметрыСоединения();
	
	стрСерверЛицензийАдрес		= бит_БитфонСервер.ПолучитьАдресСервераЛицензий();
	серверЛицензийПорт			= бит_БитфонСервер.ПолучитьПортСервераЛицензий();
	серверЛицензийНеИспПрокси	= бит_БитфонСервер.ПолучитьФлагСервераЛицензийНеИспользоватьПрокси();
	уровеньЛоггирования			= бит_БитфонСервер.ПолучитьУровеньЛоггирования();
	
	Попытка
		ИнициализацияУспешна = Софтфон.Init(уровеньЛоггирования, ПараметрыСоединения.Логин, ПараметрыСоединения.RTPПорт,
										ПараметрыСоединения.ДетекторАктивностиМикрофона,
										стрСерверЛицензийАдрес, серверЛицензийПорт, серверЛицензийНеИспПрокси);
		Если НЕ ИнициализацияУспешна Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось инициализировать Софтфон.");
			Возврат;
		КонецЕсли;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось инициализировать Софтфон. Исключение: " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Попытка
		списокКодеков = бит_БитфонСервер.ПолучитьСписокКодеков();
		Если НЕ ЗначениеЗаполнено(списокКодеков) Тогда
			списокКодеков = Софтфон.GetCodecs();
			
			// UISCOM
			Если бит_БитфонСервер.ПолучитьПрофильНастроек() = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") Тогда
				списокКодеков = УстановкаПриоритетаКодекаPCMA(списокКодеков, 131);
			КонецЕсли;
			
			бит_БитфонСервер.УстановитьСписокКодеков(списокКодеков);
		КонецЕсли;
		
		массКодеков = РазобратьСписокКодеков(списокКодеков);
		Для Каждого кодекПриор Из массКодеков Цикл
			Софтфон.SetCodecPriority(кодекПриор.Кодек, кодекПриор.Приоритет);
		КонецЦикла;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить список кодеков. Исключение: " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	многоканальныйРежим = бит_БитфонСервер.ПолучитьФлагПриниматьНесколькоВходящих();
	Попытка
		Софтфон.SetMultichannelMode(многоканальныйРежим);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить режим многоканальности. Исключение: " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	разворачиватьПриВходящемЗвонке = бит_БитфонСервер.ПолучитьФлагРазворачиватьОкноПриВходящемЗвонке();
	Попытка
		Софтфон.SetActivateOnIncomingCall(разворачиватьПриВходящемЗвонке);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить флаг разворачивания окна при входящем звонке. Исключение: " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	устройствоВыводаЗвукаВходящегоЗвонка = бит_БитфонСервер.ПолучитьУстройствоВыводаЗвукаВходящегоЗвонка();
	Если ЗначениеЗаполнено(устройствоВыводаЗвукаВходящегоЗвонка) Тогда
		Попытка
			Софтфон.SetRingPlaybackDevice(устройствоВыводаЗвукаВходящегоЗвонка);
		Исключение
			бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось задать устройство вывода звука " +
				устройствоВыводаЗвукаВходящегоЗвонка + " для входящего звонка. Исключение: " + ОписаниеОшибки());
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если ПустаяСтрока(ПараметрыСоединения.Логин) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Получить параметры соединения не удалось");
		Возврат;
	КонецЕсли;
	
	СвойНомер = бит_БитфонСервер.ПолучитьСвойНомер();
	Если ПустаяСтрока(СвойНомер) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не задан свой номер в настройках");
		Возврат;
	КонецЕсли;
	
	Попытка
		СофтФон.Register(ПараметрыСоединения.Логин, ПараметрыСоединения.АдресСервера, ПараметрыСоединения.АдресПрокси,
			ПараметрыСоединения.CallerID, ПараметрыСоединения.IDАвторизации, ПараметрыСоединения.Пароль,
			Строка(ПараметрыСоединения.Протокол), ПараметрыСоединения.ИнтервалПеререгистрации, ПараметрыСоединения.АвтоопределениеNAT);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось зарегистрироваться на АТС. " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;

КонецПроцедуры

// Обработчик изменения профиля настроек.
//
// Параметры:
//  Запись - ссылка запись регистра сведений настроек.
//  флагВыводитьСообщения - Булево, Истина для вывода сообщений при изменении настроек.
//
Процедура ОбработчикИзмененияПрофиляНастроек(Запись, флагВыводитьСообщения) ЭКСПОРТ
	
	стрАдресСервераПоУмолчаниюМанго = "mangosip.ru";
	стрАдресСервераПоУмолчаниюUISCOM = "voip.uiscom.ru:9060";
	стрАдресСервераПоУмолчаниюСкорозвон = "31.186.102.42";
	
	соотвСписокСерверов = Новый Соответствие();
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюМанго, "");
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюUISCOM, "");
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюСкорозвон, "");
	
	ключСервер = соотвСписокСерверов.Получить(Запись.АдресСервера);
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Манго") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюМанго;
		КонецЕсли;
	КонецЕсли;
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюUISCOM;
		КонецЕсли;
		
		Запись.RTPПорт = 10000;
		Запись.СписокКодеков = УстановкаПриоритетаКодекаPCMA(Запись.СписокКодеков, 131);
	Иначе
		Запись.RTPПорт						= бит_БитфонСервер.ПолучитьRTPПортПоУмолчанию();
		Запись.СписокКодеков				= УстановкаПриоритетаКодекаPCMA(Запись.СписокКодеков, 128);
	КонецЕсли;
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Скорозвон") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюСкорозвон;
		КонецЕсли;
		
		Запись.АвтоопределениеNAT	= Ложь;
		Запись.АдресПрокси = "31.186.102.42:5020";
	Иначе
		Запись.АвтоопределениеNAT	= бит_БитфонСервер.ПолучитьФлагАвтоопределениеNATПоУмолчанию();
		Запись.АдресПрокси = "";
	КонецЕсли;
	
	// общие параметры для нескольких профилей
	Запись.ПрефиксВыходаНаВнешнююЛинию = ПолучитьПрефиксВыходаНаВнешнююЛиниюПрофиля(Запись.ПрофильНастроек);
	
	// настройки для БИТ.АТС
	Если (Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.БИТ_АТС"))
		ИЛИ (Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Произвольные"))
	Тогда
		Если ключСервер <> Неопределено Тогда
			Запись.АдресСервера = "";
		КонецЕсли;
	Иначе
		Если Запись.ТипПереводаЗвонка = ПредопределенноеЗначение("Перечисление.бит_ТипПереводаЗвонка.Условный") Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Условный тип перевода недоступен при использовании АТС '" + Строка(Запись.ПрофильНастроек) + "', изменен на безусловный");
			КонецЕсли;
			Запись.ТипПереводаЗвонка = ПредопределенноеЗначение("Перечисление.бит_ТипПереводаЗвонка.Безусловный");
		КонецЕсли;
		//
		Если Запись.ИспользоватьКомандуНеБеспокоитьНаАТС Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Команда 'Не беспокоить' на АТС недоступна при использовании АТС '" + Строка(Запись.ПрофильНастроек) + "', отключена");
			КонецЕсли;
			Запись.ИспользоватьКомандуНеБеспокоитьНаАТС = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Разбор строки со списком кодеков.
//
// Параметры:
//  стрСписокКодеков - Строка, список кодеков в формате 'кодек1=приоритет1;кодек1=приоритет2;...'.
//
// Возвращаемое значение:
//  массив структур с полями
//    Кодек - Строка,
//    Приоритет - Число.
//
Функция РазобратьСписокКодеков(стрСписокКодеков) ЭКСПОРТ
	массКодеки = Новый Массив;
	
	списокСПриоритетом = бит_ТелефонияКлиентСервер.СтрРазбить(стрСписокКодеков, ";");
	Для Каждого кодекПриорЭл Из списокСПриоритетом Цикл
		стрКодекПриор = кодекПриорЭл.Значение;
		индекс = Найти(стрКодекПриор, "=");
		Если индекс > 0 Тогда
			стрКодек = Лев(стрКодекПриор, индекс-1);
			стрПриор = Сред(стрКодекПриор, индекс+1);
			приор = Число(стрПриор);
			структКодекПриор = Новый Структура();
			структКодекПриор.Вставить("Кодек", стрКодек);
			структКодекПриор.Вставить("Приоритет", приор);
			массКодеки.Добавить(структКодекПриор);
		КонецЕсли;
	КонецЦикла;
	
	Возврат массКодеки;
КонецФункции

Функция УстановкаПриоритетаКодекаPCMA(стрСписокКодеков, приоритет)
	массКодеков = РазобратьСписокКодеков(стрСписокКодеков);
	Для Каждого кодекПриор Из массКодеков Цикл
		Если Найти(кодекПриор.Кодек, "PCMA") > 0 Тогда
			кодекПриор.Приоритет = приоритет;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	стрСписокКодеков = "";
	Для Каждого кодекПриор Из массКодеков Цикл
		стрКодек = кодекПриор.Кодек;
		стрПриор = Строка(кодекПриор.Приоритет);
		стрСписокКодеков = стрСписокКодеков + стрКодек + "=" + стрПриор + ";";
	КонецЦикла;
	Возврат стрСписокКодеков;
КонецФункции

Функция ПолучитьПрефиксВыходаНаВнешнююЛиниюПрофиля(профильНастроек)
	стрПрефикс = "";
	Если профильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") ИЛИ
		профильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Скорозвон")
	Тогда
		стрПрефикс = "";
	Иначе
		стрПрефикс = бит_ТелефонияСервер.ПолучитьПрефиксВыходаНаВнешнююЛиниюПоУмолчанию();	
	КонецЕсли;
	Возврат стрПрефикс;
КонецФункции
