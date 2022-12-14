
Функция ПроверитьНаличиеПросроченныхЗадач() Экспорт
	Набор = РегистрыСведений.НапоминанияПользователя.СоздатьМенеджерЗаписи();
	Набор.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	Набор.Прочитать();
	
	Если Набор.ДатаСледующегоНапоминания > ТекущаяДата() Тогда
		Возврат Ложь;
	КонецЕсли;
	
    Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
                          |	ЗадачаМероприятие.Ссылка
                          |ИЗ
                          |	Задача.Мероприятие КАК ЗадачаМероприятие
                          |ГДЕ
                          |	НЕ ЗадачаМероприятие.Выполнена
                          |	И ЗадачаМероприятие.Ответственный = &Ответственный
                          |	И НЕ ЗадачаМероприятие.ПометкаУдаления
                          |	И (ЗадачаМероприятие.БизнесПроцесс = ЗНАЧЕНИЕ(БизнесПроцесс.БизнесПроцессы.ПустаяСсылка)
                          |			ИЛИ НЕ ЗадачаМероприятие.БизнесПроцесс.ПометкаУдаления)
                          |	И ДОБАВИТЬКДАТЕ(ЗадачаМероприятие.ПланируемаяДата, СЕКУНДА, РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), ЗадачаМероприятие.ПланируемоеВремя, СЕКУНДА)) <= &ТекущаяДата");
	Запрос.УстановитьПараметр("Ответственный", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Функция НапоминатьМероприятия() Экспорт
	Возврат Константы.НапоминатьМероприятия.Получить();	
КонецФункции

Функция НапоминатьСообщения() Экспорт
	Возврат Константы.НапоминатьСообщения.Получить()
КонецФункции

Функция ПроверитьНаличиеНеПрочитанныхСообщений() Экспорт	
	НаборЗаписей = РегистрыСведений.СообщенияКПросмотру.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ответственный.Установить(ПараметрыСеанса.ТекущийПользователь); 
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции
