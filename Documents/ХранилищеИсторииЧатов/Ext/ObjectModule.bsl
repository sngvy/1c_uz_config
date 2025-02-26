﻿#Область ПрограммныйИнтерфейс

Функция НастройкиПоУмолчанию() Экспорт

	Дата = ТекущаяДатаСеанса();
	
	ДополнительныеСвойства.Вставить("ЗакрытьСессию", Ложь);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция НастройкаСохранения(Значение) Экспорт

	НастройкаСохранения = Значение;
	
	ДополнительныеСвойства.Вставить("Настройщик", НастройкаСохранения.ПолучитьОбъект());
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция Клиент(Значение) Экспорт

	Клиент = Значение;
	
	ДополнительныеСвойства.Вставить("ИмяАкаунта", ИмяАкаунта);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция Сообщение(Значение) Экспорт

	ДатаСообщения = Значение["Дата"];

	Если Не ЗначениеЗаполнено(ДатаСообщения) Тогда
	
		ВызватьИсключение
			"Не удалось сохранить историю:
			|Не указана дата сообщения";
	
	КонецЕсли;
	
	Мессенджер = Значение["Мессенджер"];
	
	ВладелецЧата = Значение["Клиент"];
	Данные = РегистрыСведений.ИдентификаторыЧатовТелеграм
		.ДанныеАкаунта(ВладелецЧата);
	
	Если ЗначениеЗаполнено(Данные) Тогда
	
		ИмяАкаунта = Данные["ИмяАкаунта"];
	
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Сообщение", Значение);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция ЗакрытьСессию() Экспорт

	ДополнительныеСвойства.Вставить("ЗакрытьСессию", Истина);
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Процедура Сохранить() Экспорт

	Настройщик = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("Настройщик", Настройщик)
		Или Настройщик = Неопределено Тогда
	
		ВызватьИсключение
			"Не удалось сохранить историю:
			|Не выбрана настройка сохранения";
	
	КонецЕсли;

	Сообщение = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("Сообщение", Сообщение)
		Или Сообщение = Неопределено Тогда
	
		ВызватьИсключение
			"Не удалось сохранить историю:
			|Не передано сообщение";
	
	КонецЕсли;
	
	Клиент(Сообщение["Отправитель"]);
	Если Не ЗначениеЗаполнено(Клиент) Тогда
	
		МодульНастройщика = УправлениеМетаданными
			.МенеджерОбъектаПоСсылке(НастройкаСохранения);
		ИмяАкаунта = МодульНастройщика.ИмяАкаунтаОтправителя(Сообщение["ОписаниеОтправителя"]);
	
	КонецЕсли;
	
	Настройщик.ЗаписьТекстаСообщения(Сообщение);
	
	Настройщик.ЗаписьФайлыСообщения(Сообщение);

	НачатьТранзакцию();
	
	Попытка
	
		Записать(РежимЗаписиДокумента.Проведение);
		
		Настройщик.ЗаписьИдентификатораДокумента(
			Сообщение["ОписаниеОтправителя"],
			Ссылка);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		ОтменитьТранзакцию();
		Настройщик.ЗаписьОшибкаСохраненияВБазе(Сообщение);
		ВызватьИсключение СтрШаблон(
			"Проблемы с записью файла идентификации: %",
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

Процедура Перезаписать() Экспорт

	Настройщик = НастройкаСохранения.ПолучитьОбъект();
	
	Данные = РегистрыСведений.ИдентификаторыЧатовТелеграм
		.ДанныеАкаунта(Клиент);
	Если Не ЗначениеЗаполнено(Данные) Тогда
	
		ВызватьИсключение СтрШаблон(
			УправлениеСтроками.Шаблон("По Клиенту {} не нашлись данные акаунта {}"),
			Клиент,
			Мессенджер);
	
	КонецЕсли;
	
	ОписаниеОтправителя = Новый Структура;
	ОписаниеОтправителя.Вставить("ИмяАкаунта", Данные["ИмяАкаунта"]);
	ОписаниеОтправителя.Вставить("ИД", Данные["Идентификатор"]);
	
	Настройщик.УбратьОтметкуНовый(Мессенджер, ОписаниеОтправителя);
	
	ДополнительныеСвойства.Вставить("Изменяемый", Истина);
	
	Записать(РежимЗаписиДокумента.Проведение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Клиент) Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Изменяемый = Неопределено;
	Если ДополнительныеСвойства.Свойство("Изменяемый", Изменяемый)
		И Изменяемый Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
	
		Отказ = Истина;
		Возврат;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	ВладелецЧата = Неопределено;
	Если Клиент <> Неопределено Тогда
	
		ВладелецЧата = УправлениеМетаданными.МенеджерОбъектаПоСсылке(Клиент)
			.ВладелецМесенджера(Клиент);
	
	КонецЕсли;
	
	// регистр ЧатСессииСКлиентом
	Движения.ЧатСессииСКлиентом.Записывать = Истина;
	Движение = Движения.ЧатСессииСКлиентом.Добавить();
	Движение.Период = ДатаСообщения;
	Движение.Клиент = Клиент;
	Движение.Закрытие = НадоЗакрытьСессию();
	Движение.Сессия = ОпределитьНомерСессии();

	// регистр ХранилищеИсторииЧатов
	Движения.ХранилищеИсторииЧатов.Записывать = Истина;
	Движение = Движения.ХранилищеИсторииЧатов.Добавить();
	Движение.Период = ДатаСообщения;
	Движение.Клиент = Клиент;
	Движение.Мессенджер = Мессенджер;
	Движение.НастройкаСохранения = НастройкаСохранения;
	Движение.ИмяАкаунта = ИмяАкаунта;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НадоЗакрытьСессию()

	ЗакрытьСессию = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ЗакрытьСессию", ЗакрытьСессию) Тогда
	
		ЗакрытьСессию = Истина;
	
	КонецЕсли;
	
	Возврат ЗакрытьСессию;

КонецФункции // ()

Функция ОпределитьНомерСессии()

	Возврат РегистрыСведений.ЧатСессииСКлиентом.НовыйНомерСессии(Клиент);

КонецФункции // ()


#КонецОбласти