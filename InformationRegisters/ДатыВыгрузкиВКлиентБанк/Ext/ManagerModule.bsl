﻿Функция ДатаПоследнейВыгрузки() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатыВыгрузкиВКлиентБанкСрезПоследних.Период КАК Период
		|ИЗ
		|	РегистрСведений.ДатыВыгрузкиВКлиентБанк.СрезПоследних КАК ДатыВыгрузкиВКлиентБанкСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДатаВыгрузки = Дата(1, 1, 1);
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ДатаВыгрузки = ВыборкаДетальныеЗаписи.Период;
	КонецЕсли;
	
	Возврат ДатаВыгрузки;

КонецФункции // ()

Функция ПоследнийНомер() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатыВыгрузкиВКлиентБанкСрезПоследних.ПоследнийНомерДокумента КАК ПоследнийНомерДокумента
		|ИЗ
		|	РегистрСведений.ДатыВыгрузкиВКлиентБанк.СрезПоследних КАК ДатыВыгрузкиВКлиентБанкСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	
		Возврат ВыборкаДетальныеЗаписи.ПоследнийНомерДокумента;
	
	КонецЕсли;
	
	Возврат 0;

КонецФункции // ()
