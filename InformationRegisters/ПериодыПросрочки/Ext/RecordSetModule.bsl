﻿
Процедура ПриЗаписи(Отказ, Замещение)
	//КазанцевЯА , в документе Корректировка регистров он там отсутствует реквизит на который идет проверка
	//Документ Корректировка регистров является также регистратором данного регистра, но не должен подстраиваться под логику,а вносить коррективы из ТЧ 
	МетаданныеОбъекта = ЭтотОбъект.Отбор.Регистратор.Значение.Метаданные();
	Если МетаданныеОбъекта.Реквизиты.Найти("Займ") <> Неопределено Тогда
		РасчетЗадолженностиМФО.АктуализацияХарактеристикМикрозайма(ЭтотОбъект.Отбор.Регистратор.Значение.Займ);
	КонецЕсли;
КонецПроцедуры
