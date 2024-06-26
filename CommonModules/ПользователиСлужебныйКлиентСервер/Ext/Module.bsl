﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает строки вида "день", "дня", "дней".
//
// Параметры:
//   Число                       - Число  - целое число, к которому нужно добавить предмет исчисления.
//   ФорматнаяСтрока             - Строка - см. одноименный параметр метода ЧислоПрописью,
//                                          например: "ДП=Истина".
//   ПараметрыПредметаИсчисления - Строка - см. одноименный параметр метода ЧислоПрописью,
//                                          например: НСтр("ru = 'день,дня,дней,,,,,,0'").
//
//  Возвращаемое значение:
//   Строка.
//
Функция ПредметЦелогоЧисла(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления) Экспорт
	
	ЦелоеЧисло = Цел(Число);
	
	ПрописьЧисла = ЧислоПрописью(ЦелоеЧисло, ФорматнаяСтрока, НСтр("ru = ',,,,,,,,0'"));
	
	ПрописьЧислаИПредмета = ЧислоПрописью(ЦелоеЧисло, ФорматнаяСтрока, ПараметрыПредметаИсчисления);
	
	Возврат СтрЗаменить(ПрописьЧислаИПредмета, ПрописьЧисла, "");
	
КонецФункции

// Устанавливает доступность кнопки ЗаписатьИЗакрыть в формах, где
// требуется задать вопрос пользователю ПередЗаписью объекта на клиенте
// с установкой Отказ = Истина и повторным вызовом метода формы Записать.
//
// Чтобы процедуру можно было вызвать на клиенте, в форму должен быть добавлен
// реквизит ПравоРедактированиеОбъекта типа Произвольный.
// Этот реквизит инициализируется при первом вызове на стороне сервере (из обработчика
// события формы ПриСозданииНаСервере) и далее используется при вызове на клиенте,
// когда меняется свойство формы ТолькоПросмотр.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма элемента справочника, документа, ...
//  ОсновнойРеквизит - Строка - имя реквизита формы, содержащего структуру объекта.
//  ИмяЭлемента - Строка - имя элемента формы с кнопкой ЗаписатьИЗакрыть.
//
Процедура УстановитьДоступностьКнопкиЗаписатьИЗакрыть(Форма, ОсновнойРеквизит = "Объект", ИмяЭлемента = "ФормаЗаписатьИЗакрыть") Экспорт
	
	Права = Новый Структура("ПравоРедактированияОбъекта");
	ЗаполнитьЗначенияСвойств(Права, Форма);
	
	Если Права.ПравоРедактированияОбъекта = Неопределено Тогда
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Права.ПравоРедактированияОбъекта = ПравоДоступа("Редактирование", Форма[ОсновнойРеквизит].Ссылка.Метаданные());
		ЗаполнитьЗначенияСвойств(Форма, Права);
	#КонецЕсли
	КонецЕсли;
	
	ДоступностьКнопки = Не Форма.ТолькоПросмотр И Права.ПравоРедактированияОбъекта;
	Если Форма.Элементы[ИмяЭлемента].Доступность <> ДоступностьКнопки Тогда
		Форма.Элементы[ИмяЭлемента].Доступность = ДоступностьКнопки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вычисляет начальное имя для входа по полному имени пользователя.
Функция ПолучитьКраткоеИмяПользователяИБ(Знач ПолноеИмя) Экспорт
	
	Разделители = Новый Массив;
	Разделители.Добавить(" ");
	Разделители.Добавить(".");
	
	КраткоеИмя = "";
	Для Счетчик = 1 По 3 Цикл
		
		Если Счетчик <> 1 Тогда
			КраткоеИмя = КраткоеИмя + ВРег(Лев(ПолноеИмя, 1));
		КонецЕсли;
		
		ПозицияРазделителя = 0;
		Для каждого Разделитель Из Разделители Цикл
			ПозицияТекущегоРазделителя = СтрНайти(ПолноеИмя, Разделитель);
			Если ПозицияТекущегоРазделителя > 0
			   И (    ПозицияРазделителя = 0
			      ИЛИ ПозицияРазделителя > ПозицияТекущегоРазделителя ) Тогда
				ПозицияРазделителя = ПозицияТекущегоРазделителя;
			КонецЕсли;
		КонецЦикла;
		
		Если ПозицияРазделителя = 0 Тогда
			Если Счетчик = 1 Тогда
				КраткоеИмя = ПолноеИмя;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
		Если Счетчик = 1 Тогда
			КраткоеИмя = Лев(ПолноеИмя, ПозицияРазделителя - 1);
		КонецЕсли;
		
		ПолноеИмя = Прав(ПолноеИмя, СтрДлина(ПолноеИмя) - ПозицияРазделителя);
		Пока Разделители.Найти(Лев(ПолноеИмя, 1)) <> Неопределено Цикл
			ПолноеИмя = Сред(ПолноеИмя, 2);
		КонецЦикла;
	КонецЦикла;
	
	Возврат КраткоеИмя;
	
КонецФункции

// Для форма элементов справочников Пользователи и ВнешниеПользователи.
Процедура ОбновитьОграничениеСрокаДействия(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ИзменитьОграничениеНаВходВПрограмму.Видимость =
		Элементы.СвойстваПользователяИБ.Видимость И Форма.УровеньДоступа.УправлениеСписком;
	
	Если Не Элементы.СвойстваПользователяИБ.Видимость Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";
		Возврат;
	КонецЕсли;
	
	Элементы.ИзменитьОграничениеНаВходВПрограмму.Доступность = Форма.УровеньДоступа.НастройкиДляВхода;
	
	ЗаголовокСОграничением = "";
	
	Если Форма.СрокДействияНеОграничен Тогда
		ЗаголовокСОграничением = НСтр("ru = 'Вход в программу разрешен (без ограничения срока)'");
		
	ИначеЕсли ЗначениеЗаполнено(Форма.СрокДействия) Тогда
		ЗаголовокСОграничением = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вход в программу разрешен (до %1)'"),
			Формат(Форма.СрокДействия, "ДЛФ=D"));
			
	ИначеЕсли ЗначениеЗаполнено(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода) Тогда
		ЗаголовокСОграничением = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вход в программу разрешен (запретить, если не работает более %1)'"),
			Формат(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода, "ЧГ=") + " "
				+ ПредметЦелогоЧисла(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода,
					"", НСтр("ru = 'день,дня,дней,,,,,,0'")));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаголовокСОграничением) Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = ЗаголовокСОграничением;
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = НСтр("ru = 'Изменить ограничение'");
	Иначе
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = НСтр("ru = 'Установить ограничение'");
	КонецЕсли;
	
КонецПроцедуры

// Для форма элементов справочников Пользователи и ВнешниеПользователи.
Процедура УстановитьНаличиеПароля(Форма, ПарольУстановлен) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если ПарольУстановлен Тогда
		Элементы.НадписьНаличиеПароля.Заголовок = НСтр("ru = 'Пароль установлен'");
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок =
			НСтр("ru = 'Потребовать смену пароля при входе'");
	Иначе
		Элементы.НадписьНаличиеПароля.Заголовок = НСтр("ru = 'Пустой пароль'");
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок =
			НСтр("ru = 'Потребовать установку пароля при входе'");
	КонецЕсли;
	
	Если ПарольУстановлен
	   И Форма.Объект.Ссылка = ПользователиКлиентСервер.АвторизованныйПользователь() Тогда
		
		Элементы.СменитьПароль.Заголовок = НСтр("ru = 'Сменить пароль...'");
	Иначе
		Элементы.СменитьПароль.Заголовок = НСтр("ru = 'Установить пароль...'");
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ТекущийПользователь(АвторизованныйПользователь) Экспорт
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего пользователя
			           |в сеансе внешнего пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

#КонецОбласти
