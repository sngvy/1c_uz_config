﻿
&НаСервере
Процедура ВыполнитьЗадачуНаСервере()
	// Перевести текущую задачу в статус "Выполнено"
	МенеджерЗаписи = РегистрыСведений.ЗадачиСотрудников.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Дата = ТекущаяДата();
	МенеджерЗаписи.Время = ТекущаяДата();
	МенеджерЗаписи.Сотрудник = ЭтаФорма.СотрудникНаКлиенте;
	МенеджерЗаписи.ТипЗадачи = ЭтаФорма.ТипЗадачиНаКлиенте;
	МенеджерЗаписи.Состояние = Перечисления.СостоянияЗадачСотрудников.Выполнена;
	МенеджерЗаписи.Записать(); 
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗадачу(Команда)
	// Передать текущие значения на сервер
	ЭтаФорма.СотрудникНаКлиенте = ЭтаФорма.Элементы.Список.ТекущиеДанные.Сотрудник;
	ЭтаФорма.ТипЗадачиНаКлиенте = ЭтаФорма.Элементы.Список.ТекущиеДанные.ТипЗадачи;
	ВыполнитьЗадачуНаСервере();
	// Убрать признак модифицированности
	ЭтаФорма.Модифицированность = Ложь;
	ПоказатьОповещениеПользователя(ЭтаФорма.ТипЗадачиНаКлиенте,,"Задача выполнена",БиблиотекаКартинок.NC_МероприятиеВыполнено);
	ЭтаФорма.Элементы.Список.Обновить();
КонецПроцедуры