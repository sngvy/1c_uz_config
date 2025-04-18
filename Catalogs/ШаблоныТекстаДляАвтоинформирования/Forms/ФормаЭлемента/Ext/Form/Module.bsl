﻿
&НаКлиенте
Процедура НастройкаЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
			
    ТекущиеДанные = Элементы.Настройка.ТекущиеДанные;
	Если ТекущиеДанные.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Реквизит") Тогда
		СтруктураПараметров = ОткрытьФормуВыбораРеквизитов(НаПримереОбъект, ЭтаФорма,,, ТекущиеДанные);
		Если Не СтруктураПараметров = Неопределено Тогда
			//////////ТекущиеДанные.Значение = СтруктураПараметров.Синоним;
			//////////МассивХранилища = СтруктураПараметров.Хранилище.Получить(); 	
			//////////
			//////////ТекущиеДанные.КодДопСвойства = СтруктураПараметров.КодДопСвойства;
			//////////ТекущиеДанные.ОбъектДопСвойства = СтруктураПараметров.ОбъектДопСвойства;
			//////////
			//////////РеквизитВЗначение(ТекущиеДанные.НомерСтроки, СтруктураПараметров.Хранилище);
			//////////
			//////////Модифицированность = Истина;
			
			//--
			ТекущиеДанные.Значение 	= СтруктураПараметров.Синоним;
			МассивДанных = СтруктураПараметров.МассивДанных; 	
			
			ТекущиеДанные.КодДопСвойства = СтруктураПараметров.КодДопСвойства;
			ТекущиеДанные.ОбъектДопСвойства = СтруктураПараметров.ОбъектДопСвойства;
			
			Список = Новый СписокЗначений;
			Для Каждого Стр Из МассивДанных Цикл
				Список.Добавить(Стр);
			КонецЦикла;
			РеквизитВЗначение(ТекущиеДанные.НомерСтроки, МассивДанных);

			//--
			
		КонецЕсли;	
					
	ИначеЕсли ТекущиеДанные.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Файл") Тогда
		Форма = ПолучитьФорму("Справочник.ЗвуковыеФайлы.Форма.ФормаВыбора",, ЭтаФорма);
		//Чуров
		Значение = ОткрытьФорму(Форма);
		//Значение = Форма.ОткрытьМодально();
		Если Значение <> Неопределено Тогда
			ТекущиеДанные.Значение = Значение;
			Модифицированность = Истина;
		КонецЕсли;	
	КонецЕсли;	
		
КонецПроцедуры


&НаСервере
Процедура РеквизитВЗначение(НомерСтроки, Хранилище)
	Рекв = РеквизитФормыВЗначение("Объект");
	Рекв.ЗаписатьХранилищеЗначений(НомерСтроки, Хранилище);
	ЗначениеВРеквизитФормы(Рекв, "Объект");
КонецПроцедуры

&НаКлиенте
Функция ОткрытьФормуВыбораРеквизитов(ВызывающийДокумент, ФормаВладелец = Неопределено, 
		ПоказыватьЗначение = Истина, ОтФильтрТипов = Неопределено, ТекущиеДанныеПередОткрытием = Неопределено) Экспорт	
		
	Если ВызывающийДокумент = Неопределено Тогда
		Сообщить("Поле ""На примере"" должно быть заполнено", СтатусСообщения.Внимание); 
		Возврат Неопределено;	
	КонецЕсли; 
	
	Форма = ПолучитьФорму("Справочник.тсШаблоныПечатныхДокументов.Форма.ФормаВыбораРеквизитовУпр");
	Форма.ВладелецФормы = ФормаВладелец;
	Если ЗначениеЗаполнено(ОтФильтрТипов) Тогда	
		ЗаголовогПлюс = " по типу """ + Строка(ОтФильтрТипов) + """";	
	КонецЕсли; 
	форма.Заголовок = "Выбор реквизитов" + ЗаголовогПлюс;
	Форма.ЗакрыватьПриЗакрытииВладельца = Истина;
	Форма.Документ = ВызывающийДокумент;
	Форма.ОтФильтрТипов = ОтФильтрТипов;
	Форма.Элементы.ТабМетаданныеДерево.ПодчиненныеЭлементы.тзМетаданныеЗначение.Видимость = ПоказыватьЗначение;	
	 	
	//Если Не  ТекущиеДанныеПередОткрытием = Неопределено Тогда
	//	Форма.ХранилищеЗначРекв = ТекущиеДанныеПередОткрытием.Хранилище;	
	//КонецЕсли;
		
	//Чуров
	СтруктураПараметров = ОткрытьФорму(Форма);	
	//СтруктураПараметров = Форма.ОткрытьМодально();	
	Возврат СтруктураПараметров;	
КонецФункции // ()

// Получить значения с сервера

&НаСервере
Процедура ПриОткрытииНаСервере()
	ЭтаФорма.РазрешитьРедактированиеШаблоновСМС = Константы.РазрешитьРедактированиеШаблоновСообщений.Получить();
КонецПроцедуры

//

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
	УстановитьВидимостьЭлементов();
	Если Объект.НазначениеШаблона = 
		ПредопределенноеЗначение("Перечисление.ВариантыДействийДляСкоринга.EMailРассылка") Тогда
		ШаблонHTMLПриИзменении(Неопределено);	
	Иначе
		ШаблонТекстаПриИзменении(Неопределено);
	КонецЕсли;
	// Передать шаблон в форму отправки, если редактирование шаблонов запрещено
	Если ЭтаФорма.РазрешитьРедактированиеШаблоновСМС = Ложь И ЭтаФорма.МассоваяОтправка = Ложь Тогда
		ФормаСпискаШаблонов = ПолучитьФорму("Справочник.ШаблоныТекстаДляАвтоинформирования.Форма.ФормаСписка");
		ЭтаФорма.НаПримереОбъект = ФормаСпискаШаблонов.СкрытоеПолеНомерДО;
		ЗаполнитьШаблон(Неопределено);
		ПередатьВФормуОтправки(Неопределено);
		ЭтаФорма.Закрыть();
		ФормаСпискаШаблонов.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//
	Элементы.ГруппаСтраницыЦентр.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;

	//
	Если Не Объект.Ссылка.Пустая() Тогда
		//Заполнение полей НаПримере
		ИмяСправочника = Перечисления.ОбъектыУчета.ПолучитьИмяСправочника(Объект.ОбъектУчета);
		Если ИмяСправочника <> Неопределено Тогда
			Выполнить("НаПримереОбъект = Справочники." + ИмяСправочника + ".НайтиПоКоду(Объект.НаПримереОбъект);");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблон(Команда) Экспорт
	Если Объект.НазначениеШаблона = 
			ПредопределенноеЗначение("Перечисление.ВариантыДействийДляСкоринга.EMailРассылка") Тогда
		ПримерHTML = ЗаполнитьШаблонРассылки();
	Иначе
		ПримерТекста = ЗаполнитьШаблонАвтоинформирования();
		КоличествоСимволовТеста = СтрДлина(ПримерТекста);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередатьВФормуОтправки(Команда)
	// Получить формы рассылки
	ФормаСМС = ПолучитьФорму("Обработка.бит_Битфон.Форма.ОтправкаСМС");
	ФормаВЦ = ПолучитьФорму("ОбщаяФорма.ОтправкаНаWhatsApp");
	ФормаВайбер = ПолучитьФорму("ОбщаяФорма.ОтправкаНаViber");
	ФормаМассоваяОтправка = ПолучитьФорму("ОбщаяФорма.МассоваяОтправкаСМС");
	Если ФормаСМС.Открыта() Тогда
		ФормаСМС.ТекстСМС = ЭтаФорма.ПримерТекста;
	ИначеЕсли ФормаВЦ.Открыта() Тогда
		ФормаВЦ.Сообщение = ЭтаФорма.ПримерТекста;
	ИначеЕсли ФормаВайбер.Открыта() Тогда
		ФормаВайбер.Сообщение = ЭтаФорма.ПримерТекста;
	ИначеЕсли ФормаСМС.Открыта() = Ложь
		И ФормаВЦ.Открыта() = Ложь
		И ФормаВайбер.Открыта() = Ложь
		И ФормаМассоваяОтправка.Открыта() = Ложь Тогда
		Предупреждение("Не найдены открытые формы отправки сообщений",,"Шаблоны сообщений");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗаполнитьШаблонАвтоинформирования()
	Об = РеквизитФормыВЗначение("Объект");
	
	Текст = Объект.ШаблонТекста;
	Для Каждого Элемент Из Объект.Настройка Цикл
		Если Элемент.Используется Тогда
			Если Элемент.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Текст") Тогда
				СтрокаЗамены = Элемент.Значение;
				
			ИначеЕсли Элемент.ТипПоля = 
					ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Реквизит") Тогда	
					
				//--Массив = Об.Настройка[Элемент.НомерСтроки - 1].Хранилище.Получить();						
				Массив = УЭДСервер.ПолучитьМассивИзСтроки(Об.Настройка[Элемент.НомерСтроки - 1].СтрокаХранилище);

				СтрокаЗамены = Справочники.ШаблоныТекстаДляАвтоинформирования.РазобратьСтроку(
						Элемент.СтрокаДляПолученияЗначения, Элемент.Значение, НаПримереОбъект, Массив);
						
			ИначеЕсли Элемент.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Файл") И 
					Не Элемент.Значение.Пустая() Тогда	
				СтрокаЗамены = "{" + Элемент.Значение.Путь + "}";
			КонецЕсли; 		
			
			Если Не Элемент.Функция.Пустая() Тогда
				СтрокаЗамены = Справочники.ШаблоныТекстаДляАвтоинформирования.ВычислитьФункцию(Элемент.Функция.Функция, 
						НаПримереОбъект, СтрокаЗамены);
			КонецЕсли;
								
			Текст = СтрЗаменить(Текст, Элемент.Поле, СтрокаЗамены);
		КонецЕсли;
	КонецЦикла;
	Текст = СтрЗаменить(Текст, Символы.НПП, "");
	Возврат Текст;	
КонецФункции
	
&НаКлиенте
Процедура НастройкаТипПоляПриИзменении(Элемент)
	ТекСтрока = Элементы.Настройка.ТекущиеДанные;
	Если ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Файл") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;
		ТекСтрока.Значение = ПредопределенноеЗначение("Справочник.ЗвуковыеФайлы.ПустаяСсылка");
		Элементы.НастройкаЗначение.КнопкаВыбора = Истина;
	
	ИначеЕсли ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Реквизит") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;
		ТекСтрока.Значение = "";
		Элементы.НастройкаЗначение.КнопкаВыбора = Истина;
		
	ИначеЕсли ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Текст") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Истина;
		ТекСтрока.Значение = "";
		Элементы.НастройкаЗначение.КнопкаВыбора = Ложь;
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПередНачаломИзменения(Элемент, Отказ)
	ТекСтрока =  Элементы.Настройка.ТекущиеДанные;
	Если ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Файл") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;        
		Если ТипЗнч(ТекСтрока.Значение) <> Тип("СправочникСсылка.ЗвуковыеФайлы") Тогда
			ТекСтрока.Значение = ПредопределенноеЗначение("Справочник.ЗвуковыеФайлы.ПустаяСсылка");
		КонецЕсли;
		Элементы.НастройкаЗначение.КнопкаВыбора = Истина; 
		
	ИначеЕсли ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Реквизит") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;
		Если ТипЗнч(ТекСтрока.Значение) <> Тип("Строка") Тогда
           	ТекСтрока.Значение = "";
		КонецЕсли;
		Элементы.НастройкаЗначение.КнопкаВыбора = Истина;
		
	ИначеЕсли ТекСтрока.ТипПоля = ПредопределенноеЗначение("Перечисление.ТипыЗначенийДляШаблонов.Текст") Тогда
		Элементы.НастройкаЗначение.РедактированиеТекста = Истина; 
		Если ТипЗнч(ТекСтрока.Значение) <> Тип("Строка") Тогда
           	ТекСтрока.Значение = "";
		КонецЕсли;
		Элементы.НастройкаЗначение.КнопкаВыбора = Ложь;
		
	Иначе
		Элементы.НастройкаЗначение.РедактированиеТекста = Ложь; 
        ТекСтрока.Значение = "";
		Элементы.НастройкаЗначение.КнопкаВыбора = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Используется = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаПримереОбъектПриИзменении(Элемент)
	Объект.НаПримереОбъект = ПолучитьКодПоСсылке(НаПримереОбъект);
	Если ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.Контрагенты");
	ИначеЕсли ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.ДоговорыКонтрагентов");
	ИначеЕсли ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.УслугиПоДоговору") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.УслугиПоДоговору");
	ИначеЕсли ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.ДолговыеОбязательства") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.ДолговыеОбязательства");
	ИначеЕсли ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.ИсполнительныеДокументы") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.ИсполнительныеДокументы");
	ИначеЕсли ТипЗнч(НаПримереОбъект) = Тип("СправочникСсылка.Залоги") Тогда
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.Залоги");	
	Иначе
		Объект.ОбъектУчета = ПредопределенноеЗначение("Перечисление.ОбъектыУчета.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКодПоСсылке(Элемент)
	Возврат Элемент.Код;
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	ЭтоEMailРассылка = Ложь;
	Если Объект.НазначениеШаблона = 
			ПредопределенноеЗначение("Перечисление.ВариантыДействийДляСкоринга.EMailРассылка") Тогда
			
		ЭтоEMailРассылка = Истина;
		
	КонецЕсли;		
	
	ДоступныеНастройкиВидимости(ЭтоEMailРассылка);
	
КонецПроцедуры

Процедура ДоступныеНастройкиВидимости(ЭтоEMailРассылка)

	Элементы.ШаблонHTML.Доступность = ЭтоEMailРассылка;
	Элементы.ПрикрепляемыеФайлы.Доступность = ЭтоEMailРассылка;
	Элементы.ТипыПрикрепляемыхФайлов.Доступность = ЭтоEMailРассылка;
	Элементы.ФормаОтправитьEMail.Доступность = ЭтоEMailРассылка;
	Элементы.ФормаОчиститьШаблон.Доступность = ЭтоEMailРассылка;
	
	Элементы.ГруппаУведомления.Видимость = ЭтоEMailРассылка;
	Элементы.ПримерHTML.Видимость = ЭтоEMailРассылка;
	Элементы.ГруппаПримерТекста.Видимость = Не ЭтоEMailРассылка;
	
	Элементы.ГруппаСтраницыЦентр.ТекущаяСтраница = Элементы.ГруппаТаблицыШаблона;

КонецПроцедуры


&НаКлиенте
Процедура НазначениеШаблонаПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыПриАктивизацииСтроки(Элемент)
	КолонкиТаблицы.Очистить();
	ТекущиеДанные = Элементы.Таблицы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Строки = Объект.Колонки.НайтиСтроки(Новый Структура("Идентификатор", ТекущиеДанные.Идентификатор));
		Для Каждого Элемент Из Строки Цикл
			НоваяСтрока = КолонкиТаблицы.Добавить();
			НоваяСтрока.Поле = Элемент.Поле;
			НоваяСтрока.Колонка = Элемент.Колонка;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Идентификатор = 1;
		Пока Объект.Таблицы.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор)).Количество() > 0 Цикл
			Идентификатор = Идентификатор + 1;
		КонецЦикла;
		
		Элементы.Таблицы.ТекущиеДанные.Идентификатор = Идентификатор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыПередУдалением(Элемент, Отказ)
	ТекущиеДанные = Элементы.Таблицы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УдалитьЭлементыТаблицыКолонки(ТекущиеДанные.Идентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭлементыТаблицыКолонки(Идентификатор)
	Номер = 0;
	Пока Номер < Объект.Колонки.Количество() Цикл
		Если Объект.Колонки[Номер].Идентификатор = Идентификатор Тогда
			Объект.Колонки.Удалить(Номер);
		Иначе
			Номер = Номер + 1;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыФункцияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Таблицы.ТекущиеДанные;
	УдалитьЭлементыТаблицыКолонки(ТекущиеДанные.Идентификатор);
    ЗаполнитьЭлементыТаблицыКолонки(ТекущиеДанные.Функция, ТекущиеДанные.Идентификатор);
	ТаблицыПриАктивизацииСтроки(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементыТаблицыКолонки(ФункцияСсылка, Идентификатор)
	Для Каждого Элемент Из ФункцияСсылка.ВозвращаемыеКолонки Цикл
		НоваяСтрока = Объект.Колонки.Добавить();
		НоваяСтрока.Идентификатор = Идентификатор;
		НоваяСтрока.Поле = "";
		НоваяСтрока.Колонка = Элемент.Наименование;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ШаблонТекстаПриИзменении(Элемент)
	КоличествоСимволов = СтрДлина(Объект.ШаблонТекста);
КонецПроцедуры

&НаКлиенте
Процедура КолонкиПолеПриИзменении(Элемент)
	Строки = Объект.Колонки.НайтиСтроки(Новый Структура("Идентификатор, Колонка", 
			Элементы.Таблицы.ТекущиеДанные.Идентификатор, Элементы.Колонки.ТекущиеДанные.Колонка));
	Если Строки.Количество() > 0 Тогда
		Строки[0].Поле = Элементы.Колонки.ТекущиеДанные.Поле;		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблонHTMLПриИзменении(Элемент)
	ПримерHTML = ЗаполнитьШаблонРассылки(Истина);
КонецПроцедуры

&НаСервере
Функция ЗаполнитьШаблонРассылки(БезПодстановкиТегов = Ложь)
	Если БезПодстановкиТегов Тогда
        Возврат Объект.ШаблонHTML.ТекстШаблона;
	Иначе
		Если Модифицированность Тогда 
			Записать();
		КонецЕсли;
		Возврат Справочники.ШаблоныТекстаДляАвтоинформирования.ЗаполнитьHTMLШаблон(Объект.Ссылка, НаПримереОбъект);
	КонецЕсли;
КонецФункции	
	
&НаКлиенте
Процедура ОтправитьEMail(Команда)
	Текст = ПримерHTML;
	ОтправитьEMailНаСервере(Текст);
КонецПроцедуры

&НаСервере
Процедура ОтправитьEMailНаСервере(Текст)
	//Поиск учетки
	Учетка = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоРеквизиту("ОтветственныйЗаОбработкуПисем", 
			ПараметрыСеанса.ТекущийПользователь);
			
	Если Учетка.Пустая() Тогда
		Сообщить("Текущий пользователь не имеет учетной записи для e-mail.");	
	Иначе
		СистемнаяУчеткаEMail = Константы.УчеткаEMailРассылок.Получить();
		Почта = Справочники.ШаблоныТекстаДляАвтоинформирования.СоздатьОбъектПочта(СистемнаяУчеткаEMail);				
		Если Почта = Неопределено Тогда
			Сообщить("Ошибка подключения к e-mail по учетке " + СистемнаяУчеткаEMail.Наименование + ".");							
		Иначе
			Записать();		
			МассивПолучателей = Новый Массив();
			МассивПолучателей.Добавить(Учетка.АдресЭлектроннойПочты);
			ОтказДействия = Ложь;
			Если Справочники.ШаблоныТекстаДляАвтоинформирования.ОтправитьEMail(Почта, Учетка,Объект.Ссылка, Текст,
					НаПримереОбъект, МассивПолучателей, ОтказДействия) Тогда
				Сообщить("Письмо отправлено на учетку " + Учетка.Наименование + ".");						
			Иначе
				Сообщить("Не удается отправить письмо!");	
			КонецЕсли;		
			Почта.Отключиться();
		КонецЕсли;
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьШаблон(Команда)
	ПримерHTML = ЗаполнитьШаблонРассылки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПриАктивизацииЯчейки(Элемент)
	Если Элементы.Настройка.ТекущиеДанные <> Неопределено Тогда
		Если Элементы.Настройка.ТекущиеДанные.ТипПоля = ПредопределенноеЗначение(
				"Перечисление.ТипыЗначенийДляШаблонов.Реквизит") Тогда 
			Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;
			Элементы.НастройкаЗначение.КнопкаВыбора = Истина;
		ИначеЕсли Элементы.Настройка.ТекущиеДанные.ТипПоля = ПредопределенноеЗначение(
				"Перечисление.ТипыЗначенийДляШаблонов.Текст") Тогда
			Элементы.НастройкаЗначение.РедактированиеТекста = Истина;
			Элементы.НастройкаЗначение.КнопкаВыбора = Ложь;
		ИначеЕсли Элементы.Настройка.ТекущиеДанные.ТипПоля = ПредопределенноеЗначение(
				"Перечисление.ТипыЗначенийДляШаблонов.Файл") Тогда
			Элементы.НастройкаЗначение.РедактированиеТекста = Ложь;
			Элементы.НастройкаЗначение.КнопкаВыбора = Истина;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
//Лебедева 20.06.2018 Исправление выбора Реквизит - Значение
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ШаблоныПечФормВыборРеквизита" Тогда
		РеквизитыИСвойстваЗначениеЗаполнение(Параметр);	
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура РеквизитыИСвойстваЗначениеЗаполнение(СтруктураПараметров) 
	
	ТекущиеДанные = Элементы.Настройка.ТекущиеДанные;
	Если Не СтруктураПараметров = Неопределено Тогда	
		ТекущиеДанные.Значение 	= СтруктураПараметров.Синоним;
		МассивДанных = СтруктураПараметров.МассивДанных; 	
		
		ТекущиеДанные.КодДопСвойства = СтруктураПараметров.КодДопСвойства;
		ТекущиеДанные.ОбъектДопСвойства = СтруктураПараметров.ОбъектДопСвойства;
		
		ЗаписатьДанныеВСтрокуХранилище(ТекущиеДанные.НомерСтроки, МассивДанных);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеВСтрокуХранилище(НомерСтроки, МассивДанных)
	
	Рекв = РеквизитФормыВЗначение("Объект");
	Рекв.Записать_СтрокаХранилище(НомерСтроки, МассивДанных);
	ЗначениеВРеквизитФормы(Рекв, "Объект");
	
КонецПроцедуры


&НаКлиенте
Процедура ПосмотретьПрикрепленные(Команда)
	
	Если Параметры.Ключ.Пустая() Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Настройки должены быть сохранены";
		Сообщение.Сообщить();
		
		Возврат;
	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаПримереОбъект) Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Надо выбрать ОбъектВх";
		Сообщение.Сообщить();
		
		Возврат;
	
	КонецЕсли;
	
	ПараметрыФайлов = Новый Структура;
	ПараметрыФайлов.Вставить("Настройка", Объект.Ссылка);
	ПараметрыФайлов.Вставить("ДолговоеОбязательство", НаПримереОбъект);
	
	ОткрытьФорму("Справочник.ШаблоныТекстаДляАвтоинформирования.Форма.ФормаПримерПрикрепляемыхФайлов", ПараметрыФайлов, ЭтаФорма);

КонецПроцедуры

