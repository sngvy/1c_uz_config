﻿
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Формат(Код, "ЧН=; ЧГ=") + " - " + Столица + " (" + Регион + ")";
КонецПроцедуры
