﻿
&НаКлиенте
Процедура КонтрагентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	ЗакрыватьПриВыборе = Ложь;
	ОповеститьОВыборе(Значение);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	стрИмяСправочникаКонтактов = бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов();
	стрИмяТаблицы = "Справочник." + стрИмяСправочникаКонтактов;
	//
	Контрагенты.ПроизвольныйЗапрос = Истина;
	Контрагенты.ДинамическоеСчитываниеДанных = Истина;
	Контрагенты.ОсновнаяТаблица = стрИмяТаблицы;
	Контрагенты.ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                           |	Контрагенты.Наименование
	                           |ИЗ
	                           |	" + стрИмяТаблицы + " КАК Контрагенты";
	//
	НоваяКолонкаТаблицы = Элементы.Добавить("Наименование", Тип("ПолеФормы"), Элементы.Контрагенты);    
	НоваяКолонкаТаблицы.ПутьКДанным = "Контрагенты.Наименование";	// тут название реквизита формы - динамического списка, а не таблицы БД
КонецПроцедуры
