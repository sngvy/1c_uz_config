﻿&НаКлиенте 
Перем НедостающиеТипы Экспорт;


&НаСервере
Процедура НайтиФайлыСервер(НедостающиеТипы)
	Объект.ПодобранныеФайлы.Очистить();
	Если НЕ значениеЗаполнено(Объект.Объект) Тогда
		Сообщить("Необходимо выбрать объект для поиска файлов!");
		Возврат;
	КонецЕсли;
	Если НЕ значениеЗаполнено(Объект.ПечатнаяФормаШаблон) Тогда
		Сообщить("Необходимо выбрать Шаблон для поиска файлов!");
		Возврат;
	КонецЕсли;	
	
	ТипыФайловШаблона = ОбъектыСервер.ПоискТиповФайлов(Объект.ПечатнаяФормаШаблон);
	Текст = ОбъектыСервер.ПолучитьТекстЗапросаПоискаФайловПоШаблону();
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("Объект",Объект.Объект);
	Запрос.УстановитьПараметр("МассивТиповФайлов", ТипыФайловШаблона);
	//Запрос.УстановитьПараметр("Массив", МассивФайлов);
	//
	Результат = Запрос.Выполнить().Выгрузить();
	ЕстьТипы = Новый массив;
	
	Для каждого стр из  Результат Цикл
		НовСтрока = Объект.ПодобранныеФайлы.Добавить();
		НовСтрока.Файл = стр.ИмяФайла;
		НовСтрока.ТипФайла = стр.ТипФайла;
		НовСтрока.Регистратор = стр.Регистратор;
		НовСтрока.Пометка = Истина;
		НовСтрока.НомерСтрокиРегистратор = Стр.НомерСтрокиРегистратор;
		ЕстьТипы.Добавить(стр.ТипФайла);
	КонецЦикла;
	
	НедостающиеТипы = РазностьМассивов(ТипыФайловШаблона,ЕстьТипы);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	Для Каждого Элемент Из Объект.ПодобранныеФайлы Цикл
		Элемент.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого Элемент Из Объект.ПодобранныеФайлы Цикл
		Элемент.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНаДругуюФорму(Команда)
	ВладелецФормы.Объект.ПрикрепленныеФайлы.Очистить();
	ВладелецФормы.Объект.ПодобранныеФайлы.Очистить();
	ПомеченныеСтроки = Объект.ПодобранныеФайлы.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	Для Каждого Элемент Из ПомеченныеСтроки Цикл
		
		Нов = ВладелецФормы.Объект.ПодобранныеФайлы.Добавить();
		Попытка
			Нов.Регистратор = Элемент.Регистратор;
			Нов.Файл = Элемент.Файл;
			Нов.ТипФайла = Элемент.ТипФайла;
		Исключение
		КонецПопытки;
	КонецЦикла;

	
	
	ТекущийИндекс = 0; 
	ВсегоЭлементов = ПомеченныеСтроки.Количество(); 
	Пока ТекущийИндекс < ВсегоЭлементов Цикл 
		Индекс2 = ТекущийИндекс + 1; 
		Пока Индекс2 < ВсегоЭлементов Цикл 
			Если ПомеченныеСтроки[Индекс2].Регистратор = ПомеченныеСтроки[ТекущийИндекс].Регистратор Тогда 
				ПомеченныеСтроки.Удалить(Индекс2); 
				ВсегоЭлементов = ВсегоЭлементов - 1; 
			Иначе 
				Индекс2 = Индекс2 + 1; 
			КонецЕсли; 
		КонецЦикла; 
		ТекущийИндекс = ТекущийИндекс + 1; 
	КонецЦикла; 
	
	Для Каждого Элемент Из ПомеченныеСтроки Цикл
		
		Нов = ВладелецФормы.Объект.ПрикрепленныеФайлы.Добавить();
		Попытка
			Нов.ПрикрепленныйФайл = Элемент.Регистратор;	
		Исключение
		КонецПопытки;
	КонецЦикла;	
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ВладелецФормы = Неопределено Тогда
		Элементы.ФормаДобавитьНаДругуюФорму.Видимость = Ложь;
	КонецЕсли;
	Если ВладелецФормы.ИмяФормы = "Документ.ПакетноеСозданиеИсходящейКорреспонденции.Форма.ФормаДокумента" тогда
		Элементы.ФормаДобавитьНаДругуюФорму.Видимость = Ложь;
	КонецЕсли;	
	Если ВладелецФормы.ИмяФормы = "Справочник.ИсходящаяКорреспонденция.Форма.ФормаДокумента" Тогда
		Элементы.ЗакрытьИОбновить.Видимость = Ложь;
	КонецЕсли;	
		
	НайтиФайлыСервер(НедостающиеТипы);
	Если НедостающиеТипы.Количество() > 0  Тогда
		//Сообщить("Есть недостающие типы файлов по шаблону " + Объект.ПечатнаяФормаШаблон);
		Элементы.ФормаДобавитьНаДругуюФорму.Доступность = Ложь;
		Элементы.ДекорацияКомплектНеСформирован.Видимость = Истина;
		Элементы.ДекорацияКомплектСформирован.Видимость = Ложь;
		Элементы.ТекстКомплектНеСформирован.Видимость = Истина;
		Элементы.ТекстКомплектСформирован.Видимость = Ложь;
		Элементы.СформироватьДокументы.Доступность = Истина;
		Элементы.ПрикрепитьФайлы.Доступность = Истина;
		Для каждого Тип из НедостающиеТипы Цикл
			Стр = Объект.ПодобранныеФайлы.Добавить();
			Стр.ТипФайла = Тип;
		КонецЦикла;	
		НедостающиеТипыКомплекта = Новый Массив;
		НедостающиеТипыПечатнойФормы = Новый Массив;
		КонтрольТиповФайлов(НедостающиеТипы,НедостающиеТипыКомплекта,НедостающиеТипыПечатнойФормы);	
		Если НедостающиеТипыКомплекта.Количество()>0 Тогда
			Элементы.ПрикрепитьФайлы.Доступность = Истина;
		Иначе
			Элементы.ПрикрепитьФайлы.Доступность = Ложь;
		КонецЕсли;	 
		
		Если НедостающиеТипыПечатнойФормы.Количество()>0 Тогда
			Элементы.СформироватьДокументы.Доступность = Истина;
		Иначе
			Элементы.СформироватьДокументы.Доступность = Ложь;
		КонецЕсли;
			
	Иначе
		Элементы.ТекстКомплектНеСформирован.Видимость = Ложь;
		Элементы.ТекстКомплектСформирован.Видимость = Истина;
		Элементы.ДекорацияКомплектНеСформирован.Видимость = Ложь;
		Элементы.ДекорацияКомплектСформирован.Видимость = Истина;
		Элементы.ФормаДобавитьНаДругуюФорму.Доступность = Истина;
		Элементы.СформироватьДокументы.Доступность = Ложь;
		Элементы.ПрикрепитьФайлы.Доступность = Ложь;	
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлы(Команда)
	Если Элементы.ПодобранныеФайлы.ВыделенныеСтроки.Количество() = 0 Тогда 		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выбрано ни одной строки, или список пуст!";
		Сообщение.Сообщить();	
		Возврат;
	КонецЕсли;
	#Если Вебклиент Тогда
		Если Не РазыменоватьСсылку("Константы.ХранитьПрикрепляемыеФайлыНаСервере.Получить()") Тогда	
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
			Диалог.Заголовок = "Выберите каталог";
			Диалог.МножественныйВыбор = Ложь;
			Диалог.Показать(Новый ОписаниеОповещения("ОткрытьФайлыЗавершение", ЭтаФорма, Новый Структура("Диалог", Диалог)));
			
		Иначе
			//Для Каждого ВыделСтрока Из Элементы.ПодобранныеФайлы.ВыделенныеСтроки Цикл
				Данные = СписокВыборНаСервере(Элементы.ПодобранныеФайлы.ТекущиеДанные.Регистратор,Элементы.ПодобранныеФайлы.ТекущиеДанные.НомерСтрокиРегистратор, Истина);	
				Файл = Новый Файл(Элементы.ПодобранныеФайлы.ТекущиеДанные.Файл);
				Каталог = РазыменоватьСсылку("Константы.КаталогХраненияПрикрепляемыхФайловНаСервере.Получить()");
				Если Прав(Каталог, 1) <> "\" Тогда
					Каталог = Каталог + "\";
				КонецЕсли;
				ПутьКФайлу = строка(Каталог + Данные + Файл.Расширение);
				Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", этаформа);
				НачатьЗапускПриложения(Оповещение,ПутьКФайлу,,Истина);
				//ЗапуститьПриложение(Каталог + Данные + Файл.Расширение);
			//КонецЦикла;
		КонецЕсли;
		
	#Иначе
		Если Не РазыменоватьСсылку("Константы.ХранитьПрикрепляемыеФайлыНаСервере.Получить()") Тогда
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
			Диалог.Заголовок = "Выберите каталог";
			Диалог.МножественныйВыбор = Ложь;
			Если Диалог.Выбрать() Тогда
				Данные = СписокВыборНаСервере(Элементы.ПодобранныеФайлы.ТекущиеДанные.Регистратор,Элементы.ПодобранныеФайлы.ТекущиеДанные.НомерСтрокиРегистратор);
				ИмяФайла = Элементы.ПодобранныеФайлы.ТекущиеДанные.Файл;
				Файл = Новый Файл(Диалог.Каталог + "\" + ИмяФайла);
				Если Файл.Существует() Тогда 
					КнопкиДиалога = Новый СписокЗначений;
					КнопкиДиалога.Добавить(1, "Перезаписать");
					КнопкиДиалога.Добавить(2, "Переименовать");
					//Чуров
					ДопПараметры = новый Структура("Диалог, Файл, Данные");
					ДопПараметры.Диалог = Диалог;
					ДопПараметры.Файл = Файл;
					ДопПараметры.Данные = Данные;
					Оповещение = новый ОписаниеОповещения("ПослеОтветаФайлСуществует", ЭтаФорма, ДопПараметры);
					ПоказатьВопрос(Оповещение, "Файл " + Файл.Имя + " уже существует", КнопкиДиалога,,,"Файл существует"); 
				Иначе
					Данные.Записать(Диалог.Каталог + "\" + Файл.Имя);
					ЗапуститьПриложение(Диалог.Каталог + "\" + Файл.Имя);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
				Данные = СписокВыборНаСервере(Элементы.ПодобранныеФайлы.ТекущиеДанные.Регистратор,Элементы.ПодобранныеФайлы.ТекущиеДанные.НомерСтрокиРегистратор, Истина);		
				Файл = Новый Файл(Элементы.ПодобранныеФайлы.Файл);
				Каталог = РазыменоватьСсылку("Константы.КаталогХраненияПрикрепляемыхФайловНаСервере.Получить()");
				Если Прав(Каталог, 1) <> "\" Тогда
					Каталог = Каталог + "\";
				КонецЕсли;
				ЗапуститьПриложение(Каталог + Данные + Файл.Расширение);
		КонецЕсли;	
	#КонецЕсли
КонецПроцедуры

&НаСервере
Функция СписокВыборНаСервере(Регистратор,НомерСтроки, ПолучитьУИД = Ложь)
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрикрепитьФайлыФайлы.Хранилище,
	|	ПрикрепитьФайлыФайлы.УИД
	|ИЗ
	|	Документ.ПрикрепитьФайлы.Файлы КАК ПрикрепитьФайлыФайлы
	|ГДЕ
	|	ПрикрепитьФайлыФайлы.Ссылка = &Ссылка
	|	И ПрикрепитьФайлыФайлы.НомерСтроки = &НомерСтроки");
	Запрос.УстановитьПараметр("Ссылка", Регистратор);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСтроки);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ПолучитьУИД Тогда
		Возврат Результат[0].УИД;
	Иначе
		Возврат Результат[0].Хранилище.Получить();
		//Сообщить(строка(Результат[0].Хранилище.Получить()));
	КонецЕсли;
КонецФункции                                                          

&НаСервереБезКонтекста
Функция РазыменоватьСсылку(Стр)
	Возврат Вычислить(Стр);
КонецФункции

&НаКлиенте
Процедура ОткрытьФайлыЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		//Для Каждого ВыделСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
			Данные = СписокВыборНаСервере(Элементы.ПодобранныеФайлы.ТекущиеДанные.Регистратор,Элементы.ПодобранныеФайлы.ТекущиеДанные.НомерСтроки);
			ИмяФайла = Элементы.ПодобранныеФайлы.ТекущиеДанные.Файл;
			Файл = Новый Файл(Диалог.Каталог + "\" + ИмяФайла);
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Данные",Данные);
			ДополнительныеПараметры.Вставить("Диалог",Диалог);
			ДополнительныеПараметры.Вставить("Файл",Файл);
			
			//ДополнительныеПараметры.Вставить("Данные, Диалог, Файл",Данные,Диалог, Файл);
			Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("КонецПроверкиСуществования",ЭтаФорма,ДополнительныеПараметры));
		//КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&наКлиенте
Процедура ПослеОтветаФайлСуществует(Результат, Параметры) Экспорт  
	Если Результат = 1 Тогда
		ДопПарам = Новый Структура;
		ДопПарам.Вставить("Диалог", Параметры.Диалог);
		ДопПарам.Вставить("Файл",Параметры.Файл);
		КудаЗаписать = Параметры.Диалог.Каталог + "\"  + Параметры.Файл.Имя;
		Параметры.Данные.НачатьЗапись(Новый ОписаниеОповещения("ЗавершениеЗаписи",ЭтаФорма,ДопПарам),КудаЗаписать);
		//Параметры.Данные.Записать(Параметры.Диалог.Каталог + "\" + Параметры.Файл.Имя);
		//ПутьКФайлу = строка(Параметры.Диалог.Каталог + "\" + Параметры.Файл.Имя);
		//Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", этаформа);
		//НачатьЗапускПриложения(Оповещение,ПутьКФайлу,,Истина);
		
		//ЗапуститьПриложение(Параметры.Диалог.Каталог + "\" + Параметры.Файл.Имя);
	Иначе
		Форма = ОткрытьФорму("РегистрСведений.ПрикрепляемыеФайлы.Форма.ФормаПереименования",,ЭтаФорма,,,,Новый ОписаниеОповещения("ПолучитьНовоеИмяФайла",ЭтаФорма,Параметры));
		//Параметры.Данные.Записать(Параметры.Диалог.Каталог + "\" + НовоеИмяФайла + Параметры.Файл.Расширение);
		//ДопПарам = Новый Структура;
		//ДопПарам.Вставить("Диалог", Параметры.Диалог);
		//ДопПарам.Вставить("Файл",Параметры.Файл);
		//КудаЗаписать = Параметры.Диалог.Каталог + "\" + НовоеИмяФайла + Параметры.Файл.Расширение;
		//Параметры.Данные.НачатьЗапись(Новый ОписаниеОповещения("ЗавершениеЗаписи",ЭтаФорма,ДопПарам),КудаЗаписать);
		//ПутьКФайлу = строка(Параметры.Диалог.Каталог + "\" + НовоеИмяФайла + Параметры.Файл.Расширение);
		//Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", этаформа);
		//НачатьЗапускПриложения(Оповещение,ПутьКФайлу,,Истина);
		
		//ЗапуститьПриложение(Параметры.Диалог.Каталог + "\" + НовоеИмяФайла + Параметры.Файл.Расширение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПроверкиСуществования(Существует, ДополнительныеПараметры) Экспорт
	Данные = ДополнительныеПараметры.Данные;
	//Сообщить(Строка(Данные));
	Диалог = ДополнительныеПараметры.Диалог;
	Файл = ДополнительныеПараметры.Файл;
	Если Существует Тогда
		КнопкиДиалога = Новый СписокЗначений;
		КнопкиДиалога.Добавить(1, "Перезаписать");
		КнопкиДиалога.Добавить(2, "Переименовать");
		//Чуров
		ДопПараметры = новый Структура("Диалог, Файл, Данные");
		ДопПараметры.Диалог = Диалог;
		ДопПараметры.Файл = Файл;
		ДопПараметры.Данные = Данные;
		Оповещение = новый ОписаниеОповещения("ПослеОтветаФайлСуществует", ЭтаФорма, ДопПараметры);
		ПоказатьВопрос(Оповещение, "Файл " + Файл.Имя + " уже существует", КнопкиДиалога,,,"Файл существует"); 
	Иначе
		ДопПарам = Новый Структура;
		ДопПарам.Вставить("Диалог", Диалог);
		ДопПарам.Вставить("Файл",Файл);
		КудаЗаписать = Диалог.Каталог + "\" + Файл.Имя;
		Данные.НачатьЗапись(Новый ОписаниеОповещения("ЗавершениеЗаписи",ЭтаФорма,ДопПарам),КудаЗаписать);
	//	Сообщить(КудаЗаписать);
		
		
		//Данные.Записать(Диалог.Каталог + "\" + Файл.Имя);
		//ПутьКФайлу = строка(Диалог.Каталог + "\" + Файл.Имя);
		//Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", этаформа);
		//НачатьЗапускПриложения(Оповещение,ПутьКФайлу,,Истина);
		//ЗапуститьПриложение(Диалог.Каталог + "\" + Файл.Имя);
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗавершениеЗаписи(ДопПарам) Экспорт
	Диалог = ДопПарам.Диалог;
	Файл = ДопПарам.Файл;
	ПутьКФайлу = строка(Диалог.Каталог + "\" + Файл.Имя);
	Оповещение = Новый ОписаниеОповещения("ЗапускПриложения", этаформа);
	НачатьЗапускПриложения(Оповещение,ПутьКФайлу,,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускПриложения(Параметр1,Параметр2) Экспорт
//	
КонецПроцедуры

&НаСервере
Процедура ПодобранныеФайлыПометкаПриИзмененииНаСервере()
		
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеФайлыПометкаПриИзменении(Элемент)
	РегистраторТекущий = Элементы.ПодобранныеФайлы.ТекущиеДанные.Регистратор;
	ПометкаТекущая = Элементы.ПодобранныеФайлы.ТекущиеДанные.Пометка;
	Для Каждого Элемент Из Объект.ПодобранныеФайлы Цикл
		Если Элемент.Регистратор = РегистраторТекущий Тогда
			Элемент.Пометка = ПометкаТекущая;
		КонецЕсли;
	КонецЦикла;	
	//ПодобранныеФайлыПометкаПриИзмененииНаСервере();
КонецПроцедуры

// Сворачивает в массиве повторяющиеся значения.
//
// Параметры:
//	пМассив - <Массив> - Исходный массив.
//
// Возвращаемое значение:
//	<Массив> - Свёрнутый массив.
//
Функция СвернутьМассив(пМассив) Экспорт
 
	Если пМассив.Количество() > 1 Тогда
		ТЗ = Новый ТаблицаЗначений;
		ИмяКолонки = "Колонка1";
		ТЗ.Колонки.Добавить(ИмяКолонки);
		Для Индекс = 0 По пМассив.Количество()-1 Цикл
			ТЗ.Добавить();
		КонецЦикла;
		ТЗ.ЗагрузитьКолонку(пМассив, ИмяКолонки);
		ТЗ.Свернуть(ИмяКолонки, "");
 
		Возврат ТЗ.ВыгрузитьКолонку(ИмяКолонки);
	Иначе
		Результат = Новый Массив;
		Для Каждого Элемент Из пМассив Цикл
			Результат.Добавить(Элемент);
		КонецЦикла;
		Возврат Результат;
	КонецЕсли;
 
КонецФункции

&НаКлиенте
Процедура ПрикрепитьФайлы(Команда)
	НедостающиеТипыКомплекта = Новый Массив;
	ПрикрепитьФайлыСервер(НедостающиеТипыКомплекта,НедостающиеТипы);
	//Шаблон = Объект.ПечатнаяФормаШаблон;
	//ТЧШаблоныПечатныхФорм = Шаблон.ШаблоныПечатныхФорм;
	//
	//	
	//Для каждого стр из ТЧШаблоныПечатныхФорм Цикл
	//	Если ТипЗнч(Стр.ШаблонПечатнойФормы) = Тип("СправочникСсылка.КомплектыФайловДляПечати") Тогда
	//		Для каждого ТипФ из стр.ШаблонПечатнойФормы.ТипыФайлов Цикл
	//			Для каждого тип из НедостающиеТипы Цикл
	//				Если ТипФ.ТипФайла = Тип Тогда
	//					НедостающиеТипыКомплекта.Добавить(Тип);
	//				КонецЕсли;
	//			КонецЦикла;
	//		КонецЦикла;
	//	КонецЕсли;
	//КонецЦикла;	
	
	
	Организация = ПолучитьОрганизацию();
	Пользователь = ПолучитьПользователя();
	Подразделение = ПолучитьПодразделение();
	ФормаДокумент = ПолучитьФорму("Документ.ПрикрепитьФайлы.Форма.ФормаДокумента",,ЭтаФорма);
	ФормаДокумент.Объект.Организация = Организация;
	ФормаДокумент.Объект.Подразделение = Подразделение;
	ФормаДокумент.Объект.Автор = Пользователь;
	ФормаДокумент.Объект.Объект = Объект.Объект;
	Для каждого элемент из НедостающиеТипыКомплекта цикл
		НовСтр = ФормаДокумент.Объект.Файлы.Добавить();
		НовСтр.ТипФайла = Элемент;
	КонецЦикла;	
	ФормаДокумент.Открыть();
	
КонецПроцедуры

&НаСервере 
Процедура ПрикрепитьФайлыСервер(НедостающиеТипыКомплекта,НедостающиеТипы)
	Шаблон = Объект.ПечатнаяФормаШаблон;
	ТЧШаблоныПечатныхФорм = Шаблон.ШаблоныПечатныхФорм;
	
	Для каждого стр из ТЧШаблоныПечатныхФорм Цикл
		Если ТипЗнч(Стр.ШаблонПечатнойФормы) = Тип("СправочникСсылка.КомплектыФайловДляПечати") Тогда
			Для каждого ТипФ из стр.ШаблонПечатнойФормы.ТипыФайлов Цикл
				Для каждого тип из НедостающиеТипы Цикл
					Если ТипФ.ТипФайла = Тип Тогда
						НедостающиеТипыКомплекта.Добавить(Тип);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
конецПроцедуры	


&НаКлиенте
Процедура СформироватьДокументы(Команда)
	Организация = ПолучитьОрганизацию();
	Пользователь = ПолучитьПользователя();
	ФормаДокумент = ПолучитьФорму("Документ.ФормированиеПретензионногоПисьма.Форма.ФормаДокумента",,ЭтаФорма);
	ФормаДокумент.Объект.Организация = Организация;
	ФормаДокумент.Объект.Автор = Пользователь;
	ФормаДокумент.Объект.Шаблон = Объект.ПечатнаяФормаШаблон;
	ФормаДокумент.Объект.СоздатьПрикреплениеФайлов = Истина;
	ФормаДокумент.Объект.НеПечататьПовторно = Истина;
	стр = ФормаДокумент.Объект.Объекты.Добавить();
	Стр.Объект = Объект.Объект;					
	ФормаДокумент.Открыть();
КонецПроцедуры

&НаСервере
Функция ПолучитьОрганизацию()
	Возврат ПараметрыСеанса.ТекущийПользователь.Организация;
КонецФункции	

&НаСервере
Функция ПолучитьПользователя()
	Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции	

&НаСервере
Функция ПолучитьПодразделение()
	Возврат ПараметрыСеанса.ТекущееПодразделение;
КонецФункции

&НаСервере
Функция ПолучитьОбъект()
	Возврат Объект.Объект;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПродолжитьРаботуПодбораФайла" или ИмяСобытия = "ПродолжитьРаботуПодбораПослеПечатнойФормы" Тогда
		НайтиФайлыСервер(НедостающиеТипы);
		Если НедостающиеТипы.Количество() > 0  Тогда
			//Сообщить("Есть недостающие типы файлов по шаблону " + Объект.ПечатнаяФормаШаблон);
			Элементы.ФормаДобавитьНаДругуюФорму.Доступность = Ложь;
			Элементы.СформироватьДокументы.Доступность = Истина;
			Элементы.ПрикрепитьФайлы.Доступность = Истина;
			Элементы.ТекстКомплектНеСформирован.Видимость = Истина;
			Элементы.ТекстКомплектСформирован.Видимость = Ложь;

			Элементы.ДекорацияКомплектНеСформирован.Видимость = Истина;
			Элементы.ДекорацияКомплектСформирован.Видимость = Ложь;
			Для каждого Тип из НедостающиеТипы Цикл
				Стр = Объект.ПодобранныеФайлы.Добавить();
				Стр.ТипФайла = Тип;
			КонецЦикла;
			НедостающиеТипыКомплекта = Новый Массив;
			НедостающиеТипыПечатнойФормы = Новый Массив;
			КонтрольТиповФайлов(НедостающиеТипы,НедостающиеТипыКомплекта,НедостающиеТипыПечатнойФормы);	
			Если НедостающиеТипыКомплекта.Количество()>0 Тогда
				Элементы.ПрикрепитьФайлы.Доступность = Истина;
			Иначе
				Элементы.ПрикрепитьФайлы.Доступность = Ложь;
			КонецЕсли;	 
			
			Если НедостающиеТипыПечатнойФормы.Количество()>0 Тогда
				Элементы.СформироватьДокументы.Доступность = Истина;
			Иначе
				Элементы.СформироватьДокументы.Доступность = Ложь;
			КонецЕсли;	
		Иначе
			Элементы.ФормаДобавитьНаДругуюФорму.Доступность = Истина;
			Элементы.СформироватьДокументы.Доступность = Ложь;
			Элементы.ПрикрепитьФайлы.Доступность = Ложь;
			Элементы.ТекстКомплектНеСформирован.Видимость = Ложь;
			Элементы.ТекстКомплектСформирован.Видимость = Истина;

			Элементы.ДекорацияКомплектНеСформирован.Видимость = Ложь;
			Элементы.ДекорацияКомплектСформирован.Видимость = Истина;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РазностьМассивов(Массив1, Массив2)
	Результат = Новый Массив;
	Повтор = Новый Соответствие;
	Для каждого Элемент Из Массив1 Цикл
		Повтор[Элемент] = ?(Повтор[Элемент] = Неопределено, Ложь, Истина)
	КонецЦикла;
	Для каждого Элемент Из Массив2 Цикл
		Повтор[Элемент] = ?(Повтор[Элемент] = Неопределено, Ложь, Истина)
	КонецЦикла;
	Для каждого Элемент Из Повтор Цикл
		Если НЕ Элемент.Значение Тогда
			Результат.Добавить(Элемент.Ключ)
		КонецЕсли
	КонецЦикла;
	Возврат Результат
КонецФункции

&НаСервере
Процедура КонтрольТиповФайлов(НедостающиеТипы,НедостающиеТипыКомплекта,НедостающиеТипыПечатнойФормы)
	Шаблон = Объект.ПечатнаяФормаШаблон;
	ТЧШаблоныПечатныхФорм = Шаблон.ШаблоныПечатныхФорм;
	
	Для каждого стр из ТЧШаблоныПечатныхФорм Цикл
		Если ТипЗнч(Стр.ШаблонПечатнойФормы) = Тип("СправочникСсылка.КомплектыФайловДляПечати") Тогда
			Для каждого ТипФ из стр.ШаблонПечатнойФормы.ТипыФайлов Цикл
				Для каждого тип из НедостающиеТипы Цикл
					Если ТипФ.ТипФайла = Тип Тогда
						НедостающиеТипыКомплекта.Добавить(Тип);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
		Иначе
			Для каждого тип из НедостающиеТипы Цикл
				Если стр.ШаблонПечатнойФормы.ТипПрикрепляемогоФайла = Тип Тогда
					НедостающиеТипыПечатнойФормы.Добавить(Тип);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьИОбновить(Команда)
	Оповестить("ЗакрытиеИзПакета");
	ЭтаФорма.Закрыть();
КонецПроцедуры
