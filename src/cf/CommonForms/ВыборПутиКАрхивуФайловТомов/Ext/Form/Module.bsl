﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваКлиента = Новый Структура;
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	СвойстваКлиента.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	СвойстваКлиента.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте",
		ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Если СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента).ИнформационнаяБазаФайловая Тогда
		Элементы.ПутьКАрхивуWindows.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows'"); 
	Иначе
		Элементы.ПутьКАрхивуWindows.КнопкаВыбора = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Разместить(Команда)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(ПутьКАрхивуWindows) И ПустаяСтрока(ПутьКАрхивуLinux) Тогда
		Текст = НСтр("ru = 'Укажите полное имя архива с файлами начального образа (файл *.zip)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПутьКАрхивуWindows");
		Возврат;
	КонецЕсли;
	
	Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
	
		Если Не ПустаяСтрока(ПутьКАрхивуWindows) И (Лев(ПутьКАрхивуWindows, 2) <> "\\" ИЛИ Найти(ПутьКАрхивуWindows, ":") <> 0) Тогда
			ТекстОшибки = НСтр("ru = 'Путь к архиву с файлами начального образа должен быть в формате UNC (\\servername\resource) '");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьКАрхивуWindows");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Обмен данными'"), ,
				НСтр("ru = 'Осуществляется размещение файлов из архива с файлами начального образа...'"),
				БиблиотекаКартинок.СоздатьНачальныйОбраз);
	
	ОбменФайламиВызовСервера.ДобавитьФайлыВТома(ПутьКАрхивуWindows, ПутьКАрхивуLinux);
	
	ПоказатьПредупреждение(, НСтр("ru = 'Размещение файлов из архива с файлами начального образа успешно завершено'"));
	
КонецПроцедуры


&НаКлиенте
Процедура ПутьКАрхивуWindowsНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для данной операции необходимо установить расширение работы с файлами.'"));
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите файл'");
	Диалог.ПолноеИмяФайла				= ?(ЭтаФорма.ПутьКАрхивуWindows = "", "files.zip", ЭтаФорма.ПутьКАрхивуWindows);
	Диалог.МножественныйВыбор			= Ложь;
	Диалог.ПредварительныйПросмотр		= Ложь;
	Диалог.ПроверятьСуществованиеФайла	= Истина;
	Диалог.Фильтр						= "Архивы zip(*.zip)|*.zip";
	
	Если Диалог.Выбрать() Тогда
		
		ЭтаФорма.ПутьКАрхивуWindows = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

