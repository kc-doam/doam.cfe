﻿#Область ПрограммныйИнтерфейс

//	Формирует список всех возможных функций автоподстановки.
//
//	Возвращаемое значение:
//		СписокЗначений - список функций:
//  		Значение - Строка - имя функции в формате ИмяОбщегоМодуля.ИмяФункции(Параметры).
//			Представление - Строка - пользовательское наименование функции.
//			
Функция ПолучитьСписокДоступныхФункций() Экспорт
	
	ДоступныеФункции = ШаблоныДокументовПереопределяемый.ПолучитьСписокДоступныхФункций();
	
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ТекущийПользователь()",
		НСтр("ru = 'Текущий пользователь'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.НепосредственныйРуководительТекущегоПользователя()",
		НСтр("ru = 'Непосредственный руководитель текущего пользователя'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ВсеРуководителиТекущегоПользователя()",
		НСтр("ru = 'Все руководители текущего пользователя'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ВсеПодчиненныеТекущегоПользователя()",
		НСтр("ru = 'Все подчиненные текущего пользователя'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.РуководительОрганизации(Объект)",
		НСтр("ru = 'Руководитель организации'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ОтветственныйЗаДокумент(Объект)",
		НСтр("ru = 'Ответственный за документ'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ПодготовилДокумент(Объект)",
		НСтр("ru = 'Подготовил документ'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ЗарегистрировалДокумент(Объект)",
		НСтр("ru = 'Зарегистрировал документ'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ПодразделениеПодготовившегоДокумент(Объект)",
		НСтр("ru = 'Подразделение подготовившего документ'"));
		
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.РуководительПодразделения(Объект)",
		НСтр("ru = 'Руководитель подразделения документа'"));
		
	Возврат ДоступныеФункции;
	
КонецФункции

//	Получает значение для автоподстановки по названию функции.
//
//	Параметры:
//		Автоподстановка - Строка - строковое пользовательское представление функции автоподстановки (см. ПолучитьСписокДоступныхФункций()).
//		Объект - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - заполняемый объект.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи,
//		СправочникСсылка.СтруктураПредприятия,
//		СправочникСсылка.ПолныеРоли,
//		Массив,
//		Структура,
//		Неопределено. 
//
Функция ПолучитьЗначениеАвтоподстановки(Автоподстановка, Объект) Экспорт
	
	ФункцияАвтоподстановки = "";
	
	СписокФункций = ПолучитьСписокДоступныхФункций();
	Для Инд = 0 По СписокФункций.Количество() - 1 Цикл
		Если СписокФункций[Инд].Представление = Автоподстановка Тогда 
			ФункцияАвтоподстановки = СписокФункций[Инд].Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если ФункцияАвтоподстановки = "" Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не определена автоподстановка %1'"), Автоподстановка);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Для Каждого ИмяРазделителя Из РаботаВМоделиСервиса.РазделителиКонфигурации() Цикл
			УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		КонецЦикла;
		УстановитьБезопасныйРежим(Истина);
	КонецЕсли;
	
	РезультатФункции = Неопределено;
	Попытка
		Выполнить("РезультатФункции = " + ФункцияАвтоподстановки);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при выполнении автоподстановки %1:
			|%2'"), Автоподстановка, ИнформацияОбОшибке().Описание);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Если (ТипЗнч(РезультатФункции) = Тип("СправочникСсылка.Пользователи") И ЗначениеЗаполнено(РезультатФункции)) Или
		 (ТипЗнч(РезультатФункции) = Тип("СправочникСсылка.ПолныеРоли") И ЗначениеЗаполнено(РезультатФункции)) Или
		 (ТипЗнч(РезультатФункции) = Тип("СправочникСсылка.СтруктураПредприятия") И ЗначениеЗаполнено(РезультатФункции)) Или
		 (ТипЗнч(РезультатФункции) = Тип("Структура")) Или
		 (ТипЗнч(РезультатФункции) = Тип("Массив") И РезультатФункции.Количество() > 0) Тогда 
		Возврат РезультатФункции;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

//	Получает текущего пользователя сеанса.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция ТекущийПользователь() Экспорт
	
	Возврат Пользователи.ТекущийПользователь();

КонецФункции

//	Получает руководителя подразделения, в котором числится текущий пользователь сеанса.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция НепосредственныйРуководительТекущегоПользователя() Экспорт 
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	РеквизитыПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Подразделение,
		"Руководитель, Родитель");
	
	Если РеквизитыПодразделения.Руководитель <> ТекущийПользователь Тогда 
		Возврат РеквизитыПодразделения.Руководитель;
	КонецЕсли;		
	
	Пока РеквизитыПодразделения.Родитель <> Неопределено Цикл
		Подразделение = РеквизитыПодразделения.Родитель;
		РеквизитыПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Подразделение,
			"Руководитель, Родитель");
		
		Если РеквизитыПодразделения.Руководитель <> ТекущийПользователь Тогда 
			Возврат РеквизитыПодразделения.Руководитель;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат РеквизитыПодразделения.Руководитель;
	
КонецФункции

//	Получает массив руководителей всех вышестоящих подразделений текущего пользователя сеанса.
//
//	Возвращаемое значение:
//		Массив - значений СправочникСсылка.Пользователи.
//
Функция ВсеРуководителиТекущегоПользователя() Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	МассивРуководителей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат МассивРуководителей;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	
	Пока ЗначениеЗаполнено(Подразделение) Цикл
		РеквизитыПодразделения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Подразделение, 
			"Руководитель, Родитель");
		
		Если ЗначениеЗаполнено(РеквизитыПодразделения.Руководитель)
			И РеквизитыПодразделения.Руководитель <> ТекущийПользователь
			И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыПодразделения.Руководитель, "Недействителен") Тогда 
			МассивРуководителей.Добавить(РеквизитыПодразделения.Руководитель);
		КонецЕсли;	
		
		Подразделение = РеквизитыПодразделения.Родитель;
	КонецЦикла;
	
	Возврат МассивРуководителей;
	
КонецФункции

//	Получает массив пользователей, которые числятся в подразделении под руководством текущего пользователя сеанса.
//
//	Возвращаемое значение:
//		Массив - значений СправочникСсылка.Пользователи.
//
Функция ВсеПодчиненныеТекущегоПользователя() Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОПользователяхДокументооборот.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Подразделение В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				Справочник.СтруктураПредприятия.Ссылка
	|			ИЗ
	|				Справочник.СтруктураПредприятия
	|			ГДЕ
	|				Справочник.СтруктураПредприятия.Руководитель = &Руководитель)
	|	И СведенияОПользователяхДокументооборот.Пользователь <> &Руководитель
	|	И НЕ СведенияОПользователяхДокументооборот.Пользователь.Недействителен";
	Запрос.УстановитьПараметр("Руководитель", ТекущийПользователь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции	

//	Получает руководителя организации, в рамках которой создается документ.
//
//	Параметры:
//		ДокументОбъект - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - создаваемый документ.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция РуководительОрганизации(ДокументОбъект) Экспорт
			
	Если Не ДелопроизводствоКлиентСервер.ЭтоДокумент(ДокументОбъект.Ссылка) Тогда 
		 Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	 
	Организация = ДокументОбъект.Организация;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.РуководительОрганизации;
	
	Отбор = Новый Структура("Организация, ОтветственноеЛицо", Организация, ОтветственноеЛицо);
	Возврат РегистрыСведений.ОтветственныеЛицаОрганизаций.
		ПолучитьПоследнее(ДокументОбъект.ДатаСоздания, Отбор).Пользователь;
	
КонецФункции

//	Получает назначенного ответственного за документ.
//
//	Параметры:
//		ДокументОбъект - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - создаваемый документ.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция ОтветственныйЗаДокумент(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		
		Возврат ДокументОбъект.Ответственный;
		
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

//	Получает подразделение, в котором числится пользователь создавший документ.
//
//	Параметры:
//		ДокументОбъект - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - создаваемый документ.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция ПодразделениеПодготовившегоДокумент(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		 	
		Возврат РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(
			Новый Структура("Пользователь", ДокументОбъект.Создал)).Подразделение;
		 
	Иначе
		 
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();	 
		
	КонецЕсли;

КонецФункции

// Заполняет реквизиты документа (объекта) по шаблону документа.
//
// Параметры:
//   Шаблон - СправочникСсылка.ШаблоныВнутреннихДокументов,
//            СправочникСсылка.ШаблоныВходящихДокументов,
//            СправочникСсылка.ШаблоныИсходящихДокументов - источник данных заполнения.
//   Документ - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - заполняемый объект.
//
Процедура ЗаполнитьРеквизитыДокументаПоШаблону(Шаблон, Документ) Экспорт
	
	Если Не ЗначениеЗаполнено(Шаблон) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		И ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныВходящихДокументов")
		И ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныИсходящихДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыШаблона = Шаблон.Метаданные().Реквизиты;
	РеквизитыДокумента = Документ.Метаданные().Реквизиты;
	СтандартныеРеквизитыДокумента = Документ.Метаданные().СтандартныеРеквизиты;
	
	Для Каждого Реквизит Из РеквизитыШаблона Цикл
		
		Если Реквизит.Имя = "КомментарийКДокументу" 
			И Не ПустаяСтрока(Шаблон.КомментарийКДокументу) Тогда
			 
			Документ.Комментарий = Шаблон.КомментарийКДокументу;
			
		ИначеЕсли Реквизит.Имя = "ДлительностьИсполнения" 
			И Не Шаблон.ДлительностьИсполнения = 0 Тогда
			
			Документ.СрокИсполнения = ТекущаяДатаСеанса() + Шаблон.ДлительностьИсполнения*60*60*24;
			
		ИначеЕсли Реквизит.Имя <> "КомментарийКШаблону"
			И Реквизит.Имя <> "ВладелецШаблона"
			И Реквизит.Имя <> "КомментарийКДокументу"
			И Реквизит.Имя <> "ДлительностьИсполнения" 
			И ЗначениеЗаполнено(Шаблон[Реквизит.Имя]) Тогда
			
			НайденоВСтандартныхРеквизитах = Ложь;
			Для Каждого СтандРеквизит Из СтандартныеРеквизитыДокумента Цикл
				Если СтандРеквизит.Имя = Реквизит.Имя Тогда
					НайденоВСтандартныхРеквизитах = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если (РеквизитыДокумента.Найти(Реквизит.Имя) <> Неопределено 
				Или НайденоВСтандартныхРеквизитах)
				И ЗначениеЗаполнено(Шаблон[Реквизит.Имя]) Тогда
				Документ[Реквизит.Имя] = Шаблон[Реквизит.Имя];
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Контрагенты внутреннего документа.
	Если ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		И Шаблон.Контрагенты.Количество() > 0 Тогда
		
		КонтрагентыШаблона = Шаблон.Контрагенты;
		КонтрагентыДокумента = Документ.Контрагенты;
		
		КонтрагентыДокумента.Очистить();
		
		Для Каждого СтрокаШаблона из КонтрагентыШаблона Цикл
			НоваяСтрока = КонтрагентыДокумента.Добавить();
			НоваяСтрока.Контрагент = СтрокаШаблона.Контрагент;
			НоваяСтрока.КонтактноеЛицо = СтрокаШаблона.КонтактноеЛицо;
		КонецЦикла;
		
		Если КонтрагентыДокумента.Количество() > 0 Тогда 
			Документ.Контрагент = КонтрагентыДокумента[0].Контрагент;
			Документ.КонтактноеЛицо = КонтрагентыДокумента[0].КонтактноеЛицо;
		Иначе
			Документ.Контрагент = Неопределено;
			Документ.КонтактноеЛицо = Неопределено;
		КонецЕсли;
		
	// Получатели исходящего документа.
	ИначеЕсли ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов")
		И Шаблон.Получатели.Количество() > 0 Тогда
		
		ПолучателиШаблона = Шаблон.Получатели;
		ПолучателиДокумента = Документ.Получатели;
		
		// В шаблоне может быть только способ отправки, в этом случае существующих
		// получателей очищать не нужно.
		Для Каждого СтрокаШаблона Из ПолучателиШаблона Цикл
			Если ЗначениеЗаполнено(СтрокаШаблона.Получатель) Тогда 
				ПолучателиДокумента.Очистить();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПолучателиШаблона.Количество() = 1 Тогда
			
			// Следует ли заполнять получателя?
			Если ЗначениеЗаполнено(ПолучателиШаблона[0].Получатель) Тогда
				
				НоваяСтрока = ПолучателиДокумента.Добавить();
				НоваяСтрока.Адресат = ПолучателиШаблона[0].Адресат;
				НоваяСтрока.Получатель = ПолучателиШаблона[0].Получатель;
				НоваяСтрока.СпособОтправки = ПолучателиШаблона[0].СпособОтправки;
			
			// Нет, заполним способ отправки.
			ИначеЕсли ПолучателиДокумента.Количество() > 0 
				И ЗначениеЗаполнено(ПолучателиШаблона[0].СпособОтправки) Тогда // у существующих получателей
				
				Для Каждого СтрокаДокумента Из ПолучателиДокумента Цикл
					СтрокаДокумента.СпособОтправки = ПолучателиШаблона[0].СпособОтправки;
				КонецЦикла;
				
			// Добавим единственную строку со способом отправки.
			ИначеЕсли ЗначениеЗаполнено(ПолучателиШаблона[0].СпособОтправки) Тогда 
			
				НоваяСтрока = ПолучателиДокумента.Добавить();
				НоваяСтрока.СпособОтправки = ПолучателиШаблона[0].СпособОтправки;
				
			КонецЕсли;
			
		Иначе // получателей несколько, добавим их в документ
			
			Для Каждого СтрокаШаблона Из ПолучателиШаблона Цикл
				Если ЗначениеЗаполнено(СтрокаШаблона.Получатель) Тогда 
					НоваяСтрока = ПолучателиДокумента.Добавить();
					НоваяСтрока.Адресат = СтрокаШаблона.Адресат;
					НоваяСтрока.Получатель = СтрокаШаблона.Получатель;
					НоваяСтрока.СпособОтправки = СтрокаШаблона.СпособОтправки;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Стороны внутреннего документа
	Если ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		И Шаблон.Стороны.Количество() > 0 Тогда
		
		Документ.Стороны.Очистить();
		
		Для Каждого СтрокаШаблона из Шаблон.Стороны Цикл
			НоваяСтрока = Документ.Стороны.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаШаблона, "Сторона, КонтактноеЛицо, Наименование");
			НоваяСтрока.Подписал = СтрокаШаблона.Подписант;
		КонецЦикла;
		
		// Копирование контрагента
		СторонаКонтрагент = Неопределено;
		ИндексСторон = Документ.Стороны.Количество()-1;
		
		Пока ИндексСторон > -1 Цикл
			
			Если ЗначениеЗаполнено(Документ.Стороны[ИндексСторон].Сторона)
				И РаботаСПодписямиДокументовКлиентСервер.ЭтоКонтрагент(Документ.Стороны[ИндексСторон].Сторона) Тогда
					СторонаКонтрагент = Документ.Стороны[ИндексСторон].Сторона;
			КонецЕсли;
			
			ИндексСторон = ИндексСторон - 1;
		КонецЦикла;
		
		Если СторонаКонтрагент <> Неопределено Тогда
			Документ.Контрагент = СторонаКонтрагент;
		КонецЕсли;
		
		// копирование организации
		Если Документ.Стороны.Количество() > 0
			И РаботаСПодписямиДокументовКлиентСервер.ЭтоОрганизация(Документ.Стороны[0].Сторона) Тогда
			Если Документ.Организация <> Документ.Стороны[0].Сторона Тогда
				Документ.Организация = Документ.Стороны[0].Сторона;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// грифы утверждений внутреннего документа
	Если ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		И Шаблон.ГрифыУтверждения.Количество() > 0 Тогда
		
		Документ.ГрифыУтверждения.Очистить();
		
		Для Каждого СтрокаШаблона из Шаблон.ГрифыУтверждения Цикл
			НоваяСтрока = Документ.ГрифыУтверждения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаШаблона, "АвторУтверждения");
		КонецЦикла;
	КонецЕсли;
	
	// Товары и услуги.
	Если ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
		И Шаблон.Товары.Количество() > 0 Тогда
		Документ.Товары.Очистить();
		
		Для Каждого СтрокаНоменклатуры Из Шаблон.Товары Цикл 
			НоваяСтрока = Документ.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНоменклатуры);
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаНоменклатуры.Номенклатура,
				"Цена, СтавкаНДС");
			
			НоваяСтрока.Цена = Реквизиты.Цена;
			НоваяСтрока.СтавкаНДС = Реквизиты.СтавкаНДС;
			ДелопроизводствоКлиентСервер.ПересчитатьСуммуВСтрокеТЧ(НоваяСтрока, НоваяСтрока.СтавкаНДС);
		КонецЦикла;
		
		Документ.Сумма = Документ.Товары.Итог("Сумма");
		Документ.СуммаНДС = Документ.Товары.Итог("СуммаНДС");
	КонецЕсли;
	
	Если ТипЗнч(Шаблон) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов") Тогда
		Документ.Подписал = Шаблон.Подписант;
	КонецЕсли;
	
	Документ.Шаблон = Шаблон;
	// Заполним Наименование по шаблону
	Если ЗначениеЗаполнено(Шаблон.Заголовок) И Шаблон.ЗаполнениеНаименованияПоШаблону Тогда 
		Документ.Заголовок = СформироватьНаименованиеПоШаблону(Документ, Шаблон.Заголовок);
	КонецЕсли;
	
	// Заполним "ОтветственныйЗаХранение" по значению автоподстановки.
	Если ЗначениеЗаполнено(Шаблон.ОтветственныйЗаХранение)
		И ТипЗнч(Шаблон.ОтветственныйЗаХранение) = Тип("Строка") Тогда
		
		ЗначениеАвтоподстановки = ШаблоныДокументов.ПолучитьЗначениеАвтоподстановки(
			Шаблон.ОтветственныйЗаХранение,
			Документ);
			
		Если ЗначениеАвтоподстановки <> Неопределено Тогда
			Если ТипЗнч(ЗначениеАвтоподстановки) = Тип("СправочникСсылка.Пользователи") Тогда
				Документ.ОтветственныйЗаХранение = ЗначениеАвтоподстановки;
				
			ИначеЕсли ТипЗнч(ЗначениеАвтоподстановки) = Тип("Массив") Тогда 
				
				Для Каждого ЗначениеАвтоподстановкиЭлемент Из ЗначениеАвтоподстановки Цикл
					Если ТипЗнч(ЗначениеАвтоподстановкиЭлемент) = Тип("СправочникСсылка.Пользователи")Тогда 
						Документ.ОтветственныйЗаХранение = ЗначениеАвтоподстановкиЭлемент;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
		Возврат;
	КонецЕсли;
	
	// Получим массив дополнительных реквизитов.
	НаборСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Документ);
	НаборСвойствОбъекта = Новый Массив;
	Для Каждого Элемент Из НаборСвойств Цикл
		Для Каждого ДопРеквизит Из Элемент.Набор.ДополнительныеРеквизиты Цикл
			Если НаборСвойствОбъекта.Найти(ДопРеквизит.Свойство) = Неопределено Тогда
				НаборСвойствОбъекта.Добавить(ДопРеквизит.Свойство);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Скопируем из шаблона подходящие дополнительные реквизиты.
	Для Каждого ДопРеквизитШаблона Из Шаблон.ДополнительныеРеквизиты Цикл
		Если НаборСвойствОбъекта.Найти(ДопРеквизитШаблона.Свойство) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаДопРеквизита = Документ.ДополнительныеРеквизиты.Найти(
			ДопРеквизитШаблона.Свойство,
			"Свойство");
		Если СтрокаДопРеквизита = Неопределено Тогда
			СтрокаДопРеквизита = Документ.ДополнительныеРеквизиты.Добавить();
			СтрокаДопРеквизита.Свойство = ДопРеквизитШаблона.Свойство;
		КонецЕсли;
		СтрокаДопРеквизита.Значение = ДопРеквизитШаблона.Значение;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет файлы документа по шаблону, при необходимости удаляя файлы других шаблонов.
//
// Параметры:
//   Шаблон - СправочникСсылка.ШаблоныВнутреннихДокументов,
//            СправочникСсылка.ШаблоныВходящихДокументов,
//            СправочникСсылка.ШаблоныИсходящихДокументов - источник данных заполнения.
//   Файлы - ТаблицаЗначений, ДанныеФормыКоллекция - заполняемый список файлов:
//     Наименование - Строка.
//     Расширение - Строка.
//     ПолныйПуть - Строка.
//     ИндексКартинки - Число.
//     ШаблонОснованиеДляСоздания - СправочникСсылка.Файлы.
//     ДобавленИзШаблона - Булево.
//   УдалятьФайлыИзДругогоШаблона - Булево - Истина, если требуется заместить файлы
//     других шаблонов.
//
Процедура ЗаполнитьФайлыДокументаПоШаблону(Шаблон, Файлы, УдалятьФайлыИзДругогоШаблона) Экспорт
	
	Если УдалятьФайлыИзДругогоШаблона Тогда
		КоличествоФайлов = Файлы.Количество();
		Для Индекс = 1 По КоличествоФайлов Цикл
			Если Файлы[КоличествоФайлов - Индекс].ДобавленИзШаблона Тогда
				Файлы.Удалить(КоличествоФайлов - Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнениеДляФормы = (ТипЗнч(Файлы) = Тип("ДанныеФормыКоллекция"));
	
	МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(Шаблон, Ложь);
		
	Для Каждого ПрикрепленныйФайл Из МассивФайлов Цикл 
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(ПрикрепленныйФайл.Ссылка);
		Если ТипЗнч(ДанныеФайла) <> Тип("Структура")
			Или Не ДанныеФайла.Свойство("Ссылка")
			Или ДанныеФайла.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(
			ДанныеФайла, Новый УникальныйИдентификатор());
		НоваяСтрока = Файлы.Добавить();
		НоваяСтрока.ПолныйПуть = АдресВременногоХранилища;
		НоваяСтрока.Наименование = ДанныеФайла.ПолноеНаименованиеВерсии;
		Если ЗаполнениеДляФормы Тогда
			НоваяСтрока.ИндексКартинки = ФайловыеФункцииКлиентСервер.
				ПолучитьИндексПиктограммыФайла(ДанныеФайла.Расширение);
		Иначе
			НоваяСтрока.Расширение = ДанныеФайла.Расширение;
		КонецЕсли;
		НоваяСтрока.ШаблонОснованиеДляСоздания = ПрикрепленныйФайл.Ссылка;
		НоваяСтрока.ДобавленИзШаблона = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет визы документа по шаблону, сохраняя существующие.
//
// Параметры:
//   Шаблон - СправочникСсылка.ШаблоныВнутреннихДокументов,
//            СправочникСсылка.ШаблоныИсходящихДокументов - источник данных заполнения.
//   ВизыСогласования - ТаблицаЗначений, ДанныеФормыКоллекция - заполняемый список виз:
//     Исполнитель - СправочникСсылка.Пользователи - согласующее лицо.
//     РольИсполнителя - СправочникСсылка.ПолныеРоли - роль согласующего лица.
//
Процедура ЗаполнитьВизыДокументаПоШаблону(Шаблон, ВизыСогласования) Экспорт
	
	Если Не ЗначениеЗаполнено(Шаблон) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Шаблон.ИсполнителиСогласования Цикл
		
		Если Не ЗначениеЗаполнено(Строка.Исполнитель) Тогда 
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		
		Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
			
			СтруктураПоиска.Вставить("Исполнитель", Строка.Исполнитель);
			СуществующиеСтроки = ВизыСогласования.НайтиСтроки(СтруктураПоиска);
			Если СуществующиеСтроки.Количество() <> 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ВизыСогласования.Добавить();
			НоваяСтрока.Исполнитель = Строка.Исполнитель;
			
		Иначе // роль
			
			СтруктураПоиска.Вставить("РольИсполнителя", Строка.Исполнитель);
			СуществующиеСтроки = ВизыСогласования.НайтиСтроки(СтруктураПоиска);
			Если СуществующиеСтроки.Количество() <> 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ВизыСогласования.Добавить();
			НоваяСтрока.РольИсполнителя = Строка.Исполнитель;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет статьи движения денежных средств по шаблону.
//
// Параметры:
//   Шаблон - СправочникСсылка.ШаблоныВнутреннихДокументов - источник данных заполнения.
//   СтатьиДДС - ТаблицаЗначений, ДанныеФормыКоллекция - заполняемый список с колонкой 
//     СтатьяДвиженияДенежныхСредств - СправочникСсылка.СтатьиДвиженияДенежныхСредств.
//   Сумма - Число - сумма документа.
//   СуммаНДС - Число - сумма НДС документа.
//
Процедура ЗаполнитьСтатьиДДСДокументаПоШаблону(Шаблон, СтатьиДДС,
	Сумма = 0, СуммаНДС = 0) Экспорт
	
	Если Не ЗначениеЗаполнено(Шаблон) 
		Или ТипЗнч(Шаблон) <> Тип("СправочникСсылка.ШаблоныВнутреннихДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	СтатьиДДС.Очистить();
	
	СтатьяДвиженияДенежныхСредств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Шаблон, "СтатьяДвиженияДенежныхСредств");
	Если ЗначениеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
		НоваяСтрока = СтатьиДДС.Добавить();
		НоваяСтрока.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		НоваяСтрока.Сумма = Сумма;
		НоваяСтрока.СуммаНДС = СуммаНДС;
	КонецЕсли;
	
КонецПроцедуры

// Помечает / снимает пометку удаления у правил заполнения шаблона.
//
// Параметры:
//  Шаблон - СправочникСсылка.ШаблоныВнутреннихДокументов, СправочникСсылка.ШаблоныИсходящихДокументов -
//           шаблон, владелец правила автозаполнения.
//  ПометкаУдаления - Булево - признак установки/снятия пометки удаления.
//
Процедура ПометитьНаУдалениеПравилаЗаполнения(Шаблон, ПометкаУдаления) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПравилаАвтозаполненияФайлов.ПравилоАвтозаполнения КАК Ссылка
		|ИЗ
		|	Справочник.ШаблоныВнутреннихДокументов.ПравилаАвтозаполнения КАК ПравилаАвтозаполненияФайлов
		|ГДЕ
		|	ПравилаАвтозаполненияФайлов.Ссылка = &Шаблон";
	
	Запрос.УстановитьПараметр("Шаблон", Шаблон);
	
	Результат = Запрос.Выполнить();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда 
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ПравилоОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ПравилоОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
				РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			Исключение
				Продолжить;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Помечает / снимает пометку удаления с шаблонов документов.
//
// Параметры:
//  ВидДокумента - СправочникСсылка.ВидыВнутреннихДокументов, СправочникСсылка.ВидыИсходящихДокументов, СправочникСсылка.ВидыВходящихДокументов -
//           вид документа, по которому созданы шаблоны документов.
//  ПометкаУдаления - Булево - признак установки/снятия пометки удаления.
//
Процедура ПометитьНаУдалениеШаблоныДокументов(ВидДокумента, ПометкаУдаления) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныДокументов.Ссылка,
		|	ШаблоныДокументов.ПометкаУдаления
		|ИЗ
		|	%1 КАК ШаблоныДокументов
		|ГДЕ
		|	ШаблоныДокументов.ВидДокумента = &ВидДокумента";
		
	Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда 
		Запрос.Текст = СтрШаблон(Запрос.Текст, "Справочник.ШаблоныВнутреннихДокументов");
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда 
		Запрос.Текст = СтрШаблон(Запрос.Текст, "Справочник.ШаблоныВходящихДокументов");
	Иначе 
		Запрос.Текст = СтрШаблон(Запрос.Текст, "Справочник.ШаблоныИсходящихДокументов");
	КонецЕсли;
	
	Запрос.Параметры.Вставить("ВидДокумента", ВидДокумента);
	
	Результат = Запрос.Выполнить();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Ссылка) И Выборка.ПометкаУдаления <> ПометкаУдаления Тогда 
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ШаблонОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ШаблонОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
				РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			Исключение
				Прервать;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//	Получает руководителя подразделения, в рамках которого создается документ.
//
//	Параметры:
//		ДокументОбъект - СправочникОбъект.ВнутреннийДокумент,
//              СправочникОбъект.ВходящийДокумент,
//              СправочникОбъект.ИсходящийДокумент - создаваемый документ.
//
//	Возвращаемое значение:
//		СправочникСсылка.Пользователи.
//
Функция РуководительПодразделения(ДокументОбъект) Экспорт
	
	Если Не ДелопроизводствоКлиентСервер.ЭтоДокумент(ДокументОбъект.Ссылка) Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	 
	Подразделение = ДокументОбъект.Подразделение;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "Руководитель");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает подготовившего документ
//
// Параметры:
//   ДокументОбъект - Справочник.<Тип документа> - документ, для которого
//                         вычисляется автоподстановка
//
// Возвращаемое значение:
//   СправочникСсылка.Пользователи
//
Функция ПодготовилДокумент(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Или 
		ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		
		Возврат ДокументОбъект.Подготовил;
		
	ИначеЕсли ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		
		Возврат ДокументОбъект.Зарегистрировал;
		
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

// Возвращает зарегистрировавшего документ
//
// Параметры:
//   ДокументОбъект - Справочник.<Тип документа> - документ, для которого
//                         вычисляется автоподстановка
//
// Возвращаемое значение:
//   СправочникСсылка.Пользователи
//
Функция ЗарегистрировалДокумент(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Или 
		ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Или 
		ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		
		Возврат ДокументОбъект.Зарегистрировал;
		
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

// Возвращает сформированный по шаблону заголовок документа
//
// Параметры:
//   Документ - Справочник.<Тип документа> - документ, для которого
//                         вычисляется заголовок
//   ШаблонЗаголовка - Строка - шаблон, по которому формируется заголовок
//
// Возвращаемое значение:
//  Результат - Строка - заголовок документа
//
Функция СформироватьНаименованиеПоШаблону(Документ, ШаблонЗаголовка) Экспорт 
	
	Результат = ШаблонЗаголовка;
	
	МассивРеквизитов = Новый Массив; ОписаниеОшибки = "";
	ДелопроизводствоКлиентСервер.ПолучитьПоляШаблонаНаименования(
		ШаблонЗаголовка, МассивРеквизитов, ОписаниеОшибки);
		
	Для Каждого Реквизит Из МассивРеквизитов Цикл 
		ДопРеквизит = Найти(Реквизит, "ДопРеквизиты") > 0
			Или Найти(Реквизит, "ДопСвойства") > 0;
		
		Если ДопРеквизит Тогда 
			ЗначениеРеквизита = ПолучитьЗначениеДопРеквизитаДляЗаполненияШаблона(Реквизит, Документ);
			
		// Реквизит "Получатель" введен искусственно, поэтому его определяем в особом порядке.
		ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоИсходящийДокумент(Документ)
			И СтрНайти(Реквизит, "Получатель") Тогда 
			Если ЗначениеЗаполнено(Документ.Получатели) Тогда 
				ЗначениеРеквизита = Документ.Получатели[0].Получатель;
			Иначе 
				ЗначениеРеквизита = "";
			КонецЕсли;
		Иначе 
			ЗначениеРеквизита = ПолучитьЗначениеРеквизитаДляЗаполненияШаблона(Реквизит, Документ);
		КонецЕсли; 
		
		Результат = СтрЗаменить(Результат, "[" + Реквизит + "]", ЗначениеРеквизита);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

//Получает значение реквизита документа
//
Функция ПолучитьЗначениеРеквизитаДляЗаполненияШаблона(Знач НазваниеПоля, Документ)
	
	Результат = "";
	Попытка
		Если СтрНайти(НазваниеПоля, "|") > 0 Тогда
			МассивСтрок = СтрРазделить(НазваниеПоля, "|");
			НазваниеПоля = СтрЗаменить(НазваниеПоля, "|", ".");
		Иначе
			МассивСтрок = СтрРазделить(НазваниеПоля, ".");
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		Счетчик = 0; ВыражениеРеквизита = ""; ВыражениеНеПустое = Ложь;
		Для Каждого Реквизит Из МассивСтрок Цикл
			Счетчик = Счетчик + 1;
			Если Счетчик = 1 Тогда 
				ЗначениеПервогоРеквизита = Документ[Реквизит];
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ЗначениеПервогоРеквизита) Тогда 
				ВыражениеРеквизита = ВыражениеРеквизита + ?(ВыражениеНеПустое, ".", "") + Реквизит;
				ВыражениеНеПустое = Истина;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ЗначениеПервогоРеквизита) Тогда 
			Если ЗначениеЗаполнено(ВыражениеРеквизита) Тогда 
				Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеПервогоРеквизита, ВыражениеРеквизита);
			Иначе 
				Результат = ЗначениеПервогоРеквизита;
			КонецЕсли;
		КонецЕсли;
	Исключение
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение("ОшибкаДоступаКРеквизиту");
	КонецПопытки;
	
	Если ТипЗнч(Результат) = Тип("Дата") Тогда 
		Результат = Формат(Результат, "ДЛФ=D");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//Получает значение дополнительного реквизита документа
//
Функция ПолучитьЗначениеДопРеквизитаДляЗаполненияШаблона(НазваниеПоля, Документ)  
	
	Результат = "";
	
	Если СтрНайти(НазваниеПоля, "|") > 0 Тогда
		МассивСтрок = СтрРазделить(НазваниеПоля, "|");
	Иначе
		МассивСтрок = СтрРазделить(НазваниеПоля, ".");
	КонецЕсли;
	
	Если МассивСтрок.Количество() = 1 Тогда
		Возврат Результат;
	КонецЕсли;
	ИмяДопРеквизита = МассивСтрок[МассивСтрок.Количество() - 1];
	
	Счетчик = 0;
	Пока Счетчик < 2 Цикл
		Счетчик = Счетчик + 1;
		Для Каждого Строка Из МассивСтрок Цикл
			
			Если Найти(Строка, "ДопСвойства") > 0
				Или Найти(Строка, "ДопРеквизиты") > 0 Тогда
				МассивСтрок.Удалить(МассивСтрок.Найти(Строка));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Выражение = "";
	ВыражениеРеквизита = "Документ";
	
	Счетчик = 0;
	Для Каждого Реквизит Из МассивСтрок Цикл
		Счетчик = Счетчик + 1;
		
		Если Найти(Реквизит, " ") > 0
			Или Реквизит = Строка(Документ.ВидДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Счетчик < МассивСтрок.Количество() Тогда
			ВыражениеРеквизита = ВыражениеРеквизита + "." + Реквизит;
			Выражение = "Если НЕ " + ВыражениеРеквизита + " = Неопределено"
				+ " И НЕ " + ВыражениеРеквизита + ".Пустая()";
		КонецЕсли;
	КонецЦикла;	
	
	ВыражениеЦикла = 
		"Для Каждого ДопРеквизит Из " + ВыражениеРеквизита + ".ДополнительныеРеквизиты Цикл
			|Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопРеквизит.Свойство, ""Заголовок"") = ИмяДопРеквизита Тогда
			|	Результат = ДопРеквизит.Значение;
			|КонецЕсли;
		|КонецЦикла;";
		
	Если ЗначениеЗаполнено(Выражение) Тогда 
		Выражение = Выражение + " Тогда " + ВыражениеЦикла + "КонецЕсли;";
	Иначе 
		Выражение = ВыражениеЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
		Выполнить(Выражение);
		
		Если Результат = "" Тогда 
			МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(Документ);
			
			Для Каждого ДопСвойство Из МассивСвойств Цикл 
				Если ДопСвойство.Наименование = ИмяДопРеквизита 
					Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопСвойство.Ссылка, "Заголовок") = ИмяДопРеквизита Тогда
					Если СокрЛП(ДопСвойство.ТипЗначения) = "Булево" Тогда 
						Результат = Ложь;
					КонецЕсли;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		// Возможно реквизит неограниченной длины, он хранится в рекизите "ТекстоваяСтрока"
		ИначеЕсли СтрДлина(Результат) = 1024 Тогда 
			МассивСвойств = УправлениеСвойствами.СвойстваОбъекта(Документ);
			
			Для Каждого ДопСвойство Из МассивСвойств Цикл 
				Если ДопСвойство.Наименование = ИмяДопРеквизита 
					Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДопСвойство.Ссылка, "Заголовок") = ИмяДопРеквизита Тогда 
					Если СокрЛП(ДопСвойство.ТипЗначения) = "Строка" Тогда 
						СтрокаДопРеквизитов = Документ.ДополнительныеРеквизиты.Найти(ДопСвойство, "Свойство");
						Если СтрокаДопРеквизитов <> Неопределено И ЗначениеЗаполнено(СтрокаДопРеквизитов.ТекстоваяСтрока) Тогда 
							Результат = СтрокаДопРеквизитов.ТекстоваяСтрока;
						КонецЕсли;
					КонецЕсли;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(Результат) = Тип("Дата") Тогда 
		Результат = Формат(Результат, "ДЛФ=D");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти