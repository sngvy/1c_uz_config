﻿
Процедура ПередЗаписью(Отказ)
	Если ЭтоНовый() Тогда
		ЭтотОбъект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ) Экспорт
	Если Не Прочитано И Не ПометкаУдаления Тогда
		МенеджерЗаписи = РегистрыСведений.СообщенияКПросмотру.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Ответственный = Сотрудник;	
		МенеджерЗаписи.Сообщение = Ссылка;
		МенеджерЗаписи.Записать();
	Иначе
		Набор = РегистрыСведений.СообщенияКПросмотру.СоздатьНаборЗаписей();
		Набор.Отбор.Сообщение.Установить(Ссылка);
		Набор.Записать();	
	КонецЕсли;
КонецПроцедуры
