﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Пользователь = БИТфонСервер.ПолучитьТекущегоПользователя();
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
КонецПроцедуры
