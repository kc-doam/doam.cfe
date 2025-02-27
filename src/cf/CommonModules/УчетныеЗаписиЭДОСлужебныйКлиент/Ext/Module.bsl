﻿
#Область СлужебныеПроцедурыИФункции

// Подписывает и отправляет регистрационный пакет в сервис 1С-ЭДО.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	Оповещение - ОписаниеОповещения - содержит описание процедуры, которая будет выполнена после регистрации
// 	             сертификата со следующими параметрами:
// 	                * Результат - см. РезультатОперацииВСервисе1СЭДО
// 	                * ДополнительныеПараметры - Произвольный - значение, которое было указано при
// 	                создании объекта ОписаниеОповещения.
// 	ПараметрыРегистрации - см. СервисЭДОКлиент.НовыеПараметрыРегистрацииВСервисе1СЭДО
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
Процедура ЗарегистрироватьСертификатВСервисе1СЭДО(Форма, Оповещение, ПараметрыРегистрации,
	КонтекстДиагностики) Экспорт
	
	ДанныеПакета = СервисЭДОВызовСервера.ДанныеДляРегистрационногоПакета1СЭДО(ПараметрыРегистрации);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ДанныеПакета"       , ДанныеПакета);
	Контекст.Вставить("Оповещение"         , Оповещение);
	Контекст.Вставить("Форма"              , Форма);
	Контекст.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	Контекст.Вставить("ПаролиСертификатов" , Неопределено);
	
	ОписаниеПодписатьЭД = Новый ОписаниеОповещения("СформироватьИОтправитьРегистрационныйПакет1СЭДОПослеПодписания",
		ЭтотОбъект, Контекст);
	
	НачатьПодписаниеРегистрационногоПакета1СЭДО(ОписаниеПодписатьЭД, ДанныеПакета,
		ПараметрыРегистрации.ОтборСертификатов);
	
КонецПроцедуры

Процедура НачатьПодписаниеРегистрационногоПакета1СЭДО(ОбработкаПродолжения, ДанныеПакета, ОтборСертификатов)
	
	ДанныеНаПодпись = СервисЭДОКлиент.ПодготовитьДанныеНаПодпись(ДанныеПакета, ОтборСертификатов);
	
	КриптографияБЭДКлиент.Подписать(ДанныеНаПодпись, Неопределено, , ОбработкаПродолжения)
	
КонецПроцедуры

Процедура СформироватьИОтправитьРегистрационныйПакет1СЭДОПослеПодписания(РезультатВыполнения, Контекст) Экспорт
	
	РезультатОперации = РезультатОперацииВСервисе1СЭДО(Контекст);
		
	Если РезультатВыполнения = Неопределено Тогда
		РезультатОперации.Успех = Ложь;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатОперации);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Если РезультатВыполнения.Свойство("ПаролиСертификатов") Тогда
			Контекст.ПаролиСертификатов = РезультатВыполнения.ПаролиСертификатов;
			РезультатОперации.ПаролиСертификатов = РезультатВыполнения.ПаролиСертификатов;
		КонецЕсли;
		// Оповещение произошло из процедуры БСП
		Если РезультатВыполнения.Свойство("НаборДанных") Тогда
			// Если Успех, необходимо перебрать элементы массива Набор данных
			// в подписанных эд в элементе массива являющимся структурой будет свойство "Свойства подписи"
			// такие ЭД надо добавить в массив "МассивЭД" для обновления их статусов.
			Для Каждого ПодписываемыеДанные Из РезультатВыполнения.НаборДанных Цикл
				Если Не ПодписываемыеДанные.Свойство("СвойстваПодписи") Тогда
					ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатОперации);
					Контекст.Очистить();
					Возврат;
				КонецЕсли;
				
				СтруктураПодписи = ПодписываемыеДанные.СвойстваПодписи;
				Если ЭтоАдресВременногоХранилища(ПодписываемыеДанные.СвойстваПодписи) Тогда
					СтруктураПодписи = ПолучитьИзВременногоХранилища(СтруктураПодписи);
				КонецЕсли;
				Если Контекст.ДанныеПакета.ДвоичныеДанныеСоглашенияНаПодключениеЭДО = ПодписываемыеДанные.Данные Тогда
					Контекст.ДанныеПакета.ПодписанныеДвоичныеДанныеСоглашенияНаПодключениеЭДО = СтруктураПодписи.Подпись;
				КонецЕсли;
				Если Контекст.ДанныеПакета.ДвоичныеДанныеДляОператораЭДО = ПодписываемыеДанные.Данные Тогда
					Контекст.ДанныеПакета.ПодписанныеДвоичныеДанныеДляОператораЭДО = СтруктураПодписи.Подпись;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	// Подготовим сертификат оператора ЭДО для шифрования информации
	Если Не ЗначениеЗаполнено(Контекст.ДанныеПакета.ОператорЭДОСертификат) Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка получения сертификата оператора ЭДО.
									|Необходимо повторить получение идентификатора участника ЭДО.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатОперации);
		Возврат;
	КонецЕсли;

	// Зашифровать
	ОписаниеПодписатьЭД = Новый ОписаниеОповещения("СформироватьИОтправитьРегистрационныйПакет1СЭДОПослеШифрования",
		ЭтотОбъект, Контекст);
	
	ДвоичныеДанныеСертификатаОператораЭДО = КриптографияБЭДКлиент.СертификатИзСтрокиPEM(
		Контекст.ДанныеПакета.ОператорЭДОСертификат);
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("Операция",            НСтр("ru = 'Шифрование данных для регистрации у оператора ЭДО'"));
	
	МассивСертификатов = Новый Массив;
	МассивСертификатов.Добавить(ДвоичныеДанныеСертификатаОператораЭДО);
	ОписаниеДанных.Вставить("НаборСертификатов",   МассивСертификатов);
	ОписаниеДанных.Вставить("ОтборСертификатов",   МассивСертификатов);
	
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Ложь);
	ОписаниеДанных.Вставить("ИзменятьНабор",       Ложь);
	ОписаниеДанных.Вставить("Данные",              Контекст.ДанныеПакета.ДвоичныеДанныеДляОператораЭДО);
	ОписаниеДанных.Вставить("ЗаголовокДанных",     НСтр("ru = 'Файл'"));
	ОписаниеДанных.Вставить("БезПодтверждения",    Истина);
	
	Представление = Новый Структура;
	Представление.Вставить("Представление", НСтр("ru = 'Данные для регистрации у оператора ЭДО'"));
	ОписаниеПредставленияЗаявления = Новый ОписаниеОповещения("ОбработатьПредставлениеДанныхДляОператораЭДО",
		СервисЭДОКлиент, Контекст);
	Представление.Вставить("Значение",      ОписаниеПредставленияЗаявления);
	
	ОписаниеДанных.Вставить("Представление",       Представление);
	
	ЭлектроннаяПодписьКлиент.Зашифровать(ОписаниеДанных, , ОписаниеПодписатьЭД);
	
КонецПроцедуры

Процедура СформироватьИОтправитьРегистрационныйПакет1СЭДОПослеШифрования(РезультатВыполнения, Контекст) Экспорт
	
	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Если Не РезультатВыполнения.Свойство("ЗашифрованныеДанные") Тогда
			РезультатОперации = РезультатОперацииВСервисе1СЭДО(Контекст);
			ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатОперации);
			Контекст.Очистить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(РезультатВыполнения.ЗашифрованныеДанные) = Тип("ДвоичныеДанные") Тогда
		ЗашифрованныеДвоичныеДанныеОператораЭДО	= РезультатВыполнения.ЗашифрованныеДанные;
	Иначе
		ЗашифрованныеДвоичныеДанныеОператораЭДО = ПолучитьИзВременногоХранилища(РезультатВыполнения.ЗашифрованныеДанные);
	КонецЕсли;
	Контекст.ДанныеПакета.ЗашифрованныеДанныеОператораЭДО = ЗашифрованныеДвоичныеДанныеОператораЭДО;
	СформироватьИОтправитьРегистрационныйПакет1СЭДОЗавершение(Контекст);
	
КонецПроцедуры

Процедура СформироватьИОтправитьРегистрационныйПакет1СЭДОЗавершение(Контекст)
	
	ФормаВладелец = Неопределено;
	Если ТипЗнч(Контекст.Оповещение.Модуль) = Тип("ФормаКлиентскогоПриложения") Тогда
		ФормаВладелец = Контекст.Оповещение.Модуль;
	КонецЕсли;
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ФормаВладелец);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ОтправитьРегистрационныйПакет1СЭДОЗавершение",
		ЭтотОбъект, Контекст);
	
	ДлительнаяОперация = СервисЭДОВызовСервера.НачатьОтправкуЗаявлениеНаРегистрациюВСервис1СЭДО(
		Контекст.ДанныеПакета, Контекст.КонтекстДиагностики);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
		ОписаниеОповещенияЗавершение,
		ПараметрыОжидания);
		
КонецПроцедуры

Процедура ОтправитьРегистрационныйПакет1СЭДОЗавершение(Результат, Контекст) Экспорт
	
	СтруктураВозврата = РезультатОперацииВСервисе1СЭДО(Контекст);
	Если Результат = Неопределено
		Или Результат.Статус <> "Выполнено" Тогда
		Ошибка = ОбработкаНеисправностейБЭДКлиент.НоваяОшибка(НСтр("ru = 'Отправка регистрационного пакета 1С:ЭДО'"),
			ОбработкаНеисправностейБЭДКлиентСервер.ВидОшибкиНеизвестнаяОшибка(),
			Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки);
		ОбработкаНеисправностейБЭДКлиент.ДобавитьОшибку(СтруктураВозврата.КонтекстДиагностики, Ошибка,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, СтруктураВозврата);
		Контекст.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Ответ = ПолучитьИзВременногоХранилища(Результат.АдресРезультата); // см. СервисЭДО.ОтправитьРегистрационныйПакет1СЭДО
	
	Если Ответ.Свойство("КонтекстДиагностики") Тогда
		СтруктураВозврата.КонтекстДиагностики = Ответ.КонтекстДиагностики;
		Контекст.КонтекстДиагностики = Ответ.КонтекстДиагностики;
	КонецЕсли;
	
	Если Ответ.ТребуетсяПодключениеИнтернетПоддержки Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			Новый ОписаниеОповещения("СформироватьИОтправитьРегистрационныйПакет1СЭДОАутентификация", ЭтотОбъект, Контекст),
			ЭтотОбъект);
		
		Возврат;
		
	КонецЕсли;
	
	Если Ответ.ЕстьОшибки Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, СтруктураВозврата);
		Контекст.Очистить();
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата.Успех = Истина;
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, СтруктураВозврата);
	
КонецПроцедуры

Процедура СформироватьИОтправитьРегистрационныйПакет1СЭДОАутентификация(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		// Пользователь отказался от ввода логина и пароля.
		СтруктураВозврата = РезультатОперацииВСервисе1СЭДО(Контекст);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, СтруктураВозврата);
		Возврат;
	КонецЕсли;
	
	СформироватьИОтправитьРегистрационныйПакет1СЭДОЗавершение(Контекст);
	
КонецПроцедуры

Функция РезультатОперацииВСервисе1СЭДО(Контекст) 
	
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("Успех", Ложь);
	РезультатОперации.Вставить("УникальныйИдентификаторЗаявки1СЭДО", 
		Контекст.ДанныеПакета.РеквизитыПакета.УникальныйИдентификаторЗаявки1СЭДО);
	РезультатОперации.Вставить("КонтекстДиагностики", Контекст.КонтекстДиагностики);
	РезультатОперации.Вставить("ПаролиСертификатов", Контекст.ПаролиСертификатов);
	
	Возврат РезультатОперации;
	
КонецФункции

Процедура ОбработатьСозданиеЗаявкиПриПолученииНовогоИдентификатораТакском(Результат, ДополнительныеПараметры) Экспорт
	
	ОтветДействие = Новый Структура;
	
	ДанныеЗаявки = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(Результат.ДанныеЗаявки);
	
	УчетныеЗаписиЭДОСлужебныйВызовСервера.ЗаполнитьДанныеЗаявки(ДополнительныеПараметры, ДанныеЗаявки);
	
	Действие = "ОтправитьЗаявку";
	
	ДополнительныеПараметрыЗаявки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры,
		"ДополнительныеПараметрыЗаявкиТакском", Неопределено);
	
	Ошибки = ОшибкиВДанныхЗаявкиТакском(ДанныеЗаявки, ДополнительныеПараметрыЗаявки);
	Если ЗначениеЗаполнено(Ошибки) Тогда
		Действие = "Завершить";
		СообщитьОбОшибкахВДанныхЗаявкиТакском(Ошибки);
	КонецЕсли;
	
	ОтветДействие.Вставить("Действие"     , Действие);
	ОтветДействие.Вставить("ДанныеЗаявки" , ДанныеЗаявки);
	
	ВыполнитьОбработкуОповещения(Результат.ОбработчикРезультата, ОтветДействие);
	
КонецПроцедуры

Процедура РедактироватьКодНалоговогоОргана(КодНалоговогоОргана, Организация, ИдентификаторФормы, Оповещение) Экспорт
	
	СтандартнаяОбработкаМетода = Истина;
	
	ИнтеграцияЭДОКлиент.ЗаполнитьКодНалоговогоОргана(Оповещение, Организация, СтандартнаяОбработкаМетода);
	
	Если СтандартнаяОбработкаМетода Тогда
		ПараметрыФормы = Новый Структура;
		Если ЗначениеЗаполнено(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КодНалоговогоОргана)) Тогда
			ПараметрыФормы.Вставить("КодНалоговогоОргана", КодНалоговогоОргана);
		КонецЕсли;
		ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.ВводКодаНалоговогоОргана", ПараметрыФормы,
			ИдентификаторФормы, , , , Оповещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактироватьДатыЗапросаДанныхУОператораЭлектронногоДокументооборота(ИдентификаторУчетнойЗаписи) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗаписьЭДО", ИдентификаторУчетнойЗаписи);
	ОткрытьФорму("РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО.Форма.ФормаРедактирования",
		ПараметрыФормы, ЭтотОбъект, ИдентификаторУчетнойЗаписи,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Функция КлючУчетнойЗаписиЭДО(ИдентификаторЭДО) Экспорт
	
	ЗначенияКлюча = Новый Структура("ИдентификаторЭДО", ИдентификаторЭДО);
	Тип = Тип("РегистрСведенийКлючЗаписи.УчетныеЗаписиЭДО");
	Возврат ОбщегоНазначенияБЭДКлиент.КлючЗаписиРегистраСведений(Тип, ЗначенияКлюча);
	
КонецФункции

Процедура УдалитьУчетнуюЗапись(ИдентификаторУчетнойЗаписи, Оповещение, Форма = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Успех", Неопределено);
	Контекст.Вставить("ИдентификаторУчетнойЗаписи", ИдентификаторУчетнойЗаписи);
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("Форма", Форма);
	
	Описание = Новый ОписаниеОповещения("ПослеВопросаОбУдаленииУчетнойЗаписи", ЭтотОбъект, Контекст);
	
	ТекстВопроса = НСтр("ru = 'Сейчас будет удалена учетная запись ЭДО. Также будут удалены настройки отправки и получения, связанные с этой учетной записью.
                         |Продолжить?'");
	
	ПоказатьВопрос(Описание, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ПослеВопросаОбУдаленииУчетнойЗаписи(Результат, Контекст) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатУдаленияУчетнойЗаписи(Контекст));
		Возврат;
	КонецЕсли;

	ИдентификаторФормы = ?(Контекст.Форма <> Неопределено, Контекст.Форма.УникальныйИдентификатор,
		Новый УникальныйИдентификатор);
	ДлительнаяОперация = УчетныеЗаписиЭДОСлужебныйВызовСервера.НачатьУдалениеУчетнойЗаписи(
		Контекст.ИдентификаторУчетнойЗаписи, ИдентификаторФормы);

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Контекст.Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеСлужебное = Новый ОписаниеОповещения("ПослеУдаленияУчетнойЗаписи", ЭтотОбъект, Контекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеСлужебное, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПослеУдаленияУчетнойЗаписи(Результат, Контекст) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		Контекст.Успех = Ложь;
		ПодробноеПредставлениеОшибки = Результат.ПодробноеПредставлениеОшибки;
	Иначе
		РезультатУдаления = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Контекст.Успех = РезультатУдаления;
		ПодробноеПредставлениеОшибки = "";
	КонецЕсли;
	
	Если Не Контекст.Успех Тогда
		ТекстСообщения = НСтр("ru = 'Во время удаления учетной записи произошла ошибка.
                               |Подробнее см. в журнале регистрации.'");
		
		ОбработкаНеисправностейБЭДВызовСервера.ОбработатьОшибку(НСтр("ru = 'Удаление учетной записи ЭДО'"), 
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами, ПодробноеПредставлениеОшибки, ТекстСообщения);
			
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, РезультатУдаленияУчетнойЗаписи(Контекст));
	
КонецПроцедуры

Функция РезультатУдаленияУчетнойЗаписи(Контекст)
	
	Результат = Новый Структура;
	Результат.Вставить("Успех", Контекст.Успех);
	
	Возврат Результат;
	
КонецФункции

Процедура СоздатьУчетнуюЗапись(ПараметрыСоздания) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КнопкаНазадДоступна", ПараметрыСоздания.КнопкаНазадДоступна);
	ПараметрыФормы.Вставить("Контрагент", ПараметрыСоздания.Контрагент);
	ПараметрыФормы.Вставить("СпособыОбмена", ПараметрыСоздания.СпособыОбмена);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ПараметрыСоздания.ДополнительныеПараметры);
	ПараметрыФормы.Вставить("Организация", ПараметрыСоздания.Организация);
	ПараметрыФормы.Вставить("ОперацияЭДО", ПараметрыСоздания.ОперацияЭДО);
	ПараметрыФормы.Вставить("НастройкаОперацииЭДО", ПараметрыСоздания.НастройкаОперацииЭДО);
	
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО", ПараметрыФормы,
		ПараметрыСоздания.ВладелецФормы,,,, ПараметрыСоздания.ОповещениеОЗавершении, ПараметрыСоздания.РежимОткрытия);

КонецПроцедуры

Процедура СоздатьУчетнуюЗаписьПрямогоОбмена(Организация = Неопределено, ВладелецФормы = Неопределено, Оповещение = Неопределено) Экспорт

	ПараметрыФормы = Новый Структура;
	Если Организация <> Неопределено Тогда
		ПараметрыФормы.Вставить("Отбор", Новый Структура);
		ПараметрыФормы.Отбор.Вставить("Организация", Организация);
	КонецЕсли;

	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗаписьПрямогоОбмена", ПараметрыФормы, ВладелецФормы,
		,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

Процедура ОткрытьУчетнуюЗапись(ИдентификаторУчетнойЗаписи, ВладелецФормы = Неопределено,
	Оповещение = Неопределено) Экспорт
	
	КлючЗаписи = УчетныеЗаписиЭДОКлиент.КлючУчетнойЗаписи(ИдентификаторУчетнойЗаписи);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.ФормаЗаписи", ПараметрыФормы, ВладелецФормы,,,, Оповещение);
	
КонецПроцедуры

Функция ОшибкиВДанныхЗаявкиТакском(Знач ДанныеЗаявки, ДополнительныеПараметрыЗаявки = Неопределено) Экспорт
	
	Если ДополнительныеПараметрыЗаявки = Неопределено Тогда
		ДополнительныеПараметрыЗаявки = НовыеДополнительныеПараметрыЗаявкиТакском();
	КонецЕсли;
	
	КодРегиона = ДанныеЗаявки.КодРегиона;
	Телефон = ДанныеЗаявки.Телефон;
	ИНН = ДанныеЗаявки.ИНН;
	КПП = ДанныеЗаявки.КПП;
	ОГРН = ДанныеЗаявки.ОГРН;
	КодНалоговогоОргана = ДанныеЗаявки.КодНалоговогоОргана;
	ЮрФизЛицо = ДанныеЗаявки.ЮрФизЛицо;
	Фамилия = ДанныеЗаявки.Фамилия;
	Имя = ДанныеЗаявки.Имя;
	
	Ошибки = Новый Массив;
	
	Если ПустаяСтрока(Телефон) Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""Телефон""'"));
	КонецЕсли;
	
	// Проверка адреса
	
	Если ПустаяСтрока(КодРегиона) Тогда
		ПутьКДаннымАдресОрганизации = ДополнительныеПараметрыЗаявки.ПутьКДаннымАдресОрганизации;
		
		Если ЗначениеЗаполнено(ПутьКДаннымАдресОрганизации) Тогда
			ДополнениеОшибки = НСтр("ru = 'Нажмите для перехода к редактированию адреса.'");
		Иначе 
			ДополнениеОшибки = "";
		КонецЕсли;
		
		ТекстОшибки = НСтр("ru ='Не удалось определить код региона юридического адреса организации. Возможно, адрес указан в свободной форме.
			|Смените тип адреса (команды ""Административно-территориальное"" или ""Муниципальное деление"" меню ""Еще"" формы редактирования адреса.'")
			+ ДополнениеОшибки;
		ДобавитьОшибкуЗаявкиТакском(Ошибки, ТекстОшибки, ПутьКДаннымАдресОрганизации);
	КонецЕсли;
	
	Если ПустаяСтрока(ИНН) Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""ИНН""'"));
	КонецЕсли;
	
	Если ЮрФизЛицо <> "ЮрЛицо" И ЮрФизЛицо <> "ФизЛицо" Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не выбран тип организации (юридическое или физическое лицо)'"));
	КонецЕсли;
	
	Если ПустаяСтрока(КПП) И ЮрФизЛицо = "ЮрЛицо" Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""КПП""'"));
	КонецЕсли;
	
	Если ПустаяСтрока(ОГРН) И ЮрФизЛицо = "ЮрЛицо" Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""ОГРН""'"));
	КонецЕсли;
	
	Если ПустаяСтрока(КодНалоговогоОргана) Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""Код налогового органа""'"));
	КонецЕсли;
	
	Если ПустаяСтрока(Фамилия) Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""Фамилия""'"));
	КонецЕсли;
	
	Если ПустаяСтрока(Имя) Тогда
		ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='Не заполнено поле ""Имя""'"));
	КонецЕсли;
	
	// Дополнительные проверки
	
	Если НЕ ПустаяСтрока(Телефон) Тогда
		Если СтрДлина(Телефон) > 20 Тогда
			ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Телефон"" должен содержать не более 20 символов'"));
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	
	Если НЕ ПустаяСтрока(КодРегиона) Тогда
		Если КодРегиона <> "0" Тогда
			КодРегионаЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(КодРегиона));
			Если КодРегионаЧисло = 0 Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='В ""Коде региона"" использованы недопустимые символы'"));
			Иначе
				Если СтрДлина(СокрЛП(КодРегиона)) <> 2 Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Код региона"" должен содержать 2 цифры'"));
				Иначе
					Если КодРегионаЧисло > 99 ИЛИ КодРегионаЧисло < 1 Тогда
						ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Код региона"" должен быть от 01 до 99'"));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Код региона"" должен содержать 2 цифры'"));
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
		Если ИНН <> "0" Тогда
			ИННЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(ИНН));
			Если ИННЧисло = 0 Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ИНН"" должен содержать 12 цифр'"));
			Иначе
				Если СтрДлина(СокрЛП(ИНН)) <> 12 И ЮрФизЛицо = "ФизЛицо" Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ИНН"" должен содержать 12 цифр'"));
				ИначеЕсли СтрДлина(СокрЛП(ИНН)) <> 10 И ЮрФизЛицо = "ЮрЛицо" Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ИНН"" должен содержать 10 цифр'"));
				КонецЕсли;
			КонецЕсли;
		Иначе
			ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ИНН"" должен содержать 12 цифр'"));
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КПП) Тогда
		Если КПП <> "0" Тогда
			КППЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(КПП));
			Если КППЧисло = 0 Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='В ""КПП"" использованы недопустимые символы'"));
			Иначе
				Если СтрДлина(СокрЛП(КПП)) <> 9 Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""КПП"" должен содержать 9 цифр'"));
				КонецЕсли;
			КонецЕсли;
		Иначе
			ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""КПП"" должен содержать 9 цифр'"));
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ОГРН) Тогда
		Если ОГРН <> "0" Тогда
			ОГРНЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(ОГРН));
			Если ОГРНЧисло = 0 Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='В ""ОГРН"" использованы недопустимые символы'"));
			Иначе
				Если СтрДлина(СокрЛП(ОГРН)) <> 13  И ЮрФизЛицо = "ЮрЛицо" Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ОГРН"" должен содержать 13 цифр'"));
				ИначеЕсли СтрДлина(СокрЛП(ОГРН)) <> 15  И ЮрФизЛицо = "ФизЛицо" Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ОГРН"" должен содержать 15 цифр'"));
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрДлина(СокрЛП(ОГРН)) <> 13  И ЮрФизЛицо = "ЮрЛицо" Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ОГРН"" должен содержать 13 цифр'"));
			ИначеЕсли СтрДлина(СокрЛП(ОГРН)) <> 15  И ЮрФизЛицо = "ФизЛицо" Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""ОГРН"" должен содержать 15 цифр'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КодНалоговогоОргана) Тогда
		Если КодНалоговогоОргана <> "0" Тогда
			Если ОГРНЧисло = 0 Тогда
				ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='В ""Коде налогового органа"" использованы недопустимые символы'"));
			Иначе
				Если СтрДлина(СокрЛП(КодНалоговогоОргана)) <> 4 Тогда
					ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Код налогового органа"" должен содержать 4 цифры'"));
				КонецЕсли;
			КонецЕсли;
		Иначе
			ДобавитьОшибкуЗаявкиТакском(Ошибки, НСтр("ru ='""Код налогового органа"" должен содержать 4 цифры'"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ошибки;
	
КонецФункции

Процедура СообщитьОбОшибкахВДанныхЗаявкиТакском(Знач Ошибки) Экспорт
	
	Если Не ЗначениеЗаполнено(Ошибки) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Обнаружены ошибки в заявке оператору ""Такском"":'"));
	
	Для каждого Ошибка Из Ошибки Цикл
		ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.ТекстСообщения,, Ошибка.ПутьКДанным);
	КонецЦикла;
	
КонецПроцедуры

Функция НовыеДополнительныеПараметрыЗаявкиТакском() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПутьКДаннымАдресОрганизации", "");
	
	Возврат ДополнительныеПараметры;
	
КонецФункции 

Процедура ДобавитьОшибкуЗаявкиТакском(Ошибки, ТекстСообщения, ПутьКДанным = "") 
	
	Ошибка = Новый Структура;
	Ошибка.Вставить("ТекстСообщения", ТекстСообщения);
	Ошибка.Вставить("ПутьКДанным", ПутьКДанным);
	Ошибки.Добавить(Ошибка);
	
КонецПроцедуры

Процедура ПоказатьНеподписанныеДокументы(НеподписанныеДокументы, ПредставлениеДанных,
	ВладелецФормы = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Данные", НеподписанныеДокументы);
	ПараметрыФормы.Вставить("ПредставлениеДанных", ПредставлениеДанных);
	ОткрытьФорму("РегистрСведений.СертификатыУчетныхЗаписейЭДО.Форма.ПросмотрДанных", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

Процедура НачатьПолучениеНовогоИдентификатораТакском(ОписаниеОповещения, ОбработчикСтатусаЗаявки,
	СертификатКриптографии, Организация, ДополнительныеПараметры) Экспорт
	
	ОбработчикСозданияЗаявки = Новый ОписаниеОповещения(
		"ОбработатьСозданиеЗаявкиПриПолученииНовогоИдентификатораТакском",
		ЭтотОбъект, ДополнительныеПараметры);
		
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("ОбработчикСтатусаЗаявки", ОбработчикСтатусаЗаявки);
	ПараметрыОбработки.Вставить("ОбработчикСозданияЗаявки", ОбработчикСозданияЗаявки);
	
	Подключение1СТакскомКлиент.ПолучитьУникальныйИдентификаторАбонента(СертификатКриптографии, Организация,
			ОписаниеОповещения, ПараметрыОбработки);
	
КонецПроцедуры

#КонецОбласти