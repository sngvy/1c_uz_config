﻿&НаКлиенте
Процедура Подбор(Команда)
	ОбъектыКлиент.Подбор(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПодборИзФайла(Команда)
	ОбъектыКлиент.ПодборИзДОК(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектыСервер.ОграничитьТипОбъекта(Элементы.ОбъектыОбъект);
	
	//
	Если Объект.Ссылка.Пустая() Тогда
		Пользователи.ЗаполнитьРеквизитыПоДаннымПользователя(Объект);
	КонецЕсли;	
	
	//ОбъектыСервер.РасширитьТабличнуюЧасть(Объект.Объекты);
	
	Элементы.ОбъектыПодборПоНастройкам.Видимость = Константы.ИспользоватьНастройкиПодбораОбъектовУчета.Получить();
	Элементы.ГруппаАгент.Видимость = Объект.АгентскаяСхема;

	
КонецПроцедуры

&НаСервере
Процедура ПодборВтаблЧасть(Результат)
	Об = РеквизитФормыВЗначение("Объект");		
	РаботаСДокументами.ЗанестиРезультатПодбораВТабличнуюЧасть(Об.ДолговыеОбязательства, Результат);
	ЗначениеВРеквизитФормы(Об, "Объект");
КонецПроцедуры


&НаКлиенте
Процедура АгентскаяСхемаПриИзменении(Элемент)
	Элементы.ГруппаАгент.Видимость = Объект.АгентскаяСхема;
КонецПроцедуры


&НаКлиенте
Процедура ЭтоЧастичнаяПередачаПравПриИзменении(Элемент)
	Элементы.ВывестиИзРаботы.Видимость = НЕ Объект.ЭтоЧастичнаяПередачаПрав;
КонецПроцедуры

