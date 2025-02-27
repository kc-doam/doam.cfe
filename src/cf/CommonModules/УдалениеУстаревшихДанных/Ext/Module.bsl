﻿
// Обработчик регл. задания УдалениеУстаревшихДанных
// 
Процедура ВыполнитьУдаление() Экспорт
	
	Отказ = Ложь;
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.УдалениеУстаревшихДанных, Отказ);
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерыУдаляемыхОбъектов = МенеджерыВсехУдаляемыхОбъектов();
	КоличествоТиповДанныхКУдалению = МенеджерыУдаляемыхОбъектов.Количество();
	
	ОбработанныеМенеджеры = Новый Соответствие;
	
	Пока ОбработанныеМенеджеры.Количество() < КоличествоТиповДанныхКУдалению Цикл
	
		Для Каждого Менеджер Из МенеджерыУдаляемыхОбъектов Цикл
			
			Если ОбработанныеМенеджеры.Получить(Менеджер) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЕстьДанныеКУдалению = Ложь;
			
			Попытка
				ЕстьДанныеКУдалению = Менеджер.УдалитьПорциюУстаревшихДанных();
			Исключение
				ТекстОшибки = "" + Менеджер + ": " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Удаление устаревших данных'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.НайтиПоТипу(ТипЗнч(Менеджер)),,
					ТекстОшибки);
			КонецПопытки;
			
			Если Не ЕстьДанныеКУдалению Тогда
				ОбработанныеМенеджеры.Вставить(Менеджер, Истина);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция МенеджерыВсехУдаляемыхОбъектов()
	
	Результат = Новый Массив;
	Результат.Добавить(Справочники.ДескрипторыДоступаОбъектов);
	Результат.Добавить(Справочники.ДескрипторыДоступаРегистров);
	Результат.Добавить(Справочники.КоллекцииЗначенийДоступа);
	Результат.Добавить(РегистрыСведений.ЗамерыМетрик);
	Результат.Добавить(РегистрыСведений.СведенияОМобильныхОнлайнКлиентах);
	
	Если ПолучитьФункциональнуюОпцию("УдалятьНеактивныеВерсии") Тогда
		Результат.Добавить(Справочники.ВерсииФайлов);
	КонецЕсли;
	
	Если Константы.ИспользоватьВерсионированиеОбъектов.Получить() Тогда
		Результат.Добавить(РегистрыСведений.ВерсииОбъектов);
	КонецЕсли;
	
	Результат.Добавить(РегистрыСведений.HTMLПредставленияСодержанияПисем);
	Результат.Добавить(РегистрыСведений.ПромежуточныеРезультатыПоискаПисем);
	
	Если Константы.ВестиПротоколДоставкиПочты.Получить() Тогда
		Результат.Добавить(РегистрыСведений.ПротоколДоставкиПочты);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВстроеннуюПочту") Тогда
		Результат.Добавить(ЖурналыДокументов.ЭлектроннаяПочта);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
