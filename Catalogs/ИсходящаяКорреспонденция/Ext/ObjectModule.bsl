﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
		ОбъектыСервер.ОбработкаЗаполненияДокументов(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	Иначе
		ЭтотОбъект.Объект = ДанныеЗаполнения;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЭтотОбъект.РегистрационныйНомер = "";
	ЭтотОбъект.ДатаРегистрации = Дата(1,1,1);
	ЭтотОбъект.НомерЗакреплен = Ложь;
	ЭтотОбъект.ПрикрепленныеФайлы.Очистить();
	ЭтотОбъект.ПодобранныеФайлы.Очистить();
	ЭтотОбъект.Наименование = "№";
	ЭтотОбъект.Комментарий = "";
	ЭтотОбъект.Автор = "";
КонецПроцедуры

Функция Зарегестрировать(Шаблон, ДанныеРегистрации) Экспорт

	Значение = "";
	Если ДанныеРегистрации.Свойство("Номер", Значение) И ЗначениеЗаполнено(Значение)
		И ДанныеРегистрации.Свойство("Дата", Значение) И ЗначениеЗаполнено(Значение) Тогда
	
		ЭтотОбъект.РегистрационныйНомер = ДанныеРегистрации["Номер"];
		ЭтотОбъект.ДатаРегистрации = ДанныеРегистрации["Дата"];
		ЭтотОбъект.НомерЗакреплен = Истина;
		
		Возврат Истина;
	
	КонецЕсли;

	Возврат Ложь;

КонецФункции // ()

Функция ДобавитьФайл(Шаблон, ДанныеРегистрации) Экспорт

	ДокументПрикрепления = ДанныеРегистрации["ДокументПрикрепление"];
	
	Если ДокументПрикрепления.Файлы.Количество() < 1 Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	ДобавляемыйФайл = ДокументПрикрепления.Файлы[0];
	
	НовСтрока = ЭтотОбъект.ПодобранныеФайлы.Добавить();
	
	Путь = ДобавляемыйФайл.Путь;
	ФайлДляИмени = Новый Файл(Путь);
	НовСтрока.Файл = ФайлДляИмени.Имя;
	НовСтрока.ТипФайла = ДобавляемыйФайл.ТипФайла;
	НовСтрока.Регистратор = ДокументПрикрепления;

	НовСтрока = ЭтотОбъект.ПрикрепленныеФайлы.Добавить();
	НовСтрока.ПрикрепленныйФайл = ДокументПрикрепления;
	
	ЭтотОбъект.Записать();
	
	ДокументОбъект = ДокументПрикрепления.ПолучитьОбъект();
	ДокументОбъект.РегистраторКорреспонденции = ЭтотОбъект.Ссылка;
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	
	Возврат Истина;

КонецФункции // ()

Функция ДанныеРегистрацииЗаполнены()

	Возврат НЕ (ТипПисьма.Пустая() ИЛИ Объект.Пустая());

КонецФункции // ()



