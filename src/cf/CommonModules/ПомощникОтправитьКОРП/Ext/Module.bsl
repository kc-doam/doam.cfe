﻿////////////////////////////////////////////////////////////////////////////////
// Помощник отправить (КОРП): Содержит серверные процедуры и функции для редакции КОРП,
//                            по работе с помощником Отправить.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает заголовок помощника.
//
// Параметры:
//  Помощник - Структура - см. Помощник
//
// Возвращаемое значение:
//  Строка
//
Функция ЗаголовокПомощника(Помощник) Экспорт
	
	Заголовок = НСтр("ru = 'Выберите вариант для отправки'"); // Значение по умолчанию.
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПодзадачи(Помощник) Тогда
		Заголовок = НСтр("ru = 'Выберите вариант подзадачи'");
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаПроцесса(Помощник) Тогда
		Заголовок = НСтр("ru = 'Создание процесса'");
	ИначеЕсли ИспользуетсяРежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса(Помощник) Тогда
		Заголовок = НСтр("ru = 'Выберите вариант действия'");
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

// Возвращает заголовок команды выбора варианта помощника.
//
// Параметры:
//  Помощник - Структура - см. Помощник
//
// Возвращаемое значение:
//  Строка
//
Функция ЗаголовокКомандыВыбораВариантаПомощника(Помощник) Экспорт
	
	Заголовок = НСтр("ru = 'Перейти к отправке'");
	Если Помощник.РежимРаботы = ПомощникОтправитьКлиентСервер.РежимРаботыОтправкаПодзадачи() Тогда
		Заголовок = НСтр("ru = 'Создать подзадачу'");
	ИначеЕсли Помощник.РежимРаботы = ПомощникОтправитьКлиентСервер.РежимРаботыОтправкаПроцесса() Тогда
		Заголовок = НСтр("ru = 'Создать процесс'");
	ИначеЕсли Помощник.РежимРаботы =
		ПомощникОтправитьКлиентСерверКОРП.РежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса() Тогда
		
		Заголовок = НСтр("ru = 'Готово'");
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

// Проверяет возможность отправки с помощью помощника.
// В случае невозможности (при отсутствии вариантов отправки),
// генерируется исключение с описанием ошибки.
//
// Параметры:
//  Помощник - Структура - см. Помощник
//
Процедура ПроверитьВозможностьОтправки(Помощник) Экспорт
	
	Если Помощник.ДеревоВариантов.Строки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПодзадачи(Помощник) Тогда
		ТекстОшибки = НСтр("ru = 'Для создания подзадачи не предусмотрено вариантов.
			|При необходимости обратитесь к Администратору.'");
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаПроцесса(Помощник) Тогда
		ТекстОшибки = НСтр("ru = 'Для создания процесса не предусмотрено вариантов.
			|При необходимости обратитесь к Администратору.'");
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаПользователям(Помощник) Тогда
		ТекстОшибки = НСтр("ru = 'Для пользователей не предусмотрено вариантов отправки.
			|При необходимости обратитесь к Администратору.'");
	ИначеЕсли ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Тогда
		ТекстОшибки = НСтр("ru = 'Для отправки проектов/проектных задач не предусмотрено вариантов.
			|При необходимости обратитесь к Администратору.'");
	ИначеЕсли ИспользуетсяРежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса(Помощник) Тогда
		ТекстОшибки = НСтр("ru = 'Для настройки действий комплексного процесса не предусмотрено вариантов.
			|При необходимости обратитесь к Администратору.'");
	Иначе
		
		Если Помощник.ОбъектыОтправки.Количество() = 1 Тогда
			ПредставлениеОбъекта = """" + Помощник.ОбъектыОтправки[0] + """";
		Иначе
			ПредставлениеОбъекта = НСтр("ru = 'выбранных объектов'");
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru = 'Для %1 не предусмотрено вариантов отправки.
			|При необходимости обратитесь к Администратору.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ПредставлениеОбъекта);
	КонецЕсли;
	
	ВызватьИсключение ТекстОшибки;
	
КонецПроцедуры

// Возвращает параметры варианта.
//
// Параметры:
//  Помощник - см. Помощник()
//  Вариант - Произвольный - вариант отправки.
//
// Возвращаемое значение:
//  Структура - состав полей зависит от варианта. Подробнее см. функции:
//              ПараметрыВариантаСоздатьПисьмоНаОсновании
//              
//
Функция ПараметрыВарианта(Вариант, Помощник) Экспорт
	
	Параметры = Новый Структура;
	
	Если ИспользуетсяРежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса(Помощник) Тогда
		// Специальных параметров не предусмотрено.
	ИначеЕсли ПомощникОтправитьКлиентСервер.ЭтоВариантСоздатьПисьмоНаОсновании(Вариант) Тогда
		Параметры = ПомощникОтправить.ПараметрыВариантаСоздатьПисьмоНаОсновании(Помощник);
	ИначеЕсли ПомощникОтправитьКлиентСервер.ЭтоВариантСозданияПроцесса(Вариант) Тогда
		Параметры = ПомощникОтправить.ПараметрыВариантаСозданияПроцесса(Вариант, Помощник);
	КонецЕсли;
	
	Параметры.Вставить("РежимРаботы", Помощник.РежимРаботы);
	
	Возврат Параметры;
	
КонецФункции

// Возвращает описание варианта.
// Переопределяет для редакции КОРП функцию ПомощникОтправить.ОписаниеВарианта.
//
// Параметры:
//  Вариант - Произвольный - вариант отправки.
//
// Возвращаемое значение:
//  Строка
//
Функция ОписаниеВарианта(Вариант) Экспорт
	
	ОписаниеВарианта = "";
	
	Если ПомощникОтправитьКлиентСервер.ЭтоВариантСоздатьПисьмоНаОсновании(Вариант) Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаСоздатьПисьмоНаОсновании();
	ИначеЕсли ПомощникОтправитьКлиентСервер.ЭтоВариантСозданияПроцесса(Вариант) Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаСозданияПроцесса(Вариант);
	КонецЕсли;
	
	Возврат ОписаниеВарианта;
	
КонецФункции

// Возвращает признак использования режима работы ОтправкаПроектовИлиПроектныхЗадач
//
// Параметры:
//  Помощник - см. Помощник()
//
// Возвращаемое значение:
//  Булево
//
Функция ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Экспорт
	
	Возврат (Помощник.РежимРаботы = 
		ПомощникОтправитьКлиентСерверКОРП.РежимРаботыОтправкаПроектовИлиПроектныхЗадач());
	
КонецФункции

// Возвращает признак использования режима работы ВыборВариантаОтправкиДляДействияКомплексногоПроцесса
//
// Параметры:
//  Помощник - см. Помощник()
//
// Возвращаемое значение:
//  Булево
//
Функция ИспользуетсяРежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса(Помощник) Экспорт
	
	Возврат (Помощник.РежимРаботы = 
		ПомощникОтправитьКлиентСерверКОРП.РежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ВариантСоздатьПисьмоНаОсновании

// Добавляет в дерево вариант создания письма на основании объекта.
// Переопределяет для редакции КОРП процедуру ПомощникОтправить.ДобавитьВДеревоВариантСоздатьПисьмоНаОсновании.
//
// Параметры:
//  Помощник - см. Помощник()
//
Процедура ДобавитьВДеревоВариантСоздатьПисьмоНаОсновании(Помощник) Экспорт
	
	Если Не РегистрыСведений.ИспользованиеПочты.ПолучитьИспользованиеЛегкойПочты()
		И Не (РегистрыСведений.ИспользованиеПочты.ПолучитьИспользованиеВстроеннойПочты()
			И ПолучитьФункциональнуюОпцию("ИспользоватьВстроеннуюПочту")) Тогда
		
		Возврат;
	КонецЕсли;
	
	ВариантОтправкиПисьма = ПомощникОтправитьКлиентСервер.ВариантОтправкиСоздатьПисьмоНаОсновании();
	
	Если Не ПомощникОтправить.ВозможноДобавлениеВарианта(Помощник, ВариантОтправкиПисьма) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПомощникОтправитьКлиентСервер.ЕстьОбъектыУказанныхТипов(
		Помощник.ОбъектыОтправки,
		ПомощникОтправить.ДопустимыеТипыОбъектовДляВариантаСоздатьПисьмоНаОсновании()) Тогда
		
		Возврат;
	КонецЕсли;
	
	СтрокаВарианта = Помощник.ДеревоВариантов.Строки.Добавить();
	СтрокаВарианта.Вариант = ВариантОтправкиПисьма;
	СтрокаВарианта.Представление = ПомощникОтправить.ПредставлениеВариантаСоздатьПисьмоНаОсновании(Помощник);
	
КонецПроцедуры

// Возвращает допустимые типы объектов для варианта СоздатьПисьмоНаОсновании.
// Переопределяет для редакции КОРП процедуру
//   ПомощникОтправить.ДопустимыеТипыОбъектовДляВариантаСоздатьПисьмоНаОсновании.
//
//
// Возвращаемое значение:
//  Соответствие
//    * Ключ - Тип - тип объекта.
//    * Значение - Булево - всегда Истина.
//
Функция ДопустимыеТипыОбъектовДляВариантаСоздатьПисьмоНаОсновании() Экспорт
	
	ДопустимыеТипы = Новый Соответствие;
	
	ДопустимыеТипы[Тип("СправочникСсылка.ВнутренниеДокументы")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.ВходящиеДокументы")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.ИсходящиеДокументы")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.Пользователи")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.Файлы")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.Контрагенты")] = Истина;
	ДопустимыеТипы[Тип("ДокументСсылка.Бронь")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.Проекты")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.ПроектныеЗадачи")] = Истина;
	ДопустимыеТипы[Тип("СправочникСсылка.СообщенияОбсуждений")] = Истина;
	
	Если РегистрыСведений.ИспользованиеПочты.ПолучитьИспользованиеВстроеннойПочты()
			И ПолучитьФункциональнуюОпцию("ИспользоватьВстроеннуюПочту") Тогда
		
		ДопустимыеТипы[Тип("СправочникСсылка.УведомленияПрограммы")] = Истина;
	КонецЕсли;
	
	Возврат ДопустимыеТипы;
	
КонецФункции

// Возвращает представление варианта создания письма на основании объекта.
// Переопределяет для редакции КОРП процедуру
//   ПомощникОтправить.ПредставлениеВариантаСоздатьПисьмоНаОсновании.
//
// Возвращаемое значение:
//  Строка	
//
Функция ПредставлениеВариантаСоздатьПисьмоНаОсновании(Помощник) Экспорт
	
	Представление = НСтр("ru = 'По почте'");
	
	Индекс = Помощник.ОбъектыОтправки.Количество() - 1;
	ПоследнийОбъект = Помощник.ОбъектыОтправки[Индекс];
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПользователям(Помощник)
		Или ТипЗнч(ПоследнийОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		Представление = НСтр("ru = 'Письмо'");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ВариантыСозданияПроцессов

// Заполняет ПредметыПроцесса в помощнике.
//
// Параметры:
//  Помощник - Структура - см. Помощник().
//
Процедура ЗаполнитьПредметыПроцесса(Помощник) Экспорт
	
	Помощник.ПредметыПроцесса.Очистить();
	
	// Для задач, в предметы процесса, добавляем предметы задач, если они есть.
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПодзадачи(Помощник) Тогда
		
		ПредметыЗадачи = 
			ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			Помощник.ОбъектыОтправки[0], "Предметы").Выгрузить();
		
		Для Каждого СтрокаПредмет Из ПредметыЗадачи Цикл
			
			ТипПредмета = ТипЗнч(СтрокаПредмет.Предмет);
			
			ЭтоНеопределено = (ТипПредмета = Тип("Неопределено"));
			ЭтоФайл = (ТипПредмета = Тип("СправочникСсылка.Файлы"));
			ЭтоКонтрагент = (ТипПредмета = Тип("СправочникСсылка.Контрагенты"));
			
			Если ЭтоНеопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭтоФайл Тогда
				
				ВладелецФайла = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
					СтрокаПредмет.Предмет, "ВладелецФайла");
				
				Если Не ЗначениеЗаполнено(ВладелецФайла)
					Или ОбщегоНазначения.ЭтоБизнесПроцесс(ВладелецФайла.Метаданные()) Тогда
					
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЭтоКонтрагент Тогда
				Если ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
					СтрокаПредмет.Предмет, "ЭтоГруппа") = Ложь Тогда
					
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Помощник.ПредметыПроцесса.Добавить(
				СтрокаПредмет.Предмет);
		КонецЦикла;
		
		Помощник.ПредметыПроцесса = 
			ОбщегоНазначенияКлиентСервер.СвернутьМассив(
			Помощник.ПредметыПроцесса);
		
		Возврат;
	КонецЕсли;
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаОбъектов(Помощник) Тогда
		Для Каждого ОбъектОтправки Из Помощник.ОбъектыОтправки Цикл
			Помощник.ПредметыПроцесса.Добавить(ОбъектОтправки);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Если ИспользуетсяРежимРаботыВыборВариантаОтправкиДляДействияКомплексногоПроцесса(Помощник) Тогда
		Для Каждого ОбъектОтправки Из Помощник.ОбъектыОтправки Цикл
			Если ТипЗнч(ОбъектОтправки) = Тип("Неопределено") Тогда
				Продолжить;
			КонецЕсли;
			Помощник.ПредметыПроцесса.Добавить(ОбъектОтправки);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Если ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Тогда
		Для Каждого ОбъектОтправки Из Помощник.ОбъектыОтправки Цикл
			Если ТипЗнч(ОбъектОтправки) <> Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
				Продолжить;
			КонецЕсли;
			Предмет = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
				ОбъектОтправки, "Предмет");
			Если Не ЗначениеЗаполнено(Предмет) Тогда
				Продолжить;
			КонецЕсли;
			Помощник.ПредметыПроцесса.Добавить(Предмет);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет в помощнике РекомендуемыеВариантыСозданияПроцессов
// Переопределяет для редакции КОРП процедуру ПомощникОтправить.ЗаполнитьРекомендуемыеВариантыСозданияПроцессов.
//
// Параметры:
//  Помощник - см. Помощник
//
Процедура ЗаполнитьРекомендуемыеВариантыСозданияПроцессов(Помощник) Экспорт
	
	Помощник.РекомендуемыеВариантыСозданияПроцессов.Очистить();
	
	ОбъектыДляРасчета = Новый Массив;
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПользователям(Помощник) Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОбъектыДляРасчета, Помощник.ОбъектыОтправки);
	ИначеЕсли ПомощникОтправитьКОРП.ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОбъектыДляРасчета, Помощник.ПредметыПроцесса);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОбъектыДляРасчета, Помощник.ОбъектыОтправки);
	Иначе
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОбъектыДляРасчета, Помощник.ПредметыПроцесса);
	КонецЕсли;
	
	// Исключаем не заполненные объекты, по ним нельзя рассчитать назначенные шаблоны.
	Индекс = ОбъектыДляРасчета.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Если Не ЗначениеЗаполнено(ОбъектыДляРасчета[Индекс]) Тогда
			ОбъектыДляРасчета.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Если ОбъектыДляРасчета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивВариантов = ШаблоныБизнесПроцессов.ШаблоныПоОбъектам(ОбъектыДляРасчета);
	
	РекомендуемыеВарианты = Новый Соответствие;
	Для Каждого Вариант Из МассивВариантов Цикл
		Помощник.РекомендуемыеВариантыСозданияПроцессов[Вариант] = 
			ПомощникОтправить.ТипВариантаСозданияПроцесса(Вариант);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет общие варианты создания процессов.
// Переопределяет для редакции КОРП процедуру ПомощникОтправить.ЗаполнитьОбщиеВариантыСозданияПроцессов.
//
// Параметры:
//  Помощник - Структура - см. ПомощникОтправить.Помощник();
//
Процедура ЗаполнитьОбщиеВариантыСозданияПроцессов(Помощник) Экспорт
	
	// В редакции КОРП дополнительно учитываем доступность шаблонов,
	// и то, что в справочниках шаблонов процессов хранятся служебные
	// данные комплексных процессов.
	
	// Общие варианты создания процессов заполняем только если
	// они не заполнены, т.к. они не меняются при смене объектов отправки.
	Если ЗначениеЗаполнено(Помощник.ОбщиеВариантыСозданияПроцессов) Тогда
		Возврат;
	КонецЕсли;
	
	Помощник.ОбщиеВариантыСозданияПроцессов = Новый Соответствие;
	
	ТекстыЗапросов = Новый Массив;
	
	ШаблонЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныПроцессов.Ссылка КАК ШаблонПроцесса
		|ИЗ
		|	Справочник.ШаблоныИсполнения КАК ШаблоныПроцессов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДоступностьШаблоновПроцессов КАК ДоступностьШаблоновПроцессов
		|		ПО ШаблоныПроцессов.Ссылка = ДоступностьШаблоновПроцессов.Шаблон
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаШаблоновБизнесПроцессов КАК НастройкаШаблоновБизнесПроцессов
		|		ПО ШаблоныПроцессов.Ссылка = НастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса
		|ГДЕ
		|	ШаблоныПроцессов.ШаблонВКомплексномПроцессе = ЛОЖЬ
		|	И ШаблоныПроцессов.ЭтоГруппа = ЛОЖЬ
		|	И ШаблоныПроцессов.ПометкаУдаления = ЛОЖЬ
		|	И ШаблоныПроцессов.Предопределенный = ЛОЖЬ
		|	И НастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса ЕСТЬ NULL
		|	И ДоступностьШаблоновПроцессов.РучнойЗапуск = ИСТИНА";
	
	ИмяТаблицыДляЗамены = "ШаблоныИсполнения";
	
	УдалитьКлючевоеСловоРазрешенные = Ложь;
	
	ИменаСправочников = ШаблоныБизнесПроцессовКлиентСервер.ИменаСправочниковШаблонов();
	
	Для Каждого ИмяСправочникаШаблона Из ИменаСправочников Цикл
		
		Если ИмяСправочникаШаблона = "ШаблоныПоручения" Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, ИмяТаблицыДляЗамены, ИмяСправочникаШаблона);
		
		Если УдалитьКлючевоеСловоРазрешенные Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " РАЗРЕШЕННЫЕ", "");
		Иначе
			УдалитьКлючевоеСловоРазрешенные = Истина;
		КонецЕсли;
		
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
		СтрСоединить(ТекстыЗапросов, Символы.ПС + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" +Символы.ПС + Символы.ПС));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Помощник.ОбщиеВариантыСозданияПроцессов[Выборка.ШаблонПроцесса] =
			 ПомощникОтправить.ТипВариантаСозданияПроцесса(Выборка.ШаблонПроцесса);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет в помощнике ДругиеВариантыСозданияПроцессов.
// Это все доступные, назначенные шаблоны процессов видам объектов,
// которых нет в ПредметыПроцесса.
//
// Переопределяет для редакции КОРП процедуру ПомощникОтправить.ЗаполнитьДругиеВариантыСозданияПроцессов.
//
// Параметры:
//  Помощник - см. Помощник
//
Процедура ЗаполнитьДругиеВариантыСозданияПроцессов(Помощник) Экспорт
	
	// В редакции КОРП дополнительно учитываем доступность шаблонов,
	// и то, что в справочниках шаблонов процессов хранятся служебные
	// данные комплексных процессов.
	
	Помощник.ДругиеВариантыСозданияПроцессов = Новый Соответствие;
	
	КомуНазначеныШаблоны = Новый Соответствие;
	
	ДобавитьТипыДанныхИзОбъектовОтправки = Ложь;
	ДобавитьТипыДанныхИзПредметовПроцесса = Ложь;
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПользователям(Помощник) Тогда
		ДобавитьТипыДанныхИзОбъектовОтправки = Истина;
	ИначеЕсли ПомощникОтправитьКОРП.ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Тогда
		ДобавитьТипыДанныхИзОбъектовОтправки = Истина;
		ДобавитьТипыДанныхИзПредметовПроцесса = Истина;
	Иначе
		ДобавитьТипыДанныхИзПредметовПроцесса = Истина;
	КонецЕсли;
	
	Если ДобавитьТипыДанныхИзОбъектовОтправки Тогда
		Для Каждого ОбъектОтправки Из Помощник.ОбъектыОтправки Цикл
			Если Не ЗначениеЗаполнено(ОбъектОтправки) Тогда
				Продолжить;
			КонецЕсли;
			
			КомуНазначен = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(ОбъектОтправки));
			КомуНазначеныШаблоны[КомуНазначен] = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если ДобавитьТипыДанныхИзПредметовПроцесса Тогда
		Для Каждого Предмет Из Помощник.ПредметыПроцесса Цикл
			Если Не ЗначениеЗаполнено(Предмет) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Предмет) Тогда
				ВидДокумента = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
					Предмет, "ВидДокумента");
				Для Каждого ВидДокумента Из Делопроизводство.ПолучитьВидДокументаИРодителей(ВидДокумента) Цикл
					КомуНазначеныШаблоны[ВидДокумента] = Истина;
				КонецЦикла;
			Иначе
				КомуНазначен = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Предмет));
				КомуНазначеныШаблоны[КомуНазначен] = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТекстыЗапросов = Новый Массив;
	
	ШаблонЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныПроцессов.Ссылка КАК ШаблонПроцесса,
		|	НастройкаШаблоновБизнесПроцессов.КомуНазначен КАК КомуНазначен
		|ИЗ
		|	Справочник.ШаблоныИсполнения КАК ШаблоныПроцессов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДоступностьШаблоновПроцессов КАК ДоступностьШаблоновПроцессов
		|		ПО ШаблоныПроцессов.Ссылка = ДоступностьШаблоновПроцессов.Шаблон
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаШаблоновБизнесПроцессов КАК НастройкаШаблоновБизнесПроцессов
		|		ПО ШаблоныПроцессов.Ссылка = НастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса
		|ГДЕ
		|	ШаблоныПроцессов.ШаблонВКомплексномПроцессе = ЛОЖЬ
		|	И ШаблоныПроцессов.ЭтоГруппа = ЛОЖЬ
		|	И ШаблоныПроцессов.Предопределенный = ЛОЖЬ
		|	И ШаблоныПроцессов.ПометкаУдаления = ЛОЖЬ
		|	И ДоступностьШаблоновПроцессов.РучнойЗапуск = ИСТИНА";
	
	ИмяТаблицыДляЗамены = "ШаблоныИсполнения";
	
	УдалитьКлючевоеСловоРазрешенные = Ложь;
	
	ИменаСправочников = ШаблоныБизнесПроцессовКлиентСервер.ИменаСправочниковШаблонов();
	
	Для Каждого ИмяСправочникаШаблона Из ИменаСправочников Цикл
		
		Если ИмяСправочникаШаблона = "ШаблоныПоручения" Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, ИмяТаблицыДляЗамены, ИмяСправочникаШаблона);
		
		Если УдалитьКлючевоеСловоРазрешенные Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " РАЗРЕШЕННЫЕ", "");
		Иначе
			УдалитьКлючевоеСловоРазрешенные = Истина;
		КонецЕсли;
		
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
		СтрСоединить(ТекстыЗапросов, Символы.ПС + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС + Символы.ПС));
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВариантыДляПредметовПроцессов = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Если КомуНазначеныШаблоны[Выборка.КомуНазначен] = Истина Тогда
			ВариантыДляПредметовПроцессов[Выборка.ШаблонПроцесса] = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		Если ВариантыДляПредметовПроцессов[Выборка.ШаблонПроцесса] = Истина Тогда
			Продолжить;
		КонецЕсли;
		Помощник.ДругиеВариантыСозданияПроцессов[Выборка.ШаблонПроцесса] =
			 ПомощникОтправить.ТипВариантаСозданияПроцесса(Выборка.ШаблонПроцесса);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает представление варианта создания процесса по умолчанию в Еще.
//
// Параметры:
//  Вариант - СправочникСсылка - ссылка на шаблон процесса.
//  Помощник - см. Помощник()
//
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеВариантаСозданияПроцессаПоУмолчанию(Вариант, Помощник) Экспорт
	
	Представление = "";
	
	ТипВарианта = Помощник.ВариантыСозданияПроцессовПоУмолчанию[Вариант];
	
	Если ТипВарианта = Неопределено Тогда
		Возврат Представление;
	КонецЕсли;
	
	Если ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаВнутреннегоДокумента() Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаПоУмолчаниюОбработкиВнутреннегоДокумента();
	ИначеЕсли ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаВходящегоДокумента() Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаПоУмолчаниюОбработкиВходящегоДокумента();
	ИначеЕсли ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаИсходящегоДокумента() Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаПоУмолчаниюОбработкиИсходящегоДокумента();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
		Представление = ПредставлениеВариантаПоУмолчаниюСозданияКомплексногоПроцесса();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныИсполнения") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаИсполненияПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныОзнакомления") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаОзнакомленияПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныРассмотрения") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаРассмотренияПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныРегистрации") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаРегистрацииПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныСогласования") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаСогласованияПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
		Представление = ПомощникОтправить.ПредставлениеВариантаУтвержденияПоУмолчанию();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныПриглашения") Тогда
		Представление = ПредставлениеВариантаПриглашенияПоУмолчанию();
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает представление варианта по умолчанию создания комплексного процесса.
//
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеВариантаПоУмолчаниюСозданияКомплексногоПроцесса()
	
	Возврат НСтр("ru = 'Комплексный процесс (новый)'");
	
КонецФункции

// Возвращает представление варианта утверждения по умолчанию.
//
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеВариантаУтвержденияПоУмолчанию() Экспорт
	
	Возврат НСтр("ru = 'Утверждение / подписание (новое)'");
	
КонецФункции

// Возвращает представление варианта приглашения по умолчанию.
//
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеВариантаПриглашенияПоУмолчанию()
	
	Возврат НСтр("ru = 'Приглашение (новое)'");
	
КонецФункции

// Возвращает описание варианта создания процесса
// Переопределяет для редакции КОРП процедуру ПомощникОтправить.ШаблоныКомплексныхБизнесПроцессов.
//
// Параметры:
//  Вариант - Произвольное - вариант отправки.
//
// Возвращаемое значение:
//  Строка
//
Функция ОписаниеВариантаСозданияПроцесса(Вариант) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Вариант = ПомощникОтправитьКлиентСервер.ГруппаДругихВариантовСозданияПроцессов() Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеГруппыДругихВариантовСозданияПроцессов();
		Возврат ПомощникОтправить.HTMLОписаниеВарианта(ОписаниеВарианта);
	КонецЕсли;
	
	ШаблоныПроцессовПоУмолчанию = ШаблоныБизнесПроцессовКлиентСервер.ШаблоныПроцессовПоУмолчанию();
	Если ШаблоныПроцессовПоУмолчанию.Найти(Вариант) = Неопределено Тогда
		Возврат ОбзорПроцессовВызовСервера.ПолучитьОбзорШаблонаПроцесса(Вариант);
	КонецЕсли;
	
	ТипВарианта = ПомощникОтправить.ТипВариантаСозданияПроцесса(Вариант);
	Если ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаВнутреннегоДокумента() Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаПоУмолчаниюОбработкиВнутреннегоДокумента();
	ИначеЕсли ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаВходящегоДокумента() Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаПоУмолчаниюОбработкиВходящегоДокумента();
	ИначеЕсли ТипВарианта = ПомощникОтправить.ТипВариантаОбработкаИсходящегоДокумента() Тогда
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаПоУмолчаниюОбработкаИсходящегоДокумента();
	ИначеЕсли ТипВарианта = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
		ОписаниеВарианта = ОписаниеВариантаПоУмолчаниюДляКомплексногоПроцесса();
	Иначе
		ОписаниеВарианта = ПомощникОтправить.ОписаниеВариантаПоУмолчаниюЛюбогоТипа();
	КонецЕсли;
	
	Возврат ПомощникОтправить.HTMLОписаниеВарианта(ОписаниеВарианта);
	
КонецФункции

// Возвращает описание варианта по умолчанию для комплексного процесса.
//
// Возвращаемое значение:
//  Строка
//
Функция ОписаниеВариантаПоУмолчаниюДляКомплексногоПроцесса()
	
	Возврат НСтр("ru = 'Создание нового комплексного процесса для заполнения вручную.
		|
		|Вы можете запланировать произвольное количество действий, настроить порядок и условия их выполнения.'");

КонецФункции

// Возвращает параметры варианта создания процесса.
//
// Параметры:
//  Вариант - СправочникСсылка - ссылка на шаблон процесса.
//  Помощник - см. Помощник()
//
// Возвращаемое значение:
//  Структура - поля структуры зависят от переданного варианта.
//   * Основание - Структура - основание заполенние.
//      ** Шаблон - ссылкан на шаблон процесса (вариант отправки).
//      ** ЗадачаИсполнителя - ссылка на задачу (объект отправки).
//      ** Исполнители - Массив - список пользователей.
//      ** Предметы - Массив - список предметов для создаваемого процесса.
//          *** Структура с полями: Предмет, ИмяПредмета, РольПредмета
//   * ИмяФормы - Строка
//
Функция ПараметрыВариантаСозданияПроцесса(Вариант, Помощник) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("Шаблон", Вариант);
	
	МенеджерШаблона = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Вариант);
	ИмяПроцесса = МенеджерШаблона.ИмяПроцесса(Вариант);
	
	ТипШаблона = БизнесПроцессы[ИмяПроцесса].ТипШаблона();
	Если ИмяПроцесса = ПомощникОтправить.ТипВариантаОбработкаВнутреннегоДокумента() Тогда
		ТипШаблона = ПомощникОтправить.ТипВариантаОбработкаВнутреннегоДокумента();
	ИначеЕсли ИмяПроцесса = ПомощникОтправить.ТипВариантаОбработкаВходящегоДокумента() Тогда
		ТипШаблона = ПомощникОтправить.ТипВариантаОбработкаВходящегоДокумента();
	ИначеЕсли ИмяПроцесса = ПомощникОтправить.ТипВариантаОбработкаИсходящегоДокумента() Тогда
		ТипШаблона = ПомощникОтправить.ТипВариантаОбработкаИсходящегоДокумента();
	КонецЕсли;
	
	ПомощникОтправить.ЗаполнитьДопустимыеТипыПредметовВПроцессах(Помощник);
	ДопустимыеТипыПредметов = Помощник.ДопустимыеТипыПредметовВПроцессах[ТипШаблона];
	
	Предметы = Новый Массив;
	ПоляСтрокиПредметов = "Предмет, ИмяПредмета, РольПредмета";
	ИсходныеИменаПредметов = Новый Массив;
	
	Если ПомощникОтправить.ИспользуетсяРежимОтправкаПодзадачи(Помощник) Тогда
		
		Основание.Вставить("ЗадачаИсполнителя", Помощник.ОбъектыОтправки[0]);
		
		Если Не ЗначениеЗаполнено(Помощник.ПредметыПроцесса) Тогда
			ПомощникОтправить.ЗаполнитьПредметыПроцесса(Помощник);
		КонецЕсли;
		
		ПредметыЗадачи = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			Помощник.ОбъектыОтправки[0], "Предметы").Выгрузить();
		
		ИменаПредметов = Новый Соответствие;
		Для Каждого СтрокаТаблицы Из ПредметыЗадачи Цикл
			ИменаПредметов[СтрокаТаблицы.Предмет] = СтрокаТаблицы.ИмяПредмета;
		КонецЦикла;
		
		Для Каждого ПредметПроцесса Из Помощник.ПредметыПроцесса Цикл
			
			Если Не ЗначениеЗаполнено(ПредметПроцесса)
				Или ДопустимыеТипыПредметов.Найти(ТипЗнч(ПредметПроцесса)) = Неопределено Тогда
				
				Продолжить;
			КонецЕсли;
			
			СтрокаПредмета = Новый Структура(ПоляСтрокиПредметов);
			СтрокаПредмета.Предмет = ПредметПроцесса;
			СтрокаПредмета.РольПредмета = Перечисления.РолиПредметов.Основной;
			
			СтрокаПредмета.ИмяПредмета = ИменаПредметов[ПредметПроцесса];
			
			Предметы.Добавить(СтрокаПредмета);
		КонецЦикла;
		
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаПользователям(Помощник) Тогда
		Основание.Вставить("Исполнители", Помощник.ОбъектыОтправки);
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаПроцесса(Помощник) Тогда
		// Дополнительные параметры не требуются.
	ИначеЕсли ИспользуетсяРежимРаботыОтправкаПроектовИлиПроектныхЗадач(Помощник) Тогда
		
		МаксимальныйИндекс = Помощник.ОбъектыОтправки.Количество() - 1;
		
		Для Индекс = 0 По МаксимальныйИндекс Цикл
			
			ОбъектОтправки = Помощник.ОбъектыОтправки[Индекс];
			
			// Если первый объект является проектом или проектной задачей,
			// то подставляем его в соотвествующий реквизит процесса.
			Если Индекс = 0 Тогда
				Если ТипЗнч(ОбъектОтправки) = Тип("СправочникСсылка.Проекты") Тогда
					Основание.Вставить("Проект", ОбъектОтправки);
				ИначеЕсли ТипЗнч(ОбъектОтправки) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
					Основание.Вставить("ПроектнаяЗадача", ОбъектОтправки);
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			Если ДопустимыеТипыПредметов.Найти(ТипЗнч(ОбъектОтправки)) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаПредмета = Новый Структура(ПоляСтрокиПредметов);
			СтрокаПредмета.Предмет = ОбъектОтправки;
			СтрокаПредмета.РольПредмета = Перечисления.РолиПредметов.Вспомогательный;
			
			СтрокаПредмета.ИмяПредмета = МультипредметностьВызовСервера.
				ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(СтрокаПредмета.Предмет, ИсходныеИменаПредметов);
			
			ИсходныеИменаПредметов.Добавить(СтрокаПредмета.ИмяПредмета);
			
			Предметы.Добавить(СтрокаПредмета);
			
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(Помощник.ПредметыПроцесса) Тогда
			ПомощникОтправить.ЗаполнитьПредметыПроцесса(Помощник);
		КонецЕсли;
		
		Для Каждого ПредметПроцесса Из Помощник.ПредметыПроцесса Цикл
			
			Если ДопустимыеТипыПредметов.Найти(ТипЗнч(ПредметПроцесса)) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаПредмета = Новый Структура(ПоляСтрокиПредметов);
			СтрокаПредмета.Предмет = ПредметПроцесса;
			СтрокаПредмета.РольПредмета = Перечисления.РолиПредметов.Вспомогательный;
			
			СтрокаПредмета.ИмяПредмета = МультипредметностьВызовСервера.
				ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(СтрокаПредмета.Предмет, ИсходныеИменаПредметов);
			
			ИсходныеИменаПредметов.Добавить(СтрокаПредмета.ИмяПредмета);
			
			Предметы.Добавить(СтрокаПредмета);
		КонецЦикла;
		
	ИначеЕсли ПомощникОтправить.ИспользуетсяРежимОтправкаОбъектов(Помощник) Тогда
		
		Для Каждого ОбъектОтправки Из Помощник.ОбъектыОтправки Цикл
			
			Если ДопустимыеТипыПредметов.Найти(ТипЗнч(ОбъектОтправки)) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаПредмета = Новый Структура(ПоляСтрокиПредметов);
			СтрокаПредмета.Предмет = ОбъектОтправки;
			СтрокаПредмета.РольПредмета = Перечисления.РолиПредметов.Основной;
			
			СтрокаПредмета.ИмяПредмета = МультипредметностьВызовСервера.
				ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(СтрокаПредмета.Предмет, ИсходныеИменаПредметов);
			
			ИсходныеИменаПредметов.Добавить(СтрокаПредмета.ИмяПредмета);
			
			Предметы.Добавить(СтрокаПредмета);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предметы) Тогда
		Основание.Вставить("Предметы", Предметы);
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Основание", Основание);
	
	ИмяФормы = СтрШаблон("БизнесПроцесс.%1.Форма.ФормаБизнесПроцесса", ИмяПроцесса);
	Параметры.Вставить("ИмяФормы", ИмяФормы);
	
	Если Основание.Свойство("ПроектнаяЗадача")
		И ЗначениеЗаполнено(Основание.ПроектнаяЗадача) Тогда
		
		ДанныеПроектнойЗадачи = РаботаСПроектами.ПолучитьСрокиПроектнойЗадачи(Основание.ПроектнаяЗадача);
		Параметры.Вставить("ПроектнаяЗадача", Основание.ПроектнаяЗадача);
		Параметры.Вставить("ОкончаниеФактПроектнойЗадачи", ДанныеПроектнойЗадачи.ОкончаниеФакт);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти