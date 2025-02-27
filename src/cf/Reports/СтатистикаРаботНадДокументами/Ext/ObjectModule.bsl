﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Входящие документы
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ВходящиеДокументы) Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ВходящиеДокументы);
	КонецЕсли;
	
	// Внутренние документы
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ВнутренниеДокументы) Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ВнутренниеДокументы);
	КонецЕсли;
	
	// Исходящие документы
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ИсходящиеДокументы) Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ИсходящиеДокументы);
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ОбщегоНазначенияДокументооборот.УстановитьЦветаДиаграмм(ДокументРезультат);

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли