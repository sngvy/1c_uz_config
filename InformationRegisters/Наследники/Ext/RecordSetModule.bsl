﻿
Процедура ПриЗаписи(Отказ, Замещение)
	Наследник = ЭтотОбъект.Отбор.Наследник.Значение;
	ДолговоеОбязательство = ЭтотОбъект.Отбор.ДолговоеОбязательство.Значение;
	
	МасивСобытий = Новый Массив;
	МасивСобытий.Добавить("2.5");
	МасивСобытий.Добавить("1.4");
	МасивСобытий.Добавить("2.2");
	МасивСобытий.Добавить("2.3");
	
	ДокИзменение = ПолучитьДокументНБКИИзменение(ДолговоеОбязательство, Наследник);
	
	Если ДокИзменение = Документы.СведенияОбИзмененииДоговора.ПустаяСсылка() Тогда
		МасивСобытий.Вставить(2, "2.1");
	КонецЕсли;	
	Часы = 12;
	Секунды = 3600;
	ДатаСобытияИзменения = ?(ЗначениеЗаполнено(ДокИзменение.ДатаИзмененияДоговора), ДокИзменение.ДатаИзмененияДоговора, НачалоДня(ТекущаяДатаСеанса())); 
	ДатаСобытияИзменения =  ДатаСобытияИзменения + (Часы * Секунды);
	Для Каждого НБКИСобытие из МасивСобытий Цикл
		СобытиеЗафиксировано = КредитныеИстории.СобытиеСделкиЗафиксированоИсточником(ДолговоеОбязательство, Наследник, НБКИСобытие);
		Если Не СобытиеЗафиксировано Тогда
			Если НБКИСобытие = "2.5" Тогда
				ДатаСобытия = НачалоДня(ДатаСобытияИзменения);
			ИначеЕсли НБКИСобытие = "2.2" Тогда 
				ДатаСобытия = ДатаСобытияИзменения + 2;
			Иначе
				ДатаСобытия = ДатаСобытия + 2;
			КонецЕсли;	
			КредитныеИстории.ЗаписатьСобытиеСделки(ДолговоеОбязательство, ДатаСобытия, Наследник, НБКИСобытие);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьДокументНБКИИзменение(ДО, Наследник)
	
	ДокументНБКИИзменение = Документы.СведенияОбИзмененииДоговора.ПустаяСсылка();
			
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОбИзмененииДоговора.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СведенияОбИзмененииДоговора КАК СведенияОбИзмененииДоговора
		|ГДЕ
		|	СведенияОбИзмененииДоговора.ОбъектУчета = &ОбъектУчета
		|	И СведенияОбИзмененииДоговора.ТипИзменения = ЗНАЧЕНИЕ(Перечисление.НБКИ_ТипыИзмененияДоговора.НаследованиеДоговора)
		|	И СведенияОбИзмененииДоговора.Наследник = &Наследник
		|	И НЕ СведенияОбИзмененииДоговора.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Наследник", Наследник);
	Запрос.УстановитьПараметр("ОбъектУчета", ДО);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДокументНБКИИзменение = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	Возврат ДокументНБКИИзменение;
КонецФункции

