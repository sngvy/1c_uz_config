﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		УстановитьПараметрОтбора("Владелец", Элемент.ТекущаяСтрока);
	Иначе
		УстановитьПараметрОтбора("Владелец", Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрОтбора(Параметр, Значение, Использование = Истина)
	Поле = Новый ПолеКомпоновкиДанных(Параметр);
	
	Для Каждого Элемент Из Категории.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = Поле Тогда
			Элемент.ПравоеЗначение = Значение;
			Элемент.Использование = Использование;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура КатегорииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//Чуров
	//ПоказатьЗначение(,ВыбраннаяСтрока.Владелец);
	ОткрытьЗначение(ВыбраннаяСтрока.Владелец);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
		НовыйЭлемент = СкопироватьОбъект(Элементы.Список.ТекущаяСтрока);	
		//Чуров 
		//ПоказатьЗначение(,НовыйЭлемент);
		ОткрытьЗначение(НовыйЭлемент);
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СкопироватьОбъект(ОбъектКопирвоания)
	ЭтотОбъект = ОбъектКопирвоания.Скопировать();	
	ЭтотОбъект.Записать();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Категории.Код,
	                      |	Категории.Наименование,
	                      |	Категории.ПометкаУдаления,
	                      |	Категории.Используется,
	                      |	Категории.Отбор
	                      |ИЗ
	                      |	Справочник.Категории КАК Категории
	                      |ГДЕ
	                      |	Категории.Владелец = &Владелец
	                      |	И Категории.ПометкаУдаления = ЛОЖЬ");
	Запрос.УстановитьПараметр("Владелец", ОбъектКопирвоания.Ссылка);
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		ЭлементОбъект = Справочники.Категории.СоздатьЭлемент();
		ЭлементОбъект.Владелец = ЭтотОбъект.Ссылка;
		ЭлементОбъект.Используется = Результат.Используется;
		ЭлементОбъект.Наименование = Результат.Наименование;
		ЭлементОбъект.Код = Результат.Код;
		ЭлементОбъект.Отбор = Результат.Отбор;
		ЭлементОбъект.Записать();
	КонецЦикла;	
	Возврат ЭтотОбъект.Ссылка;
КонецФункции
