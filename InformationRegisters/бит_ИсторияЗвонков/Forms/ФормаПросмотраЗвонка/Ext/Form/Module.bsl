
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДлительностьЗвонка = бит_ТелефонияКлиентСервер.ФорматироватьДлительностьЗвонкаСЛидНулями(Запись.ДлительностьЗвонка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписьРазговораНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	стрПутьКЗаписи = Запись.ЗаписьРазговора;
	Если ЗначениеЗаполнено(стрПутьКЗаписи) Тогда
		бит_БитфонКлиент.ВоспроизвестиЗаписьРазговора(стрПутьКЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСсылкуВБуферОбмена(Команда)
	
	Если НЕ ЗначениеЗаполнено(Запись.ЗаписьРазговора) Тогда
		Возврат;
	КонецЕсли;
	
	objHTML = Новый COMОбъект("htmlfile");
	objHTML.ParentWindow.ClipboardData.SetData("text", Запись.ЗаписьРазговора);
КонецПроцедуры

&НаКлиенте
Процедура СкачатьЗапись(Команда)
	
	Если НЕ ЗначениеЗаполнено(Запись.ЗаписьРазговора) Тогда
		Возврат;
	КонецЕсли;
	
	данныеЗапись = Неопределено;
	загружено = бит_ТелефонияКлиент.СкачатьПоHTTPS(Запись.ЗаписьРазговора, 900, Ложь, данныеЗапись);
	
	Если загружено Тогда
		длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		длг.ПолноеИмяФайла = бит_ТелефонияКлиент.ПолучитьИмяФайлаЗаписиСДатой(Запись.Дата) + ".mp3"; 
		длг.Фильтр = "Файл mp3 (*.mp3)|*.mp3";
		бит_ТелефонияКлиентПереопределяемый.ПоказВыборФайла(длг, "БитИсторияЗвонков_СохранениеФайлаЗаписиРазговораЗавершение", данныеЗапись);
	Иначе
		бит_ТелефонияКлиент.ВывестиСообщение("Ошибка загрузки записи разговора", ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "БитИсторияЗвонков_СохранениеФайлаЗаписиРазговораЗавершение" Тогда
		Если ЗначениеЗаполнено(Параметр.Результат) Тогда
			данныеЗапись = Параметр.ПараметрОповещения;
			имяФайла = Параметр.Результат[0];
			данныеЗапись.Записать(имяФайла);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
