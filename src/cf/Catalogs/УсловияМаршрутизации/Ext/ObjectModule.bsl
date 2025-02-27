﻿
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредставлениеОтбора) 
			И СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
	
		КомпоновщикУсловий = Новый КомпоновщикНастроекКомпоновкиДанных;
		
		СхемаКомпоновкиДанных = Справочники.УсловияМаршрутизации.ПолучитьМакет("Условия");
		
		Настройки = НастройкаКомбинацииУсловий.Получить();
		Если Настройки = Неопределено Тогда
			Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		КонецЕсли;
		
		URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
		КомпоновщикУсловий.Инициализировать(ИсточникНастроек);
		КомпоновщикУсловий.ЗагрузитьНастройки(Настройки);
		
		ПредставлениеОтбора = Строка(КомпоновщикУсловий.Настройки.Отбор);
		
		ПредставлениеОтбора = СтрЗаменить(ПредставлениеОтбора, "( ", "(");
		ПредставлениеОтбора = СтрЗаменить(ПредставлениеОтбора, " )", ")");
		
	ИначеЕсли Не ЗначениеЗаполнено(ПредставлениеОтбора) И 
		СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора Тогда	
		
		Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
		
		ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(ТипОбъекта);
		ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
		
		СхемаКомпоновкиДанных = Справочники.УсловияМаршрутизации.ПолучитьМакет(ИмяЗначенияПеречисления);
		
		Настройки = НастройкаУсловия.Получить();
		Если Настройки = Неопределено Тогда
			Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		КонецЕсли;

		URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
		Компоновщик.Инициализировать(ИсточникНастроек);
		Компоновщик.ЗагрузитьНастройки(Настройки);
		
		ПредставлениеОтбора = Строка(Компоновщик.Настройки.Отбор);
		
		ПредставлениеОтбора = СтрЗаменить(ПредставлениеОтбора, "( ", "(");
		ПредставлениеОтбора = СтрЗаменить(ПредставлениеОтбора, " )", ")");
		
	КонецЕсли;	
	
КонецПроцедуры
