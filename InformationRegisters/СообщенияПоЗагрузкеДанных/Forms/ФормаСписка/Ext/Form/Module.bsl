﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	Набор = РегистрыСведений.СообщенияПоЗагрузкеДанных.СоздатьМенеджерЗаписи();
	Если Параметры.Свойство("Отбор") Тогда
		Набор.Документ = Параметры.Отбор.Документ;
		Набор.Прочитать();
		
		Массив = Набор.МассивСообщений.Получить();
		Номер = 0;
		Для Каждого Элемент Из Массив Цикл
			Номер = Номер + 1;
			СписокОтчет.Добавить(Элемент.Объект, Строка(Номер) + ")  " + СтрЗаменить(Элемент.Текст, Символы.ПС, " "));
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОтчетПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокОтчетВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные.Значение <> Неопределено Тогда
		//Чуров
		//ПоказатьЗначение(,Элемент.ТекущиеДанные.Значение);
		ОткрытьЗначение(Элемент.ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры
