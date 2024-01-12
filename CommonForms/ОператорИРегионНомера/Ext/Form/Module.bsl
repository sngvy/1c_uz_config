
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	Определитель = "https://www.kody.su/check-tel";  
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросОпределитель()
	Если ЗначениеЗаполнено(ЭтаФорма.Номер) = Истина Тогда
		document = ЭтаФорма.Элементы.Определитель.Документ;
		number = document.querySelector(".imp:nth-child(1)");
		number.value = ЭтаФорма.Номер;
		searchbutton = document.querySelector(".imp:nth-child(3)");
		searchbutton.click();
		ПодключитьОбработчикОжидания("ПолучитьОператораИРегион", 1, Истина);
	Иначе
		Предупреждение("Не заполнен номер телефона!",,"Определение оператора и региона");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОператораИРегион()
	document = ЭтаФорма.Элементы.Определитель.Документ;
	operatorregion = document.querySelector("strong:nth-child(2)").firstChild.nodeValue;
	ЭтаФорма.ОператорИРегион = СтрЗаменить(operatorregion, ",", "");
	time = document.querySelector("#time").firstChild.nodeValue;
	ЭтаФорма.ВремяВРегионе = time;
	mnp = document.querySelector("p > b").firstChild.nodeValue;
	ЭтаФорма.ПеренесенКДругомуОператору = mnp;
КонецПроцедуры

