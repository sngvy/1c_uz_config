﻿
&НаСервере
Процедура ПриОткрытииНаСервере(Отказ)
	ЭтаФорма.РольАБД = РольДоступна("АБД");
	ЭтаФорма.РольРКЦ = РольДоступна("РКЦ");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Получить непредопредленное значение с сервера
	ПриОткрытииНаСервере(Отказ);
	// Проверить права доступа
	Если ЭтаФорма.РольАБД = Ложь И ЭтаФорма.РольРКЦ = Ложь Тогда
		Предупреждение("Нарушение прав доступа",,"Предупреждение");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДолжникМероприятия(Команда)
	// Передать с ключом
	Если ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Список И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		К = Элементы.Список.ТекущиеДанные.Договор;
		ФормаМероприятия = ПолучитьФорму("Задача.Мероприятие.Форма.ФормаСписка",,,Новый УникальныйИдентификатор());
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ФормаМероприятия.Список, "Объект", К, ВидСравненияКомпоновкиДанных.Равно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный, );
		ФормаМероприятия.КоманднаяПанель.Видимость = Ложь;
		ФормаМероприятия.Открыть();
	Иначе
		Предупреждение("Не найден объект отбора!",,"Все мероприятия");
	КонецЕсли;
КонецПроцедуры
