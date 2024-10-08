﻿////////////////////////////////////////////////////////////////////////////////
// Блок функций - обработчиков событий
//

// Обработчик события "при создании на сервере" формы
// Заполняет таблицу по макету
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуПоМакетуАдресныхОбъектов();
	
КонецПроцедуры

// Обработчик события "выбор" элемента формы АдресныеОбъекты
// Инвертирует флаг выбора адресного объекта
//
&НаКлиенте
Процедура АдресныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Элемент.ТекущиеДанные.Пометка = НЕ Элемент.ТекущиеДанные.Пометка;
КонецПроцедуры

// Обработчик события нажатия на кнопку командной панели
// элемента управления АдресныеОбъекты.
// Устанавливает флаг выбора всем адресным объектам в списке
//
&НаКлиенте
Процедура ВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		ЭлементАдресныйОбъект.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку командной панели
// элемента управления АдресныеОбъекты.
// Снимает флаг выбора у всех адресных объектов в списке
//
&НаКлиенте
Процедура ОтменитьВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		ЭлементАдресныйОбъект.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку "Очистить"
// Проверяет корректность данных и вызывает диалог поддверждения
// очистки адресных сведений.
//
&НаКлиенте
Процедура ОчиститьВыполнить()
	
	ОчиститьСообщения();
	
	Если КоличествоВыделенныхАдресныхОбъектов() = 0 Тогда
		УдалитьОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Необходимо выбрать как минимум один адресный объект'"), ,
					"АдресныеОбъекты");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Адресные сведения по выбранным объектам будут удалены. Вы уверены, что хотите продолжить?'");
	КодВозврата = Неопределено;

	//Чуров
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьВыполнитьЗавершение", ЭтаФорма), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	
	//КодВозврата = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	//
	//Если КодВозврата = КодВозвратаДиалога.ОК Тогда
	//	ОчиститьАдресныеСведения(); 	
	//	Предупреждение(НСтр("ru = 'Адресные сведения успешно удалены'"),,
	//	               НСтр("ru = 'Удаление адресных сведений'"));
	//	Оповестить("ИзменениеАдресногоКлассификатора");
	//	Закрыть(Истина);
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВыполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	КодВозврата = РезультатВопроса;
	
	Если КодВозврата = КодВозвратаДиалога.ОК Тогда
		ОчиститьАдресныеСведения();
		ПоказатьПредупреждение(,НСтр("ru = 'Адресные сведения успешно удалены'"),,
		НСтр("ru = 'Удаление адресных сведений'"));
		Оповестить("ИзменениеАдресногоКлассификатора");
		Закрыть(Истина);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блок сервисных функций
//

// Заполняет переданную таблицу значений по значениям таблицы адресных объектов.
// Выбирается код, наименование и сокращение типа объекта.
//
&НаСервере
Процедура ЗаполнитьТаблицуПоМакетуАдресныхОбъектов()
	
	АдресныеОбъекты.Очистить();
	
	КлассификаторАдресныхОбъектовXML =
	   РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = УдалитьОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		Наименование = Лев(АдресныйОбъект.Code, 2)
		             + " - "
		             + АдресныйОбъект.Name
		             + " "
		             + АдресныйОбъект.Socr;
		
		НоваяСтрока = АдресныеОбъекты.Добавить();
		НоваяСтрока.Пометка             = Ложь;
		НоваяСтрока.НаименованиеАдресногоОбъекта = Наименование;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает количество помеченных адресных объектов
//
&НаКлиенте
Функция КоличествоВыделенныхАдресныхОбъектов()
	
	КоличествоВыделенныхАдресныхОбъектов = 0;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			КоличествоВыделенныхАдресныхОбъектов = КоличествоВыделенныхАдресныхОбъектов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоВыделенныхАдресныхОбъектов;
	
КонецФункции

// Удалает адресные сведения по выбранным адресным объектам
//
&НаСервере
Процедура ОчиститьАдресныеСведения()
	
	// формируем список адресных объектов, для очистки адресных сведений
	
	ВыбранныеАО = Новый Массив;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			ВыбранныеАО.Добавить(Лев(ЭлементАдресныйОбъект.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	УдалитьАдресныйКлассификатор.УдалитьАдресныеСведения(ВыбранныеАО);
	УдалитьАдресныйКлассификатор.ЗагрузитьАдресныеОбъектыПервогоУровня();
	
КонецПроцедуры
