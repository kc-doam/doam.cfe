﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьУчастников(Процесс) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.УчастникиПроцессов.СоздатьНаборЗаписей();
	Набор.Отбор.Процесс.Установить(Процесс);
	Набор.Прочитать();
	Возврат Набор.Выгрузить();
	
КонецФункции

// Записывает набор участников переданного процесса по переданной таблице участников.
//
// Параметры:
//   Процесс - БизнесПроцессСсылка - процесс, участников которого нужно записать.
//   ТаблицаИсточник - ТаблицаЗначений - участники, имена колонок соответствуют регистру.
//   Замещать - Булево - Истина, если набор следует записать с замещением.
//
Процедура ЗаписатьНаборПоПроцессу(Процесс, Знач ТаблицаИсточник, Замещать = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Процесс) Тогда
		Возврат;
	КонецЕсли;
	
	Набор = РегистрыСведений.УчастникиПроцессов.СоздатьНаборЗаписей();
	Набор.Отбор.Процесс.Установить(Процесс);
	
	Для каждого ИсточникСтрока Из ТаблицаИсточник Цикл
		
		Если Не ЗначениеЗаполнено(ИсточникСтрока.Участник) Тогда
			Продолжить;
		КонецЕсли;
		
		Запись = Набор.Добавить();
		Запись.Процесс = Процесс;
		Запись.Участник = ИсточникСтрока.Участник;
		
		ЗаполнитьУстаревшиеИзмерения(Запись);
		
	КонецЦикла;
	
	Набор.Записать(Замещать);
	
КонецПроцедуры

Процедура ОбновитьВсеДанные() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Набор = РегистрыСведений.УчастникиПроцессов.СоздатьНаборЗаписей();
		Набор.Записать();
		
		ШаблонТекстаЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1000
			|	ТаблицаПроцесса.Ссылка
			|ИЗ
			|	БизнесПроцесс.%ИмяПроцесса% КАК ТаблицаПроцесса
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчастникиПроцессов КАК УчастникиПроцессов
			|		ПО ТаблицаПроцесса.Ссылка = УчастникиПроцессов.Процесс
			|ГДЕ
			|	УчастникиПроцессов.Процесс ЕСТЬ NULL
			|	И НЕ ТаблицаПроцесса.Ссылка В (&МассивИсключений)";
			
		МассивИсключений = Новый Массив;
		ТаблицаНабора = РегистрыСведений.УчастникиПроцессов.СоздатьНаборЗаписей().ВыгрузитьКолонки();
			
		Для Каждого МетаданныеПроцесса Из Метаданные.БизнесПроцессы Цикл
			
			РезультатПустой = Ложь;
			Пока Не РезультатПустой Цикл
				
				Запрос = Новый Запрос(СтрЗаменить(ШаблонТекстаЗапроса, "%ИмяПроцесса%", МетаданныеПроцесса.Имя));
				Запрос.УстановитьПараметр("МассивИсключений", МассивИсключений);
				Результат = Запрос.Выполнить();
				РезультатПустой = Результат.Пустой();
				
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
					
					ПроцессСсылка = Выборка.Ссылка;
					ПроцессОбъект = ПроцессСсылка.ПолучитьОбъект();
					
					ТаблицаНабора.Очистить();
					
					ЕстьУчастники = Ложь;
					Участники = ПраваДоступаНаБизнесПроцессы.ПолучитьТаблицуУчастниковПроцесса(ПроцессОбъект);
					Для Каждого Участник Из Участники Цикл
						ЕстьУчастники = ЗначениеЗаполнено(Участник.Участник);
						Запись = ТаблицаНабора.Добавить();
						ЗаполнитьЗначенияСвойств(Запись, Участник);
						Запись.Процесс = ПроцессСсылка;
					КонецЦикла;
					
					СоставРГ = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(ПроцессСсылка);
					Для Каждого СтрокаРГ Из СоставРГ Цикл
						ЕстьУчастники = ЗначениеЗаполнено(СтрокаРГ.Участник);
						Запись = ТаблицаНабора.Добавить();
						ЗаполнитьЗначенияСвойств(Запись, СтрокаРГ);
						Запись.Процесс = ПроцессСсылка;
					КонецЦикла;
					
					ТаблицаНабора.Свернуть("Процесс, Участник");
					РегистрыСведений.УчастникиПроцессов.ЗаписатьНаборПоПроцессу(ПроцессСсылка, ТаблицаНабора, Ложь);
					
					Если Не ЕстьУчастники Тогда
						МассивИсключений.Добавить(ПроцессСсылка);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет устаревшие измерения записи регистра.
//
Процедура ЗаполнитьУстаревшиеИзмерения(Запись)
	
	Если ТипЗнч(Запись.Участник) <> Тип("СправочникСсылка.ПолныеРоли") Тогда
		
		Запись.УдалитьУчастник = Запись.Участник;
		Запись.УдалитьОсновнойОбъектАдресации = Неопределено;
		Запись.УдалитьДополнительныйОбъектАдресации = Неопределено;
		
	Иначе
		
		РеквизитыРоли = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Участник,
			"Владелец, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
		Запись.УдалитьУчастник = РеквизитыРоли.Владелец;
		Запись.УдалитьОсновнойОбъектАдресации = РеквизитыРоли.ОсновнойОбъектАдресации;
		Запись.УдалитьДополнительныйОбъектАдресации = РеквизитыРоли.ДополнительныйОбъектАдресации;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
