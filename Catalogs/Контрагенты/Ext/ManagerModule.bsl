﻿
#Область ПрограммныйИнтерфейс

Функция Создать() Экспорт

	Объект = СоздатьЭлемент()
		.ЗаполнитьПоУмолчанию()
	;
	
	Возврат Объект;

КонецФункции // ()

Функция СоздатьНаОсновании(Наименование, ТипКонтрагента) Экспорт

	Объект = Создать()
		.Наименование(Наименование)
		.ТипКонтрагента(ТипКонтрагента)
	;
	
	Возврат Объект;

КонецФункции // ()

Функция КонвертироватьЗависимости(Объекты) Экспорт

	Если Объекты.Количество() = 0 Тогда
	
		Возврат Объекты;
	
	КонецЕсли;
	
	ТипОбъектов = ТипЗнч(Объекты[0]);
	Если ТипОбъектов = Тип("СправочникСсылка.Контрагенты") Тогда
	
		Возврат Объекты;
	
	ИначеЕсли ТипОбъектов = Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
	
		Результат = КонвертироватьВДолговыеОбязательства(Объекты);
	
	Иначе
	
		ВызватьИсключение СтрШаблон(
			"Конвертация в Контрагенты из %1 не реализована",
			ТипОбъектов);
	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ()

Функция НайтиЭлемент(Знач КодКонтрагента) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.КодКонтрагента = &КодКонтрагента";
	
	Запрос.УстановитьПараметр("КодКонтрагента", СокрЛП(КодКонтрагента));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	
	КонецЕсли;

	Возврат ПустаяСсылка();

КонецФункции // ()

// Расчитывает минимальную длину фамилии из существующих в системе
//   Значение расчитывается на основании Табличной части ФИО
//
// Возвращаемое значение:
//   Число   - Минимальная длина фамилии
//
Функция МинимальнаяДлинаФамилии() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ДЛИНАСТРОКИ(КонтрагентыФИО.Фамилия)) КАК МинДлина
		|ИЗ
		|	Справочник.Контрагенты.ФИО КАК КонтрагентыФИО";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Возврат ВыборкаДетальныеЗаписи.МинДлина;
		
	КонецЕсли;
	
	Возврат 0;

КонецФункции

Функция ВладелецМесенджера(Элемент) Экспорт

	Возврат Элемент;

КонецФункции // ()

#Область ИдентификацияЭлементов

Функция ПолучитьИдентификатор(Элемент) Экспорт

	Возврат Элемент.УникальныйИдентификатор();

КонецФункции // ()

Функция ПолучитьЭлементПоИдентификатору(Идентификатор) Экспорт

	Возврат РегистрыСведений.ИдентификаторыЧатовТелеграм
		.НайтиОтправителя(Идентификатор);

КонецФункции // ()

Функция ЭтоКлиент() Экспорт

	Возврат Истина;

КонецФункции // ()

#КонецОбласти

#КонецОбласти

#Область Техническая

#Область КонвертацияОбъектов

Функция КонвертироватьВДолговыеОбязательства(ДолговыеОбязательства)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДолговыеОбязательстваКонтрагенты.Значение КАК Значение
		|ИЗ
		|	Справочник.ДолговыеОбязательства.Контрагенты КАК ДолговыеОбязательстваКонтрагенты
		|ГДЕ
		|	ДолговыеОбязательстваКонтрагенты.ВидКонтрагента = Значение(Перечисление.ВидыКонтрагентов.Должник)
		|	И ДолговыеОбязательстваКонтрагенты.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ДолговыеОбязательства);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Значение");

КонецФункции // ()

#КонецОбласти

Функция ОбработатьИмена(ИменаИзТабличнойЧасти)

	НовыеИмена = Новый Массив;
	
	Для каждого Имя Из ИменаИзТабличнойЧасти Цикл
	
		НовоеИмя = ОбработатьИмя(Имя);
		Если Не ЗначениеЗаполнено(НовоеИмя) Тогда
		
			Продолжить;
		
		КонецЕсли;
		НовыеИмена.Добавить(НовоеИмя);
	
	КонецЦикла;
	
	Возврат НовыеИмена;

КонецФункции

Функция ОбработатьИмя(Знач Имя)

	НовоеИмя = СокрЛП(Имя);
	НовоеИмя = ТРег(НовоеИмя);
	НовоеИмя = СтрЗаменить(НовоеИмя, "ё", "е");
	
	Возврат НовоеИмя;

КонецФункции

#КонецОбласти