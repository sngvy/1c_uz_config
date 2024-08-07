﻿
// Для работы в режиме тонкого клиента

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизитаНаСервере(ИмяОбъекта, ИмяРеквизита)
Возврат ИмяОбъекта[ИмяРеквизита];
КонецФункции

//

&НаКлиенте
Процедура ОтменитьВыполнение(Команда)
	Массив = Элементы.Список.ВыделенныеСтроки;	
	Ном = 1;
	Для Каждого Эл Из Массив Цикл	
		Состояние(, Цел(Ном * 100 / (Массив.Количество() + 1)));
		Ном = Ном + 1;
		Ключ = Новый Структура("Ключ", Эл);
		Форма = ПолучитьФорму("Задача.Мероприятие.ФормаОбъекта", Ключ); 	
		Форма.ОтменитьВыполнение(Неопределено);
	КонецЦикла;	
	Состояние(, 100);
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСрокиМероприятий(Команда)
	ОткрытьФорму("Обработка.ПереносСроковМероприятий.Форма");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Скрыть управление сроками мероприятий
	//Если РольДоступна("тсАдминистрирование") ИЛИ РольДоступна("ПереносСроковМероприятий") Тогда
		//Элементы.ФормаПеренестиСрокиМероприятий.Видимость = Истина;
		//Элементы.ФормаКонтрольСроковМероприятий.Видимость = Истина;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрольСроковМероприятий(Команда)
	ОткрытьФорму("Отчет.КонтрольСроковМероприятий.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ПозвонитьДолжнику(Команда)
	// Получить объект мероприятия
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.ТипМероприятия = ПредопределенноеЗначение("Справочник.ТипыМероприятий.ТелефонныйЗвонокИсходящий");
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Исходящий звонок");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтправитьСМСНаСервере()
	// Получить значения с сервера
	ЭтаФорма.РезультатОтправлено = Справочники.РезультатыМероприятий.НайтиПоНаименованию("Отправлено");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСМС(Команда)
	ОтправитьСМСНаСервере();
	// Выполнить обычную клиентскую процедуру
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.ТипМероприятия = ПредопределенноеЗначение("Справочник.ТипыМероприятий.ОтправкаСМС");
		НоваяЗадача.Объект.Результат = РезультатОтправлено;
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Отправка СМС");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НаписатьВВЦНаСервере()
 	ЭтаФорма.ТипВЦ = Справочники.ТипыМероприятий.НайтиПоНаименованию("WhatsApp");
	ЭтаФорма.РезультатОтправлено = Справочники.РезультатыМероприятий.НайтиПоНаименованию("Отправлено");
КонецПроцедуры

&НаСервере
Процедура НаписатьВВайберНаСервере()
	ЭтаФорма.ТипВайбер = Справочники.ТипыМероприятий.НайтиПоНаименованию("Viber");
	ЭтаФорма.РезультатОтправлено = Справочники.РезультатыМероприятий.НайтиПоНаименованию("Отправлено");
КонецПроцедуры

&НаКлиенте
Процедура НаписатьВВЦ(Команда)
	НаписатьВВЦНаСервере();
	// Выполнить обычную клиентскую процедуру
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.ТипМероприятия = ТипВЦ;
		НоваяЗадача.Объект.Результат = РезультатОтправлено; 
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Интеграция с WhatsApp");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаписатьВВайбер(Команда)
	НаписатьВВайберНаСервере();
	// Выполнить обычную клиентскую процедуру
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.ТипМероприятия = ТипВайбер;
		НоваяЗадача.Объект.Результат = РезультатОтправлено; 
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Интеграция с Viber");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗакрепитьДолжникаНаСервере()
	// Получить значения с сервера
 	ЭтаФорма.ТипЗаявка = Справочники.ТипыМероприятий.НайтиПоНаименованию("Заявка на закрепление");
КонецПроцедуры

&НаКлиенте
Процедура ЗакрепитьДолжника(Команда)
	ЗакрепитьДолжникаНаСервере();
	// Выполнить обычную клиентскую процедуру
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.ТипМероприятия = ТипЗаявка;
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Закрепление должника");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДолжникМероприятия(Команда)
	// Передать с ключом
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		ФормаМероприятия = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаСписка",,,Новый УникальныйИдентификатор());
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ФормаМероприятия.Список, "Объект", К, ВидСравненияКомпоновкиДанных.Равно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный, );
		ФормаМероприятия.КоманднаяПанель.Видимость = Ложь;
		ФормаМероприятия.Открыть();
	Иначе
		Предупреждение("Не найден объект отбора!",,"Все мероприятия");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗвонокКредиторуНаСервере()
	// Получить значения с сервера
 	ЭтаФорма.РезультатЗвонокКредитору = Справочники.РезультатыМероприятий.НайтиПоНаименованию("Звонок кредитору");
КонецПроцедуры

&НаКлиенте
Процедура ЗвонокКредитору(Команда)
	ЗвонокКредиторуНаСервере();
	// Выполнить обычную клиентскую процедуру
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = ПолучитьЗначениеРеквизитаНаСервере(Элементы.Список.ТекущиеДанные.ДолговоеОбязательство, "Кредитор");
		НоваяЗадача = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаМероприятия", Новый Структура("Объект", К),,Новый УникальныйИдентификатор());
		НоваяЗадача.Объект.Объект = К;
		НоваяЗадача.Объект.СвязанныйДоговор = Элементы.Список.ТекущиеДанные.ДолговоеОбязательство;
		НоваяЗадача.Объект.ТипМероприятия = ПредопределенноеЗначение("Справочник.ТипыМероприятий.ТелефонныйЗвонокИсходящий");
		НоваяЗадача.Объект.Результат = РезультатЗвонокКредитору; 
		// НоваяЗадача.Объект.Контакт = РезультатНомер;
		//НоваяЗадача.КонтрагентКЛ = К;
		НоваяЗадача.Открыть();
	Иначе
		Предупреждение("Не найден объект мероприятия! При первом взаимодействии необходимо создать пустое мероприятие",,"Звонок кредитору");
	КонецЕсли;
КонецПроцедуры
