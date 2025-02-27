﻿////////////////////////////////////////////////////////////////////////////////
// Общий модуль ИнтеграцияЭДОКлиент
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиКоманд

// Открывает форму выбора договора контрагента.
//
// Параметры:
//  Параметры - Структура - параметры формы.
//     * Организация - ОпределяемыйТип.Организация - ссылка на организацию.
//     * Контрагент  - ОпределяемыйТип.КонтрагентБЭД - ссылка на контрагента.
//  Владелец - УправляемаяФорма, ПолеФормы - форма или элемент управления другой формы.
//  ОповещениеОЗакрытии - ОписаниеОповещения - описание оповещения о закрытии, с которым нужно открыть форму.
//  СтандартнаяОбработка - Булево - признак использования стандартной формы выбора без дополнительного отбора.
//
Процедура ОткрытьФормуВыбораДоговора(Параметры, Владелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	
	ОбменСКонтрагентамиКлиентПереопределяемый.ПриВыбореДоговораКонтрагента(
		Параметры, Владелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПерезаполнитьДокумент(ПараметрКоманды, ЭлектронныйДокумент = Неопределено, СпособОбработки = "") Экспорт	
	
	ОчиститьСообщения();
	
	МассивСсылок = ОбщегоНазначенияБЭДКлиент.МассивПараметров(ПараметрКоманды);
	Если МассивСсылок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ЭлектронныйДокумент", ЭлектронныйДокумент);
	ПараметрыЗаполнения.Вставить("МассивСсылок", МассивСсылок);
	ПараметрыЗаполнения.Вставить("СпособОбработки", СпособОбработки);
	
	КонтекстОперации = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
	
	Результат = ИнтеграцияЭДОВызовСервера.ПерезаполнитьДокумент(ПараметрыЗаполнения, КонтекстОперации);
	
	ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(КонтекстОперации);
	
	Если Результат.Отказ Тогда
		
		Если Результат.НетПраваОбработкиЭД Тогда
			ОбработкаНеисправностейБЭДКлиент.СообщитьПользователюОНарушенииПравДоступа();
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если Результат.МассивДокументов.Количество() > 0 Тогда
		
		Оповестить("ОбновитьДокументИБПослеЗаполнения", Результат.МассивДокументов);
		
		Если Результат.МассивДокументов.Количество() = 1 Тогда
			ТекстСостоянияВывод = НСтр("ru = 'Документ перезаполнен.'");
		Иначе
			ТекстСостоянияВывод = НСтр("ru = 'Документы перезаполнены (%1).'");
			ТекстСостоянияВывод = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостоянияВывод, 
				Результат.МассивДокументов.Количество());
		КонецЕсли;
		ТекстЗаголовка = НСтр("ru = 'Обмен электронными документами'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСостоянияВывод);
		
	КонецЕсли;
	

	
КонецПроцедуры

Процедура ОткрытьФормуАннулированияСтарогоЭДИСозданияНового(КонтекстОперации, ДополнительныеПараметры) Экспорт
	
	УчетныеДокументы = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(КонтекстОперации.Диагностика.Ошибки, "СсылкаНаОбъект");
	
	СоответствиеОшибокДанным = Новый Соответствие;
	Для каждого Ошибка Из КонтекстОперации.Диагностика.Ошибки Цикл
		СоответствиеОшибокДанным.Вставить(Ошибка.СсылкаНаОбъект, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ошибка));
	КонецЦикла;
	
	ПараметрыИсправленияОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыИсправленияОшибок();
	Команда = ОбработкаНеисправностейБЭДКлиент.НовоеОписаниеКомандыФормыИсправленияОшибок();
	Команда.Заголовок = НСтр("ru = 'Аннулировать старый и создать новый'");
	Команда.Обработчик = "ИнтеграцияЭДОКлиент.АннулироватьСтарыйЭДИСоздатьНовый";
	ПараметрыИсправленияОшибок.Команды.Добавить(Команда);
	
	ПараметрыИсправленияОшибок.МножественныйВыбор = Ложь;
	
	ЭлектронныеДокументыОбъектовУчета = ИнтеграцияЭДОВызовСервера.ЭлектронныеДокументыОбъектовУчета(УчетныеДокументы);	
			
	ЭлектронныеДокументы = Новый Массив;
			
	Для Каждого СтрокаДанных Из ЭлектронныеДокументыОбъектовУчета Цикл
		ЭлектронныеДокументы.Добавить(СтрокаДанных.ЭлектронныйДокумент);
	КонецЦикла;	
	
	ДополнительныеПараметрыОбработчиков = Новый Структура;
	ДополнительныеПараметрыОбработчиков.Вставить("СоответствиеОшибокДанным", СоответствиеОшибокДанным);
	ДополнительныеПараметрыОбработчиков.Вставить("ЭлектронныеДокументы", ЭлектронныеДокументы);
	ДополнительныеПараметрыОбработчиков.Вставить("КонтекстОперации", КонтекстОперации);
	
	ПараметрыИсправленияОшибок.ДополнительныеПараметрыОбработчиков = ДополнительныеПараметрыОбработчиков;

	ОбработкаНеисправностейБЭДКлиент.ИсправитьОшибки(УчетныеДокументы, ПараметрыИсправленияОшибок);
	
КонецПроцедуры

Процедура ОткрытьФормуИсправленияЭД(КонтекстОперации, ДополнительныеПараметры) Экспорт
	
	Ошибки = КонтекстОперации.Диагностика.Ошибки;
	УчетныеДокументы = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "СсылкаНаОбъект");
	СоответствиеОшибокДанным = Новый Соответствие;
	Для каждого Ошибка Из Ошибки Цикл
		СоответствиеОшибокДанным.Вставить(Ошибка.СсылкаНаОбъект, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ошибка));
	КонецЦикла;
	ПараметрыИсправленияОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыИсправленияОшибок();

	Команда = ОбработкаНеисправностейБЭДКлиент.НовоеОписаниеКомандыФормыИсправленияОшибок();
	Команда.Заголовок = НСтр("ru = 'Исправить'");
	Команда.Обработчик = "ИнтеграцияЭДОКлиент.ИсправитьЭлектронныйДокумент";
	ПараметрыИсправленияОшибок.Команды.Добавить(Команда);
	
	ПараметрыИсправленияОшибок.МножественныйВыбор = Истина;
	
	ПараметрыИсправленияОшибок.ДополнительныеПараметрыОбработчиков = СоответствиеОшибокДанным;
	
	ОбработкаНеисправностейБЭДКлиент.ИсправитьОшибки(УчетныеДокументы, ПараметрыИсправленияОшибок);
	
КонецПроцедуры

Процедура ОткрытьФормуСозданияНовогоЭД(КонтекстОперации, ДополнительныеПараметры) Экспорт
	
	Ошибки = КонтекстОперации.Диагностика.Ошибки;
	УчетныеДокументы = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "СсылкаНаОбъект");
	СоответствиеОшибокДанным = Новый Соответствие;
	Для каждого Ошибка Из Ошибки Цикл
		СоответствиеОшибокДанным.Вставить(Ошибка.СсылкаНаОбъект, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ошибка));
	КонецЦикла;
	ПараметрыИсправленияОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыИсправленияОшибок();

	Команда = ОбработкаНеисправностейБЭДКлиент.НовоеОписаниеКомандыФормыИсправленияОшибок();
	Команда.Заголовок = НСтр("ru = 'Создать'");
	Команда.Обработчик = "ИнтеграцияЭДОКлиент.СоздатьЭлектронныйДокумент";
	ПараметрыИсправленияОшибок.Команды.Добавить(Команда);
	
	ПараметрыИсправленияОшибок.МножественныйВыбор = Истина;
	
	ПараметрыИсправленияОшибок.ДополнительныеПараметрыОбработчиков = СоответствиеОшибокДанным;
	
	ОбработкаНеисправностейБЭДКлиент.ИсправитьОшибки(УчетныеДокументы, ПараметрыИсправленияОшибок);
	
КонецПроцедуры

Процедура СоздатьЭлектронныйДокумент(Результат, СоответствиеОшибокДанным) Экспорт
	
	Для каждого Документ Из Результат Цикл
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументОбъектаУчета(Документ);
	КонецЦикла;
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(ОбработкаНеисправностейБЭДКлиент.ПолучитьИсправленныеОшибки(Результат, СоответствиеОшибокДанным));
	Оповестить("ОбменСКонтрагентами.ВыполненоУстранениеОшибок", Результат);
	
КонецПроцедуры

Процедура ИсправитьЭлектронныйДокумент(Результат, ДополнительныеПараметры) Экспорт
	
	МассивДополнительныхДанных = ДополнительныеПараметры.Получить(Результат[0]);
	
	Если МассивДополнительныхДанных.Количество() Тогда

		ПараметрыВыполненияДействийПоЭДО = МассивДополнительныхДанных[0].ДополнительныеДанные;
		Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДО", ИнтерфейсДокументовЭДОКлиент,
			Новый Структура("ОбъектыУчета, ИсправляемыйДокумент, ОповещениеУспешногоЗавершения", Результат,
			ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.ЭлектронныеДокументы[0],
			Новый ОписаниеОповещения("ПослеФормированияИсправления", ЭтотОбъект, Результат[0])));

		ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);

	КонецЕсли;
	
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(ОбработкаНеисправностейБЭДКлиент.ПолучитьИсправленныеОшибки(Результат, ДополнительныеПараметры));
	Оповестить("ОбменСКонтрагентами.ВыполненоУстранениеОшибок", Результат);
	
КонецПроцедуры

Процедура ПослеФормированияИсправления(Результат, ОбъектУчета) Экспорт
	ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументОбъектаУчета(ОбъектУчета);
КонецПроцедуры

Процедура АннулироватьСтарыйЭДИСоздатьНовый(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивДополнительныхДанных = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(ДополнительныеПараметры.КонтекстОперации.Диагностика.Ошибки,
		"ДополнительныеДанные", Новый Структура("СсылкаНаОбъект", Результат[0]));
	
	Если МассивДополнительныхДанных.Количество() Тогда
	
		Контекст = Новый Структура;
		Контекст.Вставить("Документ", Результат[0]);
		Контекст.Вставить("СоответствиеОшибокДанным", ДополнительныеПараметры.СоответствиеОшибокДанным);
		ОписаниеОповещения = Новый ОписаниеОповещения("АннулироватьСтарыйЭДИСоздатьНовыйПродолжить", ЭтотОбъект,
			Контекст);
			
		ДополнительныеПараметрыОповещения = Новый Структура;
		ДополнительныеПараметрыОповещения.Вставить("ЭлектронныеДокументы", ДополнительныеПараметры.ЭлектронныеДокументы);
		ДополнительныеПараметрыОповещения.Вставить("ОповещениеУспешногоЗавершения", ОписаниеОповещения);
		
		НаборДействий = Новый Соответствие;	
		ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.Аннулировать"));
		ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.Подписать"));
		ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.ПодготовитьКОтправке"));
		ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.Отправить"));
			
		ДополнительныеПараметрыОповещения.Вставить("НаборДействий", НаборДействий);
		ДополнительныеПараметрыОповещения.Вставить("ОсновноеДействие", ПредопределенноеЗначение(
			"Перечисление.ДействияПоЭДО.Аннулировать"));
			
		Обработчик = Новый ОписаниеОповещения("ВыполнитьДействияПоЭДОПослеВводаСтроки", ИнтерфейсДокументовЭДОКлиент, ДополнительныеПараметрыОповещения);
		
		ДополнительныеПараметры = ОбщегоНазначенияБЭДКлиент.ПараметрыВводаСтроки();
		ДополнительныеПараметры.ЗаголовокФормы = НСтр("ru = 'Укажите причины аннулирования документа'");
		ДополнительныеПараметры.НазваниеКнопкиПоУмолчанию = НСтр("ru = 'Аннулировать'");
		ДополнительныеПараметры.Многострочность = Истина;
		ДополнительныеПараметры.Обязательность = Истина;
		ДополнительныеПараметры.КомментарийОбязательностиВвода =
			НСтр("ru = 'Для аннулирования документа необходимо указать причину.'");
		ОбщегоНазначенияБЭДКлиент.ПоказатьВводСтрокиБЭД(Обработчик, ДополнительныеПараметры);		
	
	КонецЕсли;
	
КонецПроцедуры

Процедура АннулироватьСтарыйЭДИСоздатьНовыйПродолжить(Результат, Контекст) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументОбъектаУчета(Контекст.Документ);
		ТекстСообщения = НСтр("ru = 'Контрагенту отправлено предложение об аннулировании неактуальной версии документа.
									|Документооборот будет аннулирован после получения ответа от контрагента.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Предложение об аннулировании не было отправлено.
		|Отправить его можно из старой версии документа (команда ""ЭДО -> Открыть электронные документы"")'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	ВидыОшибок = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИнтеграцияЭДОКлиентСервер.ВидОшибкиОбновлениеВерсииЭДТребуетсяАннулирование());
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(ВидыОшибок);
	ИсправленныеОшибки = ОбработкаНеисправностейБЭДКлиент.ПолучитьИсправленныеОшибки(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Контекст.Документ), Контекст.СоответствиеОшибокДанным);
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(ИсправленныеОшибки);
	
КонецПроцедуры


#КонецОбласти

#Область ГотовностьКДокументообороту

// Подготавливает объекты учета к документообороту, согласно выполненной проверке.
//
// Параметры:
//  НаборОбъектовУчета - Массив Из ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - набор объектов учета.
//  ОбработкаЗавершения - ОписаниеОповещения - обработчик завершения подготовки к документообороту.
//                                             В процедуру будут переданы объекты, готовые к документообороту.
//
Процедура ПодготовитьКДокументообороту(НаборОбъектовУчета, ОбработкаЗавершения) Экспорт		
	
	ОбщегоНазначенияБЭДКлиент.ВыполнитьПроверкуПроведенияДокументов(НаборОбъектовУчета, ОбработкаЗавершения);
	
КонецПроцедуры

#КонецОбласти

#Область ОтражениеВУчете

// Выполняет отражение в учете документа.
// 
// Параметры:
// 	ДанныеЭлектронныхДокументов - См. ИнтеграцияЭДОКлиентСервер.НовыеДанныеЭлектронногоДокументаДляОтраженияВУчете.
// 	СпособОбработки - Строка - Способ обработки.
//
Процедура НачатьОтражениеДокументаВУчете(ОбработчикОповещения, ДанныеЭлектронногоДокумента, ОбъектыУчета, СпособОбработки = Неопределено) Экспорт
	
	СписокНеСопоставленнойНоменклатуры = ИнтеграцияЭДОВызовСервера.ВыполнитьКонтрольСопоставленияНоменклатурыЭлектронногоДокумента(ДанныеЭлектронногоДокумента);
	
	Если ЗначениеЗаполнено(СписокНеСопоставленнойНоменклатуры) Тогда
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ОбработчикОповещения", ОбработчикОповещения);
		ПараметрыОповещения.Вставить("ДанныеЭлектронногоДокумента", ДанныеЭлектронногоДокумента);
		ПараметрыОповещения.Вставить("ОбъектыУчета", ОбъектыУчета);
		ПараметрыОповещения.Вставить("СпособОбработки", СпособОбработки);
		
		ОповещениеОкончанияСопоставления = Новый ОписаниеОповещения("ПослеЗавершенияСопоставленияНоменклатуры", ЭтотОбъект, ПараметрыОповещения);
		
		Настройки = Новый Структура("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		СопоставлениеНоменклатурыКонтрагентовКлиент.ОткрытьСопоставлениеНоменклатуры(
			СписокНеСопоставленнойНоменклатуры, Настройки, ОповещениеОкончанияСопоставления);
	Иначе
		ОтразитьВУчетеЭлектронныйДокумент(ОбработчикОповещения, ДанныеЭлектронногоДокумента, ОбъектыУчета, СпособОбработки);
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область Контрагенты

Процедура СоздатьКонтрагентаИнтерактивно(РеквизитыКонтрагента, ОповещениеОЗакрытии) Экспорт
	
	ОбменСКонтрагентамиКлиентПереопределяемый.СоздатьКонтрагентаИнтерактивно(РеквизитыКонтрагента, ОповещениеОЗакрытии);
	
КонецПроцедуры

Процедура ВыбратьКонтрагента(ПараметрыОтбора, ОповещениеОЗакрытии) Экспорт
	
	ОбменСКонтрагентамиКлиентПереопределяемый.ВыбратьКонтрагента(ПараметрыОтбора, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

Процедура УстановитьАктуальныйЭлектронныйДокумент(НаборОбъектовУчета, ЭлектронныйДокумент, ВидДокумента) Экспорт
	ИнтеграцияЭДОВызовСервера.УстановитьАктуальныйЭлектронныйДокумент(НаборОбъектовУчета, ЭлектронныйДокумент, ВидДокумента);
КонецПроцедуры		

// Открывает форму редактирования кода налогового органа, если он хранится в конфигурации
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения о завершении.
//  	В обработчик оповещения возвращается значение:
//			Неопределено - при нажатии пользователем кнопки Отмена;
//			Число        - Номер налогового органа, введенного пользователем
//  Организация - ОпределяемыйТип.Организация - Организация для которой редактируется код налогового органа.
//  СтандартнаяОбработка - Булево - признак открытия стандартного выбора значения.
//                         Если процедура переопределяется, то следует установить Ложь.
//
Процедура ЗаполнитьКодНалоговогоОргана(ОповещениеОЗавершении, Организация, СтандартнаяОбработка) Экспорт
	ОбменСКонтрагентамиКлиентПереопределяемый.ПриЗаполненииНалоговогоОргана(ОповещениеОЗавершении, Организация, СтандартнаяОбработка);
КонецПроцедуры

// Заполняет адрес хранилища с таблицей значений - каталога товаров.
//
// Параметры:
//  ИдентификаторФормы   - УникальныйИдентификатор - уникальный  идентификатор формы, вызвавшей функцию. Форма должна
//                                                   возвращать адрес хранилища значения, содержащего таблицу товаров,
//                                                   либо Неопределено, если была вызвана отмена операции.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                            которая будет вызвана после закрытия формы подбора.
//
Процедура ОткрытьФормуПодбораТоваров(ИдентификаторФормы, ОбработкаПродолжения) Экспорт
	
	ОбменСКонтрагентамиКлиентПереопределяемый.ОткрытьФормуПодбораТоваров(ИдентификаторФормы, ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеЗавершенияСопоставленияНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	СписокНеСопоставленнойНоменклатуры = ИнтеграцияЭДОВызовСервера.ВыполнитьКонтрольСопоставленияНоменклатурыЭлектронногоДокумента(
		ДополнительныеПараметры.ДанныеЭлектронногоДокумента);

	Если ЗначениеЗаполнено(СписокНеСопоставленнойНоменклатуры) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
			"ru='Не сопоставлена номенклатура. Документ загружен не будет.'"));
	Иначе
		ОтразитьВУчетеЭлектронныйДокумент(ДополнительныеПараметры.ОбработчикОповещения,
			ДополнительныеПараметры.ДанныеЭлектронногоДокумента, ДополнительныеПараметры.ОбъектыУчета,
			ДополнительныеПараметры.СпособОбработки);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОтразитьВУчетеЭлектронныйДокумент(ОбработчикОповещения, ДанныеЭлектронногоДокумента, ОбъектыУчета, СпособОбработки = Неопределено) Экспорт
	
	ИнтеграцияЭДОВызовСервера.ЗаполнитьДокументУчета(ДанныеЭлектронногоДокумента, ОбъектыУчета, СпособОбработки);
	
	ВыполнитьОбработкуОповещения(ОбработчикОповещения, ОбъектыУчета);
		
КонецПроцедуры

#КонецОбласти






