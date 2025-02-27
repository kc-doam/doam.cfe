﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
/////////////////////////////////
//	Получение сообщений
/////////////////////////////////

Функция ПолучитьСообщения(НастройкаПочты, УдалятьПолученные = Истина) Экспорт
	
	МассивСообщенийСВД = Новый Массив;
	УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаПочты, "УчетнаяЗапись");
	СообщениеОбОшибке = "";
	Соединение = Почта.ИнтернетПочтаУстановитьСоединение(УчетнаяЗапись, , СообщениеОбОшибке);
	Если Соединение = Неопределено Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СерверСВД. Получение почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			НастройкаПочты.Метаданные(),
			НастройкаПочты,
			НСтр("ru = 'Невозможно подключиться к почтовому серверу.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат МассивСообщенийСВД;
		
	КонецЕсли;

	ПараметрыЗагрузки = Почта.СформироватьСтруктуруПараметровЗагрузки();
	
	ПротоколВходящейПочты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, 
		"ПротоколВходящейПочты");

	ПараметрыОтбора = Неопределено;
	Если ПротоколВходящейПочты = "IMAP" Тогда
		
		ПараметрыЗагрузки.ПараметрыОтбора.Вставить("ПослеДатыОтправления", ТекущаяДата() - 7 * 86400);
		ПараметрыЗагрузки.ПараметрыОтбора.Вставить("Удаленные", Ложь);
		
		Попытка
		
			ПараметрыЗагрузки.Идентификаторы = 
				Соединение.ПолучитьИдентификаторы(ПараметрыЗагрузки.Идентификаторы, 
					ПараметрыЗагрузки.ПараметрыОтбора);
					
		Исключение
					
			ПараметрыЗагрузки.ПараметрыОтбора.Удалить("ПослеДатыОтправления");
			
			ПараметрыЗагрузки.Идентификаторы = 
				Соединение.ПолучитьИдентификаторы(ПараметрыЗагрузки.Идентификаторы, 
					ПараметрыЗагрузки.ПараметрыОтбора);
			
		КонецПопытки;	
					
	КонецЕсли;	
	
	СообщениеОбОшибке = "";
	Сообщения = Почта.ПолучитьВходящиеСообщения(Соединение, ПараметрыЗагрузки, СообщениеОбОшибке);
	
	Если Сообщения <> Неопределено Тогда
		ИдентификаторыЗагруженныхСообщений = Новый Массив;
		Для каждого Сообщение Из Сообщения Цикл
			Если Сообщение.Вложения.Количество() = 0 Тогда
				ИдентификаторыЗагруженныхСообщений.Добавить(Сообщение.Идентификатор[0]);
				Продолжить;
			КонецЕсли;
			
			СообщениеСВД = Новый Структура();
			СообщениеСВД.Вставить("ОтправительПочта", Сообщение.Отправитель.Адрес);
			СообщениеСВД.Вставить("Наименование", Сообщение.Тема);
			ИмяВременногоОсновногоФайла = "";ИмяКорневогоЭлемента="";
			ТаблицаВложенний = РаботаССВД.СоздатьТаблицуВложений(Сообщение.Вложения,ИмяВременногоОсновногоФайла,ИмяКорневогоЭлемента);
			СообщениеСВД.Вставить("ИмяВременногоОсновногоФайла", ИмяВременногоОсновногоФайла);
			СообщениеСВД.Вставить("ИмяКорневогоЭлемента", ИмяКорневогоЭлемента);
			СообщениеСВД.Вставить("Файлы", ТаблицаВложенний);
			
			МассивСообщенийСВД.Добавить(СообщениеСВД);
			ИдентификаторыЗагруженныхСообщений.Добавить(Сообщение.Идентификатор[0]);
		КонецЦикла;
		
		СообщениеОбОшибке = "";
		Если Не Почта.УдалитьСообщенияВПочтовомЯщике(
			Соединение,
			ИдентификаторыЗагруженныхСообщений,
			СообщениеОбОшибке) Тогда	
			
			ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СерверСВД. Получение почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			НастройкаПочты.Метаданные(),
			НастройкаПочты,
			НСтр("ru = 'Невозможно удалить полученные сообщения. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
			+ СообщениеОбОшибке);
			
		КонецЕсли;
		
	Иначе
		
		ЗаписьЖурналаРегистрации(
		НСтр("ru = 'СерверСВД. Получение почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка, 
		НастройкаПочты.Метаданные(),
		НастройкаПочты,
		НСтр("ru = 'Невозможно загрузить сообщения. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
		+ СообщениеОбОшибке);
		
	КонецЕсли;
	
	Соединение.Отключиться();
	Возврат МассивСообщенийСВД;
	
КонецФункции	

/////////////////////////////////
//	Отправка сообщений
/////////////////////////////////
Процедура ОтправитьСообщение(НастройкаПочты, Сообщение) Экспорт
	
	Попытка 
		УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаПочты, "УчетнаяЗапись");
		ПараметрыОтправки = Новый Структура();
		
		//Тема
		ПараметрыОтправки.Вставить("Тема", Сообщение.ИдентификаторСообщения);
		
		//Текст
		ПараметрыОтправки.Вставить("Текст", Строка(ТекущаяДатаСеанса()));
		
		// Кому отправлять
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПользователиКонтактнаяИнформация.АдресЭП
			|ИЗ
			|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
			|ГДЕ
			|	ПользователиКонтактнаяИнформация.Ссылка = &Ссылка
			|	И ПользователиКонтактнаяИнформация.Тип = &Тип";
		Запрос.УстановитьПараметр("Ссылка", Сообщение.Кому);
		Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Не Выборка.Следующий() Тогда
			Возврат;
		КонецЕсли;
		ПараметрыОтправки.Вставить("Кому", Выборка.АдресЭП);
		
		// Вставка вложений
		МассивВложений = Новый Массив;
		МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(Сообщение);
		Для каждого ФайлСсылка Из МассивФайлов Цикл
			
			ДвоичныеДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(ФайлСсылка);
				
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
			
			СтруктураВложения = Новый Структура();
			СтруктураВложения.Вставить("Адрес", АдресВоВременномХранилище);
			СтруктураВложения.Вставить("ИмяФайла", ФайлСсылка.Наименование + "." + ФайлСсылка.ТекущаяВерсияРасширение);
			МассивВложений.Добавить(СтруктураВложения);
				
		КонецЦикла;
		ПараметрыОтправки.Вставить("Вложения", МассивВложений);
			
		ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыОтправки, УчетнаяЗапись);
	Исключение
		Информация = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СерверСВД. Отправка почты'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, 
			НастройкаПочты.Метаданные(),
			НастройкаПочты,
			НСтр("ru = 'Невозможно отправить сообщение. '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
				+ ПодробноеПредставлениеОшибки(Информация));
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли