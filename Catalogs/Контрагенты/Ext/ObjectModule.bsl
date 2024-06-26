﻿
#Область ПрограммныйИнтерфейс

#Область СозданиеЭлемента

Функция ЗаполнитьПоУмолчанию() Экспорт

	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	Организация = ТекущийПользователь.Организация;
	ДатаСоздания = ТекущаяДатаСеанса();
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция Наименование(Значение) Экспорт

	Наименование = Значение;
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция ТипКонтрагента(Значение) Экспорт

	ЮрФизЛицо = Значение;
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция КодКонтрагента(Значение) Экспорт

	КодКонтрагента = Значение;
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция ДатаРождения(Значение = Неопределено) Экспорт

	ДополнительныеСвойства.Вставить("ДатаРождения", Значение);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция СоставляющаяКода(Значение) Экспорт

	ЧастиКода = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ЧастиКода", ЧастиКода) Тогда
	
		ЧастиКода = Новый Массив;
	
	КонецЕсли;
	ЧастиКода.Добавить(Значение);
	
	ДополнительныеСвойства.Вставить("ЧастиКода", ЧастиКода);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция Собрать() Экспорт

	Если Не ПроверитьЗаполнение() Тогда
	
		ВызватьИсключение УправленияСообщениями.ПредупреждениеОбПользовательскойОшибке(
			"Не заполнены необходимые реквизиты"
		);
	
	КонецЕсли;
	
	КонтрольКодКонтрагента();
	КонтрольФИО();
	
	Записать();
	
	Возврат Ссылка;

КонецФункции // ()

Функция Получить() Экспорт

	НовыйКонтрагент = Скопировать();
	ДатаРождения = Неопределено;
	Если ДополнительныеСвойства.Свойство("ДатаРождения", ДатаРождения) Тогда
	
		НовыйКонтрагент.ДатаРождения(ДатаРождения);
	
	КонецЕсли;
	
	ЧастиКода = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ЧастиКода", ЧастиКода) Тогда
	
		ЧастиКода = Новый Массив;
	
	КонецЕсли;
	Для каждого ЧастьКода Из ЧастиКода Цикл
	
		НовыйКонтрагент.СоставляющаяКода(ЧастьКода);
	
	КонецЦикла;
	
	Возврат НовыйКонтрагент.Собрать();

КонецФункции // ()

#КонецОбласти

// Процедура проверяет наличие двойников в справочники Должники.
Процедура ПроверкаДвойников() Экспорт
	//Проверка двойников 
		
	////СхожийДолжник = Справочники.Контрагенты.НайтиПоНаименованию(СокрЛП(Наименование));
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Должники.Ссылка
	//	|ИЗ
	//	|	Справочник.Должники КАК Должники
	//	|ГДЕ
	//	|	Должники.Наименование = &Наименование
	//	|	И НЕ Должники.Код = &Код";
	//Запрос.УстановитьПараметр("Наименование",СокрЛП(Наименование));
	//Запрос.УстановитьПараметр("Код",Код);
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	НаборЗаписиДвойники = РегистрыСведений.Двойники.СоздатьМенеджерЗаписи();
	//	НаборЗаписиДвойники.Наименование = СокрЛП(Наименование);
	//	НаборЗаписиДвойники.Должник1 = Ссылка;
	//	НаборЗаписиДвойники.Должник2 = Выборка.Ссылка;
	//	НаборЗаписиДвойники.Записать();
	//	ВыдатьСообщение(Ссылка,"Должник " + Наименование + " возможно имеет двойника в базе.");		
	//КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
	
		Если Не ЗначениеЗаполнено(ЭтотОбъект[ПроверяемыйРеквизит]) Тогда
		
			Отказ = Истина;
		
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события "ОбработкаЗаполнения".
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ОсновнойМенеджер = ПараметрыСеанса.ТекущийПользователь;
	ДатаРегистрации = ТекущаяДатаСеанса();

	// Выполним заполнение контактной информации
	//УправлениеКонтактнойИнформацией.ОбработкаЗаполненияКИ(ЭтотОбъект, ДанныеЗаполнения);

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И ДанныеЗаполнения.Свойство("Наименование") Тогда

			//создание из взаимодействия по описанию участника
			Наименование = ДанныеЗаполнения.Наименование;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
	
		Возврат;
	
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЭтотОбъект.ДатаСоздания) Тогда
		ЭтотОбъект.ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НаименованиеИзменено = Ложь;
	Если Наименование <> Ссылка.Наименование Тогда
		НаименованиеИзменено = Истина;
	КонецЕсли;
	ДополнительныеСвойства.Вставить("НаименованиеИзменено", НаименованиеИзменено);
	
	Если ЗаполнятьСклонения()
		И ФИОИзменились() Тогда
	
		ДополнительныеСвойства.Вставить("ЗаписатьСклонения", Истина);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "Не удалось записать Контрагента: ";

	НачатьТранзакцию();
	
	Попытка
	
		ЗаполнитьСклонения();
		ОбновитьДолжниковПоДолговымОбязательствам();
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		ОтменитьТранзакцию();
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстОшибки + ОписаниеОшибки();
		Сообщение.Сообщить();
		Возврат;
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область Техническая

Процедура КонтрольКодКонтрагента()

	Если Не ЗначениеЗаполнено(КодКонтрагента) Тогда
	
		ЧастиКода = Неопределено;
		Если Не ДополнительныеСвойства.Свойство("ЧастиКода", ЧастиКода) Тогда
		
			ЧастиКода = Новый Массив;
		
		КонецЕсли;
		
		ДатаРождения = Неопределено;
		Если ДополнительныеСвойства.Свойство("ДатаРождения", ДатаРождения) Тогда
		
			ЧастиКода.Добавить(Формат(ДатаРождения, "ДФ=dd.MM.yyyy; ДП="));
		
		КонецЕсли;
		
		ДанныеДляКода = Новый Массив;
		ДанныеДляКода.Добавить(Наименование);
		Для каждого ЧастьКода Из ЧастиКода Цикл
		
			ДанныеДляКода.Добавить(ЧастьКода);
		
		КонецЦикла;
		
		КодКонтрагента = СтрСоединить(ДанныеДляКода, " ");
		
	КонецЕсли;
	
	КодКонтрагента = СокрЛП(КодКонтрагента);

КонецПроцедуры

Процедура КонтрольФИО()

	РеквизитыФИО = Новый Массив;
	РеквизитыФИО.Добавить("ФИО_Действующее");
	РеквизитыФИО.Добавить("ФИО_ПФ");
	РеквизитыФИО.Добавить("ФИО_Реестр");
	
	Для каждого РеквизитФИО Из РеквизитыФИО Цикл
	
		Если ЗначениеЗаполнено(ЭтотОбъект[РеквизитФИО]) Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		ЭтотОбъект[РеквизитФИО] = Наименование;
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

Функция ФИОИзменились()

	Запрос = Новый Запрос; 
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыФИО.ФИО КАК ФИО
	|ИЗ
	|	Справочник.Контрагенты.ФИО КАК КонтрагентыФИО
	|ГДЕ
	|	КонтрагентыФИО.Ссылка = &Ссылка"; 
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка); 
	
	ФИОДоИзменения = Запрос.Выполнить().Выгрузить(); 
	Если ФИОДоИзменения.Количество() <> ФИО.Количество() Тогда
		
		Возврат Истина;
		
	КонецЕсли;

	НовыеФИО = Новый Соответствие;
	Для каждого Запись Из ФИО Цикл
	
		НовыеФИО.Вставить(Запись.ФИО, Истина);
	
	КонецЦикла;
	
	Для каждого Запись Из ФИОДоИзменения Цикл
	
		ТекущееФИО = НовыеФИО.Получить(Запись.ФИО);
		Если ТекущееФИО = Неопределено Тогда
		
			Возврат Истина;
		
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции // ()

Процедура ДобавитьИменаВОчередь(ИменаВОчередь)

	Для каждого ИмяВОчередь Из ИменаВОчередь Цикл
	
		РегистрыСведений.ОчередьНаСклонениеФИО.ДобавитьИмяВОчередь(
			ЭтотОбъект.Ссылка,
			ИмяВОчередь
		);
	
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнениеСклоненияВФоне()

	Если ЭтоГруппа Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ИменаИзТабличнойЧасти = ЭтотОбъект.ФИО.ВыгрузитьКолонку("ФИО");
	Если ИменаИзТабличнойЧасти.Количество() = 0 Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Управлятор = УправлениеПотоками;
	
	Поток = Управлятор.Создать(
		"Справочники.Контрагенты.ЗаполнитьСклоненияВФоне",
		Новый УникальныйИдентификатор()
	);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Контрагент", ЭтотОбъект.Ссылка);
	ПараметрыЗаписи.Вставить("Имена", ИменаИзТабличнойЧасти);
	Поток = Управлятор.УстановитьПараметры(Поток, ПараметрыЗаписи);
	
	Контроллер = Управлятор.Запустить(Поток);
	Если Управлятор.ПотокЗавершился(Контроллер) Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Счетчик = 0;
	Пока Не Управлятор.ДождатьсяЗавершения(Контроллер, 5) ИЛИ Счетчик < 10 Цикл
	
		Счетчик = Счетчик + 1;
	
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьДолжниковПоДолговымОбязательствам()

	НаименованиеИзменено = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("НаименованиеИзменено", НаименованиеИзменено) Тогда
	
		НаименованиеИзменено = Ложь;
	
	КонецЕсли;
	
	Если Не НаименованиеИзменено Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДолговыеОбязательстваКонтрагенты.Ссылка
	                      |ИЗ
	                      |	Справочник.ДолговыеОбязательства.Контрагенты КАК ДолговыеОбязательстваКонтрагенты
	                      |ГДЕ
	                      |	ДолговыеОбязательстваКонтрагенты.Значение = &Значение
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ДолговыеОбязательстваКонтрагенты.Ссылка");
	Запрос.УстановитьПараметр("Значение", Ссылка);
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		
		Об = Результат.Ссылка.ПолучитьОбъект();
		
		Об.Записать();
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьСклонения()

	ЗаписатьСклонения = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ЗаписатьСклонения", ЗаписатьСклонения) Тогда
	
		ЗаписатьСклонения = Ложь;
	
	КонецЕсли;
	
	Если Не ЗаписатьСклонения Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ЗаписатьВОчередьСклоненийФИО(Ссылка);

КонецПроцедуры

Процедура ЗаписатьВОчередьСклоненийФИО(Контрагент)
	
	РегистрыСведений.ОчередьСклоненийФИО
		.Создать()
		.Контрагент(Контрагент)
		.ОбработатьВФоне()
	;

КонецПроцедуры

Функция ЗаполнятьСклонения()

	ИспользуетсяПарсинг = Константы.ПарсингДокументов.Получить();
	Возврат ИспользуетсяПарсинг
			И ЮрФизЛицо = Справочники.ЮрФизЛицо.ФизЛицо;

КонецФункции // ()
