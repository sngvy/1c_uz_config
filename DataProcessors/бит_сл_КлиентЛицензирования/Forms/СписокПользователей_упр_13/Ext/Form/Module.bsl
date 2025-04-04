﻿
&НаКлиенте
// Для всех строк устанавливает флажки в заданное значение
//
Процедура УстановитьФлажки(Значение)

	Для Каждого СтрокаСписка Из Объект.СписокПользователей Цикл
	
		СтрокаСписка.Исключить = Значение;	
	
	КонецЦикла; 	

КонецПроцедуры // УстановитьФлажки() 

&НаКлиенте
// Определяет, находится ли пользователь в списке исключения
//
Функция ПользовательЕстьВСпискеИсключения(ИДПользователя)

	Возврат Найти(ЭтаФорма.ВладелецФормы.Объект.общ_СписокИсключения, ИДПользователя) > 0;	

КонецФункции // ПользовательЕстьВСпискеИсключения() 

//////////////////////////////////////////////// ОБРАБОТЧИКИ //

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Объект.СписокПользователей.Очистить();
	
	// Получим список пользователей ИБ
	ТекущиеПользователиИБ = Новый Массив;
	Результат = бит_сл_сервер.ПолучитьСписокПользователей(ТекущиеПользователиИБ);
	
	Если Не Результат Тогда
	
		Предупреждение("У вас недостаточно прав для доступа к списку пользователей информационной базы!");
		Отказ = Истина;
	
	КонецЕсли; 
	
	Если Не Отказ Тогда
		
		// Заполним таблицу списка пользователей
		Для Каждого ПользовательИБ Из ТекущиеПользователиИБ Цикл
			
			Строка = Объект.СписокПользователей.Добавить();
			Строка.ПользовательИБ = ПользовательИБ.ПолноеИмя;
			Строка.Идентификатор = ПользовательИБ.УникальныйИдентификатор;
			Строка.Исключить = ПользовательЕстьВСпискеИсключения(ПользовательИБ.УникальныйИдентификатор);
			
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеСтроки(Команда)

	УстановитьФлажки(Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеСтроки(Команда)

	УстановитьФлажки(Ложь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)

	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)

	// Сформируем список исключения на основе таблицы списка пользователей и запишем его
	СтрокаСРазделителями = "";
	Для Каждого СтрокаСписка Из Объект.СписокПользователей Цикл
	
		Если СтрокаСписка.Исключить Тогда
			
			СтрокаСРазделителями = СтрокаСРазделителями + СтрокаСписка.Идентификатор + Символы.ПС;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// Сохраняем в объект владельца новое значение 
	// (у этой формы объект является новым экземпляром обработки и не содержит связи с данными)
	ЭтаФорма.ВладелецФормы.Объект.общ_СписокИсключения = СтрокаСРазделителями;
	
	ЭтаФорма.Закрыть(Истина);	
	
КонецПроцедуры

