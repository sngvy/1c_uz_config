﻿
#Область ПрограммныйИнтерфейс

// Обработка текущего модуля
// Работает с файловой системой Клиента/Сервера
//   В зависимости от места вызова
//
// Параметры:
//  Параметры  - Структура - См. ПодготовитьПараметры
//
// Возвращаемое значение:
//   Структура   - Результат обработки
//     Результат - Булево - Успешное завершение
//     Ошибка - Массив - Набор ошибок, если Результат = Ложь
//                     Если Результат = Истина, Может не быть
//     Ответ - - Возвращаемое значение, при Результат = Истина
//                     Если Результат = Ложь, Может не быть
//
Функция Обработать(Параметры) Экспорт

	КаталогоУправлятель = ПарсингДокументовОбщийКлиентСервер;
	ОписаниеКаталогов = Параметры["Каталоги"];
	Попытка
	
		Каталоги = КаталогоУправлятель.СоздатьКаталоги(ОписаниеКаталогов);
	
	Исключение
		ВызватьИсключение УправленияСообщениямиКлиентСервер.ИнструкцияКОшибке(
			"Ошибка обработки каталогов при распозновании изображений",
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;

	Собиратель = УправлениеКонсолью;
	
	КаталогИсполнитель = КаталогоУправлятель.КаталогИсполнитель(Каталоги);
	
	Программа = КаталогоУправлятель.НоваяПрограммаПарсинга(
		КаталогИсполнитель,
		Параметры["Кодировка"]
	);
	
	КаталогИсточник = КаталогоУправлятель.КаталогИсточник(Каталоги);
	КаталогПриемник = КаталогоУправлятель.КаталогПриемник(Каталоги);
	
	ИсполняемыйФайл = Новый Файл(
		КаталогИсполнитель.ПолноеИмя + ПолучитьРазделительПути() + Параметры["ИмяИсполняемогоФайла"]
	);
	Если Не ИсполняемыйФайл.Существует()
		ИЛИ Не ИсполняемыйФайл.ЭтоФайл() Тогда
	
		ВызватьИсключение УправленияСообщениямиКлиентСервер.ИнструкцияКОшибке(
			"Отсутствует файл для распознования изображений",
			СтрШаблон(
				"Проверяемый файл - %1
				|Подробности ошибки: %2",
				ИсполняемыйФайл.ПолноеИмя,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
			)
		);
	
	КонецЕсли;
	
	ВложенныеКаталоги = Параметры["ВложенныеКаталоги"];
	ПараметрВложенности = НастройкиПарсингаКлиентСервер
		.КонвертироватьПараметрВложенныеКаталоги(ВложенныеКаталоги);
	
	Инструкция = Собиратель.НоваяИнструкция();
	Собиратель.ДобавитьКоманду(Инструкция, ИсполняемыйФайл.ПолноеИмя)
		.ДобавитьПараметр(Инструкция, ПараметрВложенности)
		.ДобавитьПараметр(Инструкция, """" + КаталогИсточник.ПолноеИмя + """" )
		.ДобавитьПараметр(Инструкция, """" + КаталогПриемник.ПолноеИмя + """")
		
		.ДобавитьИнструкцию(Программа, Инструкция)
	;
	
	КаталогоУправлятель.ИсполнитьПрограммуПарсинга(
		Программа
	);
	
	Возврат Истина;

КонецФункции // ()

// Параметры для обработки в текущем модуле
//
// Параметры:
//  Каталоги  - Структура - Общее описание структуры каталогов
//                 См. ПарсингДокументовОбщийКлиентСервер.КаталогиДляПарсинга
//  НастройкиПарсинга  - Структура - Для Клиент Серверной работы
//                 Данные реквизитов СправочникСсылка.НастройкиПарсингаДокументов
//
// Возвращаемое значение:
//   Структура   - Параметры для Обработки
//
Функция ПодготовитьПараметры(Каталоги, НастройкиПарсинга) Экспорт

	Настройщик = НастройкиПарсингаКлиентСервер;
	ОбщийВедатель = ПарсингДокументовОбщийКлиентСервер;
	
	Описание = Новый Структура;

	КаталогиРаспознования = ПарсингДокументовОбщийКлиентСервер
		.КаталогиДляРаспознования(Каталоги);
	Описание.Вставить("Каталоги", КаталогиРаспознования);
	
	ИмяФайла = ОбщийВедатель.ИмяФайлаРаспознавателя();
	Описание.Вставить("ИмяИсполняемогоФайла", ИмяФайла);
	
	Кодировка = Настройщик.ПолучитьКодировку(НастройкиПарсинга);
	Описание.Вставить("Кодировка", Кодировка);
	
	ВложенныеКаталоги = Настройщик.ПолучитьВложенныеКаталоги(НастройкиПарсинга);
	Описание.Вставить("ВложенныеКаталоги", ВложенныеКаталоги);
	
	Возврат Описание;

КонецФункции // ()

#КонецОбласти
