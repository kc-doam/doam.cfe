﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияПоОбъектамУчетаЭДО;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	СсылкаНаОбъект = Неопределено;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("СсылкаНаОбъект");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("СсылкаНаОбъект");

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СостоянияЭД.СсылкаНаОбъект КАК СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктуальныеДокументыЭДО КАК АктуальныеДокументыЭДО
	|		ПО АктуальныеДокументыЭДО.ОбъектУчета = СостоянияЭД.СсылкаНаОбъект
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовЭДО КАК СостоянияЭДО
	|		ПО 
	|		(СостоянияЭД.УдалитьЭлектронныйДокумент = СостоянияЭДО.ЭлектронныйДокумент И 
	|			(СостоянияЭД.УдалитьЭлектронныйДокумент ССЫЛКА Документ.ЭлектронныйДокументВходящийЭДО
	|				ИЛИ СостоянияЭД.УдалитьЭлектронныйДокумент ССЫЛКА Документ.ЭлектронныйДокументИсходящийЭДО))
	|		ИЛИ 
	|		(СостоянияЭД.УдалитьЭлектронныйДокумент.ВладелецФайла.ЭлектронныйДокумент = СостоянияЭДО.ЭлектронныйДокумент И 
	|			(СостоянияЭД.УдалитьЭлектронныйДокумент ССЫЛКА Справочник.СообщениеЭДОПрисоединенныеФайлы)
	|		)
	|ГДЕ
	|	(&СсылкаНаОбъект = НЕОПРЕДЕЛЕНО ИЛИ СостоянияЭД.СсылкаНаОбъект > &СсылкаНаОбъект)
	|	И 
	// Нет записи в регистре актуальности.
	|		(АктуальныеДокументыЭДО.ОбъектУчета ЕСТЬ NULL
	|			И (СостоянияЭД.УдалитьЭлектронныйДокумент ССЫЛКА Документ.ЭлектронныйДокументВходящийЭДО
	|				ИЛИ СостоянияЭД.УдалитьЭлектронныйДокумент ССЫЛКА Документ.ЭлектронныйДокументИсходящийЭДО)
	|			И СостоянияЭД.УдалитьЭлектронныйДокумент <> ЗНАЧЕНИЕ(Документ.ЭлектронныйДокументВходящийЭДО.ПустаяСсылка)
	|			И СостоянияЭД.УдалитьЭлектронныйДокумент <> ЗНАЧЕНИЕ(Документ.ЭлектронныйДокументИсходящийЭДО.ПустаяСсылка)
	// Не заполнено представление состояния.
	|		ИЛИ СостоянияЭД.ПредставлениеСостояния = """"
	|			И СостоянияЭД.СостояниеЭДО <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументовЭДО.ПустаяСсылка)
	// Не верное состояние ЭДО.
	|		ИЛИ СостоянияЭД.СостояниеЭДО <> СостоянияЭДО.Состояние)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СсылкаНаОбъект";

	ОтработаныВсеДанные = Ложь;

	Пока Не ОтработаныВсеДанные Цикл

		Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
		Выгрузка = Запрос.Выполнить().Выгрузить();

		КоличествоСтрок = Выгрузка.Количество();

		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			СсылкаНаОбъект = Выгрузка[КоличествоСтрок - 1].СсылкаНаОбъект;
		КонецЕсли;

		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);

	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияПоОбъектамУчетаЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	МассивПроверяемыхОбъектов = Новый Массив;
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументВходящийЭДО");
	МассивПроверяемыхОбъектов.Добавить("Документ.ЭлектронныйДокументИсходящийЭДО");

	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, МассивПроверяемыхОбъектов) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, МассивПроверяемыхОбъектов);
		Возврат;
	КонецЕсли;	
	
	ДанныеДляОбновления = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
		
	Если ДанныеДляОбновления.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из ДанныеДляОбновления Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("СсылкаНаОбъект", СтрокаДанных.СсылкаНаОбъект);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Набор = РегистрыСведений.СостоянияПоОбъектамУчетаЭДО.СоздатьНаборЗаписей();
			Набор.Отбор.СсылкаНаОбъект.Установить(СтрокаДанных.СсылкаНаОбъект);
			Набор.Прочитать();
			
			ОбработатьДанные_ЗаполнитьАктуальныйДокументооборот(Набор);
			ОбработатьДанные_ЗаполнитьСостояниеЭДО(Набор, Записать);
			ОбработатьДанные_ЗаполнитьПредставлениеСостояния(Набор, Записать);
			ОбработатьДанные_ЗаполнитьОписаниеОснования(Набор, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;

			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + ДанныеДляОбновления.Количество();
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Оптимизировать после проверки корректности заполнения данных.
Процедура ОбработатьДанные_ЗаполнитьАктуальныйДокументооборот(Набор) 
	
	Для Каждого Запись Из Набор Цикл

		Если ТипЗнч(Запись.СсылкаНаОбъект) = Тип("СправочникСсылка.НастройкиЭДО")
			ИЛИ Не ЗначениеЗаполнено(Запись.СсылкаНаОбъект) Тогда
			Продолжить;
		КонецЕсли;
	
		НаборАктуальныхДокументов = РегистрыСведений.АктуальныеДокументыЭДО.СоздатьНаборЗаписей();
		НаборАктуальныхДокументов.Отбор.ОбъектУчета.Установить(Запись.СсылкаНаОбъект);
		НаборАктуальныхДокументов.Прочитать();

		Если НаборАктуальныхДокументов.Количество() = 0 Тогда
			
			ЭлектронныйДокумент = Неопределено;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО")
				Или ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
				Продолжить;
			КонецЕсли;
		
			ВидДокумента = ЭлектронныйДокумент.ВидДокумента;
			ИнтеграцияЭДО.УстановитьАктуальныйЭлектронныйДокумент(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
					Запись.СсылкаНаОбъект), ЭлектронныйДокумент, ВидДокумента);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
			
//Оптимизировать после проверки корректности заполнения данных.
Процедура ОбработатьДанные_ЗаполнитьСостояниеЭДО(Набор, Записать) 
	
Для Каждого Запись Из Набор Цикл
		
		Если Не ЗначениеЗаполнено(Запись.СостояниеЭДО) Тогда
		
			Если Не ЗначениеЗаполнено(Запись.УдалитьЭлектронныйДокумент) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлектронныйДокумент = Неопределено;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО")
				Или ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент;
			КонецЕсли;
			
			Если ТипЗнч(Запись.УдалитьЭлектронныйДокумент) = Тип("СправочникСсылка.СообщениеЭДОПрисоединенныеФайлы")  Тогда
				ЭлектронныйДокумент = Запись.УдалитьЭлектронныйДокумент.ВладелецФайла.ЭлектронныйДокумент;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда
				Продолжить;
			КонецЕсли;
			
			СостояниеЭДО = ЭлектронныеДокументыЭДО.СостояниеДокумента(ЭлектронныйДокумент);
			
			Если Запись.СостояниеЭДО <> СостояниеЭДО Тогда
				Запись.СостояниеЭДО = СостояниеЭДО;	
				Запись.ПредставлениеСостояния = ИнтеграцияЭДО.ПредставлениеСостоянияЭДООбъектаУчета(Запись.СсылкаНаОбъект,
					Запись.СостояниеЭДО);		
				Записать = Истина;	
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
			
Процедура ОбработатьДанные_ЗаполнитьПредставлениеСостояния(Набор, Записать) 
	
	Для Каждого Запись Из Набор Цикл
		
		Если Не ЗначениеЗаполнено(Запись.СсылкаНаОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Запись.ПредставлениеСостояния = "" Тогда
		
			Запись.ПредставлениеСостояния = ИнтеграцияЭДО.ПредставлениеСостоянияЭДООбъектаУчета(Запись.СсылкаНаОбъект,
				Запись.СостояниеЭДО);
			Записать = Истина;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
			
Процедура ОбработатьДанные_ЗаполнитьОписаниеОснования(Набор, Записать) 
	
	Описание = Неопределено;
	
	ЗаписиДляУдаления = Новый Массив;
	
	Для Каждого Запись Из Набор Цикл
		
		Если Запись.СсылкаНаОбъект = Неопределено Тогда
			ЗаписиДляУдаления.Добавить(Запись);
			Продолжить;
		КонецЕсли;
		
		Если Запись.СостояниеЭДО <> Перечисления.СостоянияДокументовЭДО.НеСформирован Тогда
			Продолжить;
		КонецЕсли;
		
		Если Описание = Неопределено Тогда
			Описание = ИнтеграцияЭДО.ОписаниеОснованияЭлектронногоДокумента(Запись.СсылкаНаОбъект);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, Описание);
		
		Записать = Истина;
		
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиДляУдаления Цикл
		Набор.Удалить(Запись);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли