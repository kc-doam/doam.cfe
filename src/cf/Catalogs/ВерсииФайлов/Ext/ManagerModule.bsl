﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьДанныеКУдалению = Ложь;
	
	Если Не ПолучитьФункциональнуюОпцию("УдалятьНеактивныеВерсии") Тогда 
		Возврат ЕстьДанныеКУдалению;
	КонецЕсли;
	
	СрокХраненияНеактивныхВерсий = РаботаСФайламиВызовСервера.ПолучитьСрокХраненияНеактивныхВерсий(); // срок хранения в днях
	
	ПутьСохраненияУдаляемыхВерсий = РаботаСФайламиВызовСервера.ПолучитьПутьСохраненияУдаляемыхВерсий();
	Если Не ЗначениеЗаполнено(ПутьСохраненияУдаляемыхВерсий) Тогда
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Очистка неактивных версий файлов'"), 
		УровеньЖурналаРегистрации.Ошибка, 
		, , НСтр("ru = 'Не указан путь сохранения очищаемых версий'"));
		
		Возврат ЕстьДанныеКУдалению;
		
	КонецЕсли;	
	
	ДатаОтсечения = ТекущаяДата() - СрокХраненияНеактивныхВерсий * 86400; //  86400 - секунд в сутках
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 5000
		|	ВерсииФайлов.Ссылка,
		|	ЕСТЬNULL(ОбращенияКВерсиямФайлов.ДатаПоследнегоОбращения, ВерсииФайлов.ДатаСоздания) КАК ДатаПоследнегоОбращения,
		|	ВерсииФайлов.Владелец КАК ВладелецВерсии
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбращенияКВерсиямФайлов КАК ОбращенияКВерсиямФайлов
		|		ПО (ОбращенияКВерсиямФайлов.Версия = ВерсииФайлов.Ссылка)
		|ГДЕ
		|	ЕСТЬNULL(ОбращенияКВерсиямФайлов.ДатаПоследнегоОбращения, ВерсииФайлов.ДатаСоздания) < &ДатаОтсечения
		|	И ВерсииФайлов.Ссылка <> ВерсииФайлов.Владелец.ТекущаяВерсия
		|	И ВерсииФайлов.Владелец.НеУдалятьСтарыеВерсии = ЛОЖЬ
		|	И ВерсииФайлов.ФайлУдален = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВерсииФайлов.Владелец.Ссылка";
				   
	Запрос.УстановитьПараметр("ДатаОтсечения", ДатаОтсечения);
	РезультатЗапроса = Запрос.Выполнить();
	ЕстьДанныеКУдалению = Не РезультатЗапроса.Пустой();
	
	Если Не ЕстьДанныеКУдалению Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Удаление устаревших данных'"), 
			УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВерсииФайлов,, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'"), 0));
		
		Возврат ЕстьДанныеКУдалению;
		
	КонецЕсли;
	
	ИмяКаталогаСохранения = РаботаСФайламиВызовСервера.ПолучитьИмяКаталогаСохранения();
	
	ВладелецВерсии = Неопределено;
	ЧислоФайлов = 0;
	ЧислоВерсий = 0;
	РазмерВерсий = 0;
	
	МассивРезультатов = Новый Массив;
	
	Попытка
		
		СоздатьКаталог(ИмяКаталогаСохранения);
		
		ВерсияСсылка = Неопределено;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ВерсияСсылка = Выборка.Ссылка;
			РаботаСФайламиВызовСервера.ВыполнитьУдалениеНеактивнойВерсииФайла(
				ВерсияСсылка, Выборка, ИмяКаталогаСохранения, 
				МассивРезультатов, ВладелецВерсии, ЧислоФайлов, ЧислоВерсий, РазмерВерсий);
			
		КонецЦикла;
		
	Исключение
		
		// Записать ошибку в журнал регистрации
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(НСтр("ru='Ошибка очистки неактивных версий файлов'"), 
		УровеньЖурналаРегистрации.Ошибка, 
		, , СообщениеОбОшибке);
		
	КонецПопытки;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Справочники.ВерсииФайлов,, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'"), Выборка.Количество()));
	
	Если МассивРезультатов.Количество() = 0 Тогда
		Возврат ЕстьДанныеКУдалению;
	КонецЕсли;
	
	Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Всего очищено: %1 версий из %2 файлов. Объем: %3 Мб. 
			|Версии сохранены в каталог ""%4"".
			|Список очищенных версий в приложенном файле ""Отчет.html"".'"),
		ЧислоВерсий,
		ЧислоФайлов,
		ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВерсий / (1024 * 1024)),
		ИмяКаталогаСохранения);
	
	// Записать текст в журнал регистрации
	ЗаписьЖурналаРегистрации(НСтр("ru='Выполнена очистка устаревших версий файлов'"), 
		УровеньЖурналаРегистрации.Информация, 
		, , Описание);
		
	ИмяФайлаЗаписиОтчета = ЗаписатьОтчетОбУдаленииВерсий(МассивРезультатов);
	
	ТипОповещения = РаботаСФайламиВызовСервера.ПолучитьТипОповещенияОтветственногоЗаУдалениеНеактивныхВерсий();
	Ответственный = РаботаСФайламиВызовСервера.ПолучитьОтветственногоЗаУдалениеНеактивныхВерсий();
	
	АдресФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаЗаписиОтчета));
	
	// Оповещение по электронной почте
	Если ТипОповещения = Перечисления.ТипыОповещения.ЭлектроннаяПочта Тогда
		
		Уведомление = Новый Структура("Заголовок, Содержание", 
		НСтр("ru='Отчет об автоматической очистке устаревших версий файлов'"), Описание);
		ОтправитьУведомление(Уведомление, Ответственный, АдресФайла);
		
	Иначе // Оповещение с помощью задачи - бизнес-процесс Ознакомление
		
		ПапкаДляХраненияОтчетовОбУдалении = 
			РаботаСФайламиВызовСервера.ПолучитьПапкуДляХраненияОтчетовОбУдалении();
		
		Файл = Новый Файл(ИмяФайлаЗаписиОтчета);
		
		СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией", Файл);
		СведенияОФайле.ИмяБезРасширения = НСтр("ru = 'Отчет'");
		СведенияОФайле.АдресВременногоХранилищаФайла = АдресФайла;
		
		ФайлССылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(
			ПапкаДляХраненияОтчетовОбУдалении, СведенияОФайле);
		
		БизнесПроцесс = БизнесПроцессы.Ознакомление.СоздатьБизнесПроцесс();
		БизнесПроцесс.Автор = Ответственный;
		Строка = БизнесПроцесс.Исполнители.Добавить();
		Строка.Исполнитель = Ответственный;
		БизнесПроцесс.Наименование 
			= НСтр("ru='Ознакомиться с результатами автоматической очистки устаревших версий файлов'");
		БизнесПроцесс.Описание = Описание;
		БизнесПроцесс.Дата = ТекущаяДата();
		
		Мультипредметность.ПередатьПредметыПроцессу(БизнесПроцесс, ФайлССылка);
		
		БизнесПроцесс.Записать();
		СтартПроцессовСервер.СтартоватьПроцесс(БизнесПроцесс);
		
	КонецЕсли;
	
	Возврат ЕстьДанныеКУдалению;
	
КонецФункции

Функция ЗаписатьОтчетОбУдаленииВерсий(МассивРезультатов)
	
	ТабДок = Новый ТабличныйДокумент;
	ТабМакет = Обработки.ОчисткаУстаревшихВерсийФайлов.ПолучитьМакет("МакетОтчета");
	ОбластьСтрока = ТабМакет.ПолучитьОбласть("Строка");
		
	ВладелецВерсии = Неопределено;
	Для Каждого ОписаниеВерсии Из МассивРезультатов Цикл
		
		Если ВладелецВерсии <> ОписаниеВерсии.ВладелецВерсии Тогда
			
			ВладелецВерсии = ОписаниеВерсии.ВладелецВерсии;
			
			ОбластьЗаголовок = ТабМакет.ПолучитьОбласть("Заголовок");
			ОбластьЗаголовок.Параметры.Описание = ОписаниеВерсии.ПредставлениеВладельца;
			ТабДок.Вывести(ОбластьЗаголовок);
			
			ОбластьШапка = ТабМакет.ПолучитьОбласть("Шапка");
			ТабДок.Вывести(ОбластьШапка);
			
			
		КонецЕсли;	
		
		ОбластьСтрока.Параметры.Автор = ОписаниеВерсии.Автор;
		ОбластьСтрока.Параметры.НомерВерсии = ОписаниеВерсии.НомерВерсии;
		ОбластьСтрока.Параметры.Комментарий = ОписаниеВерсии.Комментарий;
		ОбластьСтрока.Параметры.ДатаСоздания = ОписаниеВерсии.ДатаСоздания;
		ОбластьСтрока.Параметры.Размер = ОписаниеВерсии.Размер;
		
		ТабДок.Вывести(ОбластьСтрока);
		
	КонецЦикла;

	Отчет = Новый ТабличныйДокумент;
	Отчет.Вывести(ТабДок);
	
	ИмяФайлаЗаписиОтчета = ПолучитьИмяВременногоФайла("html");
	Отчет.Записать(ИмяФайлаЗаписиОтчета, ТипФайлаТабличногоДокумента.HTML);
	
	Возврат ИмяФайлаЗаписиОтчета;
	
КонецФункции

Функция ОтправитьУведомление(Уведомление, Получатель, АдресФайла)
	
	Вложение = Новый Структура;
	Вложение.Вставить("Адрес", АдресФайла);
	Вложение.Вставить("ИмяФайла", НСтр("ru = 'Отчет.html'"));
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому", 
		РаботаСФайламиВызовСервера.ПолучитьАдресДляОтправкиУведомленияПользователю(Получатель));
	ПараметрыПисьма.Вставить("Тема", Уведомление.Заголовок);
	ПараметрыПисьма.Вставить("Текст", Уведомление.Содержание);
	ПараметрыПисьма.Вставить("Вложения", Новый Массив);
	ПараметрыПисьма.Вложения.Добавить(Вложение);
	
	Попытка
		Результат = ЛегкаяПочтаСервер.ОтправитьИнтернетПочта(ПараметрыПисьма);
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Комментарий");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли