﻿

#Область ОписаниеПеременных

&НаКлиенте
Перем обВнешняяКомпонента;

&НаКлиенте
Перем ИдПолученияСтатусаSIP;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДлинаНомера = СтрДлина(СвойНомер);
	ИдПолученияСтатусаSIP = -1;
	Если Параметры.РежимПеревода Тогда
		Элементы.КНЗВ.Доступность = Ложь;
		Элементы.КНРеш.Доступность = Ложь;
		Элементы.Позвонить.Заголовок = "Перевести";
		Если ПроверкаСтатусаЧерезSIP Тогда
			Элементы.ИндексКартинкиСтатуса.КартинкаЗначений = БиблиотекаКартинок.бит_Статусы;
		Иначе
			Элементы.ИндексКартинкиСтатуса.КартинкаЗначений = БиблиотекаКартинок.бит_СтатусыAMI;
		КонецЕсли;
		Элементы.Позвонить.Картинка = БиблиотекаКартинок.бит_ПеревестиЗвонок;
		Элементы.ГруппаСтатусНомера.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОтключитьПолучениеСтатусовSIP();
	ОтключитьОбработчикОжидания("ОбновлениеСтатусаНомераAMI");
	обВнешняяКомпонента = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	ОбновитьСтатусНомера();
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Источник = "1С_Софтфон" И Событие = "СостояниеПодписки" Тогда
		
		ИдентификаторАбонента = Число(Данные);
		
		Если ИдентификаторАбонента <> ИдПолученияСтатусаSIP Тогда
			Возврат;
		КонецЕсли;
		
		Инф = обВнешняяКомпонента.BuddyGetInfo(ИдентификаторАбонента);
		параметрыПодписки = бит_ТелефонияКлиентСервер.СтрРазбить(Инф, "#");

		Если параметрыПодписки.Количество() <> 3 Тогда
			Возврат;
		КонецЕсли;

		НомерПодп = параметрыПодписки[0].Значение;
		СтрСтатус = параметрыПодписки[1].Значение;
		ОписаниеСтатуса = параметрыПодписки[2].Значение;
		
		ЧСтатус = Число(СтрСтатус);
		
		ИндексКартинкиСтатуса = бит_БитфонКлиент.ПолучитьИндексКартинкиСтатуса(ЧСтатус, ОписаниеСтатуса);
		
		СтрокаСтатуса = бит_БитфонКлиент.ПолучитьОписаниеСтатусаПоИндексуКартинки(ИндексКартинкиСтатуса);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Позвонить(Команда)
	Если Параметры.РежимПеревода Тогда
		Закрыть(Номер);
	Иначе
		ЗакрыватьПриВыборе = Истина;
		ОповеститьОВыборе(Номер);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КНЗВ(Команда)
	Номер = Номер + "*";
КонецПроцедуры

&НаКлиенте
Процедура КНРеш(Команда)
	Номер = Номер + "#";
КонецПроцедуры

&НаКлиенте
Процедура КН1(Команда)
	КодКнопки = Прав(Команда.Имя, 1);
	Номер = Номер + КодКнопки;
	ОбновитьСтатусНомера();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСсылкуНаВнешнююКомпоненту(ссылкаВнешняяКомпонента) ЭКСПОРТ
	обВнешняяКомпонента = ссылкаВнешняяКомпонента;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусНомера()
	
	Если НЕ Параметры.РежимПеревода Тогда
		Возврат;
	КонецЕсли;
	
	стрНомер = бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(Номер);
	
	Если (НЕ ЗначениеЗаполнено(стрНомер))
		ИЛИ (СтрДлина(стрНомер) <> ДлинаНомера)
		ИЛИ (обВнешняяКомпонента = Неопределено)
	Тогда
		СтатусНомера = -1;
		ИндексКартинкиСтатуса = 0;
		СтрокаСтатуса = "";
		//
		Если ПроверкаСтатусаЧерезSIP Тогда
			ОтключитьПолучениеСтатусовSIP();
		Иначе
			ОтключитьОбработчикОжидания("ОбновлениеСтатусаНомераAMI");
		КонецЕсли;
		//
		Возврат;
	КонецЕсли;
	
	Если ПроверкаСтатусаЧерезSIP Тогда
		ПодключитьПолучениеСтатусовSIP(стрНомер);
	Иначе
		ОбновлениеСтатусаНомераAMI();
	КонецЕсли;
	
КонецПроцедуры

// процедура таймера
&НаКлиенте
Процедура ОбновлениеСтатусаНомераAMI()
	ОбновитьСтатусНомераAMI();
	ПодключитьОбработчикОжидания("ОбновлениеСтатусаНомераAMI", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусНомераAMI()
	
	Если НЕ Параметры.РежимПеревода Тогда
		Возврат;
	КонецЕсли;
	
	стрНомер = бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(Номер);
	
	Если (НЕ ЗначениеЗаполнено(стрНомер))
		ИЛИ (СтрДлина(стрНомер) <> ДлинаНомера)
		ИЛИ (обВнешняяКомпонента = Неопределено)
	Тогда
		СтатусНомера = -1;
		ИндексКартинкиСтатуса = 0;
		СтрокаСтатуса = "";
		Возврат;
	КонецЕсли;
	
	Попытка
		
		стрХмл = обВнешняяКомпонента.GetExtensionStatusAndChannels(стрНомер);
		
		чтение = Новый ЧтениеXML();
		чтение.УстановитьСтроку(стрХмл);
		
		дом = Новый ПостроительDOM();
		докХмл = дом.Прочитать(чтение);
		
		списокЭкстенш = докХмл.ПолучитьЭлементыПоИмени("/ChannelsInfo/Extensions", "Extension_" + стрНомер);
		обЭкстенш = списокЭкстенш[0];
		СтатусНомера = Число(обЭкстенш.ПолучитьАтрибут("status"));
		
		ИндексКартинкиСтатуса = бит_АТСКлиент.ПолучитьИндексКартинкиСтатуса(СтатусНомера);
		
		СтрокаСтатуса = бит_АТСКлиент.ПолучитьОписаниеСтатуса(СтатусНомера);
		
	Исключение
		
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки(), ЭтаФорма);
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьПолучениеСтатусовSIP()
	Если Параметры.РежимПеревода И ПроверкаСтатусаЧерезSIP
		И (ИдПолученияСтатусаSIP <> -1) И (обВнешняяКомпонента <> Неопределено) Тогда
			обВнешняяКомпонента.BuddyDel(ИдПолученияСтатусаSIP);
			ИдПолученияСтатусаSIP = -1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьПолучениеСтатусовSIP(стрНомер)
	ОтключитьПолучениеСтатусовSIP();
	ИдПолученияСтатусаSIP = обВнешняяКомпонента.BuddyAdd(стрНомер);
КонецПроцедуры

#КонецОбласти

