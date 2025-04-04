﻿///////////////////////////////////////////////////////////////////////////////
// Общий серверный модуль работы с БИТ.АТС
///////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьВерсиюВнешнейКомпоненты() ЭКСПОРТ
	Возврат "1.2.144.0";
КонецФункции

///////////////////////////////////////////////////////////////////////////////
Процедура ЗаполнитьНастройкиПоУмолчаниюТекущегоПользователя(настройки) ЭКСПОРТ
	настройки.Пользователь					= бит_ТелефонияСервер.ПолучитьТекущегоПользователя();
	настройки.ИнтервалОбновления			= 2;
	настройки.ТаймаутЗвонка					= 15;
	настройки.ПрефиксВыходаНаВнешнююЛинию	= бит_ТелефонияСервер.ПолучитьПрефиксВыходаНаВнешнююЛиниюПоУмолчанию();
	настройки.СерверЛицензийВерсия			= 1; // СЛ 2.0
	настройки.СерверЛицензийАдрес			= "127.0.0.1";
	настройки.СерверЛицензийПорт			= 10700;
	настройки.РазворачиватьОкноПриВходящемЗвонке = Истина;
	настройки.ПредлагатьСохранитьНеизвестныйНомер	= Истина;
	настройки.ОткрыватьФормуВходящегоЗвонка	= Истина;
КонецПроцедуры

Функция ПолучитьВерсиюВнешнейКомпонентыТекущегоПользователя() ЭКСПОРТ
	настрВерсия = ПолучитьНастройкиТелефонии().ВерсияКомпонентыПанелиУправления;
	Возврат настрВерсия;
КонецФункции

Процедура УстановитьВерсиюВнешнейКомпонентыТекущегоПользователя(стрВерсия) ЭКСПОРТ
	УстановитьНастройку("ВерсияКомпонентыПанелиУправления", стрВерсия);
КонецПроцедуры

Функция ПолучитьАТС() ЭКСПОРТ
	настрАТС = ПолучитьНастройкиТелефонии().АТС;
	Возврат настрАТС;
КонецФункции

Функция ПолучитьНомерСвязанногоТелефона() ЭКСПОРТ
	настрНомер = ПолучитьНастройкиТелефонии().НомерСвязанногоТелефона;
	Возврат настрНомер;
КонецФункции

Функция ПолучитьНомерСвязанногоТелефонаДоп() ЭКСПОРТ
	настрНомер = ПолучитьНастройкиТелефонии().НомерСвязанногоТелефонаДоп;
	Возврат настрНомер;
КонецФункции

Функция ПолучитьНомерВнеОфиса() ЭКСПОРТ
	настрНомер = ПолучитьНастройкиТелефонии().НомерВнеОфиса;
	Возврат настрНомер;
КонецФункции

Функция ПолучитьИнтервалОбновления() ЭКСПОРТ
	настрИнтервал = ПолучитьНастройкиТелефонии().ИнтервалОбновления;
	Возврат настрИнтервал;
КонецФункции

Функция ПолучитьПараметрыОткрытияФормыНастроек() ЭКСПОРТ
	Возврат бит_ТелефонияСервер.ПолучитьПараметрыОткрытияФормыНастроек("бит_БитАТСНастройки", "бит_АТССервер");
КонецФункции

Функция ПолучитьФлагЗаголовокАвтоподнятия() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ЗаголовокАвтоподнятия;
	Возврат флаг;
КонецФункции

Функция ПолучитьТаймаутЗвонка() ЭКСПОРТ
	таймаут = ПолучитьНастройкиТелефонии().ТаймаутЗвонка;
	Возврат таймаут;
КонецФункции

Функция ПолучитьПрефиксВыходаНаВнешнююЛинию() ЭКСПОРТ
	префикс = ПолучитьНастройкиТелефонии().ПрефиксВыходаНаВнешнююЛинию;
	Возврат префикс;
КонецФункции

Функция ПолучитьФлагИспользоватьПрямойНабор() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ИспользоватьПрямойНабор;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагСоздаватьСобытиеВходящийЗвонок() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().СоздаватьСобытиеПриВходящемЗвонке;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагСоздаватьСобытиеИсходящийЗвонок() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().СоздаватьСобытиеПриИсходящемЗвонке;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагСоздаватьСобытияПриВнутреннихЗвонках() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().СоздаватьСобытияПриВнутреннихЗвонках;
	Возврат флаг;
КонецФункции

// Возвращаемое значение - целое неотрицательное число
// 0 - БИТ Сервер Лицензий 1.6
// 1 - БИТ Сервер Лицензий 2.0
Функция ПолучитьВерсиюСервераЛицензий() ЭКСПОРТ
	версияСЛ = ПолучитьНастройкиТелефонии().СерверЛицензийВерсия;
	Возврат версияСЛ;
КонецФункции

Функция ПолучитьАдресСервераЛицензий() ЭКСПОРТ
	адрес = ПолучитьНастройкиТелефонии().СерверЛицензийАдрес;
	Возврат адрес;
КонецФункции

Функция ПолучитьПортСервераЛицензий() ЭКСПОРТ
	порт = ПолучитьНастройкиТелефонии().СерверЛицензийПорт;
	Возврат порт;
КонецФункции

Функция ПолучитьФлагСервераЛицензийНеИспользоватьПрокси() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().СерверЛицензийНеИспользоватьПрокси;
	Возврат флаг;
КонецФункции

Функция ПолучитьCIDСервераЛицензий() ЭКСПОРТ
	ид = ПолучитьНастройкиТелефонии().СерверЛицензийCID;
	Возврат ид;
КонецФункции

Функция ПолучитьФлагАвтостартаПриЗапускеСистемы() ЭКСПОРТ
	Если НЕ бит_ТелефонияСерверПереопределяемый.ЕстьВозможностьАвтозапуска() Тогда
		Возврат Ложь;
	КонецЕсли;
	флаг = ПолучитьНастройкиТелефонии().АвтозапускПриСтартеСистемы;
	Возврат флаг;
КонецФункции	

Функция ПолучитьФлагРежимВнеОфиса() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().РежимВнеОфиса;
	Возврат флаг;
КонецФункции

Процедура УстановитьФлагРежимВнеОфиса(флагВнеОфиса) ЭКСПОРТ
	УстановитьНастройку("РежимВнеОфиса", флагВнеОфиса);
КонецПроцедуры

Функция ПолучитьФлагНеИскатьКонтрагента() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().НеИскатьКонтрагента;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагПоискДублей() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ПоискДублей;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагРазворачиватьОкноПриВходящемЗвонке() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().РазворачиватьОкноПриВходящемЗвонке;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагОткрыватьКартуЯндексПриВходящемЗвонке() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ОткрыватьКартуЯндексПриВходящемЗвонке;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагПредлагатьСохранитьНеизвестныйНомер() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ПредлагатьСохранитьНеизвестныйНомер;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагЗагрузкаЗвонков() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ЗагрузкаЗвонков;
	Возврат флаг;
КонецФункции

Функция ПолучитьФлагОткрыватьФормуВходящегоЗвонка() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().ОткрыватьФормуВходящегоЗвонка;
	Возврат флаг;
КонецФункции

Функция ПолучитьРазрешенныйАдрес() ЭКСПОРТ
	флаг = ПолучитьНастройкиТелефонии().РазрешенныйАдрес;
	Возврат флаг;
КонецФункции

Процедура УстановитьРазрешенныйАдрес(стрРазрешенныйАдрес) ЭКСПОРТ
	УстановитьНастройку("РазрешенныйАдрес", стрРазрешенныйАдрес);
КонецПроцедуры

Функция ПроверитьПраваАдминистрировать() ЭКСПОРТ
	АдминистраторАТС = (РольДоступна(Метаданные.Роли.бит_АдминистраторБитАТС) ИЛИ РольДоступна("ПолныеПрава"));
	Возврат АдминистраторАТС;
КонецФункции

Функция ПроверитьПраваИспользовать() ЭКСПОРТ
	Возврат РольДоступна(Метаданные.Роли.бит_ПользовательБитАТС);
КонецФункции

Функция ПроверитьПраваОткрытьМонитор() ЭКСПОРТ
	Возврат (ПроверитьПраваАдминистрировать() ИЛИ ПроверитьПраваИспользовать());
КонецФункции

///////////////////////////////////////////////////////////////////////////////
Функция НайтиКонтрагентаПоНомеру(Знач НомерДляПоиска, ВнешнийВызов, КонтрагентСсылка, КонтактноеЛицоСсылка, флагЕстьДубли) ЭКСПОРТ
	найден = бит_ТелефонияСервер.НайтиКонтрагентаПоНомеруВИзбранном(НомерДляПоиска, ВнешнийВызов, КонтрагентСсылка);
	Если найден <> Истина Тогда
		Если ВнешнийВызов Тогда
			флагНеИскатьКонтрагента = ПолучитьФлагНеИскатьКонтрагента();
			флагПоискДублей = ПолучитьФлагПоискДублей();
			найден = бит_ТелефонияСервер.НайтиКонтрагентаИКонтактноеЛицоПоНомеру(НомерДляПоиска, КонтрагентСсылка, КонтактноеЛицоСсылка,
				флагНеИскатьКонтрагента, флагПоискДублей, флагЕстьДубли);
		КонецЕсли;
	КонецЕсли;
	возврат найден;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
Функция ПолучитьНомераАТС(АТССсылка, РодительНомеров) ЭКСПОРТ
	массивНомеров = Новый Массив;
	ЗапросНомеров = Новый Запрос;
	ЗапросНомеров.Текст = "ВЫБРАТЬ
	                      |	бит_НомераБитАТС.Код,
	                      |	бит_НомераБитАТС.Наименование,
	                      |	бит_НомераБитАТС.Номер,
	                      |	бит_НомераБитАТС.ГруппаДоступа
	                      |ИЗ
	                      |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	                      |ГДЕ
	                      |	бит_НомераБитАТС.ЭтоГруппа = ЛОЖЬ
	                      |	И бит_НомераБитАТС.Владелец = &Владелец
	                      |	И бит_НомераБитАТС.ПометкаУдаления = ЛОЖЬ";
	ЗапросНомеров.УстановитьПараметр("Владелец", АТССсылка);
	//
	Если РодительНомеров <> ПредопределенноеЗначение("Справочник.бит_НомераБитАТС.ПустаяСсылка") Тогда
		ЗапросНомеров.Текст = ЗапросНомеров.Текст + "
		                      |	И (бит_НомераБитАТС.Родитель В ИЕРАРХИИ (&Родитель)
		                      |			ИЛИ бит_НомераБитАТС.Родитель = &Родитель)";
		ЗапросНомеров.УстановитьПараметр("Родитель", РодительНомеров);
	КонецЕсли;
	//
	таблНомера = ЗапросНомеров.Выполнить().Выгрузить();
	Для Каждого строкаВыборкиНомеров Из таблНомера Цикл
		экстеншн = Новый Структура;
		экстеншн.Вставить("Имя", строкаВыборкиНомеров.Наименование);
		экстеншн.Вставить("Номер", строкаВыборкиНомеров.Номер);
		экстеншн.Вставить("ГруппаДоступа", строкаВыборкиНомеров.ГруппаДоступа);
		массивНомеров.Добавить(экстеншн);
	КонецЦикла;
	Возврат массивНомеров;
КонецФункции

Функция ПолучитьПараметрыПодключенияАТС(АТССсылка) ЭКСПОРТ
	АТСструктура = Новый Структура("Код, Наименование, Адрес, Пользователь, Пароль, IDКлиента");
	ЗаполнитьЗначенияСвойств(АТСструктура, АТССсылка);
	Возврат АТСструктура;
КонецФункции

Функция ПолучитьПараметрыАТС(АТССсылка, СписокНомеровХоста, СоответствиеНомеровХоста) ЭКСПОРТ
	АТСструктура = ПолучитьПараметрыПодключенияАТС(АТССсылка);
	
	соотвКлиентскихГрупп = Новый Соответствие;
	Для Каждого клиентскаяГр Из АТССсылка.КлиентскиеГруппы Цикл
		соотвКлиентскихГрупп.Вставить(клиентскаяГр.Номер, клиентскаяГр.Номер);
	КонецЦикла;
	АТСструктура.Вставить("КлиентскиеГруппы", соотвКлиентскихГрупп);
	
	массивНомеров = ПолучитьНомераАТС(АТССсылка, ПредопределенноеЗначение("Справочник.бит_НомераБитАТС.ПустаяСсылка"));
	АТСструктура.Вставить("Номера", массивНомеров);
	
	// Тип - Соответствие (Map)
	// Ключ - внутренний номер, значение - Строка, имя внутреннего абонента.
	СоответствиеНомеровХоста = Новый Соответствие;
	Для Каждого Экстеншен Из массивНомеров Цикл
		Если ЗначениеЗаполнено(Экстеншен.Номер) Тогда
			СписокНомеровХоста = СписокНомеровХоста + Экстеншен.Номер + ";";
			СоответствиеНомеровХоста.Вставить(Экстеншен.Номер, Экстеншен.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат АТСструктура;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
Функция ПолучитьАдресАналитикиАТС(АТССсылка) ЭКСПОРТ
	стрАдресАналитики = "";
	Если ЗначениеЗаполнено(АТССсылка) Тогда
		стрАдресАналитики = АТССсылка.АдресАналитики;
	КонецЕсли;
	Возврат стрАдресАналитики;
КонецФункции

///////////////////////////////////////////////////////////////////////////////

// Проверка номера, при отсутствии запись создается.
// Элемент ищется по номеру телефона.
Процедура ПроверитьНаличиеЭлементаНомеровАТС(ссылкаАТС, родительСсылка, стрНаименование, стрНомер, флагПометкаУдаления=Ложь) ЭКСПОРТ
	Запрос = Новый Запрос;
	//
	// поиск элемента по номеру
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НомераБитАТС.Ссылка,
	               |	бит_НомераБитАТС.Наименование,
	               |	бит_НомераБитАТС.Родитель,
	               |	бит_НомераБитАТС.ПометкаУдаления
	               |ИЗ
	               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	               |ГДЕ
	               |	бит_НомераБитАТС.Владелец = &Владелец
	               |	И бит_НомераБитАТС.ЭтоГруппа = ЛОЖЬ
	               |	И бит_НомераБитАТС.Номер = &Номер";
	Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
	Запрос.УстановитьПараметр("Номер", стрНомер);
	табл = Запрос.Выполнить().Выгрузить();
	Если табл.Количество() = 0 Тогда
		// создание
		новОбъект = Справочники.бит_НомераБитАТС.СоздатьЭлемент();
		новОбъект.Номер = стрНомер;
		новОбъект.Наименование	= стрНаименование;
		новОбъект.Владелец		= ссылкаАТС;
		новОбъект.Родитель		= родительСсылка;
		новОбъект.ПометкаУдаления = флагПометкаУдаления;
		новОбъект.Записать();
	Иначе
		Для Каждого строкаТаблНайден Из табл Цикл
			обНомер = Неопределено;
			Если строкаТаблНайден.Родитель <> родительСсылка Тогда
				обНомер = строкаТаблНайден.Ссылка.ПолучитьОбъект();
				обНомер.Родитель = родительСсылка;
			КонецЕсли;
			// проверка наименования номера
			Если строкаТаблНайден.Наименование <> стрНаименование Тогда
				Если обНомер = Неопределено Тогда
					обНомер = строкаТаблНайден.Ссылка.ПолучитьОбъект();
				КонецЕсли;
				обНомер.Наименование = стрНаименование;
			КонецЕсли;
			//
			Если строкаТаблНайден.ПометкаУдаления <> флагПометкаУдаления Тогда
				Если обНомер = Неопределено Тогда
					обНомер = строкаТаблНайден.Ссылка.ПолучитьОбъект();
				КонецЕсли;
				обНомер.ПометкаУдаления = флагПометкаУдаления;
			КонецЕсли;
			//
			Если обНомер <> Неопределено Тогда
				обНомер.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Проверка группы номеров, при отсутствии запись создается.
// Группа ищется по коду.
// Возвращает ссылку на найденную или созданную запись.
Функция ПроверитьНаличиеГруппыНомеровАТС(ссылкаАТС, родительСсылка, стрНаименование, стрИдентификаторГруппы, флагПометкаУдаления=Ложь) ЭКСПОРТ
	Запрос = Новый Запрос;
	//
	// поиск по кодам
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НомераБитАТС.Ссылка,
	               |	бит_НомераБитАТС.Родитель,
	               |	бит_НомераБитАТС.Наименование,
	               |	бит_НомераБитАТС.ПометкаУдаления
	               |ИЗ
	               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	               |ГДЕ
	               |	бит_НомераБитАТС.Владелец = &Владелец
	               |	И бит_НомераБитАТС.Код = &Код
	               |	И бит_НомераБитАТС.ЭтоГруппа = ИСТИНА";
	Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
	Запрос.УстановитьПараметр("Код", стрИдентификаторГруппы);
	табл = Запрос.Выполнить().Выгрузить();
	Если табл.Количество() > 0 Тогда
		строкаТаблНайден = табл[0];
		элСсылка		= строкаТаблНайден.Ссылка;
		элРодитель		= строкаТаблНайден.Родитель;
		элНаименование	= строкаТаблНайден.Наименование;
		элПомУдаления	= строкаТаблНайден.ПометкаУдаления;
		элОбъект = Неопределено;
		Если элРодитель <> родительСсылка Тогда
			элОбъект = элСсылка.ПолучитьОбъект();
			элОбъект.Родитель = родительСсылка;
		КонецЕсли;
		Если элНаименование <> стрНаименование Тогда
			Если элОбъект = Неопределено Тогда
				элОбъект = элСсылка.ПолучитьОбъект();
			КонецЕсли;
			элОбъект.Наименование = стрНаименование;
		КонецЕсли;
		Если элПомУдаления <> флагПометкаУдаления Тогда
			Если элОбъект = Неопределено Тогда
				элОбъект = элСсылка.ПолучитьОбъект();
			КонецЕсли;
			элОбъект.ПометкаУдаления = флагПометкаУдаления;
		КонецЕсли;
		Если элОбъект <> Неопределено Тогда
			элОбъект.Записать();
		КонецЕсли;
	Иначе
		// создание
		новОбъект = Справочники.бит_НомераБитАТС.СоздатьГруппу();
		новОбъект.Наименование	= стрНаименование;
		новОбъект.Владелец		= ссылкаАТС;
		новОбъект.Родитель		= родительСсылка;
		новОбъект.Код			= стрИдентификаторГруппы;
		новОбъект.ПометкаУдаления = флагПометкаУдаления;
		новОбъект.Записать();
		элСсылка = новОбъект.Ссылка;
	КонецЕсли;
	//
	Возврат элСсылка;
КонецФункции

Процедура ЗагрузитьНомераСотрудников(АТСссылка, группаСотрудниковРодитель, загружено) ЭКСПОРТ
	ЗапросСотрудники = Новый Запрос;
	ЗапросСотрудники.Текст = "ВЫБРАТЬ
	                         |	Сотрудники.Наименование КАК Наименование,
	                         |	Сотрудники.Ссылка,
	                         |	Сотрудники.ЭтоГруппа,
	                         |	Сотрудники.ПометкаУдаления
	                         |ИЗ
	                         |	Справочник." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаСотрудников() + " КАК Сотрудники
	                         |ГДЕ
	                         |	(Сотрудники.Родитель В ИЕРАРХИИ (&Родитель)
	                         |			ИЛИ Сотрудники.Родитель = &Родитель)
	                         |
	                         |УПОРЯДОЧИТЬ ПО
	                         |	Наименование ИЕРАРХИЯ";
	ЗапросСотрудники.УстановитьПараметр("Родитель", группаСотрудниковРодитель);
	дерСотрудники = ЗапросСотрудники.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗагрузитьГруппуНомеровСотрудников(АТСссылка, Справочники.бит_НомераБитАТС.ПустаяСсылка(), дерСотрудники.Строки, загружено);
	ПроверкаДублейНомеров(АТСссылка);
КонецПроцедуры

// Процедура регламентного задания
Процедура СинхронизацияНомеровСотрудников() ЭКСПОРТ
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ТелефонныеСтанцииБитАТС.Ссылка,
	               |	бит_ТелефонныеСтанцииБитАТС.ГруппаСинхронизацииСотрудников
	               |ИЗ
	               |	Справочник.бит_ТелефонныеСтанцииБитАТС КАК бит_ТелефонныеСтанцииБитАТС
	               |ГДЕ
	               |	бит_ТелефонныеСтанцииБитАТС.ПометкаУдаления = ЛОЖЬ
	               |	И бит_ТелефонныеСтанцииБитАТС.СинхронизацияССотрудниками = ИСТИНА";
	таблСинхрАТС = Запрос.Выполнить().Выгрузить();
	
	Для Каждого строкаСинхрАТС Из таблСинхрАТС Цикл
		ссылкаАТС = строкаСинхрАТС.Ссылка;
		группаСинхр = строкаСинхрАТС.ГруппаСинхронизацииСотрудников;
		загружено_элементов = 0;
		ЗагрузитьНомераСотрудников(ссылкаАТС, группаСинхр, загружено_элементов);
	КонецЦикла;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Работа в веб-клиенте через веб сервис
//

Функция ВебСервисОткрытьСоединение(ссылкаАТС, стрАдрес, стрПользователь, стрПароль, стрСписокНомеров, флагМонитор) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	стрКлиентИнфо = Строка(бит_ТелефонияСервер.ПолучитьТекущегоПользователя()) + " (" + ?(флагМонитор, "монитор", "панель управления") + ")";
	Возврат вс.OpenConnection2(стрАдрес, стрПользователь, стрПароль, стрСписокНомеров, стрКлиентИнфо);
КонецФункции

Процедура ВебСервисЗакрытьСоединение(ссылкаАТС, ИдКлиента) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.CloseConnection(ИдКлиента);
КонецПроцедуры

Процедура ВебСервисНачатьРазговор(ссылкаАТС, ИдКлиента, стрВызывающийНомер, стрНомерКонтекста, стрВызываемыйНомер, флагЗаголовокАвтоподнятия, ТаймаутЗвонка) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.MakeCall(ИдКлиента, стрВызывающийНомер, стрНомерКонтекста, стрВызываемыйНомер, флагЗаголовокАвтоподнятия, ТаймаутЗвонка);
КонецПроцедуры

Функция ВебСервисОбновитьНомер(ссылкаАТС, ИдКлиента, стрСписокНомеровПолученияЗвонков, стрСписокНомеровПолученияСтатуса) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Данные = вс.GetExtensionStatusAndChannels(ИдКлиента, стрСписокНомеровПолученияЗвонков, стрСписокНомеровПолученияСтатуса, Истина);
	Возврат бит_ТелефонияКлиентСервер.ПолучитьАТСИнфоИзJSON(Данные);
КонецФункции

Функция ВебСервисПолучитьНабранныйНомер(ссылкаАТС, ИдКлиента, стрКанал) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Возврат вс.GetDestination(ИдКлиента, стрКанал);
КонецФункции

Функция ВебСервисПолучитьСвойстваНомера(ссылкаАТС, ИдКлиента, стрСипЛогин) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Возврат вс.GetSIPPeerInfo(ИдКлиента, стрСипЛогин);
КонецФункции

Функция ВебСервисПолучитьХэшЗаписиРазговора(ссылкаАТС, ИдКлиента, стрКанал, флагВходящий, стрСвязанныйКанал) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Возврат вс.GetRecordHash(ИдКлиента, стрКанал, флагВходящий, стрСвязанныйКанал);
КонецФункции

Функция ВебСервисПолучитьТранзитИд(ссылкаАТС, ИдКлиента, стрКанал) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Возврат вс.GetTransitID(ИдКлиента, стрКанал);
КонецФункции

Функция ВебСервисПолучитьПеременнуюКанала(ссылкаАТС, ИдКлиента, стрКанал, стрИмяПеременной) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Возврат вс.GetChannelVariable(ИдКлиента, стрКанал, стрИмяПеременной);
КонецФункции

Функция ВебСервисОбновитьНомера(ссылкаАТС, ИдКлиента) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Данные = вс.GetExtensionsStatusesAndChannels(ИдКлиента, Истина);
	Возврат бит_ТелефонияКлиентСервер.ПолучитьАТСИнфоИзJSON(Данные);
КонецФункции

Функция ВебСервисОбновитьОчереди(ссылкаАТС, ИдКлиента) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	Данные = вс.GetQueues(ИдКлиента, Истина);
	Возврат бит_ТелефонияКлиентСервер.ПолучитьАТСИнфоИзJSON(Данные);
КонецФункции

Процедура ВебСервисПодключитьсяКРазговору(ссылкаАТС, ИдКлиента, стрСлушающийНомер, стрНомерКонтекста, стрПодключаемыйSIPЛогин,
			стрПодключаемыйНомер, РежимПодключения, флагЗаголовокАвтоподнятия, ТаймаутЗвонка) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.Spy(ИдКлиента, стрСлушающийНомер, стрНомерКонтекста, стрПодключаемыйSIPЛогин, стрПодключаемыйНомер, РежимПодключения,
			флагЗаголовокАвтоподнятия, ТаймаутЗвонка);
КонецПроцедуры

Процедура ВебСервисУстановитьРежимDND(ссылкаАТС, ИдКлиента, стрНомерТелефона, флагРежим) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.SetDNDMode(ИдКлиента, стрНомерТелефона, флагРежим);
КонецПроцедуры

Процедура ВебСервисНабратьDTMFКоманду(ссылкаАТС, ИдКлиента, стрКанал, стрКомандаDTMF) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.PlayDTMF(ИдКлиента, стрКанал, стрКомандаDTMF);
КонецПроцедуры

Процедура ВебСервисВоспроизвестиЗаписьРазговора(ссылкаАТС, ИдКлиента, стрСлушающийНомер, стрНомерКонтекста, стрХэш, ЗаголовокАвтоподнятия, ТаймаутЗвонка) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.PlayRecording(ИдКлиента, стрСлушающийНомер, стрНомерКонтекста, стрХэш, ЗаголовокАвтоподнятия, ТаймаутЗвонка);
КонецПроцедуры

Процедура ВебСервисУсловныйПеревод(ссылкаАТС, ИдКлиента, стрКанал, стрНомерКонтекста, стрНомерПеревода) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.AtXfer(ИдКлиента, стрКанал, стрНомерКонтекста, стрНомерПеревода);
КонецПроцедуры

Процедура ВебСервисБезусловныйПеревод(ссылкаАТС, ИдКлиента, стрКанал, стрНомерКонтекста, стрНомерПеревода) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.Redirect(ИдКлиента, стрКанал, стрНомерКонтекста, стрНомерПеревода);
КонецПроцедуры

Процедура ВебСервисПерехватЗвонка(ссылкаАТС, ИдКлиента, стрПерехватывающийНомер, ЗаголовокАвтоподнятия, ТаймаутЗвонка) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.Pickup(ИдКлиента, стрПерехватывающийНомер, ЗаголовокАвтоподнятия, ТаймаутЗвонка);
КонецПроцедуры

Процедура ВебСервисОтключениеЗвука(ссылкаАТС, ИдКлиента, стрКанал, флагОтключить) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.MuteAudio(ИдКлиента, стрКанал, флагОтключить);
КонецПроцедуры

Процедура ВебСервисОтбойРазговора(ссылкаАТС, ИдКлиента, стрКанал) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.Hangup(ИдКлиента, стрКанал);
КонецПроцедуры

Процедура ВебСервисЗагрузитьURL(ссылкаАТС, ИдКлиента, стрАдрес) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеАТС(ссылкаАТС);
	вс.LoadURL(ИдКлиента, стрАдрес);
КонецПроцедуры

Функция ВебСервисПолучитьИнформациюАТС(стрВебСервисАдрес, стрАдрес, стрПользователь, стрПароль, стрТипИнформации) ЭКСПОРТ
	вс = бит_АТСВебСервисы.ПолучитьВебСервисУправлениеЗвонками(стрВебСервисАдрес, стрАдрес);
	Возврат вс.GetPBXInfoJSON(стрАдрес, стрПользователь, стрПароль, стрТипИнформации);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьНастройкиТелефонии()
	Пользователь = бит_ТелефонияСервер.ПолучитьТекущегоПользователя();
	СтруктураОтбора = Новый Структура("Пользователь", Пользователь);
	Возврат РегистрыСведений.бит_БитАТСНастройки.Получить(СтруктураОтбора);
КонецФункции

Процедура УстановитьНастройку(стрНастройка, значениеНастройки)
	бит_ТелефонияСервер.УстановитьНастройкуТекущегоПользователя("бит_БитАТСНастройки", "бит_АТССервер", стрНастройка, значениеНастройки);
КонецПроцедуры

Процедура ЗагрузитьГруппуНомеровСотрудников(ссылкаАТС, родительСсылка, строкиСотрудники, загружено)
	длинаВнешнегоНомера = бит_ТелефонияКлиентСервер.ПолучитьДлинуВнешнегоНомера();
	Для Каждого строкаСотр Из строкиСотрудники Цикл
		сотрИмя = строкаСотр.Наименование;
		помУдаления = строкаСотр.ПометкаУдаления;
		//
		Если строкаСотр.ЭтоГруппа Тогда
			// группа
			сотрКод	= Строка(строкаСотр.Ссылка.УникальныйИдентификатор());
			группаСсылка = ПроверитьНаличиеГруппыНомеровАТС(ссылкаАТС, родительСсылка, сотрИмя, сотрКод, помУдаления);
			загружено = загружено + 1;
			ЗагрузитьГруппуНомеровСотрудников(ссылкаАТС, группаСсылка, строкаСотр.Строки, загружено);
		Иначе
			массНомераСотрудника = Новый Массив;
			массНомераСотрудникаИБ = бит_ТелефонияСерверПереопределяемый.НайтиНомераСотрудника(строкаСотр.Ссылка);
			Для Каждого номерСотрудника Из массНомераСотрудникаИБ Цикл
				списокНомеровИБ = бит_ТелефонияКлиентСервер.СтрРазбить(номерСотрудника, ",");
				Для Каждого элНомерСотрудникаИБ Из списокНомеровИБ Цикл
					массНомераСотрудника.Добавить(элНомерСотрудникаИБ.Значение);
				КонецЦикла;
			КонецЦикла;
			Для Каждого номерСотрудника Из массНомераСотрудника Цикл
				сокрНомерСотрудника = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(номерСотрудника));
				длинаСокрНомераСотрудника = СтрДлина(сокрНомерСотрудника);
				Если ЗначениеЗаполнено(сокрНомерСотрудника) И (длинаСокрНомераСотрудника < длинаВнешнегоНомера) Тогда
					ПроверитьНаличиеЭлементаНомеровАТС(ссылкаАТС, родительСсылка, сотрИмя, сокрНомерСотрудника, помУдаления);
					загружено = загружено + 1;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверкаДублейНомеров(ссылкаАТС)
	Запрос = Новый Запрос;
	// поиск дублей по родителю, наименованию и номеру
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НомераБитАТС.Родитель,
	               |	бит_НомераБитАТС.Наименование,
	               |	бит_НомераБитАТС.Номер
	               |ИЗ
	               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
	               |ГДЕ
	               |	бит_НомераБитАТС.Владелец = &Владелец
	               |	И бит_НомераБитАТС.ЭтоГруппа = ЛОЖЬ
	               |	И бит_НомераБитАТС.ПометкаУдаления = ЛОЖЬ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	бит_НомераБитАТС.Родитель,
	               |	бит_НомераБитАТС.Наименование,
	               |	бит_НомераБитАТС.Номер
	               |
	               |ИМЕЮЩИЕ
	               |	КОЛИЧЕСТВО(бит_НомераБитАТС.Номер) > 1";
	Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
	таблДубли = Запрос.Выполнить().Выгрузить();
	Для Каждого строкаДубли Из таблДубли Цикл
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_НомераБитАТС.Ссылка
		               |ИЗ
		               |	Справочник.бит_НомераБитАТС КАК бит_НомераБитАТС
		               |ГДЕ
		               |	бит_НомераБитАТС.Владелец = &Владелец
		               |	И бит_НомераБитАТС.Родитель = &Родитель
		               |	И бит_НомераБитАТС.Наименование = &Наименование
		               |	И бит_НомераБитАТС.Номер = &Номер";
		Запрос.УстановитьПараметр("Владелец", ссылкаАТС);
		Запрос.УстановитьПараметр("Родитель", строкаДубли.Родитель);
		Запрос.УстановитьПараметр("Наименование", строкаДубли.Наименование);
		Запрос.УстановитьПараметр("Номер", строкаДубли.Номер);
		табл = Запрос.Выполнить().Выгрузить();
		Для й = 1 По табл.Количество() - 1 Цикл
			обНомер = табл[й].Ссылка.ПолучитьОбъект();
			обНомер.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
