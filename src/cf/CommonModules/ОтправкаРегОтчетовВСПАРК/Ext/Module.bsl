﻿#Область ПрограммныйИнтерфейс

Процедура ИзменитьОформлениеЭлементовСПАРКВОтчете(Форма) Экспорт
	
	Отчет    = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СсылкаНаОтчетПоФорме(Форма);
	Элементы = Форма.Элементы;
	
	Если НЕ ЗначениеЗаполнено(Отчет)
		ИЛИ НЕ ЭтоНужныйВидОтчетаСПАРК(Отчет) Тогда
		
		Если Элементы.Найти("ПанельОтправкиВСПАРК") <> Неопределено Тогда
			Элементы.ПанельОтправкиВСПАРК.Видимость = Ложь;
		КонецЕсли;
		
		Если Элементы.Найти("ФормаОтправитьВСПАРКИзОтчета") <> Неопределено Тогда
			Элементы.ФормаОтправитьВСПАРКИзОтчета.Видимость = Ложь;
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Свойства = СвойстваОтчетаСПАРК(Отчет);
	
	НеобходимоОтправитьНеотправленный = ПроверитьНеобходимостьОтправитьВСПАРКПоСсылке(Отчет);
	Элементы.ПанельОтправкиВСПАРК.Видимость = 
		НеобходимоОтправитьНеотправленный 
		И Свойства.КоличествоНеудачныхПопыток >= ОтправкаРегОтчетовВСПАРКВызовСервера.КоличествоНеудачныхПопыток();
	
	НеобходимоОтправитьЗапрещенный = ПроверитьНеобходимостьОтправитьВСПАРКПоСсылке(Отчет, Истина);
	Элементы.ФормаОтправитьВСПАРКИзОтчета.Видимость = НеобходимоОтправитьЗапрещенный;
	
	Организация = ДокументооборотСКОКлиентСервер.ПолучитьОрганизациюПоФорме(Форма);

	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Отчет, Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтправкаОтчетовВСПАРКВФоне(ВходящийКонтекст, АдресРезультата) Экспорт
	
	ОтчетыКОтправке   = ВходящийКонтекст.Отчеты;
	РежимТестирования = ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования();
	
	РезультатОтправки = Новый Массив;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Выполнено", 		  Ложь);
	ДополнительныеПараметры.Вставить("РезультатОтправки", РезультатОтправки);
	ДополнительныеПараметры.Вставить("ОписаниеОшибки", 	  "");
	
	Для каждого Отчет Из ОтчетыКОтправке Цикл
		
		РезультатОтправкиОдного = ОтправитьОтчетВСПАРКиЗаписатьСтатус(Отчет, РежимТестирования);
		РезультатОтправки.Добавить(РезультатОтправкиОдного);
		
	КонецЦикла;
		
	ДополнительныеПараметры.Выполнено = Истина;
	ПоместитьВоВременноеХранилище(ДополнительныеПараметры, АдресРезультата);
	
КонецПроцедуры

Функция ОтправитьОтчетВСПАРКиЗаписатьСтатус(СсылкаНаОтчет, РежимТестирования = Ложь) Экспорт
	
	Результат = ОтправитьВСПАРК(СсылкаНаОтчет, РежимТестирования);
	
	Если Результат.Выполнено Тогда
		
		ЗаписатьОтчетСПАРКВРегистр(
			СсылкаНаОтчет, 
			Перечисления.СтатусыОтправкиВСПАРК.ОтправленУспешно);
			
	Иначе
			
		ЗаписатьОтчетСПАРКВРегистр(
			СсылкаНаОтчет, 
			Перечисления.СтатусыОтправкиВСПАРК.ВозниклаОшибка, 
			Результат.ОписаниеОшибки);
			
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ИсточникиОтчетов() Экспорт
	
	Источники = Новый Массив;
	Источники.Добавить("РегламентированныйОтчетБухОтчетность");
	Источники.Добавить("РегламентированныйОтчетБухОтчетностьМП");
	
	Возврат Источники;
	
КонецФункции

Функция ЭтоНужныйВидОтчетаСПАРК(СсылкаНаОтчет) Экспорт
	
	Источники = ИсточникиОтчетов();
	
	ЭтоОтчет = ТипЗнч(СсылкаНаОтчет) = Тип("ДокументСсылка.РегламентированныйОтчет") 
		И Источники.Найти(СсылкаНаОтчет.ИсточникОтчета) <> Неопределено;
		
	ЭтоЭлПредставление = ТипЗнч(СсылкаНаОтчет) = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов")
		И Источники.Найти(СсылкаНаОтчет.ВидОтчета.Источник) <> Неопределено;
	
	Если ЭтоОтчет ИЛИ ЭтоЭлПредставление Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция НаименованияНужныхОтчетовСПАРК() Экспорт
	
	Наименования = Новый Массив;
	Наименования.Добавить(НСтр("ru = 'Бухгалтерская отчетность упрощенная'"));
	Наименования.Добавить(НСтр("ru = 'Бухгалтерская отчетность (с 2011 года)'"));
	
	Возврат Наименования;
	
КонецФункции

Функция МотивацияСПАРК() Экспорт
	
	Строка1 = НСтр("ru = 'Опубликуйте свою бухгалтерскую отчетность в крупнейшей информационной системе '"); 
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'СПАРК'"),,,,"http://www.spark-interfax.ru/");
	Строка2 = НСтр("ru = '.Наличие бухгалтерской отчетности компании в СПАРК может оказаться решающим фактором при оценке вас другими участниками рынка как клиента. Своевременная публикация отчетности является одним из необходимых условий для повышения шансов на одобрение вам кредита банком и возможное снижение ставки. По оценке Deloitte, 74,5% крупных и средних российских компаний используют СПАРК для проверки партнеров и заемщиков.'");
	
	Возврат Новый ФорматированнаяСтрока(Строка1, Ссылка, Строка2);
	
КонецФункции

Функция СвойстваОтчетаСПАРК(СсылкаНаОтчет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОтчетыПереданныеВСПАРК.Организация КАК Организация,
		|	ОтчетыПереданныеВСПАРК.Отчет КАК Отчет,
		|	ОтчетыПереданныеВСПАРК.СтатусОтправки КАК СтатусОтправки,
		|	ОтчетыПереданныеВСПАРК.ОписаниеОшибки КАК ОписаниеОшибки,
		|	ОтчетыПереданныеВСПАРК.КоличествоНеудачныхПопыток КАК КоличествоНеудачныхПопыток,
		|	ОтчетыПереданныеВСПАРК.ДатаДобавления КАК ДатаДобавления,
		|	ОтчетыПереданныеВСПАРК.ДатаПоследнейОтправки КАК ДатаПоследнейОтправки
		|ИЗ
		|	РегистрСведений.ОтчетыПереданныеВСПАРК КАК ОтчетыПереданныеВСПАРК
		|ГДЕ
		|	ОтчетыПереданныеВСПАРК.Отчет = &Отчет";
	
	Запрос.УстановитьПараметр("Отчет", СсылкаНаОтчет);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ЗаписатьОтчетСПАРКВРегистр(
		СсылкаНаОтчет, 
		СтатусОтправки, 
		ОписаниеОшибки = "") Экспорт
	
	НачатьТранзакцию();
	
	Попытка
	
		НаборЗаписей = РегистрыСведений.ОтчетыПереданныеВСПАРК.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(СсылкаНаОтчет.Организация);
		НаборЗаписей.Отбор.Отчет.Установить(СсылкаНаОтчет);
		НаборЗаписей.Прочитать();
		
		Если СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.ОтправкаРазрешена Тогда
			
			ДопПараметры = Новый Структура();
			ДопПараметры.Вставить("Организация", СсылкаНаОтчет.Организация);
			ДопПараметры.Вставить("Отчет", СсылкаНаОтчет);
			ДопПараметры.Вставить("СтатусОтправки", Перечисления.СтатусыОтправкиВСПАРК.ОтправкаРазрешена);
			ДопПараметры.Вставить("ДатаДобавления", ТекущаяДатаСеанса());
			ДопПараметры.Вставить("ДатаПоследнейОтправки", Неопределено);
			ДопПараметры.Вставить("ОписаниеОшибки", "");
			ДопПараметры.Вставить("КоличествоНеудачныхПопыток", 0);
			
			Если НаборЗаписей.Количество() = 0 Тогда
				
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, ДопПараметры);
				
			Иначе
				
				Для каждого Запись Из НаборЗаписей Цикл
					ЗаполнитьЗначенияСвойств(Запись, ДопПараметры);
				КонецЦикла;
			
			КонецЕсли;
			
		ИначеЕсли СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.ВозниклаОшибка Тогда
			
			Для каждого Запись Из НаборЗаписей Цикл
				
				Запись.ОписаниеОшибки = ОписаниеОшибки;
				Запись.КоличествоНеудачныхПопыток = Запись.КоличествоНеудачныхПопыток + 1;
				Запись.СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.ВозниклаОшибка;
				Запись.ДатаПоследнейОтправки = ТекущаяДатаСеанса();
				
				Если Запись.КоличествоНеудачныхПопыток = ОтправкаРегОтчетовВСПАРКВызовСервера.КоличествоНеудачныхПопыток() Тогда
					ОтправкаРегОтчетовВСПАРКВызовСервера.ЗаписатьСтатистикуОтправкиБухОтчетностиВСПАРК("ПревышеноПопыток");
				КонецЕсли;
				
			КонецЦикла;
			
		ИначеЕсли СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.ОтправленУспешно Тогда
		
			Для каждого Запись Из НаборЗаписей Цикл
				
				Запись.СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.ОтправленУспешно;
				Запись.ОписаниеОшибки = "";
				Запись.ДатаПоследнейОтправки = ТекущаяДатаСеанса();
				
			КонецЦикла;

		ИначеЕсли СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.БольшеНеНапоминать Тогда
		
			Для каждого Запись Из НаборЗаписей Цикл
				
				Запись.СтатусОтправки = Перечисления.СтатусыОтправкиВСПАРК.БольшеНеНапоминать;
				
			КонецЦикла;
			
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами. Установить состояние подключения к ПФР'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
	КонецПопытки;
	
КонецПроцедуры

Функция ОтправитьВСПАРК(СсылкаНаОтчет, РежимТестирования = Ложь) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено", Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("Отчет", СсылкаНаОтчет);

	Попытка
	
		Сервис = СоздатьПодключениеКСПАРК();
		
		Если Сервис = Неопределено Тогда
			Результат.Вставить("ОписаниеОшибки", "Не удалось подключиться к сервису");
			Возврат Результат;
		КонецЕсли;
		
		ЦиклОбмена  = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(СсылкаНаОтчет);
		Если НЕ ЗначениеЗаполнено(ЦиклОбмена) Тогда
			Результат.Вставить("ОписаниеОшибки", "Не найден последний цикл обмена");
			Возврат Результат;
		КонецЕсли;
		
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		
		ЦиклыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЦиклОбмена);
		Выгрузка    = КонтекстЭДОСервер.ПолучитьВыгружаемыеПакетыПоДокументооборотамСдачиОтчетностиВФНС(ЦиклыОбмена, Новый УникальныйИдентификатор);
		Выгрузка    = Выгрузка[ЦиклОбмена];
		
		Если ТипЗнч(Выгрузка) = Тип("Строка") Тогда
			Результат.Вставить("ОписаниеОшибки", Выгрузка);
			Возврат Результат;
		КонецЕсли;
			
		Данные = Base64Строка(ПолучитьИзВременногоХранилища(Выгрузка.Адрес));
		
		Попытка
			XDTOРезультат = Сервис.SendAccountingReport(Данные, Выгрузка.ИмяФайла);
		Исключение
			ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		// Для тестирования, т.к. по тестовым отчетам всегда приходит Ложь
		Если РежимТестирования Тогда
			XDTOРезультат = "true";
		КонецЕсли;
		
		Если XDTOРезультат = "true" Тогда
			
			Результат.Вставить("Выполнено", Истина);
			
		ИначеЕсли Лев(XDTOРезультат, 5) = "error" Тогда
			
			ОписаниеОшибки = Сред(XDTOРезультат, 7);
			
			Если НЕ ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				ОписаниеОшибки = НСтр("ru = 'Произошла внутренняя ошибка сервиса СПАРК'");
			КонецЕсли;
			
			Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
			
		КонецЕсли;
	
	Исключение
		
		ИмяСобытия = НСтр("ru = 'Электронный документооборот с контролирующими органами. СПАРК'",
			ОбщегоНазначения.КодОсновногоЯзыка());
			
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытия ,
			УровеньЖурналаРегистрации.Ошибка,,,
			Комментарий);
			
		Результат.Вставить("ОписаниеОшибки", Комментарий);
	
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Функция СоздатьПодключениеКСПАРК() Экспорт
	
	Попытка
		
		ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
		ПараметрыПодключения.АдресWSDL 				= "https://1cservice.spark-interfax.ru/AccountingReportLoadService.asmx?WSDL";
		ПараметрыПодключения.URIПространстваИмен 	= "urn://spark-interfax.ru/1cservice";
		ПараметрыПодключения.ИмяСервиса 			= "AccountingReportLoadService";
		ПараметрыПодключения.ИмяТочкиПодключения 	= "AccountingReportLoadServiceSoap";
		ПараметрыПодключения.ИмяПользователя 		= "";
		ПараметрыПодключения.Пароль 				= "";
		ПараметрыПодключения.Таймаут 				= 200;
		
		Сервис = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		
		Возврат Сервис;
	Исключение
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПроверитьНеобходимостьОтправитьВСПАРКПоСсылке(СсылкаНаОтчет, Вручную = Ложь) Экспорт
	
	ЦиклОбмена = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(СсылкаНаОтчет);

	Если НЕ ЗначениеЗаполнено(ЦиклОбмена) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	СообщенияЦикла = КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(ЦиклОбмена,,Ложь,Истина);
	
	Отбор = Новый Структура();
	Отбор.Вставить("Тип", Перечисления.ТипыТранспортныхСообщений.РезультатОбработкиДекларацияНО);// Сдано, требует уточнения ИЛИ Сдано
	
	ТранспортныеСообщения = СообщенияЦикла.НайтиСтроки(Отбор);
	ТранспортноеСообщение = КонтекстЭДОСервер.СсылкаНаСообщение(ТранспортныеСообщения);
	
	Возврат ПроверитьНеобходимостьОтправитьВСПАРКПоТранспортномуСообщению(ТранспортноеСообщение, Вручную);
	
КонецФункции

Функция ПроверитьНеобходимостьОтправитьВСПАРКПоТранспортномуСообщению(ТранспортноеСообщение, Вручную = Ложь) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Если НЕ КонтекстЭДОСервер.СообщениеРасшифровано(ТранспортноеСообщение) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтоРезультатОбработки = ТранспортноеСообщение.Тип = Перечисления.ТипыТранспортныхСообщений.РезультатОбработкиДекларацияНО;
	УказанПредмет = ЗначениеЗаполнено(ТранспортноеСообщение.ЦиклОбмена) 
				И ЗначениеЗаполнено(ТранспортноеСообщение.ЦиклОбмена.Предмет);
		
	Если ЭтоРезультатОбработки И УказанПредмет Тогда
		
		СсылкаНаОтчет      = ТранспортноеСообщение.ЦиклОбмена.Предмет;
		ЭтоНужныйВидОтчета = ЭтоНужныйВидОтчетаСПАРК(СсылканаОтчет);
		
		Свойства = СвойстваОтчетаСПАРК(СсылкаНаОтчет);
		Если Свойства = Неопределено Тогда
			Статус = Неопределено;
		Иначе
			Статус = Свойства.СтатусОтправки;
		КонецЕсли;
		
		ОтправкаРазрешена = 
			Статус = Перечисления.СтатусыОтправкиВСПАРК.ОтправкаРазрешена
			ИЛИ Статус = Перечисления.СтатусыОтправкиВСПАРК.ВозниклаОшибка;
			
		ОтправкаЗапрещена = НЕ ЗначениеЗаполнено(Статус)
			ИЛИ Статус = Перечисления.СтатусыОтправкиВСПАРК.БольшеНеНапоминать;
		
		НеобходимоОтправить = ОтправкаРазрешена И НЕ Вручную ИЛИ Вручную И ОтправкаЗапрещена;
		
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		
		Состояние = КонтекстЭДОСервер.ТекущееСостояниеОтправки(СсылкаНаОтчет).ТекущийЭтапОтправки.СостояниеСдачиОтчетности;
		ОтчетСдан = Состояние = Перечисления.СостояниеСдачиОтчетности.ПоложительныйРезультатДокументооборота;
		
		Возврат ЭтоНужныйВидОтчета
			И НеобходимоОтправить
			И ОтчетСдан;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ПодтверждениеОтправкиОтчета_ИзменитьОформлениеФормы(Форма, СсылкаНаОтчет) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	СведенияОбОтчете  = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(СсылкаНаОтчет);
	
	ПодтверждениеОтправкиОтчета_УстановитьНаименованиеОтчета(Форма, СведенияОбОтчете);
	ПодтверждениеОтправкиОтчета_УстановитьДатуИПериод(Форма, СведенияОбОтчете);
	ПодтверждениеОтправкиОтчета_ПодтверждениеОтправкиОтчета_УстановитьОрганизацию(Форма, СведенияОбОтчете);
	ПодтверждениеОтправкиОтчета_УстановитьОрган(Форма, СведенияОбОтчете);
	
КонецПроцедуры

Процедура ПодтверждениеОтправкиОтчета_УстановитьНаименованиеОтчета(Форма, СведенияОбОтчете)

	Элементы = Форма.Элементы;
	
	ВариантОтчета = Строка(СведенияОбОтчете.ВариантОтчета);
	Если ВариантОтчета = "П" Тогда
		ВариантОтчета = НСтр("ru = 'первичный'");
	ИначеЕсли Лев(ВариантОтчета, 2) = "К/" Тогда
		ВариантОтчета = НСтр("ru = 'корректирующий'") + " / " + Сред(ВариантОтчета, 3);
	КонецЕсли;
	
	ЛеваяСкобка 	= ?(НЕ ПустаяСтрока(ВариантОтчета), " (", "");
	ПраваяСкобка 	= ?(НЕ ПустаяСтрока(ВариантОтчета), ")", "");
	
	Элементы.НаименованиеИВариантОтчета.Заголовок = Строка(СведенияОбОтчете.Наименование) + ЛеваяСкобка + ВариантОтчета + ПраваяСкобка;

КонецПроцедуры
 
Процедура ПодтверждениеОтправкиОтчета_УстановитьДатуИПериод(Форма, СведенияОбОтчете)
	
	Элементы = Форма.Элементы;

	ПериодЗадан = ЗначениеЗаполнено(СведенияОбОтчете.ПредставлениеПериода);
		
	Элементы.ГруппаДатаСоздания.Видимость 	= НЕ ПериодЗадан;
	Элементы.ГруппаПериод.Видимость 		= ПериодЗадан;
	
	Если ПериодЗадан Тогда
		Элементы.ПредставлениеПериода.Заголовок = Строка(СведенияОбОтчете.ПредставлениеПериода);
	Иначе
		Элементы.ДатаСоздания.Заголовок = Формат(СведенияОбОтчете.Дата, "ДФ=dd.MM.yyyy");
	КонецЕсли;

КонецПроцедуры

Процедура ПодтверждениеОтправкиОтчета_ПодтверждениеОтправкиОтчета_УстановитьОрганизацию(Форма, СведенияОбОтчете)
	
	Элементы = Форма.Элементы;

	Форма.Организация = СведенияОбОтчете.Организация;
	Элементы.НаименованиеОрганизации.Заголовок = Строка(Форма.Организация.Наименование);

КонецПроцедуры

Процедура ПодтверждениеОтправкиОтчета_УстановитьОрган(Форма, СведенияОбОтчете)
	
	Элементы = Форма.Элементы;

	Элементы.ПредставлениеКонтролирующегоОргана.Заголовок 	= Строка(СведенияОбОтчете.ПредставлениеКонтролирующегоОргана);
	
КонецПроцедуры

#КонецОбласти

