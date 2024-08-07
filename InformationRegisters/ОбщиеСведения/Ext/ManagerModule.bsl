﻿
Функция ПолучитьЗначение(Свойство, Контрагент) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбщиеСведенияСрезПоследних.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.ОбщиеСведения.СрезПоследних(
		|			,
		|			Контрагент = &Контрагент
		|				И Свойство = &Свойство) КАК ОбщиеСведенияСрезПоследних";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Свойство", Свойство);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
	
		Возврат "";
	
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	Возврат ВыборкаДетальныеЗаписи.Значение;

КонецФункции // ()

Функция КонтрагентыСНовымиДанными(ПоследняяДатаОбнавления) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ Различные
		|	ОбщиеСведенияСрезПоследних.Контрагент КАК Контрагент
		|ИЗ
		|	РегистрСведений.ОбщиеСведения.СрезПервых(&ПоследняяДатаОбнавления, Контрагент.ПометкаУдаления = ЛОЖЬ) КАК ОбщиеСведенияСрезПоследних";
	
	Запрос.УстановитьПараметр(
		"ПоследняяДатаОбнавления",
		Новый Граница(ПоследняяДатаОбнавления, ВидГраницы.Исключая)
	);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контрагент");

КонецФункции // ()
