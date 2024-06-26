﻿
&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	//Загружено = РаботаСДокументами.мПрочитатьТабличныйДокументИзExcel(ПолеИсходнойТаблицы, ФайлИмпорта, 1);
	ДД = Новый ДвоичныеДанные(ФайлИмпорта);
	Загружено = РаботаСДокументами.ПрочитатьТабличныйДокументExcelизДвоичныхДанных(ПолеИсходнойТаблицы,ДД,1);
КонецПроцедуры

&НаКлиенте
Процедура ФайлИмпортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	#Если Вебклиент Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Заголовок = "Выберите файл платежей...";
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Фильтр = "Табличный документ(*.xls, *.xlsx, *.ods)|*.xls?;*.ods|";
		//МассивПутейДокументов = Новый Массив;
		Диалог.Показать(Новый ОписаниеОповещения("ФайлИмпортаНачалоВыбораЗавершение", ЭтаФорма, Новый Структура("Диалог", Диалог)));
	#Иначе
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Заголовок = "Выберите файл платежей...";
		Диалог.МножественныйВыбор = Ложь;
		Диалог.Фильтр = "Табличный документ(*.xls, *.xlsx, *.ods)|*.xls?;*.ods|";
		//МассивПутейДокументов = Новый Массив;
		Если Диалог.Выбрать() Тогда
			ФайлИмпорта = Диалог.ПолноеИмяФайла;		
			ДД = Новый ДвоичныеДанные(ФайлИмпорта);
			ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД);
			
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлИмпортаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ФайлИмпорта = Диалог.ПолноеИмяФайла;
		ДД = Новый ДвоичныеДанные(ФайлИмпорта);
		ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД);
		
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ЗагрузитьТабличныйДокумент(ПолеИсходнойТаблицы,ДД)
	Попытка
		ПолеИсходнойТаблицы.Прочитать(ФайлИмпорта);
	Исключение
		//Загружено = РаботаСДокументами.мПрочитатьТабличныйДокументИзExcel(ПолеИсходнойТаблицы, ФайлИмпорта, 1);
		Загружено = РаботаСДокументами.ПрочитатьТабличныйДокументExcelизДвоичныхДанных(ПолеИсходнойТаблицы,ДД,1);
	КонецПопытки	
КонецПроцедуры

&НаСервере
Функция ПолучитьТипСлова(Слово) 
	
	
	//Попытка
	//      ДатаИП = Дата(Слово + " 00:00:00");
	//      Возврат "Дата";
	//Исключение
	//КонецПопытки;
	
	Если Врег(Слово) = "СЕРИЯ" Тогда
		Возврат "Символ";
	КонецЕсли;
	
	СтрокаЦифры = "0123456789";
	СтрокаБуквы = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЬЪЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ";
	СтрокаСимволы = "-/";
	
	
	ЕстьБуквы = Ложь;
	стр = Слово;
	Пока СтрДлина(стр) > 0 Цикл
		Буква = Лев(стр, 1);
		стр = Прав(стр, стрДлина(стр) - 1);
		Если СтрНайти(СтрокаБуквы, врег(Буква)) > 0 Тогда
			ЕстьБуквы = Истина;
			//Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ЕстьЦифры = Ложь;
	стр = Слово;
	Пока СтрДлина(стр) > 0 Цикл
		Буква = Лев(стр, 1);
		стр = Прав(стр, стрДлина(стр) - 1);
		Если СтрНайти(СтрокаЦифры, Буква) > 0 Тогда
			ЕстьЦифры = Истина;
			//Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ЕстьСимволы = Ложь;
	
	
	Если ЕстьЦифры И Не ЕстьБуквы Тогда
		Попытка
			ДатаИП = Дата(Слово + " 00:00:00");
			Возврат "Дата";
		Исключение
			Возврат "Число";
		КонецПопытки;
	ИначеЕсли ЕстьЦифры и ЕстьБуквы Тогда
		Возврат "Номер";
	ИначеЕсли Не ЕстьЦифры и ЕстьБуквы Тогда
		Если стрДлина(Слово) > 2 Тогда
			Возврат "Слово";
		ИначеЕсли стрДлина(Слово) = 2 Тогда
			Тип = ?(СловоИсключение(Слово),"Слово","Инициалы");
			Возврат Тип;
		Иначе
			Возврат "Буква";
		КонецЕсли;
	ИначеЕсли Не ЕстьЦифры и Не ЕстьБуквы Тогда
		Возврат "Символ";
	КонецЕсли;
КонецФункции

&НаСервере
Функция СловоИсключение(Слово)
	МассивСловИсключений = ИнициализировтьСловаИсключения();
	Для Каждого сл из МассивСловИсключений Цикл
		Если сл = Слово Тогда
			Возврат Истина;
			Прервать;
		КонецЕсли;
		СловоБезТире = Стрзаменить(Слово,"-","");
		Если сл = СловоБезТире Тогда
			Возврат Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Ложь;
КонецФункции



&НаСервере
Процедура ОбработатьНаСервере(Назначение, Кредитор)
	
	
	ОбработатьТекст(Назначение);
	ПоискПоНомеруКД(Кредитор);
	ПоискПОНомеруДО(Назначение);
	Если Объект.НайденныеДО.Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	
	ПоискПоФИО(Кредитор);
	Если Объект.НайденныеДО.Количество() = 1 Тогда
		Возврат;
	ИначеЕсли Объект.НайденныеДО.Количество() = 0 Тогда
		ПоискПоРодительномуПадежу();
		Если Объект.НайденныеДО.Количество() = 1 Тогда
			Возврат;
		КонецЕсли;
		
		ПоискПоИмениОтчеству();
		Если Объект.НайденныеДО.Количество() = 1 Тогда
			Возврат;
		КонецЕсли;

		ПоискПоИнициалам(Кредитор);
		Если Объект.НайденныеДО.Количество() = 1 Тогда
			Возврат;
		КонецЕсли;
	Иначе
	КонецЕсли;
	
	Если Объект.НайденныеДО.Количество() = 0 Тогда
		ПоискПоНомеруИД();
	КонецЕсли;
		
	Если Объект.НайденныеДО.Количество() = 0 Тогда
		ПоискПоНомеруИП();
	КонецЕсли;
	
	
	Если Объект.НайденныеДО.Количество() = 0 и ЗначениеЗаполнено(Объект.ДополнительныйПараметр) И Не Объект.ИД и Не Объект.ИП Тогда
		ПоискПоДопРеквизитуДО();
	КонецЕсли;

	
	//ПоискПоНомеруИП();
	//Если Объект.НайденныеДО.Количество() = 1 Тогда

	//КонецЕсли;	
	//ПоискПоНомеруИД();
КонецПроцедуры

&НаКлиенте
Процедура Обработать(Команда)
	Объект.НайденныеДО.Очистить();
	РезультатПоиска.Очистить();
	ОбработатьНаСервере(НазначениеПлатежа, Цендент);
	ВывестиРезультат();	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультат()
	Для Каждого Стр Из Объект.НайденныеДО Цикл
		Результат = РезультатПоиска.Добавить();
		ЗаполнитьЗначенияСвойств(Результат, Стр);
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ИсполнительныеДокументы.СудебноеРешение КАК СудебноеРешение,
		                      |	ИсполнительныеДокументы.ЧастьРешения КАК ЧастьРешения,
		                      |	МАКСИМУМ(ИсполнительныеДокументы.Ссылка) КАК Ссылка
		                      |ИЗ
		                      |	Справочник.ИсполнительныеДокументы КАК ИсполнительныеДокументы
		                      |ГДЕ
		                      |	ИсполнительныеДокументы.Владелец = &Владелец
		                      |	И ИсполнительныеДокументы.Должник = &Должник
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ИсполнительныеДокументы.СудебноеРешение,
		                      |	ИсполнительныеДокументы.ЧастьРешения");                            
		Запрос.УстановитьПараметр("Должник", стр.Контрагент);
		Запрос.УстановитьПараметр("Владелец", Стр.ДолговоеОбязательство);
		Рез = Запрос.Выполнить().Выбрать();
		Пока Рез.Следующий() Цикл
			Результат = РезультатПоиска.Добавить();
			ЗаполнитьЗначенияСвойств(Результат, Стр);
			Результат.ИсполнительныйДокумент = Рез.Ссылка;
			Если ЗначениеЗаполнено(Результат.ИсполнительныйДокумент.СудебноеРешение) Тогда
				Результат.НомерДела = Результат.ИсполнительныйДокумент.СудебноеРешение.НомерДела;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Стр из РезультатПоиска Цикл
		Если Не ЗначениеЗаполнено(Стр.ИсполнительныйДокумент) Тогда
			Продолжить;
		КонецЕсли;
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ФССП_ИсполнительноеПроизводство.Наименование КАК Наименование,
		                      |	ФССП_ИсполнительноеПроизводство.ДатаВозбуждения КАК ДатаВозбуждения
		                      |ИЗ
		                      |	Справочник.ФССП_ИсполнительноеПроизводство КАК ФССП_ИсполнительноеПроизводство
		                      |ГДЕ
		                      |	ФССП_ИсполнительноеПроизводство.НомерИД = &НомерИД
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	ФССП_ИсполнительноеПроизводство.ДатаВозбуждения УБЫВ");
		Запрос.УстановитьПараметр("НомерИД", стр.ИсполнительныйДокумент);
		Результат = Запрос.Выполнить().Выбрать();
		Пока Результат.Следующий() Цикл
			стр.НомерИП = стр.НомерИП + Результат.Наименование + " от " + Формат(Результат.ДатаВозбуждения,"ДФ=dd.MM.yyyy") + "; "; 	
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбработатьТекст(Пред)
	Объект.Слова.Очистить();    
	Объект.НайденныеДО.Очистить();
	//СтрокаСТочкой = Пред;
	//СтрокБезТочки = СтрЗаменить(СтрокаСТочкой,".","");
	//Если СтрДлина(СтрокаСТочкой) > СтрДлина(СтрокБезТочки) Тогда
	//	Предложение = СтрокаСТочкой;
	//Иначе
		Предложение = Пред;
	//КонецЕсли;
	
	Предложение = стрЗаменить(Предложение, "(", " ");
	Предложение = стрЗаменить(Предложение, ".", " ");
	Предложение = стрЗаменить(Предложение, ")", " ");
	Предложение = стрЗаменить(Предложение, ":", " ");
	Предложение = стрЗаменить(Предложение, ";", " ");
	Предложение = стрЗаменить(Предложение, ",", " ");
	Предложение = стрЗаменить(Предложение, "  ", " ");
	Предложение = стрЗаменить(Предложение, "  ", " ");
	
	Для к = 1 по 199 Цикл
		Слово = ОтрезатьПервоеСлово(Предложение); 
		
		Если Слово = "" Тогда 
			Продолжить;
		КонецЕсли; 
		УдалитьЛишнее(Слово);
		Исключ = СловоИсключение(Слово);
		Если Не Исключ Тогда 
			стр = Объект.Слова.Добавить();
			стр.Слово = Слово;
			стр.ТипСлова = ПолучитьТипСлова(Слово);
			Если Стр.ТипСлова = "Номер" Тогда
				ПроверитьСлипшеесяСлово(Слово);
			КонецЕсли;
		Иначе
			Если СтрДлина(Слово) > 2 Тогда
				Продолжить;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры  

&НаСервере
Процедура ПроверитьСлипшеесяСлово(Сл)
	СтрокаБуквы = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЬЪЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	Для к = 1 по СтрДлина(Сл) Цикл
		Попытка
			Числ = Число(Лев(Сл,к));
		Исключение
			Ст = Прав(Сл,СтрДлина(Сл) - к +1);
			Прервать;
		КонецПопытки;	
	КонецЦикла;	
	
	Исходная=Ст;
	Конечная=Лев(Исходная,1);
	Для Индекс=2 по СтрДлина(Исходная) цикл
		Символ=Сред(Исходная,Индекс,1);
		Конечная=Конечная+?(ВРег(Символ)=Символ," "+НРег(Символ),Символ);
	КонецЦикла;
	
	Конечная = ТРег(Конечная); 
	
	Масс = СтрРазделить(Конечная," ",Ложь);
	
	
	стр = Объект.Слова.Добавить();
	стр.Слово = Масс[0];                       
	стр.ТипСлова = ПолучитьТипСлова(стр.Слово);
	
	Попытка
		перСлово = Масс[Масс.Количество()-2]+ Масс[Масс.Количество()-1];
		стр = Объект.Слова.Добавить();
		стр.Слово = перСлово; 
		стр.ТипСлова = ПолучитьТипСлова(стр.Слово);
	Исключение
	КонецПопытки;
	
	

КонецПроцедуры


&НаСервере
Функция ПолучитьПервоеСлово(Предложение)
	Номер = Найти(Предложение, " ");
	Если Номер > 0 Тогда
		Стр = Лев(Предложение, Номер-1);
		Возврат Стр;
	Иначе
		Возврат Предложение;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ОтрезатьПервоеСлово(Предложение)
	Номер = Найти(Предложение, " ");
	Если Номер > 0 Тогда
		Стр = Лев(Предложение, Номер-1);
		Предложение = Прав(Предложение, СтрДлина(Предложение) - Номер);
		Возврат Стр;
	Иначе
		Слово = Предложение;
		Предложение = "";
		Возврат Слово;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура УдалитьЛишнее(Слово)
	СтрокаЛишнее = ".,():;" + """";
	ПоследнийСимвол = Прав(Слово, 1);
	Если стрНайти(СтрокаЛишнее, ПоследнийСимвол) > 0 Тогда
		Слово = Лев(Слово, СтрДлина(Слово) - 1);
	КонецЕсли;
	ПоследнийСимвол = Прав(Слово, 1);
	Если стрНайти(СтрокаЛишнее, ПоследнийСимвол) > 0 Тогда
		Слово = Лев(Слово, СтрДлина(Слово) - 1);
	КонецЕсли;	
	ПервыйСимвол = Лев(Слово, 1);
	Если стрНайти(СтрокаЛишнее, ПервыйСимвол) > 0 Тогда
		Слово = Прав(Слово, стрДлина(Слово) - 1);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоискПоФИО(Кредитор)
	СловПодряд = 0;
	к = 0;
	Для Каждого Слово из Объект.Слова Цикл
		Если Слово.ТипСлова = "Слово" Тогда
			СловПодряд = СловПодряд + 1;
			Если СловПодряд = 3 Тогда
				ФИО = Объект.Слова[к - 2].Слово + " " + Объект.Слова[к - 1].Слово + " " + Объект.Слова[к].Слово;
				НайтиВБазеПоФИО(ФИО, Кредитор);
				СловПодряд = 2;
			КонецЕсли;
		Иначе
			СловПодряд = 0;
		КонецЕсли;
		к = к + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоФИО(ФИО, Кредитор)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КонтрагентыФИО.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Контрагенты.ФИО КАК КонтрагентыФИО
	                      |ГДЕ
	                      |	КонтрагентыФИО.ФИО = &Наименование");
	Запрос.УстановитьПараметр("Наименование", ФИО);
	вРезультат = Запрос.Выполнить();
	Если вРезультат.Пустой() Тогда
		вРезультат = ШаблонЕЁ(ФИО,Запрос);
	КонецЕсли;
	
	Результат = вРезультат.Выбрать();
	
	Пока Результат.Следующий() Цикл
		Контрагент = Результат.Ссылка;
		Запрос1 = Новый Запрос();
		Запрос1.Текст = "ВЫБРАТЬ
		                       |	ДолговыеОбязательства.Ссылка КАК Ссылка
		                       |ИЗ
		                       |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
		                       |ГДЕ
		                       |	ДолговыеОбязательства.Должник = &Должник
		                       |
		                       |ОБЪЕДИНИТЬ ВСЕ
		                       |
		                       |ВЫБРАТЬ
		                       |	Поручительства.ДолговоеОбязательство
		                       |ИЗ
		                       |	РегистрСведений.Поручительства КАК Поручительства
		                       |ГДЕ
		                       |	Поручительства.Поручитель = &Должник";	
		Если ЗначениеЗаполнено(Кредитор) Тогда
			Запрос1.Текст = СтрЗаменить(Запрос1.Текст,"ДолговыеОбязательства.Должник = &Должник","ДолговыеОбязательства.Должник = &Должник И ДолговыеОбязательства.Кредитор = &Кредитор"); 
			Запрос1.Текст = СтрЗаменить(Запрос1.Текст,"Поручительства.Поручитель = &Должник","Поручительства.Поручитель = &Должник И Поручительства.ДолговоеОбязательство.Кредитор = &Кредитор");
			Запрос1.УстановитьПараметр("Кредитор", Кредитор);
		КонецЕсли;	
		
		Запрос1.УстановитьПараметр("Должник", Контрагент);
		Результат1 = Запрос1.Выполнить().Выбрать();
		Пока Результат1.Следующий() Цикл
			стр = Объект.НайденныеДО.Добавить();
			стр.ДолговоеОбязательство = Результат1.Ссылка;
			стр.Контрагент = Контрагент;
			стр.ВидПоиска = "По ФИО";
			стр.ЗначениеПоиска = ФИО;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоискПоРодительномуПадежу()
	СловПодряд = 0;
	к = 0;
	Для Каждого Слово из Объект.Слова Цикл
		Если Слово.ТипСлова = "Слово" Тогда
			СловПодряд = СловПодряд + 1;
			Если СловПодряд = 3 Тогда
				ФИО = Объект.Слова[к - 2].Слово + " " + Объект.Слова[к - 1].Слово + " " + Объект.Слова[к].Слово;
				НайтиВБазеПоРодительномуПадежу(ФИО);
				СловПодряд = 2;
			КонецЕсли;
		Иначе
			СловПодряд = 0;
		КонецЕсли;
		к = к + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоРодительномуПадежу(ФИО)
	
	РезПоиска = ПолнотекстовыйПоиск(ФИО);
	
	Если РезПоиска = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	Для Каждого Результат из РезПоиска Цикл
		Контрагент = Результат.Значение;
		Запрос1 = Новый Запрос("ВЫБРАТЬ
		                      |	ДолговыеОбязательства.Ссылка КАК Ссылка
		                      |ИЗ
		                      |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
		                      |ГДЕ
		                      |	ДолговыеОбязательства.Должник = &Должник");
		Запрос1.УстановитьПараметр("Должник", Контрагент);
		Результат1 = Запрос1.Выполнить().Выбрать();
		Пока Результат1.Следующий() Цикл
			стр = Объект.НайденныеДО.Добавить();
			стр.ДолговоеОбязательство = Результат1.Ссылка;
			стр.Контрагент = Контрагент;
			стр.ВидПоиска = "ПоРодительномуПадежу";
			стр.ЗначениеПоиска = ФИО;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры


&НаСервере
Процедура ПоискПоИмениОтчеству()
	СловПодряд = 0;
	к = 0;
	Для Каждого Слово из Объект.Слова Цикл
		Если Слово.ТипСлова = "Слово" Тогда
			СловПодряд = СловПодряд + 1;
			Если СловПодряд = 2 Тогда
				ИО = Объект.Слова[к - 1].Слово + " " + Объект.Слова[к].Слово;
				НайтиВБазеПоИО(ИО);
				СловПодряд = 1;
			КонецЕсли;
		Иначе
			СловПодряд = 0;
		КонецЕсли;
		к = к + 1;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПоискПоИнициалам(Кредитор)
	СловПодряд = 0;
	к = 0;
	Для Каждого Слово из Объект.Слова Цикл
		Если Слово.ТипСлова = "Слово" Или Слово.ТипСлова = "Буква" Или Слово.ТипСлова = "Инициалы" Тогда
			СловПодряд = СловПодряд + 1;
			Если СловПодряд = 3 Тогда
				Если Объект.Слова[к - 2].ТипСлова = "Слово" И Объект.Слова[к - 1].ТипСлова = "Буква" И Объект.Слова[к].ТипСлова = "Буква" Тогда
					НайтиВБазеПоИнициалам(Объект.Слова[к - 2].Слово, Объект.Слова[к - 1].Слово, Объект.Слова[к].Слово, Кредитор);
				КонецЕсли;
				СловПодряд = 2;
			КонецЕсли;
			Если СловПодряд = 2 Тогда
				Если Объект.Слова[к - 1].ТипСлова = "Слово" И Объект.Слова[к].ТипСлова = "Инициалы" Тогда
					ИнициалИмя = Лев(Объект.Слова[к].Слово,1);
					ИнициалО = Прав(Объект.Слова[к].Слово,1);
					НайтиВБазеПоИнициалам(Объект.Слова[к - 1].Слово, ИнициалИмя,ИнициалО, Кредитор);
				КонецЕсли;
				СловПодряд = 1;
			КонецЕсли;
			
		Иначе
			СловПодряд = 0;
		КонецЕсли;
		к = к + 1;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоИнициалам(Фамилия, Имя, Отчество, Кредитор)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КонтрагентыФИО.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Контрагенты.ФИО КАК КонтрагентыФИО
	                      |ГДЕ
	                      |	КонтрагентыФИО.Фамилия = &Наименование");
	Запрос.УстановитьПараметр("Наименование", Фамилия);
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		Контрагент = Результат.Ссылка;
		ФИО = Контрагент.Наименование;
		Инициалы = ПолучитьИнициалы(ФИО);
		Если врег(Инициалы) = врег(Фамилия + " " + Имя + " " + Отчество) Тогда
			Запрос1 = Новый Запрос();
			Запрос1.Текст = "ВЫБРАТЬ
			                       |	ДолговыеОбязательства.Ссылка КАК Ссылка
			                       |ИЗ
			                       |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
			                       |ГДЕ
			                       |	ДолговыеОбязательства.Должник = &Должник";
			Если ЗначениеЗаполнено(Кредитор) Тогда
				Запрос1.Текст = СтрЗаменить(Запрос1.Текст,"&Должник","&Должник И ДолговыеОбязательства.Кредитор = &Кредитор"); 
				Запрос1.УстановитьПараметр("Кредитор", Кредитор);
			КонецЕсли;
			
			Запрос1.УстановитьПараметр("Должник", Контрагент);
			Результат1 = Запрос1.Выполнить().Выбрать();
			Пока Результат1.Следующий() Цикл
				стр = Объект.НайденныеДО.Добавить();
				стр.ДолговоеОбязательство = Результат1.Ссылка;
				стр.Контрагент = Контрагент;
				стр.ВидПоиска = "По инициалам";
				стр.ЗначениеПоиска = Фамилия + " " + Имя + ". " + Отчество + ".";
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьИнициалы(ФИО)
	Предложение = ФИО;
	Фамилия = ОтрезатьПервоеСлово(Предложение);
	Имя = ОтрезатьПервоеСлово(Предложение);
	Отчество = ОтрезатьПервоеСлово(Предложение);
	Возврат Фамилия + " " + Лев(Имя, 1) + " " + Лев(Отчество, 1);
КонецФункции

&НаСервере
Процедура НайтиВБазеПоИО(ИО)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Контрагенты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Контрагенты КАК Контрагенты
	                      |ГДЕ
	                      |	Контрагенты.Наименование ПОДОБНО &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%" + ИО + "%");
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		Контрагент = Результат.Ссылка;
		Запрос1 = Новый Запрос("ВЫБРАТЬ
		                      |	ДолговыеОбязательства.Ссылка КАК Ссылка
		                      |ИЗ
		                      |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
		                      |ГДЕ
		                      |	ДолговыеОбязательства.Должник = &Должник");
		Запрос1.УстановитьПараметр("Должник", Контрагент);
		Результат1 = Запрос1.Выполнить().Выбрать();
		Пока Результат1.Следующий() Цикл
			стр = Объект.НайденныеДО.Добавить();
			стр.ДолговоеОбязательство = Результат1.Ссылка;
			стр.Контрагент = Контрагент;
			стр.ВидПоиска = "По имени и отчеству";
			стр.ЗначениеПоиска = ИО;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоискПоНомеруКД(Кредитор)
	Для Каждого Слово из Объект.Слова Цикл
		Если Слово.ТипСлова = "Номер" ИЛИ Слово.ТипСлова = "Число" Тогда
			НайтиВБазеПоНомеруКД(Слово.Слово, Кредитор);
		КонецЕсли;		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоНомеруКД(НомерКД, Кредитор)
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ДолговыеОбязательства.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.ДолговыеОбязательства КАК ДолговыеОбязательства
	                      |ГДЕ
	                      |	ДолговыеОбязательства.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование", НомерКД);
	Если ЗначениеЗаполнено(Кредитор) Тогда
		Запрос.Текст = Запрос.Текст + " И ДолговыеОбязательства.Кредитор = &Кредитор"; 
		Запрос.УстановитьПараметр("Кредитор", Кредитор);
	КонецЕсли;	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		стр = Объект.НайденныеДО.Добавить();
		стр.ДолговоеОбязательство = Результат.Ссылка;
		стр.Контрагент = Результат.Ссылка.Должник;
		стр.ВидПоиска = "По номеру КД";
		стр.ЗначениеПоиска = НомерКД;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоискПоНомеруИП()
	Для Каждого Слово Из объект.Слова Цикл
		Если Слово.ТипСлова = "Номер" и СтрДлина(слово.Слово) > 2 Тогда
			Если ЗначениеЗаполнено(Объект.ДополнительныйПараметр) И объект.ИП Тогда
				Найдено = Ложь;
				НайтиВБазеПоДопРеквизитуДО(Слово.Слово,Найдено);
				Если Найдено Тогда
					Прервать;
				КонецЕсли;	
			Иначе
				Если СтрДлина(слово.Слово) > 2 Тогда 
					НайтиВБазеПоНомеруИП(Слово.Слово);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦИкла;
КонецПроцедуры

&НаСервере
Процедура ПоискПоНомеруИД()
	Для Каждого Слово Из объект.Слова Цикл
		Если Слово.ТипСлова = "Номер" Или Слово.ТипСлова = "Число" Тогда
			Если ЗначениеЗаполнено(Объект.ДополнительныйПараметр) И объект.ИД и СтрДлина(слово.Слово) > 2 Тогда
				Найдено = Ложь;
				НайтиВБазеПоДопРеквизитуДО(Слово.Слово,Найдено);
				Если Найдено Тогда
					Прервать;
				КонецЕсли;	
			Иначе
				Если СтрДлина(слово.Слово) > 2 Тогда
					НайтиВБазеПоНомеруИД(Слово.Слово);
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦИкла;
КонецПроцедуры

Процедура ПоискПоДопРеквизитуДО()	
	Найдено = Ложь;
	Для Каждого Слово Из объект.Слова Цикл
		НайтиВБазеПоДопРеквизитуДО(Слово.Слово,Найдено);
		Если Найдено Тогда
			Прервать;
		КонецЕсли;	
	КонецЦИкла;

КонецПроцедуры


&НаСервере
Процедура НайтиВБазеПоНомеруИД(НомерИД)
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ИсполнительныеДокументы.Ссылка КАК Ссылка,
	                      |	ИсполнительныеДокументы.Владелец КАК Владелец
	                      |ИЗ
	                      |	Справочник.ИсполнительныеДокументы КАК ИсполнительныеДокументы
	                      |ГДЕ
	                      |	ИсполнительныеДокументы.НомерДела = &СерияНомерИД");	
	Запрос.УстановитьПараметр("СерияНомерИД", НомерИД);
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		стр = Объект.НайденныеДО.Добавить();
		стр.ДолговоеОбязательство = Результат.Владелец;
		стр.ИсполнительныйДОкумент = Результат.Ссылка;
		стр.ВидПоиска = "По номеру ИД";
		стр.ЗначениеПоиска = НомерИД;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоНомеруИП(НомерИП)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ФССП_ИсполнительноеПроизводство.НомерИД.Владелец.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.ФССП_ИсполнительноеПроизводство КАК ФССП_ИсполнительноеПроизводство
	                      |ГДЕ
	                      |	ФССП_ИсполнительноеПроизводство.ПометкаУдаления = ЛОЖЬ
	                      |	И ФССП_ИсполнительноеПроизводство.Наименование Подобно &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%"+НомерИП+"%");
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		стр = Объект.НайденныеДО.Добавить();
		стр.ДолговоеОбязательство = Результат.Ссылка;
		стр.ВидПоиска = "По номеру ИП";
		стр.ЗначениеПоиска = НомерИП;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НайтиВБазеПоДопРеквизитуДО(Параметр,Найдено)	

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДолговыеОбязательстваДополнительныеРеквизиты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.ДолговыеОбязательства.ДополнительныеРеквизиты КАК ДолговыеОбязательстваДополнительныеРеквизиты
	                      |ГДЕ
	                      |	ДолговыеОбязательстваДополнительныеРеквизиты.Свойство = &Свойство
	                      |	И ДолговыеОбязательстваДополнительныеРеквизиты.Значение = &Значение
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ДополнительныеСведения.Объект
	                      |ИЗ
	                      |	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	                      |ГДЕ
	                      |	ДополнительныеСведения.Свойство = &Свойство
	                      |	И ДополнительныеСведения.Значение = &Значение");
	Запрос.УстановитьПараметр("Свойство", Объект.ДополнительныйПараметр);
	Запрос.УстановитьПараметр("Значение", Параметр);
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Не Результат.Следующий() Тогда
		Параметр = СтрЗаменить(Параметр,"№","");
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ДолговыеОбязательстваДополнительныеРеквизиты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДолговыеОбязательства.ДополнительныеРеквизиты КАК ДолговыеОбязательстваДополнительныеРеквизиты
		|ГДЕ
		|	ДолговыеОбязательстваДополнительныеРеквизиты.Свойство = &Свойство
		|	И ДолговыеОбязательстваДополнительныеРеквизиты.Значение Подобно &Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДополнительныеСведения.Объект
		|ИЗ
		|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|ГДЕ
		|	ДополнительныеСведения.Свойство = &Свойство
		|	И ДополнительныеСведения.Значение Подобно &Значение");
		Запрос.УстановитьПараметр("Свойство", Объект.ДополнительныйПараметр);
		Запрос.УстановитьПараметр("Значение", "%"+Параметр+"%");
		Результат = Запрос.Выполнить().Выбрать();
		
	КонецЕсли;
	
	
	Пока Результат.Следующий() Цикл
		стр = Объект.НайденныеДО.Добавить();
		стр.ДолговоеОбязательство = Результат.Ссылка;
		стр.ВидПоиска = "По Доп.параметру";
		стр.ЗначениеПоиска = Параметр;
		Найдено = Истина;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура Выделение(Команда)

	Для Каждого Слово из Объект.Слова Цикл
		Документ.Элементы.Добавить(Слово.Слово, Тип("ТекстФорматированногоДокумента"));
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	Сообщить(Элементы.Документ.ВыделенныйТекст);
КонецПроцедуры

&НаКлиенте
Процедура ПолеИсходнойТаблицыВыбор(Элемент, Область, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПолеИсходнойТаблицыПриАктивизацииОбласти(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеСервер()
	Объект.ЗагруженныеДанные.Очистить();
	//НомерСтолбцаДата = 1;
	//НомерСтолбцаЦессионарий = 2;
	//НомерСтолбцаВидПлательщика = 3;
	//НомерСтолбцаПлательщик = 4;
	//НомерСтолбцаСумма = 5;
	//НомерСтолбцаТекст = 6;
	
	НомерСтолбцаДата = Объект.ПолеДатаПлатежа;
	НомерСтолбцаЦессионарий = Объект.ПолеЦендент;
	НомерСтолбцаВидПлательщика = Объект.ПолеВидПлательщика;
	НомерСтолбцаПлательщик = Объект.ПолеПлательщик;
	НомерСтолбцаСумма = Объект.ПолеСумма;
	НомерСтолбцаТекст = Объект.ПолеТекст;
	НомерСтолбцаСотрудник = Объект.ПолеСотрудник;
	
	Для НомерСтроки = 2 По ПолеИсходнойТаблицы.ВысотаТаблицы Цикл
		стр = Объект.ЗагруженныеДанные.Добавить();
		стрДата = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаДата, "ЧГ=")).Текст;
		стрСумма = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаСумма, "ЧГ=")).Текст;
		стр.Дата = Технический.ПреобразоватьДату(стрДата);

//		стр.Дата = Технический.ПреобразоватьДату(стрДата); 

//		Если Не ЗначениеЗаполнено(стр.Дата) Тогда
//			Попытка
//				стр.Дата = Дата(стрДата);
//			Исключение
//			КонецПопытки;
//		КонецЕсли;

		стрСумма = стрЗаменить(стрСумма, Символы.НПП, "");
		стрСумма = стрЗаменить(стрСумма, ",", ".");
		попытка
			стр.Сумма = Число(стрСумма);
		Исключение
			Сообщить("По умолчанию столбец суммы платежа - 5"); 
			прервать;
		КонецПопытки;
		стр.НазначениеПлатежа = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаТекст, "ЧГ=")).Текст;
		стрВидПлательщика = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаВидПлательщика, "ЧГ=")).Текст;

		Попытка 
			стр.ВидПлательщика = Перечисления.ВидыПлательщика[СтрЗаменить(ТРег(СокрЛП(СтрВидПлательщика))," ","")];
		Исключение
			Стр.ВидПлательщика = Перечисления.ВидыПлательщика.Должник;
		КонецПопытки;
		
		стрПлательщик = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаПлательщик, "ЧГ=")).Текст;
		
		Попытка 
			стр.Плательщик = ПоставитьПлательщика(стрПлательщик);
			Если ТипЗнч(стр.Плательщик) = Тип("СправочникСсылка.Контрагенты") Тогда
				Если стр.Плательщик.ЮрФизЛицо = Справочники.ЮрФизЛицо.ФизЛицо Тогда
					стр.ВидПлательщика = Перечисления.ВидыПлательщика.Должник;
				ИначеЕсли стр.Плательщик.ЮрФизЛицо = Справочники.ЮрФизЛицо.ЮрЛицо Тогда
					стр.ВидПлательщика = Перечисления.ВидыПлательщика.Цедент;
				КонецЕсли;
			КонецЕсли;
			Если ТипЗнч(стр.Плательщик) = Тип("СправочникСсылка.Организации") Тогда
				стр.ВидПлательщика = Перечисления.ВидыПлательщика.Цедент;
			КонецЕсли;
			Если ТипЗнч(стр.Плательщик) = Тип("СправочникСсылка.СудебныеПриставы") Тогда
				стр.ВидПлательщика = Перечисления.ВидыПлательщика.СудебныйПристав;
			КонецЕсли;
		Исключение
		КонецПопытки;

		стрЦендент = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаЦессионарий, "ЧГ=")).Текст;
		
		Попытка
			стр.Цендент = Справочники.Контрагенты.НайтиПоНаименованию(стрЦендент,Истина);
			стр.Цендент = ?(ЗначениеЗаполнено(Объект.Цендент),Объект.Цендент,Справочники.Контрагенты.ПустаяСсылка());
		Исключение
		КонецПопытки;
		
		//
		стрСотрудник = ПолеИсходнойТаблицы.Область("R" + Формат(НомерСтроки, "ЧГ=") + "C" + Формат(НомерСтолбцаСотрудник, "ЧГ=")).Текст;
		Попытка
		
			стр.Сотрудник = Справочники.Пользователи.НайтиПоКоду(стрСотрудник);
			
		
		Исключение
		
		КонецПопытки; 
		//
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПоставитьПлательщика(сПлательщик);
	ПлательщикСсылка = Неопределено;
	МассивИменСправочников = Новый Массив;
	МассивИменСправочников.Добавить("Контрагенты");
	МассивИменСправочников.Добавить("Организации");
	МассивИменСправочников.Добавить("СудебныеПриставы");
	Для каждого Спр из МассивИменСправочников Цикл
		ПлательщикСсылка = Справочники[СПР].НайтиПоНаименованию(сПлательщик,Истина);
		Если ПлательщикСсылка <> Справочники[Спр].ПустаяСсылка() Тогда
			Прервать;
		Иначе
			 ПлательщикСсылка = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат ПлательщикСсылка;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	ЗагрузитьДанныеСервер();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗагруженныеДанные;
КонецПроцедуры

&НаКлиенте
Процедура ЗагруженныеДанныеПриАктивизацииСтроки(Элемент)
	Если Элементы.ЗагруженныеДанные.ТекущиеДанные <> Неопределено Тогда
		НазначениеПлатежа = Элементы.ЗагруженныеДанные.ТекущиеДанные.НазначениеПлатежа;
		Цендент = Элементы.ЗагруженныеДанные.ТекущиеДанные.Цендент;
		Объект.НайденныеДО.Очистить();
		РезультатПоиска.Очистить();
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ОбработатьДанныеНаСервере()	
	Для Каждого стр из Объект.ЗагруженныеДанные Цикл
		ОбработатьНаСервере(стр.НазначениеПлатежа, стр.Цендент);
		Если Объект.НайденныеДО.Количество() <> 1 Тогда
			Продолжить;
		КонецЕсли;
		
		стр.ДолговоеОбязательство = Объект.НайденныеДО[0].ДолговоеОбязательство;
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ИсполнительныеДокументы.Ссылка КАК Ссылка
		                      |ИЗ
		                      |	Справочник.ИсполнительныеДокументы КАК ИсполнительныеДокументы
		                      |ГДЕ
		                      |	ИсполнительныеДокументы.Владелец = &Владелец
		                      |	И ИсполнительныеДокументы.Должник = &Должник");                            
		Запрос.УстановитьПараметр("Владелец", Объект.НайденныеДО[0].ДолговоеОбязательство);
		Запрос.УстановитьПараметр("Должник", Объект.НайденныеДО[0].Контрагент);
		Рез = Запрос.Выполнить().Выгрузить();

		Если Рез.Количество() = 1 Тогда
			стр.ИсполнительныйДокумент = Рез[0].Ссылка;
		КонецЕсли;

	КонецЦикла;
	Объект.НайденныеДО.Очистить();	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанные(Команда)
	ОбработатьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Функция НайденоОдноДО()
	ФИО = Объект.НайденныеДО.НайтиСтроки(Новый Структура("ВидПоиска", "По ФИО"));
	Если ФИО.Количество() = 1 Тогда
		Возврат ФИО[0].ДолговоеОбязательство;
	Иначе
		НомерИП = Объект.НайденныеДО.НайтиСтроки(Новый Структура("ВидПоиска", "По номеру ИП"));
		Если НомерИП.Количество() = 1 Тогда
			Возврат НомерИП[0].ДолговоеОбязательство;
		Иначе 
			Возврат Справочники.ДолговыеОбязательства.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура Необработано(Команда)
	к = 0;
	Для Каждого стр Из Объект.ЗагруженныеДанные Цикл
		Если Не ЗначениеЗаполнено(стр.ДолговоеОбязательство) Тогда
			к = к + 1;
		КонецЕсли;
	КонецЦикла;
	Сообщить("Не распознано: " + к);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДО(Команда)
	Если Элементы.РезультатПоиска.ТекущиеДанные <> Неопределено И Элементы.ЗагруженныеДанные.ТекущиеДанные <> Неопределено Тогда
		НомерСтроки = Элементы.ЗагруженныеДанные.ТекущиеДанные.НомерСтроки;
		Объект.ЗагруженныеДанные[НомерСтроки - 1].ДолговоеОбязательство = Элементы.РезультатПоиска.ТекущиеДанные.ДолговоеОбязательство;
		Объект.ЗагруженныеДанные[НомерСтроки - 1].ИсполнительныйДокумент = Элементы.РезультатПоиска.ТекущиеДанные.ИсполнительныйДокумент;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПлатежи(Команда)
	// Создаем новый док
	Форма = ПолучитьФорму("Документ.РеестрПлатежей.Форма.ФормаДокумента");
	Для Каждого стр из Объект.ЗагруженныеДанные Цикл
			Строка = Форма.Объект.ЗагруженныеДанные.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, стр);
	КонецЦикла;
	Форма.ОткрытьМодально();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	ВсеОбработано = Истина;
	Для Каждого стр Из Объект.ЗагруженныеДанные Цикл
		Если Не ЗначениеЗаполнено(стр.ДолговоеОбязательство) Тогда
			ВсеОбработано = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ВсеОбработано Тогда
		Ответ = Вопрос("Все платежи идентифицированы!", РежимДиалогаВопрос.ОК);
		Возврат;
	КонецЕсли;
	Если Элементы.ЗагруженныеДанные.ТекущиеДанные <> Неопределено Тогда
		НомерСтроки = Элементы.ЗагруженныеДанные.ТекущиеДанные.НомерСтроки;
		Для к = НомерСтроки По Объект.ЗагруженныеДанные.Количество() Цикл
			Если к = Объект.ЗагруженныеДанные.Количество() Тогда
				к = 0;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Объект.ЗагруженныеДанные[к].ДолговоеОбязательство) Тогда
				Элементы.ЗагруженныеДанные.ТекущаяСтрока = к;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ВсеОбработано = Истина;
	Для Каждого стр Из Объект.ЗагруженныеДанные Цикл
		Если Не ЗначениеЗаполнено(стр.ДолговоеОбязательство) Тогда
			ВсеОбработано = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ВсеОбработано Тогда
		Ответ = Вопрос("Все платежи идентифицированы!", РежимДиалогаВопрос.ОК);
		Возврат;
	КонецЕсли;
	
	Если Элементы.ЗагруженныеДанные.ТекущиеДанные <> Неопределено Тогда  
		НомерСтроки = Элементы.ЗагруженныеДанные.ТекущиеДанные.НомерСтроки; 	
		ДОЗаполнено = Истина;
		Пока ДОЗаполнено Цикл
			НомерСтроки = НомерСтроки - 1;
			Если НомерСтроки = 0 Тогда
				НомерСтроки = Объект.ЗагруженныеДанные.Количество();
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Объект.ЗагруженныеДанные[НомерСтроки - 1].ДолговоеОбязательство) Тогда
				ДОЗаполнено = Ложь;
			КонецЕсли;
		КонецЦикла;

		Элементы.ЗагруженныеДанные.ТекущаяСтрока = НомерСтроки - 1;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
	ЗначениеОбъект.ЗаполнитьНомераСтолбцов();
	ЗначениеВРеквизитФормы(ЗначениеОбъект, "Объект");
КонецПроцедуры

&НаСервере
Функция ИнициализировтьСловаИсключения()
	// оглы (оглу, улы, уулу)
	//кызы (гызы)
	МассивСловИсключений = Новый Массив;
	МассивСловИсключений.Добавить("Ян");
	МассивСловИсключений.Добавить("Оглы");
	МассивСловИсключений.Добавить("Кызы");
	МассивСловИсключений.Добавить("оглы");
	МассивСловИсключений.Добавить("кызы");
	МассивСловИсключений.Добавить("Оглу");
	МассивСловИсключений.Добавить("оглу");
	МассивСловИсключений.Добавить("гызы");
	МассивСловИсключений.Добавить("Гызы");
	МассивСловИсключений.Добавить("улы");
	МассивСловИсключений.Добавить("Улы");
	МассивСловИсключений.Добавить("уулу");
	МассивСловИсключений.Добавить("Уулу");
	
	Для i = 1 по МассивСловИсключений.Количество()-1 Цикл
		МассивСловИсключений.Добавить(Врег(МассивСловИсключений[i]));
	КонецЦикла;	

	Возврат МассивСловИсключений;
КонецФункции


&НаКлиенте
Процедура ЦендентПриИзменении(Элемент)
	ПроставитьЦендентаВсемПлатежам();
КонецПроцедуры

&НаСервере
Процедура ПроставитьЦендентаВсемПлатежам()
	Для Каждого стр из объект.ЗагруженныеДанные Цикл
		стр.Цендент = ?(ЗначениеЗаполнено(Объект.Цендент),Объект.Цендент,Справочники.Контрагенты.ПустаяСсылка());
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ШаблонЕЁ(ФИО,Запрос)
	ШаблонПоиска = "";
	Для ч = 1 по СтрДлина(ФИО) Цикл
		Символ = Сред(ФИО, ч, 1);
		Если Символ = "е" или Символ = "ё" Тогда
			ШаблонПоиска = ШаблонПоиска + "[её]";
		Иначе
			ШаблонПоиска = ШаблонПоиска + Символ;
		КонецЕсли;
	КонецЦикла;
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"=","ПОДОБНО");
	Запрос.УстановитьПараметр("Наименование","%"+ШаблонПоиска+"%");
	Возврат Запрос.Выполнить();		
	
КонецФункции

&НаСервере
Функция ПолнотекстовыйПоиск(Стр)
	
	
	РезультатыПоиска = ПолнотекстовыйПоиск.СоздатьСписок(Стр, 5);
	РезультатыПоиска.ПолучатьОписание = Истина;
	
	Нечеткость = 60;
	РезультатыПоиска.ПорогНечеткости = Нечеткость;
	
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.Контрагенты);
	РезультатыПоиска.ОбластьПоиска = ОбластьПоиска;
	
	Попытка
		РезультатыПоиска.ПерваяЧасть();
	Исключение
		Нечеткость = 25;
		РезультатыПоиска.ПорогНечеткости = Нечеткость;
		РезультатыПоиска.ПерваяЧасть();
	КонецПопытки;
	
	Если РезультатыПоиска.Количество() >= 1 Тогда  
		Возврат РезультатыПоиска;
	КонецЕсли;     
	
	Возврат НЕопределено;
	
		
КонецФункции 

&НаСервере
Процедура ПоискПОНомеруДО(Назначение)
	Результат = Справочники.ДолговыеОбязательства.НайтиПоНаименованию(Назначение, Истина);
	Если НЕ Результат.Пустая() Тогда
		стр = Объект.НайденныеДО.Добавить();
		стр.ДолговоеОбязательство = Результат;
		стр.Контрагент = Результат.Должник;
		стр.ВидПоиска = "По номеру ДО";
	КонецЕсли;
		
КонецПроцедуры
