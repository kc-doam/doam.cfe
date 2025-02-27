﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Переопределяет получение сотрудников подлежащих учету самочувствия.
// Вызывается из УчетСамочувствияСотрудниковСервер.СотрудникиПодлежащиеУчетуСамочувствия
//
// Параметры:
//  ДатаУчета - Дата и время
//  Сотрудники - Массив ссылок на элементы спр. Пользователи.
//               В этот параметр следует поместить результат.
//  СтандартнаяОбработка - Булево - используется для отключения стандартной
//                         логики определения сотрудников.
//
Процедура ПриОпределенииСотрудниковПодлежащихУчетуСамочувствия(
	ДатаУчета, Сотрудники, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СотрудникиДляКонтроляСамочувствия.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.СотрудникиДляКонтроляСамочувствия КАК СотрудникиДляКонтроляСамочувствия");
	
	Сотрудники = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник"); 
	
	// Исключим удаленных, недействительных и служебных пользователей.
	РеквизитыСотрудников = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
		Сотрудники,
		"ПометкаУдаления, Служебный, Недействителен");
	КоличествоЭлементов = Сотрудники.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		
		ОбратныйИндекс = КоличествоЭлементов - Индекс;
		Сотрудник = Сотрудники[ОбратныйИндекс];
		
		РеквизитыСотрудника = РеквизитыСотрудников[Сотрудник];
		
		// Если не это действительный пользователь - считаем что он подлежит учету.
		Если Не РеквизитыСотрудника.ПометкаУдаления
			И Не РеквизитыСотрудника.Служебный
			И Не РеквизитыСотрудника.Недействителен Тогда
			Продолжить;
		КонецЕсли;
		
		// Если это не действительный, удаленный или служебный пользователь - исключаем сотрудника из учета.
		Сотрудники.Удалить(ОбратныйИндекс);
		
	КонецЦикла;
	
	// Исключим сотрудников, у которых выпадает на не рабочее время учёт.
	КоличествоЭлементов = Сотрудники.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		
		ОбратныйИндекс = КоличествоЭлементов - Индекс;
		Сотрудник = Сотрудники[ОбратныйИндекс];
		
		// Если не задан график - считаем что сотрудник работает всегда.
		ГрафикСотрудника = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Сотрудник);
		Если Не ЗначениеЗаполнено(ГрафикСотрудника) Тогда
			Продолжить;
		КонецЕсли;
		
		// Если задан график и это рабочее время - считаем что сотрудник подлежит учету.
		Если ГрафикиРаботы.ЭтоРабочаяДатаВремя(ГрафикСотрудника, ДатаУчета) Тогда
			Продолжить;
		КонецЕсли;
		
		// Если задан график и это не рабочее время - исключаем сотрудника из учета.
		Сотрудники.Удалить(ОбратныйИндекс);
		
	КонецЦикла;
	
	// Исключим сотрудников, которые отсутствуют.
	ДатаНачала = ДатаУчета - 1;
	ДатаОкончания = ДатаУчета + 1;
	НастройкиПроверкиОтсутствий = ОтсутствияКлиентСервер.НастройкиПроверкиОтсутствий();
	НастройкиПроверкиОтсутствий.УчитыватьФлагБудуРазбиратьЗадачи = Ложь;
	
	ОтсутствияСотрудников = Отсутствия.ПолучитьТаблицуОтсутствий(
		ДатаНачала,
		ДатаОкончания,
		Сотрудники,
		НастройкиПроверкиОтсутствий);
		
	КоличествоЭлементов = Сотрудники.Количество();
	Для Индекс = 1 По КоличествоЭлементов Цикл
		
		ОбратныйИндекс = КоличествоЭлементов - Индекс;
		Сотрудник = Сотрудники[ОбратныйИндекс];
		
		// Если задан график и сотрудник не отсутствует - считаем что сотрудник подлежит учету.
		Если ОтсутствияСотрудников.Найти(Сотрудник, "Сотрудник") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// Если задан график и сотрудник отсутствует -исключаем сотрудника из учета.
		Сотрудники.Удалить(ОбратныйИндекс);
		
	КонецЦикла;
	
КонецПроцедуры

// Переопределяет получение точки замера для сотрудника.
// Вызывается из УчетСамочувствияСотрудниковСервер.ТочкаЗамераДляСотрудникаНаДату
//
// Параметры:
//  Сотрудник - СправочникСсылка.Пользователи - Пользователь.
//  Дата - Дата - дата на которую выполняется получение точки.
//  ТочкаЗамера - СправочникСсылка.ГрафикУчетаСамочувствияСотрудников
//  СтандартнаяОбработка - Булево - используется для отключения стандартной
//                         логики определения точки замера.
//
Процедура ПриПолученииТочкиЗамераДляСотрудникаНаДату(
	Сотрудник, Дата, ТочкаЗамера, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТочкиИДатыЗамера = Новый ТаблицаЗначений;
	ТочкиИДатыЗамера.Колонки.Добавить("ТочкаЗамера");
	ТочкиИДатыЗамера.Колонки.Добавить("ДатаЗамера");
	
	Для Каждого СтрокаТочки Из Справочники.ГрафикУчетаСамочувствияСотрудников.ДействительныеТочкиЗамеров() Цикл
		
		ДатаЗамера = Дата(
			Год(Дата),
			Месяц(Дата),
			День(Дата),
			Час(СтрокаТочки.ВремяЗамера),
			Минута(СтрокаТочки.ВремяЗамера),
			0);
			
		Если ДатаЗамера < Дата Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы = ТочкиИДатыЗамера.Добавить();
		СтрокаТаблицы.ТочкаЗамера = СтрокаТочки.ТочкаЗамера;
		СтрокаТаблицы.ДатаЗамера = ДатаЗамера;
		
	КонецЦикла;
	
	ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Сотрудник);
	ТаблицаРабочегоВремени = ГрафикиРаботы.СформироватьТаблицуРабочегоВремени(ГрафикРаботы, НачалоДня(Дата), КонецДня(Дата));
	
	Индекс = ТочкиИДатыЗамера.Количество() - 1;
	Пока Индекс >= 0 Цикл
		
		ПроверяемаяСтрока = ТочкиИДатыЗамера[Индекс];
		Индекс = Индекс - 1;
		
		ПроверяемаяДата = ПроверяемаяСтрока.ДатаЗамера;
		
		ЕстьПересечение = Ложь;
		Для Каждого СтрокаТаблицы Из ТаблицаРабочегоВремени Цикл
			Если СтрокаТаблицы.ДатаНачала <= ПроверяемаяДата И ПроверяемаяДата <= СтрокаТаблицы.ДатаОкончания Тогда
				ЕстьПересечение = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьПересечение Тогда
			Продолжить;
		КонецЕсли;
		
		ТочкиИДатыЗамера.Удалить(ПроверяемаяСтрока);
		
	КонецЦикла;
	
	НастройкиПроверкиОтсутствий = ОтсутствияКлиентСервер.НастройкиПроверкиОтсутствий();
	НастройкиПроверкиОтсутствий.УчитыватьФлагБудуРазбиратьЗадачи = Ложь;
	
	ОтсутствияСотрудников = Отсутствия.ПолучитьТаблицуОтсутствий(
		НачалоДня(Дата),
		КонецДня(Дата),
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		НастройкиПроверкиОтсутствий);
	
	Индекс = ТочкиИДатыЗамера.Количество() - 1;
	Пока Индекс >= 0 Цикл
		
		ПроверяемаяСтрока = ТочкиИДатыЗамера[Индекс];
		Индекс = Индекс - 1;
		
		ПроверяемаяДата = ПроверяемаяСтрока.ДатаЗамера;
		
		ЕстьПересечение = Ложь;
		Для Каждого СтрокаТаблицы Из ТаблицаРабочегоВремени Цикл
			Если СтрокаТаблицы.ДатаНачала <= ПроверяемаяДата И ПроверяемаяДата <= СтрокаТаблицы.ДатаОкончания Тогда
				ЕстьПересечение = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьПересечение Тогда
			Продолжить;
		КонецЕсли;
		
		ТочкиИДатыЗамера.Удалить(ПроверяемаяСтрока);
		
	КонецЦикла;
	
	Если ТочкиИДатыЗамера.Количество() = 0 Тогда
		ТочкаЗамера = Справочники.ГрафикУчетаСамочувствияСотрудников.ПустаяСсылка();
	Иначе
		ТочкаЗамера = ТочкиИДатыЗамера[0].ТочкаЗамера;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
