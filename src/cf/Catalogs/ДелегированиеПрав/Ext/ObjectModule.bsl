﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда 
		Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		ВариантДелегирования = Перечисления.ВариантыДелегированияПрав.ВсеПрава;
	КонецЕсли;	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Отсутствие") Тогда
		
		Предмет = ДанныеЗаполнения;
		
		РеквизитыОтсутствия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, "Сотрудник, ДатаНачала, ДатаОкончания, Комментарий");
		ОтКого = РеквизитыОтсутствия.Сотрудник;
		ДатаНачалаДействия = РеквизитыОтсутствия.ДатаНачала;
		ДатаОкончанияДействия = РеквизитыОтсутствия.ДатаОкончания;
		Комментарий = РеквизитыОтсутствия.Комментарий;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ОбластиДоЗаписи", Ссылка.ОбластиДелегирования.Выгрузить());
	ДополнительныеСвойства.Вставить("ДатаОкончанияДоЗаписи", Ссылка.ДатаОкончанияДействия);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ЭтотОбъект.Действует = ПравилоДелегированияПравДействует();

	Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'От: %1 кому: %2 (%3)'"),
		ОтКого,
		Кому,
		ВариантДелегирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление записей в регистре ИсполнителиРолейИДелегаты
	РегистрыСведений.ИсполнителиРолейИДелегаты.ОбновитьЗаписиПоНастройкеДелегирования(ЭтотОбъект);

	// Выполним регистрацию делегированных данных на узле обмена с мобильным.
	Если Не (ДополнительныеСвойства.Свойство("ЗначениеИзменено")
		И ДополнительныеСвойства.ЗначениеИзменено
		И ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеКлиенты") = Истина
		И Не МП_СлужебныйПовтИсп.ИспользуетсяПриложение21()) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСинхронизации = ОбменСМобильнымиСервер.ПолучитьПараметрыСинхронизации(ОтКого);

	ПериодРегистрации = ПараметрыСинхронизации.СрокУстареванияДанных;
	ОбластиДоЗаписи = ДополнительныеСвойства.ОбластиДоЗаписи;

	Результат = НеобходимаПереРегистрацияРаздела(
		Справочники.ОбластиДелегированияПрав.Почта, ПараметрыСинхронизации.СинхронизацияПочты);

	Если Результат.ДанныеИзменены Тогда

		МассивДанныхДляРегистрации = Новый Массив();

		ПапкиПисемДляСинхронизации =
			РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ПолучитьПапкиДляСинхронизации(
				ОтКого, Истина);

		ОбменСМобильнымиРегистрацияИзмененийСервер.ОпределитьСписокДанныхРазделаПочтаДляРегистрации(
			ОтКого, ПапкиПисемДляСинхронизации, МассивДанныхДляРегистрации);
		ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, Результат.УдалитьУДелегатов);

		ОбменСМобильнымиРегистрацияИзмененийСервер.ОпределитьСписокДанныхРазделаПочтаДляРегистрации(
			ОтКого, ПапкиПисемДляСинхронизации, МассивДанныхДляРегистрации);
		ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, Результат.УдалитьУДелегатов);

	КонецЕсли;

	Результат = НеобходимаПереРегистрацияРаздела(
		Справочники.ОбластиДелегированияПрав.Календарь, ПараметрыСинхронизации.СинхронизацияКалендаря);

	Если Результат.ДанныеИзменены Тогда

		МассивДанныхДляРегистрации = Новый Массив();

		ОбменСМобильнымиРегистрацияИзмененийСервер.ОпределитьСписокДанныхРазделаКалендарьДляРегистрации(
			ОтКого, ПапкиПисемДляСинхронизации, МассивДанныхДляРегистрации, ПериодРегистрации);
		ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, Результат.УдалитьУДелегатов);

	КонецЕсли;

	Результат = НеобходимаПереРегистрацияРаздела(
		Справочники.ОбластиДелегированияПрав.ПроцессыИЗадачи, ПараметрыСинхронизации.СинхронизацияЗадач);

	Если Результат.ДанныеИзменены Тогда

		МассивДанныхДляРегистрации = Новый Массив();

		ОбменСМобильнымиРегистрацияИзмененийСервер.ОпределитьСписокДанныхРазделаЗадачиДляРегистрации(
			ОтКого, ПапкиПисемДляСинхронизации, МассивДанныхДляРегистрации);
		ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, Результат.УдалитьУДелегатов);

	КонецЕсли;

	Результат = НеобходимаПереРегистрацияРаздела(
		Справочники.ОбластиДелегированияПрав.Контроль, ПараметрыСинхронизации.СинхронизацияКонтроля);

	Если Результат.ДанныеИзменены Тогда

		МассивДанныхДляРегистрации = Новый Массив();

		ОбменСМобильнымиРегистрацияИзмененийСервер.ОпределитьСписокДанныхРазделаКонтрольДляРегистрации(
			ОтКого, ПапкиПисемДляСинхронизации, МассивДанныхДляРегистрации);
		ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, Результат.УдалитьУДелегатов);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет активность правила делегирования прав на текущий момент времени с учетом
// срока действия.
//
Функция ПравилоДелегированияПравДействует()
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Если ПометкаУдаления Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Действует = Истина;
	
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ДатаНачалаДействия > ТекущаяДата Тогда
		Действует = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончанияДействия) И ТекущаяДата > ДатаОкончанияДействия Тогда
		Действует = Ложь;
	КонецЕсли;
	
	Возврат Действует;
	
КонецФункции

Функция НеобходимаПереРегистрацияРаздела(
	Раздел, ФлагРаздела)

	ОбластиДоЗаписи = ДополнительныеСвойства.ОбластиДоЗаписи;
	ДелегируетсяВсе = (ВариантДелегирования = Перечисления.ВариантыДелегированияПрав.ВсеПрава);
	ДатаКонцаБыла = ДополнительныеСвойства.ДатаОкончанияДоЗаписи;

	РаньшеБылиТеперьНет = 
		(Не ОбластиДоЗаписи.Найти(Раздел) = Неопределено 
		И ОбластиДелегирования.Найти(Раздел) = Неопределено) 
		Или ДатаКонцаБыла > ДатаОкончанияДействия
		Или ТекущаяДата() > ДатаОкончанияДействия;

	РаньшеНеБылиТеперьЕсть = 
		((ОбластиДоЗаписи.Найти(Раздел) = Неопределено
		И Не ОбластиДелегирования.Найти(Раздел) = Неопределено)
		Или Не ОбластиДелегирования.Найти(Раздел) = Неопределено)
		И ДатаОкончанияДействия > ТекущаяДата();

	ТребуетсяПеререгистрация = 
		ФлагРаздела 
		И (ДелегируетсяВсе
			Или РаньшеБылиТеперьНет 
			Или РаньшеНеБылиТеперьЕсть);

	Результат = Новый Структура();
	Результат.Вставить("ДанныеИзменены", ТребуетсяПеререгистрация);
	Результат.Вставить("УдалитьУДелегатов", РаньшеБылиТеперьНет);

	Возврат Результат;

КонецФункции

Процедура ВыполнитьПеререгистрациюЭлемента(МассивДанныхДляРегистрации, УдалитьУДелегатов)

	Если УдалитьУДелегатов Тогда

		УзлыОбмена = ОбменСМобильнымиРегистрацияИзмененийСервер.ПолучитьУзлыПоПользователям(Кому);

		Для каждого Элемент Из МассивДанныхДляРегистрации Цикл

			Попытка
				ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, Элемент);
			Исключение
			КонецПопытки;

		КонецЦикла;

	Иначе
		ОбменСМобильнымиРегистрацияИзмененийСервер.ВыполнитьРегистрациюДанныхНаЦентральномУзле(
			МассивДанныхДляРегистрации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
