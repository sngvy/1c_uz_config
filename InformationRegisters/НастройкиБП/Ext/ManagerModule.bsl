﻿
Функция ПолучитьСхемуПоОперации(Организация, Подразделение, Операция) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НастройкиБП.Схема
	                      |ИЗ
	                      |	РегистрСведений.НастройкиБП КАК НастройкиБП
	                      |ГДЕ
	                      |	НастройкиБП.Организация = &Организация
	                      |	И (НастройкиБП.Подразделение = &Подразделение
	                      |			ИЛИ НастройкиБП.Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка))
	                      |	И НастройкиБП.Операция = &Операция
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НастройкиБП.Подразделение УБЫВ");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Операция", Операция);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат.Схема;
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		               |	НастройкиБП.Схема,
		               |	НастройкиБП.Подразделение
		               |ИЗ
		               |	РегистрСведений.НастройкиБП КАК НастройкиБП
		               |ГДЕ
		               |	НастройкиБП.Организация = &Организация
		               |	И НастройкиБП.Операция = &Операция";
		Таблица = Запрос.Выполнить().Выгрузить();
		Если Таблица.Количество() = 1 Тогда
			Подразделение = Таблица[0].Подразделение;
			Возврат Таблица[0].Схема;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
КонецФункции


Функция ЗаполнитьДанныеДляЗапускаСВыбраннойСтадии(ЗапускБП, Операция) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	КартыМаршрутовСтадии.Ссылка КАК Ссылка,
	                      |	КартыМаршрутовСтадии.НомерСтроки КАК НомерСтроки,
	                      |	КартыМаршрутовСтадии.Идентификатор КАК Идентификатор,
	                      |	КартыМаршрутовСтадии.Наименование КАК Наименование,
	                      |	КартыМаршрутовСтадии.ВидСтадии КАК ВидСтадии,
	                      |	КартыМаршрутовСтадии.Операция КАК Операция,
	                      |	КартыМаршрутовСтадии.Исполнитель КАК Исполнитель,
	                      |	КартыМаршрутовСтадии.Стадия КАК Стадия,
	                      |	КартыМаршрутовСтадии.ЗапретСтарта КАК ЗапретСтарта
	                      |ИЗ
	                      |	Справочник.КартыМаршрутов.Стадии КАК КартыМаршрутовСтадии
	                      |ГДЕ
	                      |	КартыМаршрутовСтадии.Операция = &Операция");
	Запрос.УстановитьПараметр("Операция", Операция);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		ТСИсполнитель = Результат.Исполнитель;
		ТСОбъектРодитель = "";
		ТССхема = Результат.Ссылка;
		ТСТипМероприятия = Результат.Стадия;
		ТСТочка = Результат.Идентификатор;
		
		ТСМассив = Новый ТаблицаЗначений;
		ТСМассив.Колонки.Добавить("Идентификатор");
		ТСМассив.Колонки.Добавить("ОбъектРодитель");
		ТСМассив.Колонки.Добавить("Схема");
		Стр = ТСМассив.Добавить();
		Стр.Идентификатор = ТСТочка;
		Стр.ОбъектРодитель = ТСОбъектРодитель;
		Стр.Схема = ТССхема;
		
		//ЗапускБП = Документы.ЗапускБП.СоздатьДокумент();
		//Стр = Новый Структура("Идентификатор, ОбъектРодитель, Схема", ТСТочка, ТСОбъектРодитель, ТССхема);
		//ТСМассив.Добавить(Стр);
		МассивДанных = Новый Структура("ТСИсполнитель, ТСОбъектРодитель, ТССхема, ТСТипМероприятия, ТСТочка, ТСМассив", 
			ТСИсполнитель, ТСОбъектРодитель, ТССхема, ТСТипМероприятия, ТСТочка, ТСМассив);          
		ЗапускБП.Схема = ТССхема;
		ЗапускБП.Подразделение = ТССхема.Подразделение;
		ЗапускБП.ПоместитьВХранилище(МассивДанных);
		ЗапускБП.ТССтартоватьСВыбраннойСтадии = Истина;
		ЗапускБП.ТСПуть = ТССхема.Наименование;
		ЗапускБП.ТСМероприятие = Операция.Наименование; 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Процедура ДобавитьСоответствие(Схема, Операция) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НастройкиБП.Схема
	                      |ИЗ
	                      |	РегистрСведений.НастройкиБП КАК НастройкиБП
	                      |ГДЕ
	                      |	НастройкиБП.Операция = &Операция");
	Запрос.УстановитьПараметр("Операция", Операция);
	Если Запрос.Выполнить().Пустой() Тогда
		Набор = РегистрыСведений.НастройкиБП.СоздатьМенеджерЗаписи();		
		//Набор.Организация = Операция.Организация;
		//Набор.Подразделение = Операция.Подразделение;
		Набор.Операция = Операция;
		Набор.Схема = Схема;
		Набор.Записать();
	КонецЕсли;
КонецПроцедуры
