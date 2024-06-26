﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "БитАТС_ЗапросРазрешенияДоступа" Тогда
		Если Параметр.Результат = КодВозвратаДиалога.Да Тогда
			Оповестить(Параметр.ПараметрОповещения);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "БитАТС_ВыполнитьВыгрузку" Тогда
		КоличествоИзменений = бит_АТСВыгрузкаИзменений.КоличествоИзмененийВУзле(УзелОбмена);
		ТекущееИзменение = 0;
		Если КоличествоИзменений > 0 Тогда
			Элементы.СчетчикВыгрузки.Видимость = Истина;
		КонецЕсли;
		ПодключитьОбработчикОжидания("ВыполнитьВыгрузку", 0.1, Истина);
	ИначеЕсли ИмяСобытия = "БитАТС_ПроверитьНомер" Тогда
		НомерКонтрагента = "";
		бит_ТелефонияКлиентПереопределяемый.ПоказВводСтроки(НомерКонтрагента, "Введите номер", "БитАТС_ПроверкаНомераКлиентМенеджера");
	ИначеЕсли ИмяСобытия = "БитАТС_ОчиститьБазуНаАТС" Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказВопрос("Очистить таблицы номеров телефонов, менеджеров и названий контрагентов?" +
						Символы.ПС + "Вся информация на БИТ.АТС будет удалена.",
						РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, ,
						"БитАТС_ОчисткаБазыКлиентМенеджера");
	ИначеЕсли ИмяСобытия = "БитАТС_ОчисткаБазыКлиентМенеджера" Тогда
		ОчиститьБазуНаАТСЗавершение(Параметр.Результат, Параметр.ПараметрОповещения);
	ИначеЕсли ИмяСобытия = "БитАТС_ПроверкаНомераКлиентМенеджера" Тогда
		ПроверитьНомерЗавершение(Параметр.Результат);
	ИначеЕсли ИмяСобытия = "БитАТС_ПроверитьВебСервис" Тогда
		стрОшибка = "";
		стрВерсия = бит_АТСВыгрузкаИзменений.ПолучитьВерсиюВебСервиса(УзелОбмена, стрОшибка);
		Если ЗначениеЗаполнено(стрОшибка) Тогда
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение(стрОшибка);
		Иначе
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Веб-сервис версия " + стрВерсия);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ВыгрузитьНаАТС(Команда)
	
	флагРасширение = РаботаВРасширенииКонфигурации();
	
	Если Не флагРасширение Тогда
		
		стрСообщениеАвтоВыгрузка = "Выгрузка базы модуля клиент-менеджера на БИТ.АТС выполняется автоматически регламентным заданием.";
		
		Если НЕ ЭтаБазаФайловая() Тогда
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение(стрСообщениеАвтоВыгрузка);
			Возврат;
		КонецЕсли;
		
		// Проверка версии платформы, выполняющей регламентные задания в фоновом потоке.
		минВерсия = Новый Массив();
		минВерсия.Добавить(8);
		минВерсия.Добавить(3);
		минВерсия.Добавить(4);

		массВерсПлатф = бит_ТелефонияКлиент.ПолучитьВерсиюПлатформы();
		
		платформаБольшеРавна834 = бит_ТелефонияКлиент.ПроверкаВерсий(массВерсПлатф, минВерсия);
		
		Если платформаБольшеРавна834 Тогда
			// проверка режима совместимости
			массРежимСовм = бит_ТелефонияСервер.ПолучитьРежимСовместимостиКонфигурации();
			
			Если (массРежимСовм = Неопределено) Тогда
				совместимо834 = Истина;
			Иначе
				совместимо834 = бит_ТелефонияКлиент.ПроверкаВерсий(массРежимСовм, минВерсия);
			КонецЕсли;
			
			Если совместимо834 Тогда
				бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение(стрСообщениеАвтоВыгрузка);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	//
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
		
	АдминистраторАТС = бит_АТССервер.ПроверитьПраваАдминистрировать();
	Если НЕ АдминистраторАТС Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Недостаточно прав для выгрузки базы модуля клиент-менеджера на БИТ.АТС");
		Возврат;
	КонецЕсли;
	
	ЗапросРазрешенияДоступа("БитАТС_ВыполнитьВыгрузку");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНомер(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	ЗапросРазрешенияДоступа("БитАТС_ПроверитьНомер");
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьБазуНаАТС(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	АдминистраторАТС = бит_АТССервер.ПроверитьПраваАдминистрировать();
	Если НЕ АдминистраторАТС Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Недостаточно прав для очистки базы модуля клиент-менеджера на БИТ.АТС");
		Возврат;
	КонецЕсли;
	
	ЗапросРазрешенияДоступа("БитАТС_ОчиститьБазуНаАТС");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВебСервис(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗапросРазрешенияДоступа("БитАТС_ПроверитьВебСервис");
КонецПроцедуры

&НаКлиенте
Процедура ВывестиВерсию(Команда)
	бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Механизм синхронизации с БИТ.АТС, версия " + бит_АТСВыгрузкаИзменений.ПолучитьВерсиюМеханизмаСинхронизации());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЭтаБазаФайловая()
	СтрокаСоединенияИнформационнойБазы = СтрокаСоединенияИнформационнойБазы();
	Возврат Найти(Врег(СтрокаСоединенияИнформационнойБазы), "FILE=") = 1;
КонецФункции 

&НаСервере
Функция РаботаВРасширенииКонфигурации()
	списЗнач = бит_ТелефонияКлиентСервер.СтрРазбить(ЭтаФорма.ИмяФормы, ".");
	стрИмяОбработки = списЗнач[1].Значение;
	Возврат Метаданные.Обработки[стрИмяОбработки].РасширениеКонфигурации() <> Неопределено;
КонецФункции

&НаСервере
Функция ПолучитьХостУзлаОбмена()
	Возврат УзелОбмена.ХостБД;
КонецФункции

&НаКлиенте
Процедура ЗапросРазрешенияДоступа(стрИмяСобытияРазрешения)
	стрЗапрос = "Выполняется подключение к внешнему ресурсу '" + ПолучитьХостУзлаОбмена() + "' и выгрузка/получение данных. Продолжить?";
	бит_ТелефонияКлиентПереопределяемый.ПоказВопрос(стрЗапрос, РежимДиалогаВопрос.ДаНет, , , , "БитАТС_ЗапросРазрешенияДоступа", стрИмяСобытияРазрешения);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыгрузку()
	стрСостояниеВыполнения = "";
	стрОшибка = "";
	флагПродолжить = бит_АТСВыгрузкаИзменений.ВыполнитьВыгрузкуИзмененийНаАТС(УзелОбмена, стрСостояниеВыполнения, стрОшибка, Ложь);
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = стрСостояниеВыполнения;
	Если ЗначениеЗаполнено(стрОшибка) Тогда
		Сообщение.Текст = Сообщение.Текст + Символы.ПС + Символы.ПС + "Ошибка выгрузки:" + Символы.ПС + стрОшибка;
	КонецЕсли;
	Если флагПродолжить Тогда
		Сообщение.Сообщить();
		ТекущееИзменение = ТекущееИзменение + 1;
		СчетчикВыгрузки = (ТекущееИзменение / КоличествоИзменений) * 100;
		ПодключитьОбработчикОжидания("ВыполнитьВыгрузку", 0.1, Истина);
	Иначе
		Элементы.СчетчикВыгрузки.Видимость = Ложь;
		Если (КоличествоИзменений = 0) Или ЗначениеЗаполнено(стрОшибка) Тогда
			Сообщение.Сообщить();	// сообщение что изменений в узле обмена нет или ошибка
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНомерЗавершение(НомерКонтрагента)
	Если НЕ ЗначениеЗаполнено(НомерКонтрагента) Тогда
		Возврат;
	КонецЕсли;
	стрСостояниеВыполнения = "";
	стрОшибка = "";
	бит_АТСВыгрузкаИзменений.ПроверитьНомерНаАТС(УзелОбмена, НомерКонтрагента, стрСостояниеВыполнения, стрОшибка);
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = стрСостояниеВыполнения;
	Если ЗначениеЗаполнено(стрОшибка) Тогда
		Сообщение.Текст = Сообщение.Текст + Символы.ПС + Символы.ПС + "Ошибка проверки номера:" + Символы.ПС + стрОшибка;
	КонецЕсли;
	Сообщение.Сообщить();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьБазуНаАТСЗавершение(РезультатВопроса, ДополнительныеПараметры)
	
	ответ = РезультатВопроса;
	Если ответ = КодВозвратаДиалога.Да Тогда
		стрСостояниеВыполнения = "";
		стрОшибка = "";
		бит_АТСВыгрузкаИзменений.ОчиститьБазуДанныхНаАТС(УзелОбмена, стрСостояниеВыполнения, стрОшибка);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = стрСостояниеВыполнения;
		Если ЗначениеЗаполнено(стрОшибка) Тогда
			Сообщение.Текст = Сообщение.Текст + Символы.ПС + Символы.ПС + "Ошибка очистки:" + Символы.ПС + стрОшибка;
		КонецЕсли;
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
