
// Функция генерирует UUID по варианту 1 (на основании MAC-адреса и текущего времени)
//
// Параметры:
//  МеткаВремени  - Дата - время UTC
//  АдресСетевойКарты  - Строка - MAC-адрес сетевой карты формата "XX:XX:XX:XX:XX:XX"
//
// Возвращаемое значение:
//   Строка   - уникальный идентификатор в формате "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
//
Функция СформироватьУидПоПравиламЦБ(МеткаВремени = Неопределено, АдресСетевойКарты = Неопределено) Экспорт 
	
	УУИД = ОбъектыСервер.СформироватьUUIDver1(ТекущаяДата(), ПолучитьMACАдрес());
	UIDНБКИ = УУИД + "-" + ОбъектыСервер.СгенерироватьКонтрольныйСимвол(УУИД);
	Возврат UIDНБКИ;
	
КонецФункции // СформироватьUUIDver1()

Функция ПолучитьMACАдрес() Экспорт  

	WinMGMT = "";
	Win32_NetworkAdapterConfiguration ="";
	NetworkAdapterConfiguration = "";
	MAC_IP = "";
	MACAddress = "";
	IPAddress = "";
	Computer = ".";
	
	MAC_IP = Новый ТаблицаЗначений;
	MAC_IP.Колонки.Добавить("MAC");
	MAC_IP.Колонки.Добавить("IP");
	
	Попытка
		WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
		Win32_NetworkAdapterConfiguration = WinMGMT.ExecQuery("SELECT * From Win32_NetworkAdapterConfiguration Where IPEnabled = True");
		Для Каждого NetworkAdapterConfiguration ИЗ Win32_NetworkAdapterConfiguration Цикл
			MACAddress = NetworkAdapterConfiguration.MACAddress;
			
			NetworkAdapterConfigurationInfo = MAC_IP.Добавить();
			NetworkAdapterConfigurationInfo.MAC = MACAddress;
			
			Если ЗначениеЗаполнено(MACAddress) Тогда
				Для Каждого IPAddress ИЗ NetworkAdapterConfiguration.IPAddress Цикл
					Если ЗначениеЗаполнено(IPAddress) Тогда
						NetworkAdapterConfigurationInfo.IP = IPAddress;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	Возврат MAC_IP[0].MAC;
	
КонецФункции