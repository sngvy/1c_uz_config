﻿
//////////////////////////////////////////////////////////////
// ОСНОВНЫЕ МЕТОДЫ ЯДРА

&НаСервере
// Функция предназначена для подключению к серверу SMS4B. Вызывается перед первой 
// попыткой обращения к функциям сервера 
// либо после разрыва сервером SMS4B открытой ранее сессии.
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Число	- НомерСессии > 0, если функция выполнена успешно,
//				или код ошибки < 0, если функция выполнена не успешно 
//				(см описание функции ОписаниеОшибокВебСервиса ()). 
//
Функция SMS4B_Подключиться()
	// Устанавливаем GMT=0, т.к. всегда будем работать по UTC (как сервер SMS4B)
	GMT = 0;
	// Собираем информацию о конфигурации (для статистики на сервере SMS4B)
	ИмяКонфигурации 	= СтрЗаменить(Метаданные.Имя, " ", "_");
	КраткаяИнформация 	= СтрЗаменить(Метаданные.КраткаяИнформация," ","_");
	ИмяКонфигурации = ИмяКонфигурации + "(" + КраткаяИнформация + ")";
	Если СтрДлина(ИмяКонфигурации) > 425 Тогда
		ИмяКонфигурации = Лев(ИмяКонфигурации, 425);
	КонецЕсли;	
	ИнформацияОСистеме = Новый СистемнаяИнформация;
	// Дополняем имя пользователя сведениями о конфигурации
	Пользователь = " S_" + смсНомерЯдра + "_" + Метаданные.Версия + "_" + ИмяКонфигурации + "_" + ИнформацияОСистеме.ВерсияПриложения + " " + смсИмяПользователя;
	Пароль 		 = смсПарольПользователя;
	ВебСервис = SMS4B_ПодключитьВебСервис();
	Если ВебСервис = Неопределено Тогда
		SMS4B_ПоменятьСервер();
		ВебСервис = SMS4B_ПодключитьВебСервис();
		Если ВебСервис = Неопределено Тогда
			КодОшибки = -9;
			Возврат КодОшибки;
		КонецЕсли;	
	КонецЕсли; 
	// Открываем сессию для работы с веб-сервисом
	Попытка
		РезультатПодключения = ВебСервис.StartSession(Пользователь, Пароль, GMT); 
	Исключение
		РезультатПодключения = Неопределено;
	КонецПопытки;
	// Запомним код ошибки
	КодОшибки = РезультатПодключения;
	// Проверяем результат подключения первый раз
	// Если нет связи, либо ошибки от -1 до -19, то подключаемся на резервный сервер
	Если (РезультатПодключения = Неопределено) ИЛИ ((РезультатПодключения <= -1) И (РезультатПодключения >= -19)) Тогда
		// Подключаемся к резервному серверу
		SMS4B_ПоменятьСервер();
		ВебСервис = SMS4B_ПодключитьВебСервис();
		Если ВебСервис = Неопределено Тогда
			SMS4B_ПоменятьСервер();
			ВебСервис = SMS4B_ПодключитьВебСервис();
			Если ВебСервис = Неопределено Тогда
				КодОшибки = -9;
				Возврат КодОшибки;
			КонецЕсли;	
		КонецЕсли; 
		Попытка
			РезультатПодключения = ВебСервис.StartSession(Пользователь, Пароль, GMT); 
		Исключение
			РезультатПодключения = Неопределено;
		КонецПопытки;
		// Запомним код ошибки
		КодОшибки = РезультатПодключения;
	КонецЕсли;
	// Проверяем результат подключения второй раз
	Если РезультатПодключения = Неопределено Тогда
		Если КодОшибки = Неопределено Тогда
			КодОшибки = -99999; // Проблема с интернетом (сервис не ответил)
		КонецЕсли; 
	Иначе
		// Проверяем РезультатПодключения на ошибки 
		КодОшибки = РезультатПодключения;
		Если КодОшибки > 0 Тогда
			смсНомерСессии = КодОшибки;
		ИначеЕсли КодОшибки < 0 Тогда
			SMS4B_ВывестиСообщение( SMS4B_ОписаниеОшибокВебСервиса(РезультатПодключения), СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;	
	// Возвращаем результат работы функции
	Возврат КодОшибки;	
КонецФункции // SMS4B_Подключиться()

&НаСервере
// Функция предназначена для получения параметров пользователя. 
// Вызывается после подключения к серверу, и после отправки sms-сообщений,
// чтобы пользователь видел остаток sms-сообщений. 
//
// Параметры:
//	СтруктураПараметровСессии	- Структура	- Возвращаемый параметр. 
// 
// Возвращаемое значение:
//	Число	- Числовой код ошибки, 1 - если функция выполнена успешно, 
// 				и код ошибки < 0, если функция выполнена не успешно.
//
Функция SMS4B_ПолучитьПараметрыСессии(СтруктураПараметровСессии)
	КодОшибки = 1;
	// Подключаем веб-сервис
	ВебСервис = SMS4B_ПодключитьВебСервис();
	Если ВебСервис = Неопределено Тогда
		SMS4B_ПоменятьСервер();
		ВебСервис = SMS4B_ПодключитьВебСервис();
		Если ВебСервис = Неопределено Тогда
			КодОшибки = -9;
			Возврат КодОшибки;
		КонецЕсли;	
	КонецЕсли; 
	// Получаем фабрику XDTO
	Фабрика = ВебСервис.ФабрикаXDTO;		
	ТекущееВремяСеанса = SMS4B_ПолучитьТекущееВремя();
	Попытка
		// Получаем с веб-сервиса параметры сессии
		ПараметрыСессии = ВебСервис.ParamSMS(смсНомерСессии);
	Исключение
		ПараметрыСессии = Неопределено;
	КонецПопытки;
	// Проверяем результат выполнения
	Если ПараметрыСессии = Неопределено Тогда
		// Проблема с интернетом (сервис не ответил)
		КодОшибки = -99999;
	Иначе	
		// Код ошибки при неуспешном выполнении метода
		КодОшибки = Число(ПараметрыСессии.Result);
		Если (КодОшибки = -1) ИЛИ (КодОшибки = -2) Тогда
			// Если сессия устарела или её нет
			КодОшибки = SMS4B_Подключиться();
			// Если не удалось подключится
			Если КодОшибки > 0 Тогда
				// Пробуем получить ещё раз
				смсНомерСессии = КодОшибки;
				ТекущееВремяСеанса = SMS4B_ПолучитьТекущееВремя();
				Попытка
					// Получаем с веб сервиса параметры сессии
					ПараметрыСессии = ВебСервис.ParamSMS(смсНомерСессии);
				Исключение
					ПараметрыСессии = Неопределено;
				КонецПопытки;
				Если ПараметрыСессии = Неопределено Тогда
					// Проблема с интернетом (сервис не ответил)
					КодОшибки = -99999;
				Иначе	
					КодОшибки = Число(ПараметрыСессии.Result);
				КонецЕсли;							
			КонецЕсли;
		ИначеЕсли (КодОшибки > -20) И (КодОшибки < -2) Тогда
			// Возможно, что Основной сервер не доступен, пробуем переключится на резервный.
			SMS4B_ПоменятьСервер();				
			// Пробуем получить ещё раз
			ТекущееВремяСеанса = SMS4B_ПолучитьТекущееВремя();
			Попытка
				// Получаем с веб сервиса параметры сессии
				ПараметрыСессии = ВебСервис.ParamSMS(смсНомерСессии);
			Исключение
				ПараметрыСессии = Неопределено;
			КонецПопытки;
			Если ПараметрыСессии = Неопределено Тогда
				// Проблема с интернетом (сервис не ответил)
				КодОшибки = -99999;
			Иначе	
				КодОшибки = Число(ПараметрыСессии.Result);
			КонецЕсли;							
		КонецЕсли;		
		// Если ошибка, то возвращаем код ошибки
		Если КодОшибки > 0 Тогда 
			СтруктураПараметровСессии.Вставить("смсНомераОтправителя",	ПараметрыСессии.Addresses);
			СтруктураПараметровСессии.Вставить("смсОстатокСМС",			ПараметрыСессии.Rest);
			СтруктураПараметровСессии.Вставить("смсКоличествоНомеров",	ПараметрыСессии.AddrMask);
			СтрВремяСервера = Сред(ПараметрыСессии.UTC, 1, 19);
			ВремяСервера = SMS4B_СтрокаВДату(СтрЗаменить(СтрВремяСервера, "T", " "));
			СтруктураПараметровСессии.Вставить("смсКорректировкаUTC",			Окр((ТекущееВремяСеанса - ВремяСервера) / 3600) * 3600);
			СтруктураПараметровСессии.Вставить("смсМаксАктуальностьДоставки",	ПараметрыСессии.Limit);
			СтруктураПараметровСессии.Вставить("смсМаксДлительностьДоставки",	ПараметрыСессии.Duration);
		ИначеЕсли КодОшибки < 0 Тогда 	
			// Выводим текст с описанием ошибки
			SMS4B_ВывестиСообщение(SMS4B_ОписаниеОшибокВебСервиса(КодОшибки), СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;
	Возврат КодОшибки;
КонецФункции // SMS4B_ПолучитьПараметрыСессии()

&НаСервереБезКонтекста
// Функция возвращает массив доступных номеров отправителя из строки
//
// Параметры:
//	НомерОтправителя - Строка	- Строка, содержащая список номеров
//
// Возвращаемое значение:
//	Массив	- Массив номеров отправителя
//
Функция  SMS4B_ПолучитьМассивНомеровИзСтроки(НомерОтправителя) Экспорт
	// Создаем массив
	МассивВозврата = Новый Массив;
	// Берем строку с номерами
	ТекстКонстанты = СокрЛП(СтрЗаменить(НомерОтправителя, Символы.ВК, ""));
	Пока НЕ ПустаяСтрока(ТекстКонстанты) Цикл
		// Ищем позицию разделителя
		НомерРазделителя = Найти(ТекстКонстанты, Символы.ПС);
		Если НомерРазделителя = 0 Тогда // всего один номер
			МассивВозврата.Добавить(ТекстКонстанты);
			ТекстКонстанты = "";	
		Иначе // если больше одного
			// Получаем номер
			ЛевСтрокаНомера = Лев(ТекстКонстанты, НомерРазделителя - 1);
			// Добавляем в список
			МассивВозврата.Добавить(ЛевСтрокаНомера);
			Если НомерРазделителя = СтрДлина(ТекстКонстанты) Тогда
				ТекстКонстанты = "";	
			Иначе	
				ТекстКонстанты = Сред(ТекстКонстанты, НомерРазделителя + 1);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат МассивВозврата;
КонецФункции //  SMS4B_ПолучитьМассивНомеровИзСтроки()

&НаСервереБезКонтекста
// Функция получает описание ошибки по ее коду
// 
// Параметры:
//	КодОшибки	- Число	- Код ошибки
//
// Возвращаемое значение:
//	Строка	- Текст сообщения об ошибке
//
Функция SMS4B_ОписаниеОшибокВебСервиса(КодОшибки)
	Если КодОшибки = 0 Тогда
		ТекстСообщить = "ru = ""Превышен предел открытых сессий!""";
	ИначеЕсли КодОшибки = -1 Тогда
		ТекстСообщить = "ru = ""Неверный логин или пароль (Необходимо использовать пароль для доступа к SMS сервису из внешних программ)!""";
	ИначеЕсли КодОшибки = -2 Тогда
		ТекстСообщить = "ru = ""Сессия закрыта!""";
	ИначеЕсли КодОшибки = -9 Тогда
		ТекстСообщить = "ru = ""Отказ сервера!""";
	ИначеЕсли КодОшибки = -10 Тогда
		ТекстСообщить = "ru = ""Неизвестная ошибка сервера!""";
	ИначеЕсли КодОшибки = -20 Тогда
		ТекстСообщить = "ru = ""Сбой сеанса связи!""";
	ИначеЕсли КодОшибки = -21 Тогда
		ТекстСообщить = "ru = ""Сообщение не идентифицировано!""";
	ИначеЕсли КодОшибки = -22 Тогда
		ТекстСообщить = "ru = ""Неверный идентификатор сообщения!""";
	ИначеЕсли КодОшибки = -23 Тогда
		ТекстСообщить = "ru = ""Неверный параметр - GMT""";
	ИначеЕсли КодОшибки = -30 Тогда
		ТекстСообщить = "ru = ""Неизвестная кодировка сообщения! (не заполнен текст сообщения)""";
	ИначеЕсли КодОшибки = -31 Тогда
		ТекстСообщить = "ru = ""Неразрешенная зона тарификации!""";
	ИначеЕсли КодОшибки = -32 Тогда
		ТекстСообщить = "ru = ""Неверный параметр - дата начала или окончания доставки сообщения!""";
	ИначеЕсли КодОшибки = -33 Тогда
		ТекстСообщить = "ru = ""Превышение длительности доставки!""";
	ИначеЕсли КодОшибки = -34 Тогда
		ТекстСообщить = "ru = ""Превышение срока актуальности доставки!""";
	ИначеЕсли КодОшибки = -35 Тогда
		ТекстСообщить = "ru = ""Неверный параметр - период доставки сообщения!""";
	ИначеЕсли КодОшибки = -36 Тогда
		ТекстСообщить = "ru = ""Неизвестный код группы!""";
	ИначеЕсли КодОшибки = -50 Тогда
		ТекстСообщить = "ru = ""Неверный отправитель!""";
	ИначеЕсли КодОшибки = -51 Тогда
		ТекстСообщить = "ru = ""Неразрешенный получатель!""";
	ИначеЕсли КодОшибки = -52 Тогда
		ТекстСообщить = "ru = ""Недостаточно средств на Вашем счете!""";
	ИначеЕсли КодОшибки = -53 Тогда
		ТекстСообщить = "ru = ""Незарегистрированный отправитель!""";
	ИначеЕсли КодОшибки <= -54 и КодОшибки >= -59 Тогда
		ТекстСообщить = "ru = ""Таймаут изменения счета!""";
	ИначеЕсли КодОшибки = -66 Тогда
		ТекстСообщить = "ru = ""Не задан отправитель!""";
	ИначеЕсли КодОшибки = -67 Тогда
		ТекстСообщить = "ru = ""Превышение сроков отправки""";
	ИначеЕсли КодОшибки = -68 Тогда
		ТекстСообщить = "ru = ""Пользователь заблокирован!""";
	ИначеЕсли КодОшибки = -99999 Тогда
		ТекстСообщить = "ru = ""Ошибка соединения (нет доступа к интернету или не указаны настройки прокси-сервера)!""";
	Иначе
		ТекстСообщить = "ru = ""Неизвестная ошибка... код ошибки: " + Строка(КодОшибки) + "!""";
	КонецЕсли;
	Возврат НСтр(ТекстСообщить);
КонецФункции // SMS4B_ОписаниеОшибокВебСервиса()

&НаСервереБезКонтекста
// Функция создает файл inetcfg.xml для работы с прокси
//
// Параметры
//  Адрес	- Строка	- Адрес прокси сервера
//  Порт	- Строка	- Порт прокси сервера
//  Имя		- Строка	- Имя пользователя
//  Пароль	- Строка	- Пароль пользователя
//
// Возвращаемое значение:
//	Булево	- Признак создания файла
//
Функция SMS4B_СоздатьФайлНастроекПрокси(Адрес, Порт, Имя, Пароль)
	Попытка
		ЗаписьХМЛ = Новый ЗаписьXML;
		ЗаписьХМЛ.ОткрытьФайл(КаталогПрограммы() + "conf\inetcfg.xml");
		ЗаписьХМЛ.ЗаписатьНачалоЭлемента("InternetProxy");
			ЗаписьХМЛ.ЗаписатьАтрибут("protocols", Строка(Адрес) + ":" + Строка(Порт));
			ЗаписьХМЛ.ЗаписатьАтрибут("user", Строка(Имя));
			ЗаписьХМЛ.ЗаписатьАтрибут("password", Строка(Пароль));
			ЗаписьХМЛ.ЗаписатьАтрибут("bypassOnLocal", "true");
		ЗаписьХМЛ.ЗаписатьКонецЭлемента();
		ЗаписьХМЛ.Закрыть();
	Исключение
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции // SMS4B_СоздатьФайлНастроекПрокси()

&НаСервереБезКонтекста
// Функция проверяет, есть ли в каталоге программы файл настроек прокси
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Булево	- Признак наличия файла
//
Функция SMS4B_ЕстьФайлНастроекПрокси()
	ФайлНастроек = Новый Файл(КаталогПрограммы() + "conf\inetcfg.xml");
    Возврат ФайлНастроек.Существует();
КонецФункции // SMS4B_ЕстьФайлНастроекПрокси()

&НаСервереБезКонтекста
// Функция удаляет файл настрок прокси сервера
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Булево	- Признак удаления файла
//
Функция SMS4B_УдалитьФайлНастроекПрокси()
	ФайлУдален = Ложь;
	Попытка
		УдалитьФайлы(КаталогПрограммы() + "conf\inetcfg.xml");
		ФайлУдален = Истина;
	Исключение
		ФайлУдален = Ложь;
	КонецПопытки; 
	Возврат ФайлУдален;
КонецФункции // SMS4B_УдалитьФайлНастроекПрокси()

&НаСервереБезКонтекста
// Процедура выполняет чтение настроек из файла
//
// Параметры:
//	Нет.
//
Процедура SMS4B_ПрочитатьФайлНастроек()
	ОбъектXML = Новый ЧтениеXML;
	Попытка
		ОбъектXML.ОткрытьФайл(КаталогПрограммы() + "conf\inetcfg.xml");
	Исключение
		ОбъектXML.Закрыть();
		Возврат;
	КонецПопытки;
	Пока ОбъектXML.Прочитать() Цикл
		Если ОбъектXML.КоличествоАтрибутов() > 0 Тогда
			Пока ОбъектXML.ПрочитатьАтрибут() Цикл
				Если ОбъектXML.Имя = "protocols" Тогда 
					смсПроксиСервер = Лев(ОбъектXML.Значение, Найти(ОбъектXML.Значение, ":") - 1);
					смсПроксиПорт   = Сред(ОбъектXML.Значение, Найти(ОбъектXML.Значение, ":") + 1, 10);
				ИначеЕсли ОбъектXML.Имя = "user" Тогда
					смсПроксиПользователь = ОбъектXML.Значение;
				ИначеЕсли ОбъектXML.Имя = "password" Тогда
					смсПроксиПароль = ОбъектXML.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // SMS4B_ПрочитатьФайлНастроек()

//////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ЯДРА

&НаСервере
// Функция выполняет подключение к ВебСервису
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	WS-ссылка	- Ссылка на ВебСервис
//
Функция SMS4B_ПодключитьВебСервис()
	Попытка
		Если смсОсновнойСервер Тогда
			// Основной сервер
			Определения = Новый WSОпределения("https://sms4b.ru/webservices/sms.asmx?WSDL", смсИмяПользователя, смсПарольПользователя);
			ВебСервис = Новый WSПрокси(Определения, "SMS client", "WSSM", "WSSMSoap12");
		Иначе
			// Резервный сервер
			Определения = Новый WSОпределения("https://s.sms4b.ru/webservices/sms.asmx?WSDL", смсИмяПользователя, смсПарольПользователя);
			ВебСервис = Новый WSПрокси(Определения, "SMS client", "WSSM", "WSSMSoap12");
		КонецЕсли; 
	Исключение
		Возврат Неопределено;
	КонецПопытки; 
	Возврат ВебСервис;
КонецФункции // SMS4B_ПодключитьВебСервис()

&НаСервере
// Процедура меняет основной сервер
//
// Параметры:
//	Нет.
//
Процедура SMS4B_ПоменятьСервер()
	ЭтаФорма.смсОсновнойСервер = НЕ ЭтаФорма.смсОсновнойСервер;
КонецПроцедуры // SMS4B_ПоменятьСервер()

&НаСервереБезКонтекста
// Функция переводит дату из текстовый формат вида 'YYYYMMDD hh:mm:ss' в канонический формат
//
// Параметры:
//	СтрокаДаты	- Строка	- Строка даты
//
// Возвращаемое значение:
//	Дата	- Дата
//
Функция SMS4B_СтрокаВДату(СтрокаДаты)
	Стр = СтрЗаменить(СтрокаДаты, "-", "");
	Стр = СтрЗаменить(Стр, ":", "");
	Стр = СтрЗаменить(Стр, " ", "");
	Возврат Дата(Стр);
КонецФункции // SMS4B_СтрокаВДату()

&НаСервереБезКонтекста
// Процедура выводит переданное сообщение
//
// Параметры:
//	Сообщение	- Строка					- Текст сообщения
//	Статус		- СтатусСообщения			- Статус сообщения
//	Заголовок	- Строка					- Событие для журнала регистрации
//	Уровень		- УровеньЖурналаРегистрации	- Уровень для журнала регистрации
//
Процедура SMS4B_ВывестиСообщение(Сообщение, Статус)
	Сообщить(Сообщение, Статус);
КонецПроцедуры // SMS4B_ВывестиСообщение()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
// Функция проверяет заполение имени и пароля пользователя
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Булево	- Результат проверки
//
Функция SMS4B_ПроверитьЗаполнениеНастроекПодключения()
	ЕстьОшибки = Ложь;
	Если НЕ ЗначениеЗаполнено(смсИмяПользователя) Тогда 
		SMS4B_ВывестиСообщение(НСтр("ru = 'Не заполнен логин для подключения к sms4b.ru из внешних программ!'"), СтатусСообщения.Важное);
		ЕстьОшибки = Истина;
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(смсПарольПользователя) Тогда 
		SMS4B_ВывестиСообщение(НСтр("ru = 'Не заполнен пароль для подключения к sms4b.ru из внешних программ!'"), СтатусСообщения.Важное);
		ЕстьОшибки = Истина;
	КонецЕсли;
	Возврат НЕ ЕстьОшибки;
КонецФункции // SMS4B_ПроверитьЗаполнениеНастроекПодключения()

&НаКлиенте
// Процедура управляет доступностью элементов настроек прокси
//
// Параметры:
//	Доступность	- Булево	- Доступность элементов
//
Процедура SMS4B_ДоступностьНастроекПрокси(Доступность)
	Элементы.смсПроксиСервер.Доступность		= Доступность;
	Элементы.смсПроксиПорт.Доступность			= Доступность;
	Элементы.смсПроксиПользователь.Доступность	= Доступность;
	Элементы.смсПроксиПароль.Доступность		= Доступность;
	Элементы.смсСоздатьФайлНастроек.Доступность	= Доступность;
КонецПроцедуры // SMS4B_ДоступностьНастроекПрокси()

 &НаКлиенте
// Процедура заполняет список выбора номеров отправителя
//
// Параметры:
//	Нет.
//
Процедура SMS4B_ЗаполнитьСписокНомеровОтправителя()
	Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора.Очистить();
	МассивНомеров = SMS4B_ПолучитьМассивНомеровИзСтроки(смсНомераОтправителя);
	Для Каждого Номер Из МассивНомеров Цикл
		Если НЕ ПустаяСтрока(Номер) Тогда
			Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора.Добавить(Номер);
		КонецЕсли; 
	КонецЦикла; 
	Если Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора.Количество() = 0 Тогда
		смсИмяПользователяПоУмолчанию = "";
	ИначеЕсли Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора.НайтиПоЗначению(смсИмяПользователяПоУмолчанию) = Неопределено Тогда
		смсИмяПользователяПоУмолчанию = Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора[0].Значение;
	КонецЕсли;
КонецПроцедуры // SMS4B_ЗаполнитьСписокНомеровОтправителя()

&НаСервере
// Процедура записывает параметры сессии
//
// Параметры:
//	ПараметрыСессии	- Структура	- Структура, которая содержит параметры сессии
//							
Процедура SMS4B_ЗаписатьПараметрыСессии(ПараметрыСессии) 
	Если ПараметрыСессии.Свойство("смсКоличествоНомеров") Тогда
		ЭтаФорма.смсКоличествоНомеров = ПараметрыСессии.смсКоличествоНомеров;
	КонецЕсли;	
	Если ПараметрыСессии.Свойство("смсКорректировкаUTC") Тогда
		ЭтаФорма.смсКорректировкаUTC = ПараметрыСессии.смсКорректировкаUTC;
	КонецЕсли;	
	Если ПараметрыСессии.Свойство("смсМаксАктуальностьДоставки") Тогда
		ЭтаФорма.смсМаксАктуальностьДоставки = ПараметрыСессии.смсМаксАктуальностьДоставки;
	КонецЕсли;	
	Если ПараметрыСессии.Свойство("смсМаксДлительностьДоставки") Тогда
		ЭтаФорма.смсМаксДлительностьДоставки = ПараметрыСессии.смсМаксДлительностьДоставки;
	КонецЕсли;	
	Если ПараметрыСессии.Свойство("смсНомераОтправителя") Тогда
		ЭтаФорма.смсНомераОтправителя = ПараметрыСессии.смсНомераОтправителя;
	КонецЕсли;	
	Если ПараметрыСессии.Свойство("смсОстатокСМС") Тогда
		ЭтаФорма.смсОстатокСМС = ПараметрыСессии.смсОстатокСМС;
	КонецЕсли;	
КонецПроцедуры // SMS4B_ЗаписатьПараметрыСессии()

 &НаКлиенте
 // Функция возвращает структуру настроек
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	Структура	- Структура настроек
//
Функция SMS4B_ПолучитьСтруктуруНастроек()
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("смсДатаПолученияСМС",				смсДатаПолученияСМС);
	СтруктураНастроек.Вставить("смсИмяПользователя",				смсИмяПользователя);
	СтруктураНастроек.Вставить("смсИмяПользователяПоУмолчанию",		смсИмяПользователяПоУмолчанию);
	СтруктураНастроек.Вставить("смсИспользоватьПроксиСервер",		смсИспользоватьПроксиСервер);
	СтруктураНастроек.Вставить("смсКоличествоНомеров",				смсКоличествоНомеров);
	СтруктураНастроек.Вставить("смсКонецПериодаЗапрета",			смсКонецПериодаЗапрета);
	СтруктураНастроек.Вставить("смсМаксАктуальностьДоставки",		смсМаксАктуальностьДоставки);
	СтруктураНастроек.Вставить("смсМаксДлительностьДоставки",		смсМаксДлительностьДоставки);
	СтруктураНастроек.Вставить("смсНачалоПериодаЗапрета",			смсНачалоПериодаЗапрета);
	СтруктураНастроек.Вставить("смсНеОтправлятьSMS",				смсНеОтправлятьSMS);
	СтруктураНастроек.Вставить("смсНомераОтправителя",				смсНомераОтправителя);
	СтруктураНастроек.Вставить("смсНомерСессии",					смсНомерСессии);
	СтруктураНастроек.Вставить("смсОсновнойСервер",					смсОсновнойСервер);
	СтруктураНастроек.Вставить("смсОстатокСМС",						смсОстатокСМС);
	СтруктураНастроек.Вставить("смсПарольПользователя",				смсПарольПользователя);
	СтруктураНастроек.Вставить("смсПолучатьТолькоПолныеСообщения",	смсПолучатьТолькоПолныеСообщения);
	СтруктураНастроек.Вставить("смсПроксиПароль",					смсПроксиПароль);
	СтруктураНастроек.Вставить("смсПроксиПользователь",				смсПроксиПользователь);
	СтруктураНастроек.Вставить("смсПроксиПорт",						смсПроксиПорт);
	СтруктураНастроек.Вставить("смсПроксиСервер",					смсПроксиСервер);
	СтруктураНастроек.Вставить("смсСрокЖизниSMS",					смсСрокЖизниSMS);
	Возврат СтруктураНастроек;
КонецФункции // SMS4B_ПолучитьСтруктуруНастроек()

&НаСервереБезКонтекста
// Функция возвращает текущее время
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	ДатаВремя	- Текущая дата и время
//
Функция SMS4B_ПолучитьТекущееВремя()
	Возврат ТекущаяДатаСеанса();
КонецФункции // SMS4B_ПолучитьТекущееВремя()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" элемента формы "смсИспользоватьПроксиСервер"
//
Процедура смсИспользоватьПроксиСерверПриИзменении(Элемент)
    ЕстьФайлНастроекПрокси = SMS4B_ЕстьФайлНастроекПрокси();
	Если смсИспользоватьПроксиСервер Тогда
		SMS4B_ДоступностьНастроекПрокси(Истина);
		Если ЕстьФайлНастроекПрокси Тогда
			Ответ = Вопрос(НСтр("ru = 'Обнаружен ранее созданный файл настроек conf\inetcfg.xml в каталоге программы!
			|Прочитать из него настройки?'"), РежимДиалогаВопрос.ДаНет, , , "Внимание!");
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Сообщить(НСтр("ru = 'Настройки не прочитаны!'"));
			Иначе
				SMS4B_ПрочитатьФайлНастроек();
			КонецЕсли;  
		КонецЕсли;
	Иначе
		SMS4B_ДоступностьНастроекПрокси(Ложь);
		Если ЕстьФайлНастроекПрокси Тогда
			Ответ = Вопрос(НСтр("ru = 'Рекомендуется удалить ранее созданный файл настроек прокси-сервера conf\inetcfg.xml в каталоге программы!
			|Удалить его сейчас?'"), РежимДиалогаВопрос.ДаНет, , , "Внимание!");
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Сообщить(НСтр("ru = 'Файл настроек не был удален! Возможны проблемы при работе с сервером SMS4B!'"));
			Иначе
				Если НЕ SMS4B_УдалитьФайлНастроекПрокси() Тогда
					Сообщить(НСтр("ru = 'Не удалось удалить файл настроек прокси-сервера (вероятно, нет прав доступа в каталог программы). 
					|Необходимо удалить файл вручную. Обратитесь к администратору.'"));
				Иначе
					Сообщить(НСтр("ru = 'Файл настроек прокси-сервера удален.'"));
					смсПроксиПользователь	= "";
					смсПроксиПароль			= "";
					смсПроксиСервер			= "";
					смсПроксиПорт			= "";
				КонецЕсли;
			КонецЕсли;  
		КонецЕсли;
    КонецЕсли; 
КонецПроцедуры // смсИспользоватьПроксиСерверПриИзменении()

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" элемента формы "смсНеОтправлятьSMS"
//
Процедура смсНеОтправлятьSMSПриИзменении(Элемент)
	Элементы.смсНачалоПериодаЗапрета.Доступность = смсНеОтправлятьSMS;
	Элементы.смсКонецПериодаЗапрета.Доступность	 = смсНеОтправлятьSMS;
КонецПроцедуры // смсНеОтправлятьSMSПриИзменении()

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" элемента формы "смсНачалоПериодаЗапрета"
//
Процедура смсНачалоПериодаЗапретаПриИзменении(Элемент)
    смсНачалоПериодаЗапрета = НачалоЧаса(смсНачалоПериодаЗапрета);
КонецПроцедуры // смсНачалоПериодаЗапретаПриИзменении()

&НаКлиенте
// Процедура - обработчик события "Регулирование" элемента формы "смсНачалоПериодаЗапрета"
//
Процедура смсНачалоПериодаЗапретаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если смсНачалоПериодаЗапрета = Дата('00010101') И (Направление = -1) Тогда
		смсНачалоПериодаЗапрета = смсНачалоПериодаЗапрета + 82800;
	Иначе	
		смсНачалоПериодаЗапрета = смсНачалоПериодаЗапрета + 3600 * Направление;
	КонецЕсли;	
КонецПроцедуры // смсНачалоПериодаЗапретаРегулирование()

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" элемента формы "смсКонецПериодаЗапрета"
//
Процедура смсКонецПериодаЗапретаПриИзменении(Элемент)
    смсКонецПериодаЗапрета = НачалоЧаса(смсКонецПериодаЗапрета);
КонецПроцедуры // смсКонецПериодаЗапретаПриИзменении()

&НаКлиенте
// Процедура - обработчик события "Регулирование" элемента формы "смсКонецПериодаЗапрета"
//
Процедура смсКонецПериодаЗапретаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если смсКонецПериодаЗапрета = Дата('00010101') И (Направление = -1) Тогда
		смсКонецПериодаЗапрета = смсКонецПериодаЗапрета + 82800;
	Иначе	
		смсКонецПериодаЗапрета = смсКонецПериодаЗапрета + 3600 * Направление;
	КонецЕсли;	
КонецПроцедуры // смсКонецПериодаЗапретаРегулирование()

&НаКлиенте
// Процедура - обработчик события "НачалоВыбора" элемента формы "смсДатаПолученияСМС"
//
Процедура смсДатаПолученияСМСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    Текст = НСтр("ru = 'При изменении даты входящего сообщения возможна перезапись ранее 
	| полученных частичных сообщений!!! Продолжить?'");
	Режим = РежимДиалогаВопрос.ДаНет;
	Ответ = Вопрос(Текст, Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
КонецПроцедуры // смсДатаПолученияСМСНачалоВыбора()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере"
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("смсИмяПользователя") Тогда
		ЭтаФорма.смсИмяПользователя = Параметры.смсИмяПользователя;
	КонецЕсли;	
	Если Параметры.Свойство("смсИмяПользователяПоУмолчанию") Тогда
		ЭтаФорма.смсИмяПользователяПоУмолчанию = Параметры.смсИмяПользователяПоУмолчанию;
	КонецЕсли;	
	Если Параметры.Свойство("смсКонецПериодаЗапрета") Тогда
		ЭтаФорма.смсКонецПериодаЗапрета = Параметры.смсКонецПериодаЗапрета;
	КонецЕсли;	
	Если Параметры.Свойство("смсНачалоПериодаЗапрета") Тогда
		ЭтаФорма.смсНачалоПериодаЗапрета = Параметры.смсНачалоПериодаЗапрета;
	КонецЕсли;	
	Если Параметры.Свойство("смсНомераОтправителя") Тогда
		ЭтаФорма.смсНомераОтправителя = Параметры.смсНомераОтправителя;
	КонецЕсли;	
	Если Параметры.Свойство("смсНомерЯдра") Тогда
		ЭтаФорма.смсНомерЯдра = Параметры.смсНомерЯдра;
	КонецЕсли;	
	Если Параметры.Свойство("смсНеОтправлятьSMS") Тогда
		ЭтаФорма.смсНеОтправлятьSMS = Параметры.смсНеОтправлятьSMS;
	КонецЕсли;
	Если Параметры.Свойство("смсНомерСессии	") Тогда
		ЭтаФорма.смсНомерСессии = Параметры.смсНомерСессии;
	КонецЕсли;
	Если Параметры.Свойство("смсОсновнойСервер") Тогда
		ЭтаФорма.смсОсновнойСервер = Параметры.смсОсновнойСервер;
	Иначе	
		ЭтаФорма.смсОсновнойСервер = Истина;
	КонецЕсли;	
	Если Параметры.Свойство("смсПарольПользователя") Тогда
		ЭтаФорма.смсПарольПользователя = Параметры.смсПарольПользователя;
	КонецЕсли;	
	Если Параметры.Свойство("смсПолучатьТолькоПолныеСообщения") Тогда
		ЭтаФорма.смсПолучатьТолькоПолныеСообщения = Параметры.смсПолучатьТолькоПолныеСообщения;
	КонецЕсли;	
	Если Параметры.Свойство("смсПроксиПароль") Тогда
		ЭтаФорма.смсПроксиПароль = Параметры.смсПроксиПароль;
	КонецЕсли;	
	Если Параметры.Свойство("смсПроксиПользователь") Тогда
		ЭтаФорма.смсПроксиПользователь = Параметры.смсПроксиПользователь;
	КонецЕсли;	
	Если Параметры.Свойство("смсПроксиПорт") Тогда
		ЭтаФорма.смсПроксиПорт = Параметры.смсПроксиПорт;
	КонецЕсли;	
	Если Параметры.Свойство("смсПроксиСервер") Тогда
		ЭтаФорма.смсПроксиСервер = Параметры.смсПроксиСервер;
	КонецЕсли;	
	Если Параметры.Свойство("смсСрокЖизниSMS") Тогда
		ЭтаФорма.смсСрокЖизниSMS = Параметры.смсСрокЖизниSMS;
	КонецЕсли;	
	Если ЭтаФорма.смсСрокЖизниSMS = 0 Тогда
		ЭтаФорма.смсСрокЖизниSMS = 24;
	КонецЕсли;	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Процедура - обработчик события формы "ПриОткрытии"
//
Процедура ПриОткрытии(Отказ)
	SMS4B_ЗаполнитьСписокНомеровОтправителя();
    смсНеОтправлятьSMSПриИзменении(Неопределено);
	ЕстьФайлНастроекПрокси = SMS4B_ЕстьФайлНастроекПрокси();
	Если ЕстьФайлНастроекПрокси Тогда
		Ответ = Вопрос(НСтр("ru = 'Обнаружен ранее созданный файл настроек conf\inetcfg.xml в каталоге программы!
		|Прочитать из него настройки?'"), РежимДиалогаВопрос.ДаНет, , , "Внимание!");
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Сообщить(НСтр("ru = 'Настройки не прочитаны!'"));
			смсИспользоватьПроксиСервер = Ложь;
		Иначе
			SMS4B_ПрочитатьФайлНастроек();
			смсИспользоватьПроксиСервер = Истина;
		КонецЕсли;
	Иначе
		смсИспользоватьПроксиСервер = Ложь;
	КонецЕсли;
	SMS4B_ДоступностьНастроекПрокси(смсИспользоватьПроксиСервер);
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
// Процедура - обработчик команды формы "Записать"
//
Процедура смсЗаписать(Команда)
	СтруктураНастроек = SMS4B_ПолучитьСтруктуруНастроек();
	Оповестить("SMS4B_СтруктураНастроек", СтруктураНастроек);
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // смсЗаписать()

&НаКлиенте
// Процедура - обработчик команды формы "ЗаписатьИЗакрыть"
//
Процедура смсЗаписатьИЗакрыть(Команда)
	смсЗаписать(Команда);
	Закрыть();
КонецПроцедуры // смсЗаписатьИЗакрыть()

&НаКлиенте
// Процедура - обработчик команды формы "Подключится"
//
Процедура смсПодключится(Команда)
	Если НЕ SMS4B_ПроверитьЗаполнениеНастроекПодключения() Тогда Возврат; КонецЕсли; 
	смсИмяПользователяПоУмолчанию = ""; 
    Элементы.смсИмяПользователяПоУмолчанию.СписокВыбора.Очистить();
	Результат = SMS4B_Подключиться();
	Если Результат > 0 Тогда 
		ПараметрыСессии = Новый Структура;
		SMS4B_ПолучитьПараметрыСессии(ПараметрыСессии);
		SMS4B_ЗаписатьПараметрыСессии(ПараметрыСессии);
		SMS4B_ЗаполнитьСписокНомеровОтправителя();
		смсЗаписать(Неопределено);
		Элементы.смсИмяПользователя.Доступность		= Ложь;
		Элементы.смсПарольПользователя.Доступность	= Ложь;
		Элементы.смсПодключиться.Доступность		= Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Вы успешно подключились к сервису SMS4B!'"), 3);
	Иначе
		SMS4B_ВывестиСообщение(НСтр("ru = 'Ошибка при попытке подключения: " + SMS4B_ОписаниеОшибокВебСервиса(Результат) + "'"), СтатусСообщения.Важное);
	КонецЕсли;
КонецПроцедуры // смсПодключится()

&НаКлиенте
// Процедура - обработчик команды формы "смсСоздатьФайлНастроек"
//
Процедура смсСоздатьФайлНастроек(Команда)
    ВсеОК = Истина;
	Если НЕ ЗначениеЗаполнено(смсПроксиСервер) Тогда 
		Сообщить(НСтр("ru = 'Не указан прокси-сервер!'"));
		Возврат;
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(смсПроксиПорт) Тогда 
		Сообщить(НСтр("ru = 'Не указан порт прокси-сервера!'"));
		Возврат;
	КонецЕсли;	
	// проверим, нет ли уже созданного файла настроек
	ЕстьФайл = SMS4B_ЕстьФайлНастроекПрокси();
	Если ЕстьФайл Тогда
		Ответ = Вопрос(НСтр("ru = 'Обнаружен ранее созданный файл настроек conf\inetcfg.xml в каталоге программы!
					   |Перезаписать его?'"), РежимДиалогаВопрос.ДаНет,,, "Внимание!");
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;				   
		КонецЕсли;  
	КонецЕсли;
	УдалосьЗаписать = SMS4B_СоздатьФайлНастроекПрокси(смсПроксиСервер, смсПроксиПорт, смсПроксиПользователь, смсПроксиПароль);
	Если Не УдалосьЗаписать Тогда
		Ответ = Вопрос(НСтр("ru = 'Не удалось записать файл настроек (вероятно, нет прав доступа в каталог программы).
					   |Вы можете сохранить файл локально на диск и вручную скопировать его (см. справку).
					   |Сохранить файл на диск?'"), РежимДиалогаВопрос.ДаНет,,, "Внимание!");
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			ВсеОК = Ложь;
		Иначе
			Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог:'");
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ЗаписьХМЛ = Новый ЗаписьXML;
				Путь = СтрЗаменить(ДиалогОткрытияФайла.Каталог + "\inetcfg.xml", "\\", "\");
				ЗаписьХМЛ.ОткрытьФайл(ДиалогОткрытияФайла.Каталог + "inetcfg.xml");
				ЗаписьХМЛ.ЗаписатьНачалоЭлемента("InternetProxy");
					ЗаписьХМЛ.ЗаписатьАтрибут("protocols", Строка(смсПроксиСервер) + ":" + Строка(смсПроксиПорт));
					ЗаписьХМЛ.ЗаписатьАтрибут("user", Строка(смсПроксиПользователь));
					ЗаписьХМЛ.ЗаписатьАтрибут("password", Строка(смсПроксиПароль));
					ЗаписьХМЛ.ЗаписатьАтрибут("bypassOnLocal", "true");
				ЗаписьХМЛ.ЗаписатьКонецЭлемента();
				ЗаписьХМЛ.Закрыть();
			Иначе
				ВсеОК = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	Если ВсеОК Тогда
		Сообщить(НСтр("ru = 'Файл настроек прокси-сервера успешно записан.'"));	
	Иначе
		Сообщить(НСтр("ru = 'Настройки прокси-сервера не сохранены. Возможны проблемы при работе с сервером SMS4B!'"));		
	КонецЕсли
КонецПроцедуры // смсСоздатьФайлНастроек()
