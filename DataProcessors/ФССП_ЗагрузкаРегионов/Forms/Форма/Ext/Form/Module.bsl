﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
	ЗначениеОбъект.ЗаполнитьНомераСтолбцов();
	ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УбратьВидимостьКолонок();
КонецПроцедуры


#Область СчитатьФайл

&НаКлиенте
Функция ОбщаяЗагрузкаНачало()

	Если Не ДоступностьЗагрузки() Тогда
	
		СообщениеПользователю("Не выбраны файлы!");
		Возврат Ложь;
	
	КонецЕсли;
	СообщениеПользователю("Начало загрузки");
	
	Возврат Истина;

КонецФункции // ()

&НаКлиенте
Функция ОбщаяЗагрузкаКонец(Контроллер)

	Если Контроллер["Ошибка"] <> Неопределено Тогда
	
		СообщениеПользователю("Не корректный файл");
		СообщениеПользователю(Контроллер["Ошибка"]);
		СообщениеПользователю("Конец загрузки");
		Возврат Ложь;
	
	КонецЕсли;
	
	Ожидатор = УправлениеОжиданиемПотоков;
	
	Если Ожидатор.ВПотокеОшибки(Контроллер) Тогда
	
		СообщениеПользователю(
			"Произошла ошибка при загрузке: " + Ожидатор.ТекстОшибки(Контроллер)
		);
		Возврат Ложь;
	
	КонецЕсли;

	ПараметрыОтображения = Новый Структура;
	ПараметрыОтображения.Вставить("Сообщение", "Идет загрузка ...");

	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ВыполнитьПослеОкончания",
		ЭтаФорма,
		Контроллер
	);
	ПараметрыОтображения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	Описание = Ожидатор.ОписаниеПользовательскогоОтображения(ЭтаФорма, ПараметрыОтображения);
	
	Ожидатор.ОжидатьЗавершение(Контроллер, Описание);

КонецФункции // ()

&НаКлиенте
Процедура ЗагрузитьПриставов(Команда)
	
	Начало = ОбщаяЗагрузкаНачало();
	Если Не Начало Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ДанныеЗагрузки = Новый Структура;
	ДанныеЗагрузки.Вставить("МетодЗагрузки", "Обработки.ФССП_ЗагрузкаРегионов.ЗагрузитьДанныеПриставовВФоне");
	
	НомераКолонок = Новый Структура;
	НомераКолонок.Вставить("КодРегиона", Объект.КодРегиона);
	НомераКолонок.Вставить("НаименованиеОСП", Объект.НаименованиеОСП);
	НомераКолонок.Вставить("Должность", Объект.Должность);
	НомераКолонок.Вставить("ФИО", Объект.ФИО);
	НомераКолонок.Вставить("РабочийТелефон1", Объект.РабочийТелефон1);
	
	ДанныеЗагрузки.Вставить("НомераКолонок", НомераКолонок);
	
	Контроллер = ПередатьНаСервер(ДанныеЗагрузки);
	
	ОбщаяЗагрузкаКонец(Контроллер);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьССП(Команда)

	Начало = ОбщаяЗагрузкаНачало();
	Если Не Начало Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ДанныеЗагрузки = Новый Структура;
	ДанныеЗагрузки.Вставить("МетодЗагрузки", "Обработки.ФССП_ЗагрузкаРегионов.ЗагрузитьДанныеССПВФоне");
	
	НомераКолонок = Новый Структура;
	НомераКолонок.Вставить("КодРегиона", Объект.КодРегиона);
	НомераКолонок.Вставить("КодАгенства", Объект.КодАгенства);
	НомераКолонок.Вставить("НаименованиеОСП", Объект.НаименованиеОСП);
	НомераКолонок.Вставить("ПочтовыйАдрес", Объект.ПочтовыйАдрес);
	НомераКолонок.Вставить("Руководитель", Объект.Руководитель);
	НомераКолонок.Вставить("РабочийТелефон1", Объект.РабочийТелефон1);
	НомераКолонок.Вставить("Факс", Объект.Факс);
	НомераКолонок.Вставить("РабочийТелефон2", Объект.РабочийТелефон2);
	НомераКолонок.Вставить("РабочийТелефон3", Объект.РабочийТелефон3);
	НомераКолонок.Вставить("ГрафикРаботы", Объект.ГрафикРаботы);
	НомераКолонок.Вставить("Территория", Объект.Территория);

	ДанныеЗагрузки.Вставить("НомераКолонок", НомераКолонок);
	
	Контроллер = ПередатьНаСервер(ДанныеЗагрузки);
	
	ОбщаяЗагрузкаКонец(Контроллер);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)

	Начало = ОбщаяЗагрузкаНачало();
	Если Не Начало Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ДанныеЗагрузки = Новый Структура;
	ДанныеЗагрузки.Вставить("МетодЗагрузки", "Обработки.ФССП_ЗагрузкаРегионов.ЗагрузитьДанныеРегионаВФоне");
	
	НомераКолонок = Новый Структура;
	НомераКолонок.Вставить("КодРегиона", Объект.КодРегиона);
	НомераКолонок.Вставить("ИмяРегиона", Объект.НаименованиеРегиона);
	
	ДанныеЗагрузки.Вставить("НомераКолонок", НомераКолонок);
	
	Контроллер = ПередатьНаСервер(ДанныеЗагрузки);
	
	ОбщаяЗагрузкаКонец(Контроллер);

КонецПроцедуры

&НаКлиенте
Функция ВыполнитьПослеОкончания(Результат, Параметры) Экспорт

	УдалитьВременныеФайлы(Параметры);
	
	ТекстСообщения = "Готово";
	Если Результат = Неопределено Тогда
	
		ТекстСообщения = "Прекращена загрузка";
	
	ИначеЕсли Результат["Статус"] = "Ошибка" Тогда
	
		ТекстСообщения = Результат["КраткоеПредставлениеОшибки"];
	
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();

КонецФункции // ()

&НаСервере
Функция УдалитьВременныеФайлы(Параметры)

	ИмяТабличногоДокумента = Параметры["ИмяТабличногоДокумента"];
	ФайловаяСистема.УдалитьВременныйФайл(ИмяТабличногоДокумента);

КонецФункции // ()

&НаСервере
Функция ПередатьНаСервер(ДанныеЗагрузки = Неопределено)

	Загрузчик = УправлениеЗагрузкойСервер;
	
	ДанныеТабличногоДокумента = Новый Структура;
	ЗаполнитьДанныеФайла(ДанныеТабличногоДокумента, ФайлИмпорта, Истина);
	ДанныеТабличногоДокумента.Вставить("Адрес", АдресФайлИмпорта);
	Ответ = ПолучитьВременныйФайл(ДанныеТабличногоДокумента);
	Если Ответ["Ошибка"] <> Неопределено Тогда
	
		Возврат Ответ;
	
	КонецЕсли;
	ИмяТабличногоДокумента = Ответ["ИмяФайла"];
	ДанныеТабличногоДокумента.Вставить("Имя", ИмяТабличногоДокумента);
	
	Результат = ЗагрузитьНаСервере(ДанныеТабличногоДокумента, ДанныеЗагрузки);
	Результат.Вставить("ИмяТабличногоДокумента", ИмяТабличногоДокумента);
	
	Возврат Результат;

КонецФункции // ()

&НаСервере
Функция ЗагрузитьНаСервере(ДанныеТабличногоДокумента, ДанныеЗагрузки)

	Управлятор = УправлениеПотоками;
	
	Поток = Управлятор.Создать(
		ДанныеЗагрузки["МетодЗагрузки"],
		ЭтаФорма.УникальныйИдентификатор
	);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеТабличногоДокумента", ДанныеТабличногоДокумента);
	ПараметрыПроцедуры.Вставить("НомераКолонок", ДанныеЗагрузки["НомераКолонок"]);
	
	Поток = Управлятор.УстановитьПараметры(Поток, ПараметрыПроцедуры);
	
	Контроллер = Управлятор.Запустить(Поток);
	
	Возврат Контроллер;

КонецФункции // ()

&НаКлиенте
Асинх Процедура ФайлИмпортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Ответ = Ждать ВыборТипаФайла();

	Чтец = УправлениеЧтениеФайловКлиент;
	Попытка
	
		ОписаниеФайла = Ждать Чтец.ВыбратьИПоместитьНаСерверТабличныйДокумент(ЭтаФорма.УникальныйИдентификатор);
	
	Исключение
		СообщениеПользователю("Операция не удалась: " + ОписаниеОшибки());
		ОчиститьДанныеФайла();
		Возврат;
	КонецПопытки;
	
	Если ОписаниеФайла = Неопределено Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ЗаполнитьКолонкиПоОтвету(Ответ);
	
	АдресФайлИмпорта = ОписаниеФайла["Адрес"];
	ФайлИмпорта = ОписаниеФайла["СсылкаНаФайл"]["Имя"];
	
	Результат = ЗаполнитьИзАрхива();
	// ФайловаяСистема.УдалитьВременныйФайл(Результат["ИмяФайла"]);
	СообщениеПользователю(Результат["Сообщение"]);
	
КонецПроцедуры

#КонецОбласти

#Область Настройки

&НаКлиенте
Функция ПолучитьКнопки()

	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Регионы", "Файл Регионов");
	Кнопки.Добавить("ССП", "Файл служб судебных приставов");
	Кнопки.Добавить("Приставы", "Файл приставов");
	Кнопки.Добавить("Отмена", "Отмена");
	
	Возврат Кнопки;

КонецФункции // ()

&НаКлиенте
Процедура ЗаполнитьКолонкиПоОтвету(Ответ)

	Если Ответ = "Отмена" Тогда
	
		Возврат;
	
	КонецЕсли;
	
	НастроитьПользовательскоеОтображение(Ответ);
	
	Если Ответ = "Регионы" Тогда
	
		КолонкиРегионов();
		Возврат;
	
	ИначеЕсли Ответ = "ССП" Тогда
	
		КолонкиССП();
		Возврат;
	
	ИначеЕсли Ответ = "Приставы" Тогда
	
		КолонкиПриставов();
		Возврат;
	
	Иначе
	
		ВызватьИсключение "Непредвиденная ошибка";
	
	КонецЕсли;
	
	СообщениеПользователю("Настройки для: " + Ответ);

КонецПроцедуры

&НаКлиенте
Процедура УбратьВидимостьКолонок()

	Элементы.ГруппаРегионы.Видимость = Ложь;
	Элементы.ГруппаОСП.Видимость = Ложь;
	Элементы.ГруппаТелефон1.Видимость = Ложь;
	Элементы.ГруппаССП.Видимость = Ложь;
	Элементы.ГруппаПриставы.Видимость = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура НастроитьПользовательскоеОтображение(Ответ)

	УбратьВидимостьКолонок();
	
	Если Ответ = "Регионы" Тогда
	
		Элементы.ГруппаРегионы.Видимость = Истина;
		Возврат;
	
	ИначеЕсли Ответ = "ССП" Тогда
	
		Элементы.ГруппаОСП.Видимость = Истина;
		Элементы.ГруппаТелефон1.Видимость = Истина;
		Элементы.ГруппаССП.Видимость = Истина;
		Возврат;
	
	ИначеЕсли Ответ = "Приставы" Тогда
	
		Элементы.ГруппаОСП.Видимость = Истина;
		Элементы.ГруппаТелефон1.Видимость = Истина;
		Элементы.ГруппаПриставы.Видимость = Истина;
		Возврат;
	
	Иначе
	
		ВызватьИсключение "Непредвиденная ошибка";
	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КолонкиРегионов()

	Объект.КодРегиона = 1;
	Объект.НаименованиеРегиона = 2;

КонецПроцедуры

&НаКлиенте
Процедура КолонкиПриставов()

	Объект.КодРегиона = 1;
	Объект.НаименованиеОСП = 2;
	Объект.Должность = 3;
	Объект.ФИО = 4;
	Объект.РабочийТелефон1 = 6;

КонецПроцедуры

&НаКлиенте
Процедура КолонкиССП()

	Объект.КодРегиона = 1;
	Объект.КодАгенства = 2;
	Объект.НаименованиеОСП = 3;
	Объект.ПочтовыйАдрес = 4;
	Объект.Руководитель = 5;
	Объект.РабочийТелефон1 = 6;
	Объект.Факс = 7;
	Объект.РабочийТелефон2 = 8;
	Объект.РабочийТелефон3 = 9;
	Объект.ГрафикРаботы = 10;
	Объект.Территория = 11;

КонецПроцедуры

#КонецОбласти

#Область Вспомогательный

&НаКлиенте
Асинх Функция ВыборТипаФайла()

	Кнопки = ПолучитьКнопки();

	Обещание = ВопросАсинх(
		"Какой файл загружаем?",
		Кнопки,
		,
		,
		"Настройки колонок по умолчанию"
	);
	
	Возврат Обещание;

КонецФункции



&НаСервере
Функция ПолучитьВременныйФайл(ДанныеФайла)

	Загрузчик = УправлениеЗагрузкойСервер;
	
	ИмяФайла = Загрузчик.ЗадатьИмяВременногоФайла(ДанныеФайла);
	
	Ответ = Новый Структура;
	Ответ.Вставить("Ошибка", Неопределено);
	Ответ.Вставить("ИмяФайла", Неопределено);
	
	Попытка
	
		ИмяФайла = Загрузчик.ЗаполнитьВременныйФайлПоАдресуВХранилище(
			ИмяФайла,
			ДанныеФайла["Адрес"]
		);
	
	Исключение
		ФайловаяСистема.УдалитьВременныйФайл(ИмяФайла);
		Ответ.Вставить("Ошибка", ОписаниеОшибки());
		Возврат Ответ;
	КонецПопытки;
	
	Ответ.Вставить("ИмяФайла", ИмяФайла);
	
	Возврат Ответ;

КонецФункции // ()

&НаКлиенте
Функция ДоступностьЗагрузки()

	Возврат ЗначениеЗаполнено(АдресФайлИмпорта) И ЗначениеЗаполнено(АдресФайлИмпорта);

КонецФункции // ()

&НаКлиенте
Процедура ОчиститьДанныеФайла()

	ФайлИмпорта = Неопределено;
	АдресФайлИмпорта = Неопределено;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьДанныеФайла(Данные, ПутьФайла, ТолькоРасширение = Ложь)

	Файл = Новый Файл(ПутьФайла);
	Если Не ТолькоРасширение Тогда
	
		Данные.Вставить("Имя", Файл.ИмяБезРасширения);
	
	КонецЕсли;
	Данные.Вставить("Расширение", Файл.Расширение);
	
	Возврат Истина;

КонецФункции // ()

&НаСервере
Функция ЗаполнитьИзАрхива()

	ДанныеТабличногоДокумента = Новый Структура;
	ЗаполнитьДанныеФайла(ДанныеТабличногоДокумента, ФайлИмпорта, Истина);
	ДанныеТабличногоДокумента.Вставить("Адрес", АдресФайлИмпорта);
	Ответ = ПолучитьВременныйФайл(ДанныеТабличногоДокумента);
	Если Ответ["Ошибка"] <> Неопределено Тогда
	
		Ответ.Вставить("Сообщение", Ответ["Ошибка"]);
		Возврат Ответ;
	
	КонецЕсли;
	
	Попытка
	
		ПолеИсходнойТаблицы = УправлениеЗагрузкойСервер.ПолучитьТабличныйДокументИзФайлаХранилища(
			Ответ["ИмяФайла"]
		);
	
	Исключение
		ФайловаяСистема.УдалитьВременныйФайл(Ответ["ИмяФайла"]);
		Ответ.Вставить("Ошибка", ОписаниеОшибки());
		Ответ.Вставить("Сообщение", "Ошибка при востановлении файла: " + ОписаниеОшибки());
		Возврат Ответ;
	КонецПопытки;
	
	Ответ.Вставить("Сообщение", "Выведена таблица");
	ФайловаяСистема.УдалитьВременныйФайл(Ответ["ИмяФайла"]);
	Возврат Ответ;

КонецФункции

&НаКлиенте
Процедура СообщениеПользователю(ТекстСообщения)

	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();

КонецПроцедуры





#КонецОбласти

#Область НаУдаление

//&НаКлиенте
//Асинх Процедура ПрочитатьФайлСКлиента()

//	ДанныеПрочитанногоФайла = Неопределено;
//	Попытка
//	
//		ДанныеПрочитанногоФайла = Ждать УправлениеЗагрузкойКлиент.ИмпортироватьФайл(ЭтаФорма.УникальныйИдентификатор);
//	
//	Исключение
//		Сообщение = Новый СообщениеПользователю;
//		Сообщение.Текст = ОписаниеОшибки();
//		Сообщение.Сообщить();
//	КонецПопытки;
//	
//	Если НЕ ЗначениеЗаполнено(ДанныеПрочитанногоФайла) Тогда
//	
//		Возврат;
//	
//	КонецЕсли;
//	
//	ПолеИсходнойТаблицы = ДанныеПрочитанногоФайла["ТабличныйДокумент"];
//	ФайлИмпорта = ДанныеПрочитанногоФайла["ПутьФайлаНаКлиенте"];

//КонецПроцедуры

//&НаКлиенте
//Процедура ФайлИмпортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	
//	ПрочитатьФайлСКлиента();
//	
//КонецПроцедуры

//&НаСервере
//Процедура ЗагрузитьНаСервере()
//	НачатьТранзакцию();
//	Попытка
//		ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
//		ЗначениеОбъект.ЗагрузитьДанные(ПолеИсходнойТаблицы, Ложь);
//		ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
//		Сообщить("Загрузка успешно выполнена!");
//		ЗафиксироватьТранзакцию();
//	Исключение
//		Сообщить("При загрузке данных произошла ошибка!");
//		Сообщить(ОписаниеОшибки());
//		ОтменитьТранзакцию();
//	КонецПопытки;
//КонецПроцедуры

//&НаКлиенте
//Процедура Загрузить(Команда)
//	ЗагрузитьНаСервере();
//КонецПроцедуры


//&НаСервере
//Процедура ЗагрузитьНаСервере()
//	НачатьТранзакцию();
//	Попытка
//		ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
//		ЗначениеОбъект.ЗагрузитьДанные(ПолеИсходнойТаблицы, Ложь);
//		ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
//		Сообщить("Загрузка успешно выполнена!");
//		ЗафиксироватьТранзакцию();
//	Исключение
//		ОтменитьТранзакцию();
//		Сообщить("При загрузке данных произошла ошибка!");
//		Сообщить(ОписаниеОшибки());
//	КонецПопытки;

//КонецПроцедуры

#КонецОбласти

