﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	
	Если Исполнители.Количество() = 0 Тогда
		МассивПолей.Добавить("Исполнители");
	КонецЕсли;	
	
	Возврат МассивПолей;
	
КонецФункции	

//Формирует текстовое представление бизнес-процесса, создаваемого по шаблону
Функция СформироватьСводкуПоШаблону() Экспорт
	
	Результат = ШаблоныБизнесПроцессов.ПолучитьОбщуюЧастьОписанияШаблона(Ссылка);
	
	Если ЗначениеЗаполнено(НаименованиеБизнесПроцесса) Тогда
		Результат = Результат + НСтр("ru = 'Заголовок'") + ": " + НаименованиеБизнесПроцесса + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Описание) Тогда
		Результат = Результат + НСтр("ru = 'Описание'") + ": " + Описание + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Важность) Тогда
		Результат = Результат + НСтр("ru = 'Важность'") + ": " + Строка(Важность) + Символы.ПС;
	КонецЕсли;
	
	Если Исполнители.Количество() > 0 Тогда
		Результат = Результат + НСтр("ru = 'Согласующие'") + ": ";
		Для Каждого Исполнитель Из Исполнители Цикл
			Результат = Результат + Исполнитель.Исполнитель
				+ ";" + Символы.ПС;
		КонецЦикла;
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 2);
		Результат = Результат + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантСогласования) Тогда
		Результат = Результат + Нстр("ru = 'Порядок согласования'") + ": " + Строка(ВариантСогласования) + Символы.ПС;
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(ЭтотОбъект);
	ДлительностьПроцессаСтрокой = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
		ДлительностьПроцесса.СрокИсполненияПроцессаДни,
		ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
		ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
	Если ЗначениеЗаполнено(ДлительностьПроцессаСтрокой) Тогда
		Результат = Результат + Нстр("ru = 'Срок'") + ": "
			+ ДлительностьПроцессаСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Заполняет предопределенный шаблон по умолчанию.
// Предназначена для вызова из предопределенного объекта.
// Если объект не предопределенный, то вызов процедуры приведет к исключению.
//
Процедура ЗаполнитьШаблонПоУмолчанию() Экспорт
	
	Если Ссылка <> Справочники.ШаблоныСогласования.ПоУмолчанию Тогда
		ВызватьИсключение НСтр("ru = 'Процедура ЗаполнитьШаблонПоУмолчанию предназначена для вызова из предопределенного шаблона.'");
	КонецЕсли;
	
	Автор = Справочники.Пользователи.ПустаяСсылка();
	Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Параллельно;
	ВариантУстановкиСрокаОбработкиРезультатов = Перечисления.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок;
	ВладелецШаблона = Неопределено;
	ДобавлятьНаименованиеПредмета = Истина;
	ИспользоватьУсловия = Ложь;
	ИсходныйШаблон = Справочники.ШаблоныСогласования.ПустаяСсылка();
	КоличествоИтераций = 1;
	Комментарий = "";
	КомплексныйПроцесс = БизнесПроцессы.КомплексныйПроцесс.ПустаяСсылка();
	НаименованиеБизнесПроцесса = "";
	Наименование = НСтр("ru = 'По умолчанию'");
	Описание = "";
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	Если Не Пользователи.ЭтоПолноправныйПользователь(Ответственный) Тогда
		Ответственный = Пользователи.СсылкаНеуказанногоПользователя(Истина);
	КонецЕсли;
	
	ПодписыватьЭП = Ложь;
	
	СрокИсполненияПроцесса = Дата(1,1,1);
	
	СрокОбработкиРезультатов = Дата(1,1,1);
	СрокОбработкиРезультатовДни = 0;
	СрокОбработкиРезультатовМинуты = 0;
	СрокОбработкиРезультатовЧасы = 0;
	
	СрокОтложенногоСтарта = 0;
	
	ТрудозатратыПланАвтора = 0;
	ТрудозатратыПланИсполнителя = 0;
	
	ШаблонВКомплексномПроцессе = Ложь;
	
	Исполнители.Очистить();
	Предметы.Очистить();
	ПредметыЗадач.Очистить();
	УсловияЗапретаВыполнения.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаМеханизмаОтсутствий

// Получает исполнителей
Функция ПолучитьИсполнителей() Экспорт
	
	МассивИсполнителей = Новый Массив;
	
	Для Каждого СтрокаИсполнитель Из Исполнители Цикл
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(СтрокаИсполнитель.Исполнитель);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЦикла;
	
	Возврат МассивИсполнителей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ШаблоныБизнесПроцессов.НачальноеЗаполнениеШаблона(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если Ссылка <> Справочники.ШаблоныСогласования.ПоУмолчанию Тогда
		ПроверяемыеРеквизиты.Добавить("НаименованиеБизнесПроцесса");
	КонецЕсли;
	
	// Проверка согласующих на дубли
	КоличествоИсполнителей = Исполнители.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей-2 Цикл
		Строка1 = Исполнители[Инд1];
		Если Не ЗначениеЗаполнено(Строка1.Исполнитель) Тогда 
			Продолжить;
		КонецЕсли;

		Для Инд2 = Инд1+1 По КоличествоИсполнителей-1 Цикл
			Строка2 = Исполнители[Инд2];
			
			Если Строка1.Исполнитель = Строка2.Исполнитель 
				И (ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.Пользователи")
					Или ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли")) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке согласующих!'"),
					Строка(Строка2.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Исполнители[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
					
			ИначеЕсли Строка1.Исполнитель = Строка2.Исполнитель 
				И ТипЗнч(Строка1.Исполнитель) = Тип("Строка") Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Автоподстановка ""%1"" указана дважды в списке согласующих!'"),
					Строка(Строка2.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Исполнители[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
		
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныБизнесПроцессов.ШаблонПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли