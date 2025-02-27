﻿//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПодключитьОповещенияОНовыхЭлектронныхДокументах(Включить = Истина, ДоступноОповещениеОСобытиях = Неопределено) Экспорт
	
	Если Включить Тогда
		ПодключитьОбработчикОповещенияОНовыхДокументах(ДоступноОповещениеОСобытиях);
	Иначе
		ОтключитьОбработчикОповещенияОНовыхДокументах();
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие новых электронных документов в сервисе 1С-ЭДО и выводит сообщение пользователю.
Процедура ПроверитьНаличиеНовыхЭлектронныхДокументовВСервисе1СЭДО() Экспорт
	
	ЕстьСобытияЭДО = ОповещенияОСобытияхЭДОВызовСервера.ЕстьСобытияЭДО();
	
	Если ЕстьСобытияЭДО Тогда
		
		ОповеститьОНовыхДокументахЭДО();
		
	КонецЕсли;
	
	ПодключитьОбработчикОжидания(ОбработчикОповещенияОНовыхДокументах(), 60, Истина);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

// См. СинхронизацияЭДОКлиент.ПослеНачалаРаботыСистемы
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ДоступноОповещениеОСобытиях = Неопределено;
	ОповещенияОСобытияхЭДОВызовСервера.ПослеНачалаРаботыСистемы(ДоступноОповещениеОСобытиях);
	ПодключитьОбработчикДействияЧерезСистемуВзаимодействия();
	
	#Если Не МобильныйКлиент Тогда
		ПодключитьОповещенияОНовыхЭлектронныхДокументах(Истина, ДоступноОповещениеОСобытиях);
	#КонецЕсли
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодключитьОбработчикОповещенияОНовыхДокументах(ДоступноОповещениеОСобытиях = Неопределено)
	
	Если ДоступноОповещениеОСобытиях = Неопределено Тогда
		ДоступноОповещениеОСобытиях = ОповещенияОСобытияхЭДОВызовСервера.ДоступноОповещениеОСобытияхЭДО();
	КонецЕсли;
	
	Если Не ДоступноОповещениеОСобытиях Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания(ОбработчикОповещенияОНовыхДокументах(), 15, Истина);
	
КонецПроцедуры

Процедура ОтключитьОбработчикОповещенияОНовыхДокументах()
	
	ОтключитьОбработчикОжидания(ОбработчикОповещенияОНовыхДокументах());
	
КонецПроцедуры

Функция ОбработчикОповещенияОНовыхДокументах()
	
	Возврат "ПроверитьНаличиеНовыхЭлектронныхДокументов";
	
КонецФункции

Процедура ПриНажатииНаОповещениеОНовыхДокументах(ДополнительныеПараметры) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОткрытьТекущиеДелаЭДО();
	
КонецПроцедуры

Процедура ПодключитьОбработчикДействияЧерезСистемуВзаимодействия()
	
	Если Не СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПриНажатииГиперссылкуВСообщенииБотаЭДО", ЭтотОбъект);
	СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Оповещение);
	
КонецПроцедуры

Процедура ПриНажатииГиперссылкуВСообщенииБотаЭДО(Сообщение, Действие, ДополнительныеПараметры) Экспорт
	
	Если Действие = "СинхронизироватьЭДО" Тогда
		Оповестить("ВыполнитьСинхронизацию");
	ИначеЕсли Действие = "ПодписатьЭД" Или Действие = "ОтклоненАннулированЭД" Тогда
		Если ТипЗнч(Сообщение.Данные) <> Тип("Структура") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Неверный формат данных сообщения чата'"));
			Возврат; 
		КонецЕсли;
		
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументСообщенияЭДО(Сообщение.Данные.ЭлектронныйДокумент);
			
	ИначеЕсли Действие = "ОткрытьЭД" Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Сообщение.Данные);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОНовыхДокументахЭДО()
	
	ДействиеПриНажатии = Новый ОписаниеОповещения("ПриНажатииНаОповещениеОНовыхДокументах", ЭтотОбъект);
		ЗаголовокОповещения = НСтр("ru ='Сервис 1С-ЭДО'");
		ТекстОповещения = НСтр("ru = 'Доступны к получению новые документы'");
		
	ПоказатьОповещениеПользователя(ЗаголовокОповещения,
		ДействиеПриНажатии,
		ТекстОповещения,
		БиблиотекаКартинок.ЭмблемаСервиса1СЭДО,
		СтатусОповещенияПользователя.Важное, 
		"ОповещениеОНовыхДокументахЭДО");
	
КонецПроцедуры

#КонецОбласти