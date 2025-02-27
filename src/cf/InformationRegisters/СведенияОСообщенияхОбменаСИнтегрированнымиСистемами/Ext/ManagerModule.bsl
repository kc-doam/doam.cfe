﻿// Записывает сведения о сообщении обмена с интегрированной системой
// Параметры:
//	Сообщение - ссылка на СообщениеИнтегрированныхСистем
//	РазмерСообщения - размер сообщения в байтах
//	КоличествоДанных - количество объектов данных, помещенных в сообщение
Процедура ЗаписатьСведения(Сообщение, РазмерСообщения, КоличествоДанных) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.РазмерСообщения = РазмерСообщения;
	Запись.КоличествоДанных = КоличествоДанных;
	Запись.Записать();
	
КонецПроцедуры

// Записывает время формирования сообщения обмена с интегрированной системой
// Параметры:
//	Сообщение - ссылка на СообщениеИнтегрированныхСистем
//	ВремяФормирования - время формирования в секундах
Процедура ЗаписатьВремяФормирования(Сообщение, ВремяФормирования) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.ВремяФормирования = ВремяФормирования;
	Запись.Записать();
	
КонецПроцедуры

// Записывает время подготовки сообщения обмена с интегрированной системой
// Параметры:
//	Сообщение - ссылка на СообщениеИнтегрированныхСистем
//	ВремяПодготовки - время формирования в секундах
Процедура ЗаписатьВремяПодготовки(Сообщение, ВремяПодготовки) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.ВремяПодготовки = ВремяПодготовки;
	Запись.Записать();
	
КонецПроцедуры

// Записывает дату окончания передачи сообщения интегрированной системе
// Параметры:
//	Сообщение - ссылка на СообщениеИнтегрированныхСистем
//	ДатаПередачиКлиенту - дата окончания передачи сообщения клиенту
Процедура ЗаписатьДатуПередачиКлиенту(Сообщение, ДатаПередачиКлиенту) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.ДатаПередачиКлиенту = ДатаПередачиКлиенту;
	Запись.Записать();
	
КонецПроцедуры

Процедура ЗаписатьНеобходимостьОтвета(Сообщение, НеобходимОтвет) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.НеобходимоПодготовитьОтвет = НеобходимОтвет;
	Запись.Записать();
	
КонецПроцедуры

Процедура ЗаписатьРазмер(Сообщение, Размер) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Запись.Сообщение = Сообщение;
	Запись.РазмерСообщения = Размер;
	Запись.Записать();
	
КонецПроцедуры

// Возвращает все сведения о сообщении
// Параметры:
//	Сообщение - ссылка на СообщениеИнтегрированныхСистем
Функция ПолучитьСведения(Сообщение) Экспорт
	
	Запись = РегистрыСведений.СведенияОСообщенияхОбменаСИнтегрированнымиСистемами.СоздатьМенеджерЗаписи();
	Запись.Сообщение = Сообщение;
	Запись.Прочитать();
	Если Не Запись.Выбран() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РазмерСообщения", Запись.РазмерСообщения);
	Результат.Вставить("КоличествоДанных", Запись.КоличествоДанных);
	Результат.Вставить("ДатаПередачиКлиенту", Запись.ДатаПередачиКлиенту);
	Результат.Вставить("ДатаФормирования", Запись.ДатаФормирования);
	Результат.Вставить("ВремяПодготовки", Запись.ВремяПодготовки);
	Результат.Вставить("НеобходимоПодготовитьОтвет", Запись.НеобходимоПодготовитьОтвет);
	Возврат Результат;
	
КонецФункции