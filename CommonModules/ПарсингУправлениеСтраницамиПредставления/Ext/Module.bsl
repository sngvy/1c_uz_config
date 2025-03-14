﻿
#Область ПрограммныйИнтерфейс

Функция ПредыдущаяСтраница(ДанныеИсходногоФайла, Каталоги) Экспорт

	Смещение = Смещение(-1);
	Возврат ПереходНаСтраницу(ДанныеИсходногоФайла, Смещение, Каталоги);

КонецФункции

Функция СледующаяСтраница(ДанныеИсходногоФайла, Каталоги) Экспорт

	Смещение = Смещение(1);
	Возврат ПереходНаСтраницу(ДанныеИсходногоФайла, Смещение, Каталоги);

КонецФункции

Функция ПерваяСтраница(ДанныеИсходногоФайла, Каталоги) Экспорт

	Возврат ПереходВНачало(ДанныеИсходногоФайла, Каталоги);

КонецФункции // ()


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Конфигурация

Функция СтраницыПерехода()

	Описание = Новый Структура;
	Описание.Вставить("Начало", "*");
	Описание.Вставить("Конец", "*");
	Описание.Вставить("Смещение", 0);
	
	Возврат Описание;

КонецФункции // ()

Функция Начало()

	Переходы = СтраницыПерехода();
	Возврат Переходы["Начало"];

КонецФункции // ()

Функция Конец()

	Переходы = СтраницыПерехода();
	Возврат Переходы["Конец"];

КонецФункции // ()

Функция Смещение(Значение)

	Переходы = СтраницыПерехода();
	Возврат Переходы["Смещение"] + Значение;

КонецФункции // ()

Функция ФорматНомераСтраницы(СтраницаПерехода)

	Если ТипЗнч(СтраницаПерехода) = Тип("Строка") Тогда
	
		Возврат СтраницаПерехода;
	
	КонецЕсли;
	Возврат Формат(СтраницаПерехода, "ЧДЦ=0; ЧН=0; ЧГ=0")

КонецФункции // ()

#КонецОбласти

#Область ПроверкиДанных

Функция КорректнаяСтруктураДанных(ДанныеИсходногоФайла) Экспорт

	Если ДанныеИсходногоФайла = Неопределено Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	Если Не ДанныеИсходногоФайла.Свойство("Страница") Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	Если Не ДанныеИсходногоФайла.Свойство("ОригиналСкана") Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ()

#КонецОбласти

Функция ПереходНаСтраницу(ДанныеИсходногоФайла, Смещение, Каталоги)
	
	Если Не КорректнаяСтруктураДанных(ДанныеИсходногоФайла) Тогда
	
		ВызватьИсключение УправленияСообщениямиКлиентСервер.ИнструкцияКОшибке(
			"Проверка переданных данных",
			"Не корректные данные исходного файла:
			|Должны быть свойства Страница, ОригиналСкана"
		);
	
	КонецЕсли;
	
	ТекущийНомер = ДанныеИсходногоФайла.Страница;
	МиниПредставление = ПредставлениеНовойСтраницы(
		ДанныеИсходногоФайла.ОригиналСкана,
		ТекущийНомер + Смещение,
		Каталоги
	);
	
	Возврат СформироватьОтвет(МиниПредставление, ТекущийНомер, ТекущийНомер + Смещение);

КонецФункции

Функция ПереходВНачало(ДанныеИсходногоФайла, Каталоги)
	
	Если Не КорректнаяСтруктураДанных(ДанныеИсходногоФайла) Тогда
	
		ВызватьИсключение УправленияСообщениямиКлиентСервер.ИнструкцияКОшибке(
			"Проверка переданных данных",
			"Не корректные данные исходного файла:
			|Должны быть свойства Страница, ОригиналСкана"
		);
	
	КонецЕсли;
	
	Смещение = Начало();
	МиниПредставление = ПредставлениеНовойСтраницы(
		ДанныеИсходногоФайла.ОригиналСкана,
		Смещение,
		Каталоги
	);
	
	Возврат СформироватьОтвет(МиниПредставление, 0);

КонецФункции

Функция СформироватьОтвет(МиниПредставление, СтараяСтраница, НоваяСтраница = Неопределено)

	Ответ = Новый Структура;
	Ответ.Вставить("Представление", Неопределено);
	Ответ.Вставить("Файл", Неопределено);
	Ответ.Вставить("ТекущаяСтраница", СтараяСтраница);
	Если МиниПредставление <> Неопределено Тогда
	
		Ответ["Представление"] = МиниПредставление.ИмяБезРасширения;
		Ответ["Файл"] = МиниПредставление.ПолноеИмя;
		Ответ["ТекущаяСтраница"] = НоваяСтраница;
		Если НоваяСтраница = Неопределено Тогда
		
			Ответ["ТекущаяСтраница"] = ПолучитьНомерПредставления(МиниПредставление);
		
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Ответ;

КонецФункции // ()


Функция ПолучитьКаталогПредставления(ИсходныйФайл, Каталоги)

	ПутьКаталогПредставления = СтрЗаменить(
		ИсходныйФайл.Путь,
		Каталоги["Начальный"],
		Каталоги["МиниИзображения"]
	);

	КаталогПредставления = Новый Файл(ПутьКаталогПредставления);
	БазовыйКаталогПредставления = Новый Файл(КаталогПредставления.Путь);
	
	Если Не БазовыйКаталогПредставления.Существует()
		Или Не КаталогПредставления.Существует()
		Или Не КаталогПредставления.ЭтоКаталог() Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	Возврат КаталогПредставления;

КонецФункции // ()

Функция ПолучитьНомерПредставления(МиниПредставление)

	ЧастиИмени = СтрРазделить(МиниПредставление.ИмяБезРасширения, "-");
	Если ЧастиИмени.Количество() = 0 Тогда
	
		Возврат 0;
	
	КонецЕсли;
	ТолькоНомерСтраницы = ЧастиИмени[ЧастиИмени.Количество() - 1];
	
	ОписаниеЧисла = Новый ОписаниеТипов("Число");
	Возврат ОписаниеЧисла.ПривестиЗначение(ТолькоНомерСтраницы);

КонецФункции // ()

Функция ПредставлениеНовойСтраницы(ПутьИсходногоФайла, ИскомаяСтраница, Каталоги)

	ИсходныйФайл = Новый Файл(ПутьИсходногоФайла);

	КаталогПредставления = ПолучитьКаталогПредставления(ИсходныйФайл, Каталоги);
	Если КаталогПредставления = Неопределено Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	ИмяИсходногоФайла = ИсходныйФайл.ИмяБезРасширения;

	МиниПредставления = НайтиФайлы(
		КаталогПредставления.ПолноеИмя,
		ИмяИсходногоФайла + "-" + ФорматНомераСтраницы(ИскомаяСтраница) + ".jpeg"
	);
	Если МиниПредставления.Количество() = 0 Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;

	МиниПредставление = МиниПредставления[0];
	
	Возврат МиниПредставление;

КонецФункции

#КонецОбласти