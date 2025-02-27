﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обработка заявлений абонента на подключение".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция СледующееЗаявлениеТребующееРеакцииПользователя() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Документы.ЗаявлениеАбонентаСпецоператораСвязи) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаявлениеАбонентаСпецоператораСвязи КАК ЗаявлениеАбонентаСпецоператораСвязи
	|ГДЕ
	|	ЗаявлениеАбонентаСпецоператораСвязи.Статус В (&Одобрено, &Отклонено)
	|	И (НЕ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена
	|			ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена
	|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЭДОЗавершена
	|				И ПОДСТРОКА(ЗаявлениеАбонентаСпецоператораСвязи.НастройкиЭДО, 0, 1000) <> """"
	|				И (ЗаявлениеАбонентаСпецоператораСвязи.ПереиздатьСертификатЭДО
	|					ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.ПодключитьЭДО))
	|	И ЗаявлениеАбонентаСпецоператораСвязи.Ответственный = &Ответственный
	|	И НЕ ЗаявлениеАбонентаСпецоператораСвязи.ПометкаУдаления
	|	И НЕ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка В (&ЗаявленияТребующиеНапоминанияПозже)";
	
	Запрос.УстановитьПараметр("Ответственный", 	Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("Одобрено", 		Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено);
	Запрос.УстановитьПараметр("Отклонено", 		Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено);
	
	Запрос.УстановитьПараметр("ЗаявленияТребующиеНапоминанияПозже", ЗаявленияТребующиеНапоминанияПозже());
	
	РезультатЗапроса 	= Запрос.Выполнить();
	Выборка 			= РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;
	КонецЦикла;

	Возврат Неопределено;
		
КонецФункции

Процедура ВключитьОтслеживаниеИзмененияСтатусаЗаявления(ДокументЗаявление) Экспорт
	
	Если ДокументЗаявление.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		// Повторный запуск задания по одному заявлению вызывает ошибку.
		Задания = ЗаданияПоЗаявлению(ДокументЗаявление);
		Если Задания.Количество() > 0 Тогда
			Возврат;
		КонецЕсли;
		
		Если ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования() Тогда
			Интервал = 30;
		Иначе
			Интервал = 600;
		КонецЕсли;
		
		// Запускаем отслеживание изменения состояния
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ПериодПовтораВТечениеДня  	= Интервал;
		Расписание.ПериодПовтораДней 			= 1;
		
		Параметры = Новый Массив;
		Параметры.Добавить(ДокументЗаявление);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Метаданные", 	Метаданные.РегламентныеЗадания.ОбработкаЗаявленийАбонента);
		ПараметрыЗадания.Вставить("Ключ", 			КлючЗадания(ДокументЗаявление));
		ПараметрыЗадания.Вставить("Параметры", 		Параметры);
		ПараметрыЗадания.Вставить("Расписание", 	Расписание);
		ПараметрыЗадания.Вставить("Использование", 	Истина);
		ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 		10);
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 	3);
		ПараметрыЗадания.Вставить("Наименование", 	НСтр("ru = 'Отслеживание заявления '") + ДокументЗаявление.Номер + НСтр("ru = ' по 1С-Отчетности'"));
		
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЕсли;

КонецПроцедуры

Процедура ОтключитьОтслеживаниеИзменениеСтатусаЗаявления(ДокументЗаявление) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Задания = ЗаданияПоЗаявлению(ДокументЗаявление);
	Для каждого Задание Из Задания Цикл
		РегламентныеЗаданияСервер.УдалитьЗадание(Задание.УникальныйИдентификатор);
	КонецЦикла;

КонецПроцедуры
 
Функция ПолучитьИРазобратьОтветНаЗаявление(
		Знач ДокументЗаявление,
		ЭтоВызовИзМастера = Ложь,
		ОбновитьЗаявление = Ложь) Экспорт
		
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", 					Ложь);
	Результат.Вставить("Статус", 						ДокументЗаявление.Статус);
	Результат.Вставить("СтатусКомментарий", 			ДокументЗаявление.СтатусКомментарий);
	Результат.Вставить("ОтпечатокСертификатаИзОтвета", 	"");
	Результат.Вставить("ИдентификаторАбонента", 		"");
	Результат.Вставить("ПовторятьСоединение", 			Истина);
	Результат.Вставить("УдалосьСоединиться", 			Ложь);
	Результат.Вставить("СтатусИзменился", 				Ложь);
	
	РезультатОбмена = ОбменССерверомПолучитьОтвет(
		ДокументЗаявление,
		ЭтоВызовИзМастера); 
		
	Результат.Вставить("ПовторятьСоединение", 	РезультатОбмена.ПовторятьСоединение);
	Результат.Вставить("УдалосьСоединиться",	РезультатОбмена.УдалосьСоединиться);
	
	ОтветПолучен = РезультатОбмена.Выполнено;
		
	Если ОтветПолучен Тогда
		
		РезультатРазбораОтвета = РегистрацияРазобратьОтвет(ДокументЗаявление, РезультатОбмена);
			
		ОтветРазобран = РезультатРазбораОтвета.Выполнено;
		
		Результат.Вставить("Статус", 			РезультатРазбораОтвета.Статус);
		Результат.Вставить("СтатусКомментарий", РезультатРазбораОтвета.СтатусКомментарий);
		
		Если ОтветРазобран Тогда
			
			Результат.Вставить("Выполнено", 					Истина);
			Результат.Вставить("ОтпечатокСертификатаИзОтвета",	РезультатРазбораОтвета.ОтпечатокСертификатаИзОтвета);
			Результат.Вставить("ИдентификаторАбонента", 		РезультатРазбораОтвета.ИдентификаторАбонента);
			Результат.Вставить("СтатусИзменился", 				РезультатРазбораОтвета.Статус <> ДокументЗаявление.Статус);
			
			Если ОбновитьЗаявление Тогда
				РеквизитыДляЗаписи = Новый Структура();
				РеквизитыДляЗаписи.Вставить("СтатусКомментарий", 	РезультатРазбораОтвета.СтатусКомментарий);
				РеквизитыДляЗаписи.Вставить("ДатаПолученияОтвета", 	РезультатОбмена.ДатаОтвета);
				РеквизитыДляЗаписи.Вставить("Статус", 				РезультатРазбораОтвета.Статус);
				
				ОбновитьРеквизитыЗаявления(ДокументЗаявление, РеквизитыДляЗаписи);
			КонецЕсли;
			
		КонецЕсли;
		
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(РезультатОбмена.ИмяКаталогаСОтветом);
		
	ИначеЕсли РезультатОбмена.УдалосьСоединиться И НЕ ОтветПолучен Тогда 
		
		Если ОбновитьЗаявление Тогда
			РеквизитыДляЗаписи = Новый Структура();
			РеквизитыДляЗаписи.Вставить("СтатусКомментарий", 	РезультатОбмена.СтатусКомментарий);
			РеквизитыДляЗаписи.Вставить("ДатаПолученияОтвета", 	РезультатОбмена.ДатаОтвета);
			РеквизитыДляЗаписи.Вставить("Статус", 				РезультатОбмена.Статус);
			
			ОбновитьРеквизитыЗаявления(ДокументЗаявление, РеквизитыДляЗаписи);
		КонецЕсли;
		
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(РезультатОбмена.ИмяКаталогаСОтветом);
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ОтправленныеЗаявленияАбонентов(
		ДокументЗаявление 	 = Неопределено,
		Организация 		 = Неопределено,
		ТипЗаявления 		 = Неопределено,
		ИзмененныеРеквизиты  = Неопределено,
		ВключаяЭДО           = Ложь) Экспорт
		
	Если НЕ ПравоДоступа("Чтение", Метаданные.Документы.ЗаявлениеАбонентаСпецоператораСвязи) Тогда
		Возврат Новый Массив;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	
	Если ИзмененныеРеквизиты = Неопределено Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявлениеАбонентаСпецоператораСвязи КАК ЗаявлениеАбонентаСпецоператораСвязи
		|ГДЕ
		|	НЕ ЗаявлениеАбонентаСпецоператораСвязи.ПометкаУдаления
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Статус В (&Отклонено, &Одобрено)
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена
		|			ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.Статус = &Отправлено
		|			ИЛИ &ВключаяЭДО
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЭДОЗавершена
		|				И ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.Статус = &Отклонено
		|				И ПОДСТРОКА(ЗаявлениеАбонентаСпецоператораСвязи.НастройкиЭДО, 0, 1000) <> """"
		|				И (ЗаявлениеАбонентаСпецоператораСвязи.ПодключитьЭДО
		|					ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.ПереиздатьСертификатЭДО))
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Организация = &Организация
		|				И &ЕстьОтборПоОрганизации
		|			ИЛИ НЕ &ЕстьОтборПоОрганизации)
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка В (&Заявления)
		|				И &ЕстьОтборПоЗаявлению
		|			ИЛИ НЕ &ЕстьОтборПоЗаявлению)
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.ТипЗаявления = &ТипЗаявления
		|				И &ЕстьОтборПоТипу
		|			ИЛИ НЕ &ЕстьОтборПоТипу)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаявлениеАбонентаСпецоператораСвязи.ДатаОтправкиЗаявления УБЫВ";
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявлениеАбонентаСпецоператораСвязи.ИзменившиесяРеквизитыВторичногоЗаявления КАК ЗаявлениеАбонентаСпецоператораСвязи
		|ГДЕ
		|	НЕ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.ПометкаУдаления
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.Статус В (&Отклонено, &Одобрено)
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.НастройкаЗавершена
		|			ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.Статус = &Отправлено
		|			ИЛИ &ВключаяЭДО
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.НастройкаЭДОЗавершена
		|				И ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.НастройкаЗавершена
		|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.Статус = &Отклонено
		|				И ПОДСТРОКА(ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.НастройкиЭДО, 0, 1000) <> """"
		|				И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.ПодключитьЭДО
		|					ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.ПереиздатьСертификатЭДО))
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.Организация = &Организация
		|				И &ЕстьОтборПоОрганизации
		|			ИЛИ НЕ &ЕстьОтборПоОрганизации)
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка В (&Заявления)
		|				И &ЕстьОтборПоЗаявлению
		|			ИЛИ НЕ &ЕстьОтборПоЗаявлению)
		|	И (ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.ТипЗаявления = &ТипЗаявления
		|				И &ЕстьОтборПоТипу
		|			ИЛИ НЕ &ЕстьОтборПоТипу)
		|	И ЗаявлениеАбонентаСпецоператораСвязи.ИзмененныйРеквизит В(&ИзмененныеРеквизиты)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка.Дата УБЫВ";

		Запрос.УстановитьПараметр("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Отправлено", Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено);
	Запрос.УстановитьПараметр("Одобрено", 	Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено);
	Запрос.УстановитьПараметр("Отклонено", 	Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено);
	
	Запрос.УстановитьПараметр("Организация", 			Организация);
	Запрос.УстановитьПараметр("ЕстьОтборПоОрганизации", ЗначениеЗаполнено(Организация));
	
	Если ТипЗнч(ДокументЗаявление) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		
		Заявления = Новый Массив;
		Заявления.Добавить(ДокументЗаявление);
		
		Запрос.УстановитьПараметр("Заявления", Заявления);
		
	Иначе
		
		Заявления = ДокументЗаявление;
		Запрос.УстановитьПараметр("Заявления", Заявления);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ЕстьОтборПоЗаявлению", 	ЗначениеЗаполнено(ДокументЗаявление));
	
	Запрос.УстановитьПараметр("ТипЗаявления", 		ТипЗаявления);
	Запрос.УстановитьПараметр("ЕстьОтборПоТипу", 	ЗначениеЗаполнено(ТипЗаявления));
	Запрос.УстановитьПараметр("ВключаяЭДО", 	    ВключаяЭДО);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
КонецФункции

// Проверяет наличие отправленных или одобренных заявления по 1С-Отчетности
// Внимание! Не менять без согласования с БП3. Вызывается из БП3.
// 
// Возвращаемое значение:
//  Булево - есть ли отправленные или одобренные заявлений
//
Функция ЕстьОтправленныеИлиОдобренныеЗаявления() Экспорт
		
	Если НЕ ПравоДоступа("Чтение", Метаданные.Документы.ЗаявлениеАбонентаСпецоператораСвязи) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	
	Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявлениеАбонентаСпецоператораСвязи.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаявлениеАбонентаСпецоператораСвязи КАК ЗаявлениеАбонентаСпецоператораСвязи
	|ГДЕ
	|	НЕ ЗаявлениеАбонентаСпецоператораСвязи.ПометкаУдаления
	|	И (ЗаявлениеАбонентаСпецоператораСвязи.Статус = &Отправлено
	|				И ЗаявлениеАбонентаСпецоператораСвязи.ДатаОтправкиЗаявления > &ДатаОтправкиЗаявления
	|			ИЛИ ЗаявлениеАбонентаСпецоператораСвязи.Статус = &Одобрено
	|				И НЕ ЗаявлениеАбонентаСпецоператораСвязи.НастройкаЗавершена)";
	
	ДвеНеделиНазад = ТекущаяДатаСеанса() - 14 * 24 * 60 * 60;
	
	Запрос.УстановитьПараметр("Отправлено", Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено);
	Запрос.УстановитьПараметр("Одобрено", 	Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено);
	Запрос.УстановитьПараметр("ДатаОтправкиЗаявления", ДвеНеделиНазад);
	
	Запрос.Текст = Текст;
	
	Результат 		= Запрос.Выполнить();
	ЕстьЗаявления 	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка").Количество() > 0;
	
	Возврат ЕстьЗаявления;
		
КонецФункции

Функция ОбновитьРеквизитыЗаявления(Документ, РеквизитыДокумента) Экспорт
	
	Если Документ = Неопределено Тогда
		Возврат Ложь;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		ДокументОбъект = Документ.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документ;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ДокументОбъект.Прочитать();
		
		// Копируем в заявление все новые свойства.
		ЗаполнитьЗначенияСвойств(ДокументОбъект, РеквизитыДокумента);
		
		// ИдентификаторКлючевогоКонтейнера
		Если РеквизитыДокумента.Свойство("ИдентификаторКлючевогоКонтейнера") Тогда
			
			Если ЗначениеЗаполнено(ДокументОбъект.УчетнаяЗапись) Тогда 
				ЗаблокироватьДанныеДляРедактирования(ДокументОбъект.УчетнаяЗапись);
				УчетнаяЗапись = ДокументОбъект.УчетнаяЗапись.ПолучитьОбъект();
				УчетнаяЗапись.ИдентификаторДокументооборота = РеквизитыДокумента.ИдентификаторКлючевогоКонтейнера;
				УчетнаяЗапись.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		ДокументОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обработка заявлений.Обновление статуса'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСтруктуруРеквизитовЗаявления(Документ) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("СпецОператорСвязи", 					Документ.СпецОператорСвязи);
	ДополнительныеПараметры.Вставить("ПутьКонтейнерЗакрытогоКлюча", 		Документ.ПутьКонтейнерЗакрытогоКлюча);
	ДополнительныеПараметры.Вставить("СтатусКомментарий", 					Документ.СтатусКомментарий);
	ДополнительныеПараметры.Вставить("ИдентификаторДокументооборота", 		Документ.ИдентификаторДокументооборота);
	ДополнительныеПараметры.Вставить("ДатаПолученияОтвета", 				Документ.ДатаПолученияОтвета);
	ДополнительныеПараметры.Вставить("Статус", 								Документ.Статус);
	ДополнительныеПараметры.Вставить("Организация", 						Документ.Организация);
	ДополнительныеПараметры.Вставить("НастройкаЗавершена", 					Документ.НастройкаЗавершена);
	ДополнительныеПараметры.Вставить("Дата", 								Документ.Дата);
	ДополнительныеПараметры.Вставить("Номер", 								Документ.Номер);
	ДополнительныеПараметры.Вставить("ЭлектроннаяПодписьВМоделиСервиса", 	Документ.ЭлектроннаяПодписьВМоделиСервиса);
	ДополнительныеПараметры.Вставить("ТелефонМобильныйДляАвторизации", 		Документ.ТелефонМобильныйДляАвторизации);
	ДополнительныеПараметры.Вставить("ЭтоУпрощенноеЗаявление", 				Документ.ЭтоУпрощенноеЗаявление);
	ДополнительныеПараметры.Вставить("ПодписатьЭП", 						Документ.ПодписатьЭП);
	ДополнительныеПараметры.Вставить("ТипЗаявления", 						Документ.ТипЗаявления);
	ДополнительныеПараметры.Вставить("ПометкаУдаления", 					Документ.ПометкаУдаления);
	ДополнительныеПараметры.Вставить("НастройкиЭДО", 						Документ.НастройкиЭДО);
	ДополнительныеПараметры.Вставить("НастройкаЭДОЗавершена", 				Документ.НастройкаЭДОЗавершена);
	ДополнительныеПараметры.Вставить("ПодключитьЭДО", 						Документ.ПодключитьЭДО);
	ДополнительныеПараметры.Вставить("ПереиздатьСертификатЭДО", 			Документ.ПереиздатьСертификатЭДО);
	ДополнительныеПараметры.Вставить("НомерОсновнойПоставки1с", 			Документ.НомерОсновнойПоставки1с);
	ДополнительныеПараметры.Вставить("СпособПолученияСертификата", 			Документ.СпособПолученияСертификата);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция СформироватьИОтправитьЗаявлениеВМоделиСервиса(ДокументЗаявление, Алгоритм) Экспорт
	
	РезультатВыгрузки 		  = ОбработкаЗаявленийАбонента.ВыгрузитьЗаявлениеАбонентаВМоделиСервиса(ДокументЗаявление, Алгоритм);
	УдалосьВыгрузитьЗаявление = РезультатВыгрузки.Выполнено;
	
	Если УдалосьВыгрузитьЗаявление Тогда
		
		Статус 					= ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено");
		ДатаОтправкиЗаявления 	= ТекущаяДатаСеанса();

		РеквизитыДокументаДляЗаписи = Новый Структура;
		РеквизитыДокументаДляЗаписи.Вставить("ПутьКонтейнерЗакрытогоКлюча", Неопределено);
		РеквизитыДокументаДляЗаписи.Вставить("Статус",						Статус);
		РеквизитыДокументаДляЗаписи.Вставить("ДатаОтправкиЗаявления",		ДатаОтправкиЗаявления);
		РеквизитыДокументаДляЗаписи.Вставить("СтатусКомментарий", 			"");
		
		ОбновитьРеквизитыЗаявления(ДокументЗаявление.Ссылка, РеквизитыДокументаДляЗаписи);
			
	Иначе
		
		Статус 					= ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Подготовлено");
		ДатаОтправкиЗаявления 	= ТекущаяДатаСеанса();
		
	КонецЕсли;
	
	РезультатВыгрузки.Вставить("Статус", 				Статус);
	РезультатВыгрузки.Вставить("ДатаОтправкиЗаявления", ДатаОтправкиЗаявления);
		
	Возврат РезультатВыгрузки;
		
КонецФункции

Функция ОбработатьИзменениеСтатусаЗаявленияАбонентаВМоделиСервиса(ДокументЗаявление) Экспорт
	
	Результат = МенеджерСервисаКриптографии.ПолучитьСтатусЗаявленияНаПодключение(ДокументЗаявление.ИдентификаторДокументооборота);
	
	Если Не Результат.Выполнено Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ОписаниеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Если Результат.Статус = "Исполняется" Тогда
		Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено;
	ИначеЕсли Результат.Статус = "Отклонено" Тогда
		Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено;
	ИначеЕсли Результат.Статус = "Исполнено" Тогда
		Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено;
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Пояснение = Результат.Пояснение;

	Если ЗначениеЗаполнено(Результат.Токен) 
		И ЗначениеЗаполнено(Результат.ИдентификаторСертификата) Тогда
		СпособПодтвержденияКриптоопераций = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументЗаявление, "СпособПодтвержденияКриптоопераций");
		ОбновитьДанныеДолговременногоТокена(Результат.Токен, Результат.ИдентификаторСертификата, СпособПодтвержденияКриптоопераций);
	КонецЕсли;
	
	РеквизитыДляЗаписи = Новый Структура;
	РеквизитыДляЗаписи.Вставить("Статус", Статус);
	РеквизитыДляЗаписи.Вставить("ДатаПолученияОтвета", ТекущаяДатаСеанса());
	РеквизитыДляЗаписи.Вставить("СтатусКомментарий", Пояснение);
	
	Возврат ОбработкаЗаявленийАбонентаВызовСервера.ОбновитьРеквизитыЗаявления(ДокументЗаявление, РеквизитыДляЗаписи);
	
КонецФункции

Функция ПолучитьОтветСервераНаЗаявлениеАбонента(ДокументЗаявление) Экспорт
	
	РезультатОтветаСервера = Новый Структура;
	РезультатОтветаСервера.Вставить("СтатусИзменился", Ложь);
	
	РеквизитыДокумента	= ПолучитьСтруктуруРеквизитовЗаявления(ДокументЗаявление);
	
	Ответ = Новый Структура;
	Ответ.Вставить("РезультатОтветаСервера", РезультатОтветаСервера);
	Ответ.Вставить("РеквизитыДокумента", 	 РеквизитыДокумента);
	
	// Для заявления с ЭП в модели сервиса обязательно нужно сначала получить идентификатор ключевого контейнера.
	Если РеквизитыДокумента.ЭлектроннаяПодписьВМоделиСервиса Тогда
		
		ЗаявлениеОбработано = ОбработатьИзменениеСтатусаЗаявленияАбонентаВМоделиСервиса(ДокументЗаявление);
		
		Если ЗаявлениеОбработано Тогда
			
			// Обновляем структуру реквизитов в доп. параметрах после обращения к серверу.
			РеквизитыДокумента	= ПолучитьСтруктуруРеквизитовЗаявления(ДокументЗаявление);
			
		Иначе
			
			Возврат Ответ;
			
		КонецЕсли;
		
	КонецЕсли;
		
	// Получаем ответ от сервера.
	Если РеквизитыДокумента.ЭлектроннаяПодписьВМоделиСервиса 
		И РеквизитыДокумента.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено Тогда
		
		РезультатОтветаСервера = Новый Структура;
		РезультатОтветаСервера.Вставить("ОтпечатокСертификатаИзОтвета", "");
		РезультатОтветаСервера.Вставить("ИдентификаторАбонента", 		"");
		РезультатОтветаСервера.Вставить("СтатусИзменился", 				Истина);
		РезультатОтветаСервера.Вставить("Статус", 						РеквизитыДокумента.Статус);
		РезультатОтветаСервера.Вставить("Выполнено", 					Истина);
		РезультатОтветаСервера.Вставить("ПовторятьСоединение", 			Ложь);
		
	Иначе
		
		РезультатОтветаСервера = ПолучитьИРазобратьОтветНаЗаявление(ДокументЗаявление,,Истина);
		
		ПолученОтветНаЗаявление = РезультатОтветаСервера.Выполнено;
		ПовторятьСоединение 	= РезультатОтветаСервера.ПовторятьСоединение;
		
		Если НЕ ПолученОтветНаЗаявление И ПовторятьСоединение Тогда
			РезультатОтветаСервера.Вставить("СообщитьОбОтсутствииИнтернета", Истина);
		Иначе
			// Обновляем структуру реквизитов в доп. параметрах после обращения к серверу.
			РеквизитыДокумента = ПолучитьСтруктуруРеквизитовЗаявления(ДокументЗаявление);
		КонецЕсли;
		
	КонецЕсли;
	
	Ответ.Вставить("РезультатОтветаСервера", РезультатОтветаСервера);
	Ответ.Вставить("РеквизитыДокумента", 	 РеквизитыДокумента);
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаданияПоЗаявлению(ДокументЗаявление)
	
	// Задание ищется по ключу - ссылка на заявление абонента
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Ключ", КлючЗадания(ДокументЗаявление));
	ДополнительныеПараметры.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОбработкаЗаявленийАбонента);
	
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(ДополнительныеПараметры);
	
	Возврат Задания;
	
КонецФункции

Функция КлючЗадания(ДокументЗаявление)
	
	Возврат ДокументЗаявление.ИдентификаторДокументооборота;
	
КонецФункции

Функция ОбменССерверомПолучитьОтвет(ДокументЗаявление, ЭтоВызовИзМастера)
	
	ИдентификаторДокументооборота 	= ДокументЗаявление.ИдентификаторДокументооборота;
	СпецоператорСвязи 				= ДокументЗаявление.СпецоператорСвязи;
	
	ИмяКаталогаСОтветомНаСервере 	= ОперацииСФайламиЭДКО.СоздатьВременныйКаталог();
	ИмяФайлаОтвета 					= ИмяКаталогаСОтветомНаСервере + "ответ.zip";
	
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", 			Ложь);
	Результат.Вставить("ДатаОтвета", 			Неопределено);
	Результат.Вставить("СтатусКомментарий", 	ДокументЗаявление.СтатусКомментарий);
	Результат.Вставить("ИмяКаталогаСОтветом", 	ИмяКаталогаСОтветомНаСервере);
	Результат.Вставить("ИмяФайлаОтвета", 		ИмяФайлаОтвета);
	Результат.Вставить("Статус", 				ДокументЗаявление.Статус);
	Результат.Вставить("УдалосьСоединиться", 	Ложь);
	Результат.Вставить("ПовторятьСоединение", 	Истина);
	
	Сервис = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОбменССерверомСоздатьСервис(
		СпецоператорСвязи, 
		ЭтоВызовИзМастера, 
		,
		, 
		Ложь);
		
	Если Сервис = Неопределено Тогда
		Результат.Вставить("СтатусКомментарий", НСтр("ru = 'Не удалось соединиться с сервером'"));
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		XDTOРезультат = Сервис.ReceivePacket(Строка(идентификаторДокументооборота));
	Исключение
		Результат.Вставить("СтатусКомментарий", НСтр("ru = 'Не удалось соединиться с сервером'"));
		Возврат Результат;
	КонецПопытки;
	
	Результат.Вставить("УдалосьСоединиться", 	Истина);
	Результат.Вставить("ПовторятьСоединение", 	Ложь);
	
	ЧтениеXML 		= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XDTOРезультат);
	
	ПостроительДОМ 	= Новый ПостроительDOM();
	ДОМ 			= ПостроительДОМ.Прочитать(ЧтениеXML);
	УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("code");
	кодРезультата 	= УзелDOM[0].ТекстовоеСодержимое;
	
	Результат.Вставить("ДатаОтвета", ТекущаяДатаСеанса());
	
	Если кодРезультата = "0" Тогда
		УзелDOM = ДОМ.ПолучитьЭлементыПоИмени("packet");
		
		Если УзелDOM.Количество() > 0 Тогда
			
			ДвоичныеДанные = Base64Значение(УзелDOM[0].ТекстовоеСодержимое);
			ДвоичныеДанные.Записать(ИмяФайлаОтвета);
			ЧтениеXML.Закрыть();
			
			Результат.Вставить("Выполнено", Истина);
			
		Иначе
			
			СтатусКомментарий = НСтр("ru = 'При получении ответа возникла ошибка: ответ нечитаем'");
			Результат.Вставить("СтатусКомментарий", СтатусКомментарий);
			
		КонецЕсли;
		
	ИначеЕсли Кодрезультата = "1" Тогда
		
		СтатусКомментарий = НСтр("ru = 'Заявление еще не обработано сервером, попробуйте позже.'");
		Результат.Вставить("СтатусКомментарий", СтатусКомментарий);
		
	Иначе
		
		УзелDOM = ДОМ.ПолучитьЭлементыПоИмени("errorMessage");
		Если УзелDOM.Количество() > 0 Тогда
			сообщениеОшибки = УзелDOM[0].ТекстовоеСодержимое;
			СтатусКомментарий = НСтр("ru = 'При получении ответа возникла ошибка: '") + сообщениеОшибки;
		Иначе
			СтатусКомментарий = НСтр("ru = 'При получении ответа возникла ошибка: '") + кодРезультата;
		КонецЕсли;
		
		Результат.Вставить("СтатусКомментарий", СтатусКомментарий);
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция РегистрацияРазобратьОтвет(ДокументЗаявление, РезультатОбмена)
		
	Результат = Новый Структура;
	Результат.Вставить("Выполнено", 					Ложь);
	Результат.Вставить("СтатусКомментарий", 			"");
	Результат.Вставить("Статус", 						ДокументЗаявление.Статус);
	Результат.Вставить("ИдентификаторАбонента", 		"");
	Результат.Вставить("ОтпечатокСертификатаИзОтвета", 	"");
	
	ИмяКаталогаСОтветом 	= РезультатОбмена.ИмяКаталогаСОтветом;
	ИмяФайлаОтвета 			= РезультатОбмена.ИмяФайлаОтвета; 
		
	Попытка
		Архив1 = Новый ЧтениеZipФайла(ИмяФайлаОтвета);
		
		Для Счетчик = 0 по Архив1.Элементы.Количество() - 1 Цикл
			
			Если Архив1.Элементы[Счетчик].расширение = "bin" Тогда
				
				Архив1.Извлечь(Архив1.Элементы[Счетчик], ИмяКаталогаСОтветом);
				Архив2 = Новый ЧтениеZipФайла(ИмяКаталогаСОтветом + Архив1.Элементы[Счетчик].имя);
				Архив2.Извлечьвсе(ИмяКаталогаСОтветом);
				
				ДокументDOM = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗагрузитьФайлXML(ИмяКаталогаСОтветом + "file");
				
				// Отпечаток
				ОтпечатокСертификатаИзОтвета = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьЗначениеУзлаXML(ДокументDOM,"ОтпечатокСертификата");
				Результат.Вставить("ОтпечатокСертификатаИзОтвета", ОтпечатокСертификатаИзОтвета);
				
				// Комментарий
				Результат.Вставить("СтатусКомментарий", ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьЗначениеУзлаXML(ДокументDOM,"Результат"));
				
				// Успешность регистрации заявления
				РезультатРегистрации = Булево(ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьЗначениеУзлаXML(ДокументDOM,"РегистрацияУспешна"));
				Если РезультатРегистрации Тогда
					
					ИдентификаторАбонента = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьЗначениеУзлаXML(ДокументDOM,"ИдентификаторАбонента");
					
					Результат.Вставить("Статус", 				Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено);
					Результат.Вставить("ИдентификаторАбонента",	ИдентификаторАбонента);
					Результат.Вставить("Выполнено", 			Истина);
					
					Возврат Результат;
					
				Иначе
					
					Результат.Вставить("Статус", 	Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено);
					Результат.Вставить("Выполнено", Истина);
									
					Возврат Результат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Исключение
		
		СтатусКомментарий = НСтр("ru = 'Ошибка. Не удалось разобрать ответ сервера.'");
		
		Результат.Вставить("Статус", 			Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено);
		Результат.Вставить("СтатусКомментарий", СтатусКомментарий);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Процедура ОчиститьЗаявленияТребующиеНапоминанияПозжеСПрошедшимСроком()
	
	Заявления = ХранилищеОбщихНастроек.Загрузить(ОбработкаЗаявленийАбонента.КлючЗаявленийТребующихНапоминанияПозже());
	
	Если Заявления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Количество 		= Заявления.Количество();
	ТекущаяСтрока 	= 0;

	Пока ТекущаяСтрока <= Количество - 1 Цикл
		
		Если Заявления[ТекущаяСтрока].Дата < ТекущаяДатаСеанса() Тогда
			Заявления.Удалить(ТекущаяСтрока);
			Количество = Количество - 1;
		Иначе
			ТекущаяСтрока = ТекущаяСтрока + 1;
		КонецЕсли;
		
	Конеццикла; 
	
	ХранилищеОбщихНастроек.Сохранить(ОбработкаЗаявленийАбонента.КлючЗаявленийТребующихНапоминанияПозже(), , Заявления);

КонецПроцедуры

Функция ЗаявленияТребующиеНапоминанияПозже() Экспорт
	
	ОчиститьЗаявленияТребующиеНапоминанияПозжеСПрошедшимСроком();
	Заявления = ХранилищеОбщихНастроек.Загрузить(ОбработкаЗаявленийАбонента.КлючЗаявленийТребующихНапоминанияПозже());
	
	Если Заявления = Неопределено Тогда
		Возврат Новый Массив;
	Иначе
		Возврат Заявления.ВыгрузитьКолонку("Заявление");
	КонецЕсли;

КонецФункции

Функция ОбновитьДанныеДолговременногоТокена(ДолговременныйТокен, ИдентификаторСертификата, Знач СпособПодтверждения = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если СпособПодтверждения = Неопределено Тогда
		СпособПодтверждения = Перечисления.СпособыПодтвержденияКриптоопераций.СессионныйТокен;
	КонецЕсли;
	
	Если СпособПодтверждения = Перечисления.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен Тогда
		ИмяВеткиХранения				= СервисКриптографииСлужебный.ИмяНастройкиДлительногоМаркерБезопасностиСертификата(ИдентификаторСертификата);
		ДлительныйМаркерБезопасности 	= ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИмяВеткиХранения, "ДлительныйМаркерБезопасности", Ложь);
		
		Если ДлительныйМаркерБезопасности = Неопределено Тогда
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ИмяВеткиХранения, ДолговременныйТокен, "ДлительныйМаркерБезопасности"); 
		КонецЕсли;
		
		ЭлектроннаяПодписьВМоделиСервиса.УстановитьСвойстваРасшифрованияПодписания(ИдентификаторСертификата);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции	

#КонецОбласти
