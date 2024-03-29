﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	ЭтаФорма.РольАБД = РольДоступна("АБД");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Получить непредопредленное значение с сервера
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЭтаФорма.Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура СформироватьСпискиНаСервере()
	ФоновыеЗадания.Выполнить("ФоновыеЗаданияМодуль.ФормированиеСписковАвтообзвона",,,"Формирование списков автообзвона");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписки(Команда)
	// Проверить доступность служебных функций
	Если ЭтаФорма.РольАБД = Истина Тогда
		ПоказатьОповещениеПользователя("Формирование списков автообзвона",,"Задание запущено в фоновом режиме",БиблиотекаКартинок.NC_Подсистема_тсАдминистрирование);
		СформироватьСпискиНаСервере();
	Иначе
		Предупреждение("Нарушение прав доступа!",,"Предупреждение");
	КонецЕсли;
КонецПроцедуры

 &НаСервере
Процедура УдалитьСпискиНаСервере()
	ФоновыеЗадания.Выполнить("ФоновыеЗаданияМодуль.УдалениеСписковАвтообзвона",,,"Удаление списков автообзвона");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСписки(Команда)
	// Проверить доступность служебных функций
	Если ЭтаФорма.РольАБД = Истина Тогда
		Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			УдалитьСпискиНаСервере();
			Для Счетчик = 1 По 100 Цикл
				Состояние("Удаление списков автообзвона", Счетчик, "Пожалуйста, подождите...", БиблиотекаКартинок.NC_ПодсистемаНастройкиАвтообзвона);
				Пока Элементы.Список.ТекущиеДанные <> Неопределено Цикл
					Элементы.Список.Обновить();
				КонецЦикла;
			КонецЦикла;
			ПоказатьОповещениеПользователя("Удаление списков автообзвона",,"Списки автообзвона удалены",БиблиотекаКартинок.NC_ПодсистемаНастройкиАвтообзвона);
		Иначе
			Предупреждение("Не выбраны объекты!",,"Удаление списков автообзвона");
		КонецЕсли;
	Иначе
		Предупреждение("Нарушение прав доступа!",,"Предупреждение");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РазблокироватьДелаНаСервере()
	ФоновыеЗадания.Выполнить("ФоновыеЗаданияМодуль.РазблокировкаДелДляАвтообзвона",,,"Разблокировка дел для автообзвона");
КонецПроцедуры

&НаКлиенте
Процедура РазблокироватьДела(Команда)
	// Проверить доступность служебных функций
	Если ЭтаФорма.РольАБД = Истина Тогда
		ПоказатьОповещениеПользователя("Разблокировка дел для автообзвона",,"Задание запущено в фоновом режиме",БиблиотекаКартинок.NC_Подсистема_тсАдминистрирование);
		РазблокироватьДелаНаСервере();
	Иначе
		Предупреждение("Нарушение прав доступа!",,"Предупреждение");
	КонецЕсли;
КонецПроцедуры


