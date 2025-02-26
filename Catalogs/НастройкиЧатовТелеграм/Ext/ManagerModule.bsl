﻿
#Область ПрограммныйИнтерфейс

Функция ЗарегистрироватьАдресРучки(Элемент) Экспорт

	Параметры = ПараметрыПодключения(Элемент);
	АдресРучки = СформироватьПолныйАдрес(Элемент.АдресПриемаСообщений);
	
	Ответ = ЗарегестрироватьАдресРучки(Параметры, АдресРучки);
	
	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	Описание = Новый Структура;
	Описание.Вставить("Результат", Ложь);
	Описание.Вставить("Данные", "Не удалось зарегестрироваться");
	
	Если УспешныйОтвет(Ответ) Тогда
	
		Результат = Ответ.Получить(Ключи["Результат"]);
		Описание.Вставить("Результат", Истина);
		Описание.Вставить("Данные", "Адрес зарегестрирован");
	
	КонецЕсли;
	
	Возврат Описание;

КонецФункции // ()

Функция ОбработатьПолучениеСообщений(Запрос) Экспорт

	Данные = ОбработатьСообщение(Запрос);
	
	Описание = Новый Структура;
	Описание.Вставить("Результат", Истина);
	Описание.Вставить("Ответ", Данные);
	
	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	МаксимальныйОбновленныйИД = НайтиМаксИД(
		Данные.Получить(Ключи["Результат"]));
	
	Описание.Вставить("Отметка", МаксимальныйОбновленныйИД);
	
	Возврат Описание;

КонецФункции // ()

Функция ПолучитьНовыеСообщения(Элемент) Экспорт

	Параметры = ПараметрыПодключения(Элемент);

	Ответ = ОтправитьЗапросНовыеСообщения(Параметры);

	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	Описание = Новый Структура;
	Описание.Вставить("Результат", Ложь);
	
	Результат = "Не удалось получить сообщения";
	Если УспешныйОтвет(Ответ) Тогда
	
		Результат = Ответ.Получить(Ключи["Результат"]);
		Описание.Вставить("Результат", Истина);
	
	КонецЕсли;
	Описание.Вставить("Ответ", Результат);
	
	МаксимальныйОбновленныйИД = НайтиМаксИД(
		Ответ.Получить(Ключи["Результат"]));
	
	Описание.Вставить("Отметка", МаксимальныйОбновленныйИД);
	
	Возврат Описание;

КонецФункции // ()

Процедура ОтметитьПрочитанными(Элемент, МаксимальныйОбновленныйИД) Экспорт

	Если МаксимальныйОбновленныйИД = 0 Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Параметры = ПараметрыПодключения(Элемент);
	
	ПодтвердитьНовыеСообщения(Параметры, МаксимальныйОбновленныйИД);
	
КонецПроцедуры

Функция ПолучитьФайл(Элемент, ИДФайла) Экспорт

	Параметры = ПараметрыПодключения(Элемент);
	
	ПутьНаСервере = ОтправитьЗапросПолучениеПутиНаСервере(Параметры, ИДФайла);
	Если ПустаяСтрока(ПутьНаСервере) Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	ДвоичныеДанные = ОтправитьЗапросПолучениеФайла(Параметры, ПутьНаСервере);
	
	Описание = Новый Структура;
	Описание.Вставить("ПутьНаСервере", ПутьНаСервере);
	Описание.Вставить("ДвоичныеДанные", ДвоичныеДанные);
	
	Возврат Описание;

КонецФункции // ()

Функция ОтправитьСообщение(Элемент, ЧатИД, Текст) Экспорт

	Параметры = ПараметрыПодключения(Элемент);
	
	Ответ = ОтправитьОтветВЧат(Параметры, ЧатИД, Текст);

	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	Описание = Новый Структура;
	Описание.Вставить("Результат", Ложь);
	
	Результат = "Не удалось получить сообщения";
	Если УспешныйОтвет(Ответ) Тогда
	
		Результат = Ответ.Получить(Ключи["Результат"]);
		Описание.Вставить("Результат", Истина);
	
	КонецЕсли;
	Описание.Вставить("Ответ", Результат);
	
	Возврат Описание;

КонецФункции // ()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеОтправкойЗапросов

Функция ПолучитьТокен(Элемент) Экспорт

	Ключи = Новый Массив;
	Ключи.Добавить(КлючТокен());
	
	Результат = ОбработкаБезопасноеХранилище.Получить(
		Элемент,
		Ключи);
	Если Не ЗначениеЗаполнено(Результат) Тогда
	
		Возврат "";
	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ()

Процедура ЗаписатьТокен(Элемент, Значение) Экспорт
	
	Если Не ЗначениеЗаполнено(Элемент) Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ОбработкаБезопасноеХранилище.Записать(
		Элемент,
		КлючТокен(),
		Значение);

КонецПроцедуры

Функция АдресСервера() Экспорт

	Возврат "api.telegram.org";

КонецФункции // ()

Функция ПараметрыПодключения(Элемент) Экспорт

	Описание = Новый Структура;
	Описание.Вставить("Сервер", АдресСервера());
	Описание.Вставить("Бот", Элемент.ИмяБота);
	Описание.Вставить("Токен", ПолучитьТокен(Элемент));
	
	Для каждого Свойство Из Описание Цикл
	
		Если ПустаяСтрока(Свойство.Значение) Тогда
		
			ВызватьИсключение СтрШаблон(
				"В настройке телеграм бота не указано поле - %1",
				Свойство.Ключ);
		
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Описание;

КонецФункции // ()

Функция ДанныеАкаунта(Клиент, ОписаниеОтправителя = Неопределено) Экспорт

	ТипыОтправителей = Метаданные.ОпределяемыеТипы
		.Отправители.Тип;
	
	Если ЗначениеЗаполнено(Клиент)
		И ТипыОтправителей.СодержитТип(ТипЗнч(Клиент)) Тогда
	
		Возврат РегистрыСведений.ИдентификаторыЧатовТелеграм
			.ДанныеАкаунта(Клиент);
	
	КонецЕсли;
	
	Если ТипЗнч(ОписаниеОтправителя) = Тип("Структура") Тогда
	
		ОписаниеОтправителя.Вставить("Идентификатор", ОписаниеОтправителя["ИД"]);
		Возврат ОписаниеОтправителя;
	
	КонецЕсли;

	ВызватьИсключение СтрШаблон(
		УправлениеСтроками.Шаблон(
			"Тип клиента не является Отправителем
			|Или описанием акаунта телеграмма
			|
			|Получен: {}"),
		ТипЗнч(ОписаниеОтправителя));
	
КонецФункции // ()

#КонецОбласти

#Область УправлениеРазборомОтветов

Функция ПолучитьСообщения(Элемент, Ответ) Экспорт

	Состояние = Новый Структура;
	Состояние.Вставить("Позиция", 0);
	Состояние.Вставить("Ответ", Ответ);
	
	История = СообщениеИзЧата.НоваяИстория();
	
	Пока ЕстьСледующий(Состояние) Цикл
	
		ТекущееСообщение = СформироватьСообщение(
			Элемент,
			Следующий(Состояние));
		
		СообщениеИзЧата.ДобавитьСообщение(
			История,
			ТекущееСообщение);
	
	КонецЦикла;
	
	Возврат История;

КонецФункции // ()

Функция ЕстьСледующий(Состояние)

	Возврат Состояние["Позиция"] < Состояние["Ответ"].Количество();

КонецФункции // ()

Функция Следующий(Состояние)
	
	Позиция = Состояние["Позиция"];
	Ответ = Состояние["Ответ"];
	
	Элемент = Ответ[Позиция];
	
	Состояние["Позиция"] = Позиция + 1;
	
	Возврат Элемент;

КонецФункции // ()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПолныйАдрес(IpАдрес)

	// Отмена регистрации
	Если ПустаяСтрока(IpАдрес) Тогда
	
		Возврат "";
	
	КонецЕсли;
	
	ПутьКСервису = КонфигурацияИсторияЧатов.АдресОжиданияСообщений();
	
	Возврат СтрШаблон(
		УправлениеСтроками.Шаблон("https://{}/{}"),
		IpАдрес,
		ПутьКСервису);

КонецФункции // ()

Функция УспешныйОтвет(Значение)

	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	ЗначениеУспех = Значение.Получить(Ключи["Успешно"]);
	Если ЗначениеУспех = Неопределено Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	Возврат ЗначениеУспех = КонфигурацияИсторияЧатов.УспешныйОтветТелеграмм();

КонецФункции // ()

Функция СформироватьСообщение(Элемент, СообщениеТелеграмм)

	Данные = СообщениеТелеграмм.Получить("message");
	
	Сообщение = СообщениеИзЧата.НовоеСообщение();
	
	Сообщение["Текст"] = ДостатьТекстСообщения(Данные);
	Сообщение["Дата"] = СообщениеИзЧата.УниверсальнаяДатаИзМилесекунд(
		Данные.Получить("date"));
	Сообщение["Мессенджер"] = Элемент;
	
	Документ = Данные.Получить("document");
	Если Документ <> Неопределено Тогда
	
		Сообщение["Файл"] = Документ;
	
	КонецЕсли;
	
	Видео = Данные.Получить("video");
	Если Видео <> Неопределено Тогда
	
		Сообщение["Видео"] = Видео;
	
	КонецЕсли;
	
	Звук = Данные.Получить("voice");
	Если Звук <> Неопределено Тогда
	
		Сообщение["Звук"] = Звук;
	
	КонецЕсли;
	
	Сообщение["Изображение"] = Данные.Получить("photo");
	
	КтоОтправил = Данные.Получить("from");
	
	ДанныеОтправителя = Новый Структура;
	ДанныеОтправителя.Вставить("ИмяАкаунта", КтоОтправил.Получить("username"));
	ДанныеОтправителя.Вставить("Фамилия", КтоОтправил.Получить("last_name"));
	ДанныеОтправителя.Вставить("Имя", КтоОтправил.Получить("first_name"));
	ДанныеОтправителя.Вставить("ИД", КтоОтправил.Получить("id"));
	
	Сообщение["ОписаниеОтправителя"] = ДанныеОтправителя;
	
	Отправитель = НайтиОтправителя(ДанныеОтправителя);
	Если Отправитель = Неопределено Тогда
	
		Возврат Сообщение;
	
	КонецЕсли;
	
	Сообщение["Отправитель"] = Отправитель;
	
	МодульОтправителя = УправлениеМетаданными.МенеджерОбъектаПоСсылке(
		Отправитель);
	
	Если МодульОтправителя.ЭтоКлиент() Тогда
	
		Сообщение["Клиент"] = Отправитель;
	
	Иначе
	
		Сообщение["Сотрудник"] = Отправитель;
	
	КонецЕсли;
	
	Возврат Сообщение;

КонецФункции // ()

Функция ДостатьТекстСообщения(Данные)

	Текст = Данные.Получить("text");
	Если Текст = Неопределено Тогда
	
		Текст = Данные.Получить("caption");
	
	КонецЕсли;
	Если Текст = Неопределено Тогда
	
		Стикер = Данные.Получить("sticker");
		Если Стикер <> Неопределено Тогда
		
			Текст = СтрШаблон(
				"Стикер:
				|Смайлик: %1
				|Сет: %2",
				Стикер.Получить("emoji"),
				Стикер.Получить("set_name"));
		
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Текст;

КонецФункции // ()

Функция НайтиОтправителя(ДанныеОтправителя)

	Возврат РегистрыСведений.ИдентификаторыЧатовТелеграм
		.НайтиОтправителя(ДанныеОтправителя["ИмяАкаунта"]);

КонецФункции // ()

Функция КлючТокен()

	Возврат "Токен";

КонецФункции // ()

Функция ВыполнитьЗапрос(Сервер, ТекстЗапроса)
	
	//ИнтернетПрокси = Новый ИнтернетПрокси;
	//ИнтернетПрокси.Установить(СтрокаТаблицаПрокси.Протокол, СтрокаТаблицаПрокси.Сервер, СтрокаТаблицаПрокси.Порт, СтрокаТаблицаПрокси.Пользователь, СтрокаТаблицаПрокси.Пароль, Ложь);

	Соединение = Новый HTTPСоединение(
		Сервер,
		443, , , , ,
		Новый ЗащищенноеСоединениеOpenSSL());
	
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	
	Попытка
		
		HTTPОтвет = Соединение.Получить(Запрос);
		
	Исключение
		ВызватьИсключение СтрШаблон(
			"Неудалось выполнить запрос к Телеграм:
			|Причина:
			|%",
			ОписаниеОшибки());
	КонецПопытки;
	
	Возврат HTTPОтвет;

КонецФункции

Функция ОбработатьСообщение(Значение, ОтветФайл = Ложь)

	ДвоичныеДанныеОтвета = Значение.ПолучитьТелоКакДвоичныеДанные();
	
	Если ОтветФайл Тогда
	
		Возврат ДвоичныеДанныеОтвета;
	
	КонецЕсли;
	
	Возврат КоннекторHTTP.JsonВОбъект(ДвоичныеДанныеОтвета);

КонецФункции // ()

#Область ОтправкаЗапросовНаСервер

// "bot"+ПараметрыТелеграм.Токен+"/getUpdates?offset="+Формат(ПараметрыТелеграм.update_id_max+1, "ЧДЦ=0; ЧГ=0")
// "bot"+ПараметрыТелеграм.Токен+"/sendMessage?chat_id=" + СтрЗаменить(Формат(chat_id, "ЧДЦ=; ЧС=; ЧРГ=."), ".", "") + "&text="+ТекстСообщения
Функция ОтправитьЗапросНаСервер(Сервер, ТекстЗапроса, ОтветФайл = Ложь) Экспорт
	
	Ответ = ВыполнитьЗапрос(Сервер, ТекстЗапроса);

	Возврат ОбработатьСообщение(Ответ, ОтветФайл);
	
КонецФункции

//ip_address
Функция ШаблонУстановкиАдресаРучки()

	Возврат "bot%1/setWebhook?url=%2";

КонецФункции // ()

Функция ШаблонПолучения()

	Возврат "bot%1/getUpdates";

КонецФункции // ()

Функция ШаблонПодтверждения()

	Возврат "bot%1/getUpdates?offset=%2";

КонецФункции // ()

Функция ШаблонПолученияФайла()

	Возврат "file/bot%1/%2"

КонецФункции // ()

Функция ШаблонПолученияСслкиНаФайл()

	Возврат "bot%1/getFile?file_id=%2";

КонецФункции // ()

Функция ШаблонОтправкиТекста()

	Возврат "bot%1/sendMessage?chat_id=%2&text=%3";

КонецФункции // ()
// https://core.telegram.org/bots/api#sendmessage chat_id text

Функция ЗарегестрироватьАдресРучки(Параметры, АдресРучки)

	ТекстЗапроса = СтрШаблон(
		ШаблонУстановкиАдресаРучки(),
		Параметры["Токен"],
		АдресРучки);
	
	Возврат ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса);

КонецФункции // ()

Функция ОтправитьЗапросНовыеСообщения(Параметры)

	ТекстЗапроса = СтрШаблон(
		ШаблонПолучения(),
		Параметры["Токен"]);
	
	Возврат ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса);

КонецФункции // ()

Процедура ПодтвердитьНовыеСообщения(Параметры, Идентификатор)

	ТекстЗапроса = СтрШаблон(
		ШаблонПодтверждения(),
		Параметры["Токен"],
		Формат(Идентификатор + 1, "ЧГ=0"));
	
	Результат = ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса);

КонецПроцедуры

Функция ОтправитьЗапросПолучениеПутиНаСервере(Параметры, ИДФайла)

	ТекстЗапроса = СтрШаблон(
		ШаблонПолученияСслкиНаФайл(),
		Параметры["Токен"],
		ИДФайла);

	Ответ = ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса);
	
	Если Не УспешныйОтвет(Ответ) Тогда
	
		Возврат "";
	
	КонецЕсли;
	
	Ключи = КонфигурацияИсторияЧатов.КлючиОтветаСервисаТелеграмм();
	
	Данные = Ответ.Получить(Ключи["Результат"]);
	
	Возврат Данные.Получить("file_path");

КонецФункции // ()

Функция ОтправитьЗапросПолучениеФайла(Параметры, ПутьНаСервере)

	ТекстЗапроса = СтрШаблон(
		ШаблонПолученияФайла(),
		Параметры["Токен"],
		ПутьНаСервере);

	Возврат ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса, Истина);
	
КонецФункции // ()

Функция ОтправитьОтветВЧат(Параметры, ЧатИД, Текст)

	ТекстЗапроса = СтрШаблон(
		ШаблонОтправкиТекста(),
		Параметры["Токен"],
		ЧатИД,
		Текст);
	
	Возврат ОтправитьЗапросНаСервер(Параметры["Сервер"], ТекстЗапроса);

КонецФункции // ()

#КонецОбласти

Функция НайтиМаксИД(Ответ)

	Состояние = Новый Структура;
	Состояние.Вставить("Позиция", 0);
	Состояние.Вставить("Ответ", Ответ);
	
	МаксимальныйИД = 0;
	Пока ЕстьСледующий(Состояние) Цикл

		Темп = Следующий(Состояние);

		ИДОбновления = Темп.Получить("update_id");
		
		МаксимальныйИД = Макс(МаксимальныйИД, ИДОбновления);
	
	КонецЦикла;
	
	Возврат МаксимальныйИД;

КонецФункции // ()

#КонецОбласти


