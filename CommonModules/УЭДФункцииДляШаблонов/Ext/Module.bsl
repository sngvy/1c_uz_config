﻿
// "05 июля 2009 г."
Функция ДатаВСтроку(Дата) Экспорт 
	Возврат Строка(Формат(Дата, "ДЛФ=DD"));	
КонецФункции  

// "июля 2009"
Функция ДатаВСтрокуБезЧисла(Дата) Экспорт 
	Строка = Строка(Формат(Дата, "ДЛФ=DD"));
	Строка = Сред(Строка, Найти(Строка, " ") + 1, СтрДлина(Строка));	
	Возврат НРег(Строка);	
КонецФункции  

// "1385,55 рублей"
Функция ЧислоВСтроку(Число) Экспорт 
	ФормСтрока = "Л = ru_RU; ДП = Ложь";
	ПарПредмета = "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2";
	ПрописьЧисла = ЧислоПрописью(Число, ФормСтрока, ПарПредмета);
	Строка = Сред(ПрописьЧисла, Найти(ПрописьЧисла, "рубл"), СтрДлина(ПрописьЧисла));
	Строка = Сред(Строка, 0, Найти(Строка, " ") - 1);
	Строка = Строка(Число) + " " + Строка;
	Возврат НРег(Строка);
КонецФункции  

// "1385,55 (тысяча триста...) рублей 55 копеек"
Функция ЧислоВСтроку2(Число) Экспорт 
	ФормСтрока = "Л = ru_RU; ДП = Ложь";
	ПарПредмета = "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,2";
	ПрописьЧисла = ЧислоПрописью(Число, ФормСтрока, ПарПредмета);	
	Строка = "(" + ПрописьЧисла;
	Строка = СтрЗаменить(Строка, " рубл", ") рубл");
	Строка = Строка(Число) + " " + Строка;   
	Возврат НРег(Строка);
КонецФункции  

// "156 (сто пятьдесят..) месяцев"
Функция ЧислоВСтроку3(Число) Экспорт
	ФормСтрока = "Л = ru_RU; НД = Ложь; ДП = Ложь";
	ПарПредмета = "месяц,месяца,месяцев,м,,,,,0";
	ПрописьЧисла = ЧислоПрописью(Число, ФормСтрока, ПарПредмета);
	Строка = "(" + ПрописьЧисла;
	Строка = СтрЗаменить(Строка, " месяц", ") месяц");
	Строка = Строка(Число) + " " + Строка;
	Возврат НРег(Строка);
КонецФункции

//"Август 2011"
//Формат(Дата, "MMMM yyyy");
//Формат(Дата, "ММММ гггг");

//"Воскресенье"
//Формат(Дата, "дддд");
//Формат(Дата, "dddd");

//"Вс"
//Формат(Дата, "ддд");
//Формат(Дата, "ddd");

Функция ДатаВПадеже(Дата)
	Ном = Месяц(Дата);
	Стр = Формат(Дата, "ДФ='ММММ'");
	Если Ном = 3 ИЛИ Ном = 8 Тогда
		// +е
		Стр = Стр + "е";
	Иначе
		// -1+е
		Стр = Лев(Стр, СтрДлина(Стр) - 1) + "е";
	КонецЕсли;
	Стр = Стр + " " + Формат(Дата, "ДФ='гггг'");
	Возврат Стр;
КонецФункции
