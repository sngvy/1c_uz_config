﻿
Функция ПорядокСписанияВнесудебка() Экспорт
	Массив = Новый Массив;

	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженности.Проценты);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженности.ОсновнойДолг);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженности.Пени);
	Массив.Добавить(ПланыВидовХарактеристик.ТипыЗадолженности.Штрафы);
	
	Возврат Массив;
КонецФункции

Функция СоставляющаяСписанияПриПереплате() Экспорт
	Возврат ПланыВидовХарактеристик.ТипыЗадолженности.Составляющая8;
КонецФункции