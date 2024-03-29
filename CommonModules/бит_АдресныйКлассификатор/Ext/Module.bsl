﻿////Служебные

Функция ПолучитьПредставлениеИзXML(СтрокаФИАС) Экспорт
	
	Номер = Найти(СтрокаФИАС, "Представление=");
	
	Если Номер = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Номер = Номер + 14;
	Представление = Сред(СтрокаФИАС,Номер);
	Представление = Лев(Представление, Найти(Представление,">") - 1);
	Представление = СтрЗаменить(Представление, Символ(34), "");
	Возврат Представление;
КонецФункции



//Значение      - Полный адрес в формате КЛАДРа,
//ЧастьАдреса - Массив,часть(-и) адреса(-ов) КЛАДРа; примеры - "Индекс", "Город"; либо Массив(Индекс,Город и тп)
Функция ПолучитьЧастиАдресаИзКЛАДР(Значение, ЧастьАдреса) Экспорт
	
	Номер      =   Найти(Значение, ";");
	Строка     =   Прав(Значение, СтрДлина(Значение) - Номер);
	Адрес      =   Лев(Значение, Номер-1);
	Строки     =   СтрЗаменить(Строка, ";", Символы.Пс);
	Значение   =   "";
	
	ЧастиАдресаКЛАДР = Новый Структура;
	ЧастиАдресаКЛАДР.Вставить("Адрес","");
	ЧастиАдресаКЛАДР.Вставить("Индекс","");
	ЧастиАдресаКЛАДР.Вставить("Регион","");
	ЧастиАдресаКЛАДР.Вставить("Район","");
	ЧастиАдресаКЛАДР.Вставить("Город","");
	ЧастиАдресаКЛАДР.Вставить("Улица","");
	ЧастиАдресаКЛАДР.Вставить("Дом","");
	ЧастиАдресаКЛАДР.Вставить("ТипДома","");
	ЧастиАдресаКЛАДР.Вставить("НаселенныйПункт","");
	ЧастиАдресаКЛАДР.Вставить("Корпус","");
	ЧастиАдресаКЛАДР.Вставить("Квартира","");
	ЧастиАдресаКЛАДР.Вставить("Офис","");
	
	Если ТипЗнч(ЧастьАдреса) = Тип("Массив") Тогда
		
		Для ИндексМассива=0 По ЧастьАдреса.Количество()-1 Цикл
			
			Если ЧастьАдреса[ИндексМассива]= "Адрес" Тогда
				ЧастиАдресаКЛАДР.Адрес = Адрес;
				Продолжить;
			Иначе
				Для Номер = 1 По СтрЧислоСтрок(Строки) Цикл
					Стр = СтрПолучитьСтроку(Строки, Номер);
					
					Если
						Найти(Стр,ЧастьАдреса[ИндексМассива]) Тогда						
						ЧастиАдресаКЛАДР[ЧастьАдреса[ИндексМассива]] = Прав(Стр, СтрДлина(стр) - Найти(Стр, "="));
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
	Иначе
		
		Сообщить("Не верно указан тип второго параметра");
	КонецЕсли;
	Возврат ЧастиАдресаКЛАДР;
КонецФункции


//ЧастьАдреса - Строка, возможные значения:
//"Представление";
//"Индекс";
//"Регион";
//"Район";
//"Город";
//"Улица";
//"Дом";
//"ТипДома";
//"НаселенныйПункт";
//"Корпус";
//"Квартира";
//"ТипКорпуса";
//"ТипКвартиры";
Функция ПолучитьЧастьАдресаИзКЛАДР(знач Значение, ЧастьАдреса) Экспорт
	
	Номер           = Найти(Значение, ";");
	Строка          = Прав(Значение, СтрДлина(Значение) - Номер);
	Адрес           = Лев(Значение, Номер-1);
	Строки          = СтрЗаменить(Строка, ";", Символы.Пс);
	Значение = "";
	
	Если ЧастьАдреса = "Представление" Тогда
	       Возврат Адрес;
	Иначе
	       Для Номер = 1 По СтрЧислоСтрок(Строки) Цикл
	               Стр = СтрПолучитьСтроку(Строки, Номер);
	
	               Если Найти(Стр,ЧастьАдреса) Тогда
	                       Значение = Прав(Стр, СтрДлина(стр) - Найти(Стр,"="));
	                      Прервать;
	              КонецЕсли;
	      КонецЦикла;
	
	КонецЕсли;
	
	Возврат Значение;
КонецФункции

//ЧастьАдреса - Строка, возможные значения:
//"Представление";
//"Индекс";
//"Регион";
//"Район";
//"Город";
//"Улица";
//"Дом";
//"ТипДома";
//"НаселенныйПункт";
//"Корпус";
//"Квартира";
// Значение - XML строка
Функция ПолучитьЧастьАдресаИзФИАС(знач Значение, ЧастьАдреса = Неопределено) Экспорт
	XDTO = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(Значение);
	СписокПолей = Обработки.РасширенныйВводКонтактнойИнформации.КонтактнаяИнформацияВСтаруюСтруктуру(XDTO);
	Значения = СписокПолей.ЗначенияПолей;
	
	Если ЧастьАдреса = Неопределено Тогда
		Возврат Значения;
	КонецЕсли;
	
	Для Номер = 0 по Значения.Количество()-1 Цикл
		Если ВРег(Значения[Номер].Представление) = Врег(ЧастьАдреса) Тогда
			Возврат Значения[Номер].Значение;
		КонецЕсли;
	КонецЦикла;
КонецФункции


#Область КонвертацияКладраВФиас
//Преобразовывает корректный адрес КЛАДР в корректный адрес ФИАС, если адрес КЛАДР не корректный то пробует преобразовать в корректный ФИАС,
//если это не получается то записывает как есть с ошибками, при этом делает запись в регистр сведений ОшибкиФИАС.
//Подробнее о возможных ошибках -
// 1)Некорректный формат адреса:
// - Отсутствуют все значения кроме представления
// - Отсутствует индекс
// - Отсутствует И Улица И НаселенныйПункт не заполнены
//
// 2) По индексу не найдено не одного адреса:
// - По индексу нет адресов в классификаторе
// - Индекс состоит не из 6 символов
//
// 3) Поиск в классификаторе не дал результатов:
// - В списке найденных по индексу адресов не найдено точных совпадений по улице либо населенному пункту
//
// 4) По индексу найдено несколько значений! Не удалось уточнить по городу":
// - После поиска по улице осталось несколько адресов, среди которых не найдено точных совпадений по городу
//
//Параметры -
// Значение - Строка в формате КЛАДР
// ТекЭлемент - Ссылка на объект которое содержит доп сведение
// СвойствоДопСведения - Ссылка на доп сведение
//Возвращает строку в формате XML

&НаСервере
Функция ПреобразоватьАдресКЛАДРВФИАС(Значение, ТекЭлемент, СвойствоДопСведения) Экспорт
	СтруктураАдресаВКЛАДР = ПолучитьСтруктураАдресаВКЛАДР(Значение);
	Если (СтруктураАдресаВКЛАДР.Улица <> "" ИЛИ
		СтруктураАдресаВКЛАДР.НаселенныйПункт <> "") И Не СтруктураАдресаВКЛАДР.Индекс = "" Тогда
		РезультатПоиска = ПолучитьУлицуИРайонПоСтрокеКладр(СтруктураАдресаВКЛАДР, ТекЭлемент, СвойствоДопСведения);
	Иначе
		ТекстОшибки = "Некорректный формат адреса - " + Значение;
		ЗаписатьДополнительноеСведение(ТекЭлемент, СвойствоДопСведения, ТекстОшибки);
		Возврат КривойКАЛДРВКривойФИАС(СтруктураАдресаВКЛАДР);
	КонецЕсли;
	
	Если РезультатПоиска = Неопределено Тогда
		СтрокаXML = КривойКАЛДРВКривойФИАС(СтруктураАдресаВКЛАДР);
	Иначе
		СтруктураАдрес = Обработки.РасширенныйВводКонтактнойИнформации.СписокРеквизитовНаселенныйПункт(РезультатПоиска);
		Если ПустаяСтрока(СтруктураАдрес.ZipCode) Тогда
			СтруктураАдрес.ZipCode = Формат(СтруктураАдресаВКЛАДР.Индекс,"ЧГ=0");
		КонецЕсли;
		
		СтруктураАдресаПолностью(СтруктураАдрес,СтруктураАдресаВКЛАДР);
		СтрокаXML = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзJSONВXML(СтруктураАдрес, Перечисления.ТипыКонтактнойИнформации.Адрес);
	КонецЕсли;
	Возврат СтрокаXML;
КонецФункции

&НаСервере
Функция ПолучитьУлицуИРайонПоСтрокеКЛАДР(СтруктураКладр, ТекЭлемент,
	СвойствоДопСведения)
	
	РезультатПоиска = Неопределено;
	
	РезультатПоискаПоИндексу = НайтиПоИндексу(СтруктураКладр.Индекс);
	
	Если РезультатПоискаПоИндексу = Неопределено Тогда
		ТекстОшибки = "По индексу не найдено не одного адреса";
		ЗаписатьДополнительноеСведение(ТекЭлемент, СвойствоДопСведения,
		ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	УлицаПоЧастям = СтрРазделить(СтруктураКладр.Улица, " ", Ложь);
	Если УлицаПоЧастям.Количество() = 0 Тогда
		УлицаПоЧастям = СтрРазделить(СтруктураКладр.НаселенныйПункт, "", Ложь);
	КонецЕсли;
	
	ЧастиУлицы = Новый Массив;
	
	Для Каждого Строка Из УлицаПоЧастям Цикл
		Если (СтрДлина(Строка)<5 И Прав(Строка, 1)=".") ИЛИ
			СтрДлина(Строка)=1 Тогда
			Продолжить;
		КонецЕсли;
		ЧастиУлицы.Добавить(Строка);
	КонецЦикла;
	
	Для Каждого ЧастьУлицы Из ЧастиУлицы Цикл
		КоличествоЭлементовМассива =
		РезультатПоискаПоИндексу.Количество();
		Для Счетчик = 1 По КоличествоЭлементовМассива Цикл
			ТекИндекс = КоличествоЭлементовМассива - Счетчик;
			ПредставлениеАдреса =
			РезультатПоискаПоИндексу[ТекИндекс].Представление;
			
			Если СтрНайти(ПредставлениеАдреса,ЧастьУлицы)=0 Тогда
				РезультатПоискаПоИндексу.Удалить(ТекИндекс);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	КоличествоСтрок = РезультатПоискаПоИндексу.Количество();
	
	Если КоличествоСтрок = 0 Тогда
		ТекстОшибки = "Поиск в классификаторе не дал результатов";
		ЗаписатьДополнительноеСведение(ТекЭлемент, СвойствоДопСведения,
		ТекстОшибки);
		Возврат Неопределено;
		
	ИначеЕсли КоличествоСтрок = 1 Тогда
		Возврат ПоместитьВСтруктуру(РезультатПоискаПоИндексу[0],
		СтруктураКладр.Индекс);
		
	Иначе
		
		ГородПоЧастям = СтрРазделить(СтруктураКладр.Город, " ", Ложь);
		
		ЧастиГорода = Новый Массив;
		Для Каждого Строка Из ГородПоЧастям Цикл
			Если (СтрДлина(Строка)<5 И Прав(Строка, 1)=".") ИЛИ
				СтрДлина(Строка)=1 Тогда
				Продолжить;
			КонецЕсли;
			Строка = СтрЗаменить(Строка, ".", "");
			Строка = СтрЗаменить(Строка, ",", "");
			ЧастиГорода.Добавить(СокрЛП(Строка));
		КонецЦикла;
		
		Для Каждого ЧастьГорода Из ЧастиГорода Цикл
			КоличествоЭлементовМассива =
			РезультатПоискаПоИндексу.Количество();
			Для Счетчик = 1 По КоличествоЭлементовМассива Цикл
				ТекИндекс = КоличествоЭлементовМассива -
				Счетчик;
				ПредставлениеАдреса =
				РезультатПоискаПоИндексу[ТекИндекс].Представление;
				
				Если СтрНайти(ПредставлениеАдреса,ЧастьГорода)>0
					Тогда
					
					РезультатПоискаПоИндексу.Удалить(ТекИндекс);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		КоличествоСтрок = РезультатПоискаПоИндексу.Количество();
		
		Если Не КоличествоСтрок = 1 Тогда
			ТекстОшибки = "По индексу найдено несколько значений! Не удалось уточнить по городу";
			ЗаписатьДополнительноеСведение(ТекЭлемент,
			СвойствоДопСведения, ТекстОшибки);
			Возврат РезультатПоиска;
		КонецЕсли;
		
		Возврат ПоместитьВСтруктуру(РезультатПоискаПоИндексу[0],
		СтруктураКладр.Индекс);
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктураАдресаВКЛАДР(ИсходнаяСтрока)
	
	СписокСтрок = СтрЗаменить(ИсходнаяСтрока, ";", Символы.ПС);
	ЗначенияПолей = Новый Структура;
	
	Если СтрЧислоСтрок(СписокСтрок) > 1 Тогда
		Для Индекс = 2 По СтрЧислоСтрок(СписокСтрок) Цикл
			Стр = СтрПолучитьСтроку(СписокСтрок, Индекс);
			Если Стр <> "" Тогда
				СписокПодстрок = СтрЗаменить(Стр, "=",
				Символы.ПС);
				Если СтрЧислоСтрок(СписокПодстрок) = 2 Тогда
					
					
					ЗначенияПолей.Вставить(СтрПолучитьСтроку(СписокПодстрок, 1),
					СтрПолучитьСтроку(СписокПодстрок, 2));
				Иначе
					//ТекстОшибки = "Некорректный формат адреса - " + ИсходнаяСтрока;
					
					//ЗаписатьДополнительноеСведение(ТекЭлемент, СвойствоКЛАДР, ТекстОшибки);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		ЗначенияПолей.Вставить("Представление",
		СтрПолучитьСтроку(СписокСтрок,1));
	ИначеЕсли СтрЧислоСтрок(СписокСтрок) = 1 Тогда
		ЗначенияПолей.Вставить("Представление", ИсходнаяСтрока);
		//ТекстОшибки = "Некорректный формат адреса - " + ИсходнаяСтрока;
		//ЗаписатьДополнительноеСведение(ТекЭлемент, СвойствоКЛАДР, ТекстОшибки);
	КонецЕсли;
	
	ЧастиАдреса = Новый Структура;
	ЧастиАдреса.Вставить("Страна", "");
	ЧастиАдреса.Вставить("Индекс", "");
	ЧастиАдреса.Вставить("Регион", "");
	ЧастиАдреса.Вставить("Город", "");
	ЧастиАдреса.Вставить("Район", "");
	ЧастиАдреса.Вставить("НаселенныйПункт", "");
	ЧастиАдреса.Вставить("Улица", "");
	ЧастиАдреса.Вставить("ТипДома", "");
	ЧастиАдреса.Вставить("Дом", "");
	ЧастиАдреса.Вставить("ТипКвартиры", "");
	ЧастиАдреса.Вставить("Квартира", "");
	ЧастиАдреса.Вставить("ТипКорпуса", "");
	ЧастиАдреса.Вставить("Корпус", "");
	ЧастиАдреса.Вставить("Представление", "");
	
	ЗаполнитьЗначенияСвойств(ЧастиАдреса, ЗначенияПолей);
	
	Возврат ЧастиАдреса;
КонецФункции

&НаСервере
Процедура СтруктураАдресаПолностью(СтруктураАдрес, ЧастиАдресаКладр)
	
	apartments = Новый Массив;
	Структура = Новый Структура;
	Если ЗначениеЗаполнено(ЧастиАдресаКладр.Квартира) ИЛИ
		ЗначениеЗаполнено(ЧастиАдресаКладр.ТипКвартиры) Тогда
		Структура.Вставить("number", ЧастиАдресаКладр.Квартира);
		Структура.Вставить("type",
		УбратьСокращения(ЧастиАдресаКладр.ТипКвартиры));
		apartments.Добавить(Структура);
	КонецЕсли;
	
	buildings = Новый Массив;
	Структура = Новый Структура;
	Если ЗначениеЗаполнено(ЧастиАдресаКладр.Корпус) ИЛИ
		ЗначениеЗаполнено(ЧастиАдресаКладр.ТипКорпуса) Тогда
		Структура.Вставить("number", ЧастиАдресаКладр.Корпус);
		Структура.Вставить("type",
		УбратьСокращения(ЧастиАдресаКладр.ТипКорпуса));
		buildings.Добавить(Структура);
	КонецЕсли;
	
	СтруктураАдрес.apartments       = apartments;
	СтруктураАдрес.buildings        = buildings;
	СтруктураАдрес.houseType        =
	УбратьСокращения(ЧастиАдресаКладр.ТипДома);
	СтруктураАдрес.houseNumber      = ЧастиАдресаКладр.Дом;
	
	СтруктураАдрес.value            =
	РаботаСАдресамиКлиентСервер.ПредставлениеАдреса(СтруктураАдрес, Ложь);
	
КонецПроцедуры

&НаСервере
Функция НайтиПоИндексу(Индекс)
	Если СтрДлина(Индекс) = 6 Тогда
		СписокАдресов = ВыбратьУлицыПоИндексу(Индекс);
		Если Не ЗначениеЗаполнено(СписокАдресов) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	МассивАТАдресов = СписокАдресов.НайтиСтроки(Новый
	Структура("Муниципальный",Ложь));
	Возврат МассивАТАдресов;
КонецФункции

&НаСервере
Функция ВыбратьУлицыПоИндексу(Индекс)
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("СкрыватьНеактуальные",Истина);
	ДанныеКлассификатора =
	Обработки.РасширенныйВводКонтактнойИнформации.АдресаКлассификатораПоПочтовомуИндексу(Индекс, ПараметрыПоиска);
	
	Если ДанныеКлассификатора.Отказ Тогда
		КраткоеПредставлениеОшибки =
		ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Возврат Неопределено;
		
	ИначеЕсли ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		КраткоеПредставлениеОшибки = НСтр("ru = 'Индекс не найден в адресном классификаторе.'");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеКлассификатора.Данные;
	
КонецФункции

&НаСервере
Функция ПоместитьВСтруктуру(СтрокаТЗ, Индекс)
	Структура = Новый Структура;
	Структура.Вставить("Идентификатор", СтрокаТЗ.Идентификатор);
	Структура.Вставить("Индекс", Индекс);
	Структура.Вставить("КраткоеПредставлениеОшибки", "");
	Структура.Вставить("Муниципальный", СтрокаТЗ.Муниципальный);
	Структура.Вставить("Отказ", Ложь);
	Возврат Структура;
КонецФункции

&НаСервере
Функция КривойКАЛДРВКривойФИАС(ЧастиАдреса) Экспорт
	
	ВыпрямлениеКЛАДРа(ЧастиАдреса);
	
	Результат =
	РаботаСАдресамиКлиентСервер.ОписаниеНовойКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	Результат.Вставить("ZIPcode", ЧастиАдреса.Индекс);
	Результат.Вставить("id", Новый УникальныйИдентификатор);
	Результат.Вставить("addressType", "Административно-территориальный");
	apartments = Новый Массив;
	Структура = Новый Структура;
	Если ЗначениеЗаполнено(ЧастиАдреса.Квартира) ИЛИ
		ЗначениеЗаполнено(ЧастиАдреса.ТипКвартиры) Тогда
		Структура.Вставить("number", ЧастиАдреса.Квартира);
		Структура.Вставить("type",
		УбратьСокращения(ЧастиАдреса.ТипКвартиры));
		apartments.Добавить(Структура);
	КонецЕсли;
	Результат.Вставить("apartments", apartments);
	Результат.Вставить("area", ЧастиАдреса.Регион);
	Результат.Вставить("areaCode", "");
	Результат.Вставить("areaId", "");
	Результат.Вставить("areaType", Неопределено);
	Результат.Вставить("asInDocument", "");
	buildings = Новый Массив;
	Структура = Новый Структура;
	Если ЗначениеЗаполнено(ЧастиАдреса.Корпус) ИЛИ
		ЗначениеЗаполнено(ЧастиАдреса.ТипКорпуса) Тогда
		Структура.Вставить("number", ЧастиАдреса.Корпус);
		Структура.Вставить("type",
		УбратьСокращения(ЧастиАдреса.ТипКорпуса));
		buildings.Добавить(Структура);
	КонецЕсли;
	Результат.Вставить("buildings", buildings);
	Результат.Вставить("city", ЧастиАдреса.Город);
	Результат.Вставить("cityDistrict", "");
	Результат.Вставить("cityDistrictId", "");
	Результат.Вставить("cityDistrictType", "");
	Результат.Вставить("cityType", Неопределено);
	Результат.Вставить("codeKLADR", "");
	Результат.Вставить("comment", "");
	Результат.Вставить("country", ЧастиАдреса.Страна);
	Результат.Вставить("countryCode", "");
	Результат.Вставить("district", ЧастиАдреса.Район);
	Результат.Вставить("districtType", Неопределено);
	Результат.Вставить("districtId", "");
	Результат.Вставить("munDistrict", "");
	Результат.Вставить("munDistrictType", "");
	Результат.Вставить("munDistrictId", "");
	Результат.Вставить("settlement", "");
	Результат.Вставить("settlementType", "");
	Результат.Вставить("settlementId", "");
	Результат.Вставить("territory", "");
	Результат.Вставить("territoryType", "");
	Результат.Вставить("territoryId", "");
	Результат.Вставить("locality", ЧастиАдреса.НаселенныйПункт);
	Результат.Вставить("localityType", Неопределено);
	Результат.Вставить("localityId", "");
	Результат.Вставить("street", ЧастиАдреса.Улица);
	Результат.Вставить("streetId", "");
	Результат.Вставить("streetType", "");
	Результат.Вставить("houseType", УбратьСокращения(ЧастиАдреса.ТипДома));
	Результат.Вставить("houseNumber", ЧастиАдреса.Дом);
	Результат.Вставить("houseId", "");
	Результат.Вставить("oktmo", "");
	Результат.Вставить("okato", "");
	Результат.Вставить("ifnsFLCode", "");
	Результат.Вставить("ifnsULCode", "");
	Результат.Вставить("ifnsFLAreaCode", "");
	Результат.Вставить("ifnsULAreaCode", "");
	Результат.Вставить("type", "Адрес");
	Результат.Вставить("value", ЧастиАдреса.Представление);
	СтрокаХМЛ =
	УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзJSONВXML(Результат, Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	Возврат СтрокаХМЛ;
КонецФункции

&НаСервере
Процедура ЗаписатьДополнительноеСведение(ОбъектСсылка, Свойство, Значение)
	Если Свойство <>
		ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка() И
		Свойство <> Неопределено Тогда
		НаборЗаписей =
		РегистрыСведений.ОшибкиФИАС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(ОбъектСсылка);
		НаборЗаписей.Отбор.Свойство.Установить(Свойство);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 0 Тогда
			Запись = НаборЗаписей.Добавить();
			Запись.Объект = ОбъектСсылка;
			Запись.Свойство = Свойство;
			Запись.Значение = Значение;
		Иначе
			НаборЗаписей[0].Значение = Значение;
		КонецЕсли;
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УбратьСокращения(ПроверяемоеЗанчение)
	
	Если ВРЕГ(ПроверяемоеЗанчение) = "КОРП" Или ВРЕГ(ПроверяемоеЗанчение) =
		"КОРП." Тогда
		ПроверяемоеЗанчение = "Корпус";
	ИначеЕсли ВРЕГ(ПроверяемоеЗанчение) = "КВ" Или ВРЕГ(ПроверяемоеЗанчение)
		= "КВ." Тогда
		ПроверяемоеЗанчение = "Квартира";
	ИначеЕсли ВРЕГ(ПроверяемоеЗанчение) = "ОФ" Или ВРЕГ(ПроверяемоеЗанчение)
		= "ОФ." Тогда
		ПроверяемоеЗанчение = "Офис";
	ИначеЕсли ВРЕГ(ПроверяемоеЗанчение) = "ПОМЕЩ" Или
		ВРЕГ(ПроверяемоеЗанчение) = "ПОМЕЩ." Тогда
		ПроверяемоеЗанчение = "Помещение";
	ИначеЕсли ВРЕГ(ПроверяемоеЗанчение) = "Д" Или ВРЕГ(ПроверяемоеЗанчение)
		= "Д." Тогда
		ПроверяемоеЗанчение = "Дом";
	ИначеЕсли ВРЕГ(ПроверяемоеЗанчение) = "ЛИТЕРА" Тогда
		ПроверяемоеЗанчение = "Литер";
	КонецЕсли;
	
	Возврат ПроверяемоеЗанчение;
КонецФункции

&НаСервере
Процедура ВыпрямлениеКЛАДРа(ЧастиАдреса)
	
	Для каждого ЧастьАдреса Из ЧастиАдреса Цикл
		Если ЧастьАдреса.Ключ = "Регион" И Не ЧастьАдреса.Значение = ""
			Тогда
			
			Результат =
			ЗаменитьПриНеобходимости(ЧастьАдреса.Значение);
			Если ЗначениеЗаполнено(Результат) Тогда
				ЧастиАдреса.Регион = Результат;
			КонецЕсли;
			Продолжить;
			
		ИначеЕсли        ЧастьАдреса.Ключ = "Город" Тогда
			
			Результат =
			ЗаменитьПриНеобходимости(ЧастьАдреса.Значение);
			Если ЗначениеЗаполнено(Результат) Тогда
				ЧастиАдреса.Город = Результат;
			КонецЕсли;
			Продолжить;
			
		ИначеЕсли        ЧастьАдреса.Ключ = "Район" Тогда
			
			
			Результат =
			ЗаменитьПриНеобходимости(ЧастьАдреса.Значение);
			Если ЗначениеЗаполнено(Результат) Тогда
				ЧастиАдреса.Район = Результат;
			КонецЕсли;
			Продолжить;
			
		ИначеЕсли        ЧастьАдреса.Ключ = "НаселенныйПункт" Тогда
			
			Результат =
			ЗаменитьПриНеобходимости(ЧастьАдреса.Значение);
			Если ЗначениеЗаполнено(Результат) Тогда
				ЧастиАдреса.НаселенныйПункт = Результат;
			КонецЕсли;
			Продолжить;
			
		ИначеЕсли        ЧастьАдреса.Ключ = "Улица" Тогда
			
			Результат =
			ЗаменитьПриНеобходимости(ЧастьАдреса.Значение);
			Если ЗначениеЗаполнено(Результат) Тогда
				ЧастиАдреса.Улица = Результат;
			КонецЕсли;
			Продолжить;
			
		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	СформироватьПредставление(ЧастиАдреса);
	
КонецПроцедуры

&НаСервере
Функция ЗаменитьПриНеобходимости(ЗначениеЧастиАдреса)
	
	ВозможныеВариантыСокращений = "%обл%респ%край%аобл%ао%г%рп%р-н%п%п%д%с%пгт%тер%нп%пер%проезд%ул%пр-д%пр-кт%пл%б-р%ш%наб%";
	
	СписокСтрок = СтрРазделить(ЗначениеЧастиАдреса, " ", Символы.ПС);
	
	Если СписокСтрок.Количество() < 2 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧастьСтроки = СтрЗаменить(СписокСтрок[0], ".", "");
	СтрокаПоиска = ("%" + ЧастьСтроки + "%");
	
	Если СтрНайти(ВРег(ВозможныеВариантыСокращений), ВРег(СтрокаПоиска)) = 0
		Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СписокСтрок.Удалить(0);
	СписокСтрок.Добавить(ЧастьСтроки);
	Возврат СокрП(СтрСоединить(СписокСтрок, " "));
КонецФункции

&НаСервере
Процедура СформироватьПредставление(СтруктураАдреса)
	
	Представление = "";
	
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Индекс),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Регион),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Район),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Город),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.НаселенныйПункт),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Улица),
	", ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Дом),
	", " + СтруктураАдреса.ТипДома    + " № ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Корпус),
	", " + СтруктураАдреса.ТипКорпуса + " ", Представление);
	ДополнитьПредставлениеАдреса(СокрЛП(СтруктураАдреса.Квартира),
	", " + СтруктураАдреса.ТипКвартиры, Представление);
	
	Если СтрДлина(Представление) > 2 Тогда
		Представление = Сред(Представление, 3);
	КонецЕсли;
	Если Представление = "" И СтруктураАдреса.Представление <> "" Тогда
		Возврат;
	КонецЕсли;
	СтруктураАдреса.Представление = Представление;
КонецПроцедуры

&НаСервере
Процедура ДополнитьПредставлениеАдреса(Дополнение, СтрокаКонкатенации,
	Представление)
	Если Дополнение <> "" Тогда
		Представление = Представление + СтрокаКонкатенации + Дополнение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
 
//+Protas 10.12.18 Открытие формы адреса в формате ФИАС 
&НаСервере 
Функция ПолучитьСтрокуXML(СтрокаJSON) Экспорт 
	СтруктураJSON = УправлениеКонтактнойИнформациейСлужебный.СтрокаJSONВСтруктуру(СтрокаJSON); 
	СтрокаХМЛ = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзJSONВXML(СтруктураJSON, Перечисления.ТипыКонтактнойИнформации.Адрес); 
	Возврат СтрокаХМЛ; 
КонецФункции 

&НаСервере 
Функция ПолучитьJSONИзXML(знач Параметры) Экспорт 
	СтруктураJSON = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтруктуруJSON(Параметры); 
	Возврат УправлениеКонтактнойИнформациейСлужебный.СтруктураВСтрокуJSON(СтруктураJSON); 
КонецФункции 
//-Protas