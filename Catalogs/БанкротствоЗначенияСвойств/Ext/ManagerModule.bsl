﻿Процедура ЗагрузитьИзМакетаЭлемены() Экспорт
	ТабДок = ПолучитьМакет("МакетБЗС");	
	ПЗ = Новый ПостроительЗапроса;	
	ПЗ.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабДок.Область());	
	ПЗ.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;	
	ПЗ.ЗаполнитьНастройки();
	ПЗ.Выполнить();	
	ТЗ = ПЗ.Результат.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ.Наименование КАК Наименование,
		|	ТЗ.ИсходноеНаименование КАК ИсходноеНаименование,
		|	ТЗ.ВладелецПолныйПутьКДанным КАК ВладелецПолныйПутьКДанным
		|ПОМЕСТИТЬ ВТ_ТЗ
		|ИЗ
		|	&ТЗ КАК ТЗ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЗ.Наименование КАК ТЗНаименование,
		|	ВТ_ТЗ.ИсходноеНаименование КАК ТЗИсходноеНаименование,
		|	ВТ_ТЗ.ВладелецПолныйПутьКДанным КАК ТЗВладелецПолныйПутьКДанным,
		|	БанкротствоЗначенияСвойств.Ссылка КАК СпрСсылка,
		|	БанкротствоЗначенияСвойств.Наименование КАК СпрНаименование
		|ИЗ
		|	ВТ_ТЗ КАК ВТ_ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БанкротствоЗначенияСвойств КАК БанкротствоЗначенияСвойств
		|		ПО ВТ_ТЗ.ВладелецПолныйПутьКДанным = БанкротствоЗначенияСвойств.Владелец.ПолныйПутьКДанным
		|			И ВТ_ТЗ.ИсходноеНаименование = БанкротствоЗначенияСвойств.ИсходноеНаименование
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ТЗ.Наименование,
		|	ВТ_ТЗ.ИсходноеНаименование,
		|	БанкротствоЗначенияСвойств.Ссылка,
		|	БанкротствоЗначенияСвойств.Наименование,
		|	ВТ_ТЗ.ВладелецПолныйПутьКДанным";
	Запрос.УстановитьПараметр("ТЗ",ТЗ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.СпрСсылка) И Выборка.ТЗНаименование <> Выборка.СпрНаименование Тогда
			Спр = Выборка.СпрСсылка.ПолучитьОбъект();
			Спр.Наименование = Выборка.ТЗНаименование;
			Спр.Записать(); 
		ИначеЕсли НЕ ЗначениеЗаполнено(Выборка.СпрСсылка) Тогда
			Спр = Справочники.БанкротствоЗначенияСвойств.СоздатьЭлемент();
			Спр.Наименование = Выборка.ТЗНаименование;
			Спр.ИсходноеНаименование = Выборка.ТЗИсходноеНаименование;
			Спр.Владелец = Справочники.БанкротствоИерархияСвойств.НайтиПоРеквизиту("ПолныйПутьКДанным",Выборка.ТЗВладелецПолныйПутьКДанным);	
			Спр.Записать();
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры // ЗагрузитьИзМакетаЭлемены()
