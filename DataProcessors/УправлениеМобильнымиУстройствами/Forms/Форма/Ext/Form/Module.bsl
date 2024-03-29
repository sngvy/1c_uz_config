﻿
&НаКлиенте
Процедура УзелПриИзменении(Элемент)
	ПоказатьНомераСообщений(Объект.Узел);
КонецПроцедуры

&НаСервере
Процедура ПоказатьНомераСообщений(Узел)
	Принятое = Узел.НомерПринятого;
	Отправленное = Узел.НомерОтправленного
КонецПроцедуры

&НаСервере
Процедура ИзменитьНомераНаСервере()
	Если ЗначениеЗаполнено(Объект.Узел) тогда
		Узел = Объект.Узел.ПолучитьОбъект();
		Узел.НомерОтправленного = Отправленное;
		Узел.НомерПринятого = Принятое;
		Узел.Записать();
		Сообщить("Номера сообщений узла изменены вручную!");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНомера(Команда)
	ИзменитьНомераНаСервере();
КонецПроцедуры

&НаСервере
Процедура очиститьРСНаСервере()
	НаборЗаписей = РегистрыСведений.ТрекСотрудника.СоздатьНаборЗаписей(); // ИмяРегистра например "УчетнаяПолитика", "ЦеныНоменклатуры" и т.д
	НаборЗаписей.Записать();
КонецПроцедуры

&НаКлиенте
Процедура очиститьРС(Команда)
	очиститьРСНаСервере();
КонецПроцедуры

&НаСервере
Процедура УдалитьРегистрациюНаСервере()
	Попытка
		ПланыОбмена.УдалитьРегистрациюИзменений(Объект.Узел);
		ТекстСообщения = "Изменения удалены!";
	Исключение
		ТекстСообщения = "Необходимо выбрать узел мобильного устройства!";
	КонецПопытки;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРегистрацию(Команда)
	УдалитьРегистрациюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПервичнаяРегистрацияОбъектовНаСервере()
	
	//МассивУзлов = Новый Массив;
	//МассивУзлов.Вставить();
	Попытка
		СоставПланаОбмена = Объект.Узел.Метаданные().Состав;
		Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл	
			ПланыОбмена.ЗарегистрироватьИзменения(Объект.Узел,ЭлементСоставаПланаОбмена.Метаданные);
		КонецЦикла;		
		//ПланыОбмена.ЗарегистрироватьИзменения(Объект.Узел,Неопределено);
		СообщениеНастройки = "Для узла зарегистрированы объекты обмена как новые!";
	Исключение
		СообщениеНастройки = "Необходимо выбрать узел мобильного устройства!";
	КонецПопытки;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СообщениеНастройки;
	Сообщение.Сообщить();
КонецПроцедуры


&НаКлиенте
Процедура ПервичнаяРегистрацияОбъектов(Команда)	
	ПервичнаяРегистрацияОбъектовНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИзменитьРегистрациюНаСервере()
	Если ОбъектыВБазе.Количество() = 0 Тогда
		Сообщить("Нужно выбрать хотя бы один объект из базы и указать, что сделать с его регистрацией!");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Узел) ИЛИ Объект.Узел = Планыобмена.Мобильные.ЭтотУзел() Тогда
		Сообщить("Необходимо выбрать узел мобильного устройства!");
		Возврат;
	КонецЕсли;	
	
	Для Каждого Об из ОбъектывБазе Цикл
		Если (Об.Зарегистрировать И Об.Удалить) ИЛИ (НЕ Об.Зарегистрировать И НЕ Об.Удалить) Тогда
			Сообщить("Нет действия " + Строка(Об.Ссылка));
			Продолжить;
		КонецЕсли;
		Если Об.Зарегистрировать И Не Об.Удалить Тогда
			Сообщить("Регистрация " + Строка(Об.Ссылка));
			 ПланыОбмена.ЗарегистрироватьИзменения(Объект.Узел,Об.Ссылка);
		КонецЕсли;	
		Если Не Об.Зарегистрировать И Об.Удалить Тогда
			Сообщить("Удаление " + Строка(Об.Ссылка));
			 ПланыОбмена.УдалитьРегистрациюИзменений(Объект.Узел,Об.Ссылка);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьРегистрацию(Команда)
	ИзменитьРегистрациюНаСервере();
	Если УчитыватьНастройки Тогда
		ЗарегистрироватьОбъектыНастройкиБазы();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьОбъектыНастройкиБазы()
	Попытка
		СоставПланаОбмена = Объект.Узел.Метаданные().Состав;
		Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
			Если ЭтоНастройка(ЭлементСоставаПланаОбмена.Метаданные) Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(Объект.Узел,ЭлементСоставаПланаОбмена.Метаданные);
			КонецЕсли;
		КонецЦикла;
		СообщениеНастройки = "Для узла зарегистрированы настройки как новые объекты!";
	Исключение
		СообщениеНастройки = "Необходимо выбрать узел мобильного устройства!";
	КонецПопытки;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СообщениеНастройки;
	Сообщение.Сообщить();
КонецПроцедуры

&НаСервере
Функция ЭтоНастройка(МД)
	Если МД.Имя = "Категории" ИЛИ МД.Имя = "ТипыДолговыхОбязательств" ИЛИ
		МД.Имя = "ТипыКонтактныхЛицПоДолжнику"
		ИЛИ МД.Имя = "ТипыПрикрепляемыхФайлов" ИЛИ МД.Имя = "ЮрФизЛицо"
		ИЛИ МД.Имя = "ПунктыЧекЛистов" ИЛИ МД.Имя = "НастройкиЧекЛистов" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции



&НаКлиенте
Процедура ОбъектывБазеЗарегистрироватьПриИзменении(Элемент)
	ТекСтрока = Элементы.ОбъектывБазе.ТекущиеДанные;
	Действие = "Регистрация";
	ПроверкаДействий(ТекСтрока,Действие);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектывБазеУдалитьПриИзменении(Элемент)
	ТекСтрока = Элементы.ОбъектывБазе.ТекущиеДанные;
	Действие = "Удаление";
	ПроверкаДействий(ТекСтрока,Действие);
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаДействий(Стр,Действие)
	Если Действие = "Регистрация" Тогда
		Если Стр.Зарегистрировать и Стр.Удалить Тогда
			Стр.Удалить = Ложь;
		КонецЕсли;	
	КонецЕсли;
	Если Действие = "Удаление" Тогда
		 Если Стр.Зарегистрировать и Стр.Удалить Тогда
			Стр.Зарегистрировать = Ложь;
		КонецЕсли;	
	КонецЕсли;		
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьМУПользователя(Команда)
	ОткрытьФорму("ПланОбмена.Мобильные.ФормаСписка"); 
КонецПроцедуры

&НаСервере
Процедура ПодобратьТекущиеОбъектыНаСервере()
	Сотрудник = Объект.Узел.ОтветственныйВыезднойСотрудник;
	Если Не ЗначениеЗаполнено(Сотрудник) тогда
		Сообщить("Нужно выбрать узел обмена");
		Возврат;
	КонецЕсли;
	ОбъектыВБазе.Очистить();
	ОбъектыВРаботеСотрудника = ОбменСМобильнымПриложением.ПолучитьТаблицуРегистрируемыхОбъектов(Сотрудник);
	Для Каждого Стр из ОбъектыВРаботеСотрудника Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Объект;
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Кредитор;
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Должник;
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Контрагент;
	КонецЦикла;
	МаршрутыСотрудника = ОбменСМобильнымПриложением.ПолучитьТаблицуМаршрутов(Сотрудник);
	Для Каждого Стр из МаршрутыСотрудника Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	ОтсутствияСотрудника = ОбменСМобильнымПриложением.ПолучитьТаблицуОтсутствий(Сотрудник);
	Для Каждого Стр из ОтсутствияСотрудника Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	ОбещанныеПлатежиСотрудника = ОбменСМобильнымПриложением.ПолучитьТаблицуОбещанныхПлатежей(ОбъектыВРаботеСотрудника);
	Для Каждого Стр из ОбещанныеПлатежиСотрудника Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	МероприятияСотрудника = ОбменСМобильнымПриложением.ПолучитьТаблицуМероприятий(Сотрудник,ОбъектыВРаботеСотрудника);
	
	Если УчитыватьТолькоВыездныеМероприятия Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		| ТипыВыездныхМероприятий.ТипМероприятия КАК ТипМероприятия
		|ИЗ
		| РегистрСведений.ТипыВыездныхМероприятий КАК ТипыВыездныхМероприятий";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Сч = 0;
		Пока Сч < МероприятияСотрудника.Количество() Цикл
			Мер = МероприятияСотрудника[Сч];
			Удалять = Истина;
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если Мер.Ссылка.типМероприятия = ВыборкаДетальныеЗаписи.ТипМероприятия Тогда
					Удалять = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Удалять тогда
				МероприятияСотрудника.Удалить(Сч);
			Иначе
				Сч = Сч+1;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	Для Каждого Стр из МероприятияСотрудника Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	ТипыМероприятий = ОбменСМобильнымПриложением.ПолучитьТаблицуТиповМероприятий(МероприятияСотрудника);
	Для Каждого Стр из ТипыМероприятий Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	РезультатыМероприятий = ОбменСМобильнымПриложением.ПолучитьТаблицуРезультатов(ТипыМероприятий);
	Для Каждого Стр из РезультатыМероприятий Цикл
		НСтр = ОбъектыВБазе.Добавить();
		Нстр.Ссылка = Стр.Ссылка;
	КонецЦикла;
	Если УчитыватьИсториюФайлов Тогда	
		Если УчитыватьТолькоФайлыДляВыезда Тогда
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТипыФайловДляМобильногоПриложения.ТипФайла КАК ТипФайла
			|ИЗ
			|	РегистрСведений.ТипыФайловДляМобильногоПриложения КАК ТипыФайловДляМобильногоПриложения";
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ТипФайла");
			ПрикрепляемыеФайлы = ОбменСМобильнымПриложением.ПолучитьТаблицуПрикрепляемыхФайловВыезда(ОбъектыВРаботеСотрудника,ВыборкаДетальныеЗаписи);
			
		Иначе
			ПрикрепляемыеФайлы = ОбменСМобильнымПриложением.ПолучитьТаблицуПрикрепляемыхФайлов(ОбъектыВРаботеСотрудника);	
		КонецЕсли;	
		
		Для Каждого Стр из ПрикрепляемыеФайлы Цикл
			НСтр = ОбъектыВБазе.Добавить();
			Нстр.Ссылка = Стр.Ссылка;
		КонецЦикла;
	КонецЕсли;
	ТЗКопия = ОбъектыВБазе.Выгрузить();
	ТЗКопия.Свернуть("Ссылка");
	ОбъектыВБазе.Загрузить(ТЗКопия);
	Сч = ОбъектыВБазе.Количество();
	Пока Сч > 0 Цикл
		Сч = Сч - 1;
		Строка = ОбъектыВБазе[сч];
		Если НЕ ЗначениеЗаполнено(Строка.Ссылка) Тогда
			ОбъектыВБазе.Удалить(Сч);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Об из ОбъектыВБазе Цикл
		Об.Зарегистрировать = Истина;
	КонецЦикла;
КонецПроцедуры
&НаКлиенте
Процедура ПодобратьТекущиеОбъекты(Команда)
	ПодобратьТекущиеОбъектыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьТолькоФайлыДляВыездаПриИзменении(Элемент)
	Если НЕ УчитыватьИсториюФайлов тогда
		УчитыватьИсториюФайлов = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьИсториюФайловПриИзменении(Элемент)
	Если НЕ УчитыватьИсториюФайлов тогда
		УчитыватьТолькоФайлыДляВыезда = Ложь;
	КонецЕсли;	
КонецПроцедуры




