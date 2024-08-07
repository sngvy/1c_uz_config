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
	КаталогКорень = КаталогоУправлятель.КореньКаталогов(ОписаниеКаталогов);
	Корень = Новый Файл(КаталогКорень);
	Попытка
	
		КаталогоУправлятель.СуществуетКаталог(Корень);
	
	Исключение
		ВызватьИсключение ОбработкаОшибок.КраткоеПредставлениеОшибки(
			ИнформацияОбОшибке()
		);
	КонецПопытки;
	
	ОчищаемыеКаталоги = Параметры["КаталогиДляОчистки"];

	Для каждого ТекущийПодкаталог Из ОчищаемыеКаталоги Цикл
	
		Подкаталог = Новый Файл(ТекущийПодкаталог);

		Если Не Подкаталог.Существует() Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		Попытка
		
			УдалитьФайлы(Подкаталог.ПолноеИмя);
		
		Исключение
			
			НадоУдалить = СтрСоединить(ОчищаемыеКаталоги, Символы.ПС);
			
			ВызватьИсключение УправленияСообщениямиКлиентСервер.ИнструкцияКОшибке(
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
				"Не хватило прав на удаление
				|Добавьте прав или удалите вручную каталоги:
				|" + НадоУдалить
			);

		КонецПопытки;

	КонецЦикла;
	
	ВключатьВложенныеКаталоги = Параметры["ВложенныеКаталоги"];
	КаталогИсточник = КаталогоУправлятель.КаталогИсточник(ОписаниеКаталогов);
	Источник = Новый Файл(КаталогИсточник);
	Попытка
	
		КаталогоУправлятель.СуществуетКаталог(Источник);
	
	Исключение
		ВызватьИсключение ОбработкаОшибок.КраткоеПредставлениеОшибки(
			ИнформацияОбОшибке()
		);
	КонецПопытки;
	НайденыеФайлы = НайтиФайлы(Источник.ПолноеИмя, "*", ВключатьВложенныеКаталоги);
	
	ТолькоФайлы = Новый Массив;
	Для каждого ТекущийФайл Из НайденыеФайлы Цикл
	
		Если ТекущийФайл.ЭтоКаталог() Тогда
		
			Продолжить;
		
		КонецЕсли;
		СведенияОФайле = КаталогоУправлятель.ПолучитьСведенияОФайле(ТекущийФайл);
		ТолькоФайлы.Добавить(СведенияОФайле);
	
	КонецЦикла;
	
	Возврат ТолькоФайлы;

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

	НастройщикПарсинга = НастройкиПарсингаКлиентСервер;
	КаталогоУправлятель = ПарсингДокументовОбщийКлиентСервер;
	
	Описание = Новый Структура;

	КаталогиКонвертера = КаталогоУправлятель
		.КаталогиДляПервичнойПодготовки(Каталоги);
	Описание.Вставить("Каталоги", КаталогиКонвертера);
	
	КаталогиДляОчистки = КаталогоУправлятель
		.КаталогиДляОчистки(Каталоги);
	Описание.Вставить("КаталогиДляОчистки", КаталогиДляОчистки);
	
	ВложенныеКаталоги = НастройщикПарсинга
		.ПолучитьВложенныеКаталоги(НастройкиПарсинга);
	Описание.Вставить("ВложенныеКаталоги", ВложенныеКаталоги);
	
	Кодировка = НастройщикПарсинга.ПолучитьКодировку(НастройкиПарсинга);
	Описание.Вставить("Кодировка", Кодировка);
	
	Возврат Описание;

КонецФункции // ()

#КонецОбласти