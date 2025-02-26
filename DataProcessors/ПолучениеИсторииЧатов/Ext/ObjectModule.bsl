﻿#Область ПрограммныйИнтерфейс

Функция ХранилищеИстории(Значение) Экспорт

	ХранилищеИстории = Значение;
	
	Возврат ЭтотОбъект;

КонецФункции // ()

Функция Получить(Отправитель, Последние = 0) Экспорт

	Попытка
	
		История = ХранилищеИстории.Создать()
			.Отправитель(Отправитель)
			.КоличествоПоследних(Последние)
			.Получить();
	
	Исключение
		ВызватьИсключение ОшибкаЧтенияИстории(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат История;

КонецФункции // ()

Функция ПолучитьЗаПериод(Отправитель, НачалоПериода, КонецПериода) Экспорт

	Попытка
	
		История = ХранилищеИстории.Создать()
			.Отправитель(Отправитель)
			.НачалоПериода(НачалоПериода)
			.КонецПериода(КонецПериода)
			.Получить();
	
	Исключение
		ВызватьИсключение ОшибкаЧтенияИстории(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат История;

КонецФункции // ()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОшибкаЧтенияИстории(ИнформацияОбОшибке)

	Возврат СтрШаблон(
		"Не удалось загрузить историю сообщений
		|По причине:
		|%1",
		ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));

КонецФункции // ()

#КонецОбласти