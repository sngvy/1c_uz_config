﻿
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.НастройкиБП.ДобавитьСоответствие(ЭтотОбъект.Схема, ЭтотОбъект.Операция);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Наименование = УправлениеЗапрещеннымиСимволами
		.УбратьЗапрещенныеСимволыДляБизнесПроцесса(Наименование);
	
КонецПроцедуры
