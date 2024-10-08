﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//КазанцевЯА , в документе Корректировка регистров он там отсутствует реквизит на который идет проверка
	//Документ Корректировка регистров является также регистратором данного регистра, но не должен подстраиваться под логику,а вносить коррективы из ТЧ 
	МетаданныеОбъекта = ЭтотОбъект.Отбор.Регистратор.Значение.Метаданные();
	Если МетаданныеОбъекта.ТабличныеЧасти.Найти("Объекты") <> Неопределено Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ОбъектыВРаботеОстатки.Сотрудник КАК Сотрудник
		                      |ИЗ
		                      |	РегистрНакопления.ОбъектыВРаботе.Остатки(
		                      |			,
		                      |			Объект = &Объект
		                      |				И Сотрудник <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)) КАК ОбъектыВРаботеОстатки");
		Для Каждого Стр из ЭтотОбъект.Отбор.Регистратор.Значение.Объекты Цикл
			Запрос.УстановитьПараметр("Объект", Стр.Объект);
			Результат = Запрос.Выполнить().Выбрать();	
			НаборЗаписей = РегистрыСведений.ОбъектыВРаботеСотрудника.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Объект.Установить(Стр.Объект);
			Пока Результат.Следующий() Цикл
				Запись = НаборЗаписей.Добавить();
				Запись.Объект = Стр.Объект;
				Запись.Сотрудник = Результат.Сотрудник;
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЦикла;
	КонецЕсли;
	//
	Справочники.ФункцииДополнительныхСвойств.ПроставитьЗначенияДопСвойств(ЭтотОбъект, 
			Перечисления.ИнициаторыСобытийДляДопСвойств.ОбъектыВРаботе);
КонецПроцедуры
