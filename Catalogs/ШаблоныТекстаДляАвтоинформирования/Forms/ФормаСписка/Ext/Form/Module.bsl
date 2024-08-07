﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	ЭтаФорма.РольАБД = РольДоступна("АБД");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Проверить доступность служебных функций
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	// Записать текущие настройки редактирования
	Если ЭтаФорма.РольАБД = Истина Тогда
		ПоказатьОповещениеПользователя("Шаблоны сообщений",,"Настройки редактирования сохранены",БиблиотекаКартинок.NC_Сохранено);
		ЭтаФорма.Записать();
	Иначе
		Предупреждение("Нарушение прав доступа!","Предупреждение");
	КонецЕсли;
КонецПроцедуры

