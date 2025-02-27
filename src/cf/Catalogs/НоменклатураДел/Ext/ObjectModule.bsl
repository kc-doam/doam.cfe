﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		ФормаДокументов = Перечисления.ВариантыФормДокументов.Бумажная;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Раздел) И (Год <> Раздел.Год) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
			НСтр("ru = 'Год элемента номенклатуры дел не совпадает с годом раздела'"),
			ЭтотОбъект,
			"Год",,
			Отказ);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Если ЗначениеЗаполнено(Раздел) И ЗначениеЗаполнено(Организация) 
			И Организация <> Раздел.Организация Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
				РедакцииКонфигурацииКлиентСервер.ОшибкаНоменклатураОрганизации(),
				ЭтотОбъект,
				"Организация",,
				Отказ);
		КонецЕсли;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураДел.Ссылка
	|ИЗ
	|	Справочник.НоменклатураДел КАК НоменклатураДел
	|ГДЕ
	|	НоменклатураДел.Индекс = &Индекс
	|	И НоменклатураДел.Год = &Год
	|	И НоменклатураДел.Ссылка <> &Ссылка";
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.Текст = Запрос.Текст + " И (Организация = &Организация) ";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Индекс", Индекс);
	Запрос.УстановитьПараметр("Год", Год);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
			НСтр("ru = 'Элемент номенклатуры дел с указанным индексом уже зарегистрирован'"),
			ЭтотОбъект,
			"Индекс",,
			Отказ);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РаздельныйУчетДокументов") Тогда 
		ПроверяемыеРеквизиты.Добавить("ФормаДокументов");
		
		Если ЗначениеЗаполнено(ФормаДокументов) И Не Ссылка.Пустая() Тогда 
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Документы.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВнутренниеДокументы КАК Документы
			|ГДЕ
			|	НЕ Документы.ПометкаУдаления
			|	И (Документы.НоменклатураДел = &Ссылка
			|			ИЛИ Документы.Дело.НоменклатураДел = &Ссылка)
			|	И Документы.ФормаДокумента <> &ФормаДокумента
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	Документы.Ссылка
			|ИЗ
			|	Справочник.ВходящиеДокументы КАК Документы
			|ГДЕ
			|	НЕ Документы.ПометкаУдаления
			|	И (Документы.НоменклатураДел = &Ссылка
			|			ИЛИ Документы.Дело.НоменклатураДел = &Ссылка)
			|	И Документы.ФормаДокумента <> &ФормаДокумента
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	Документы.Ссылка
			|ИЗ
			|	Справочник.ИсходящиеДокументы КАК Документы
			|ГДЕ
			|	НЕ Документы.ПометкаУдаления
			|	И (Документы.НоменклатураДел = &Ссылка
			|			ИЛИ Документы.Дело.НоменклатураДел = &Ссылка)
			|	И Документы.ФормаДокумента <> &ФормаДокумента";
			
			Запрос.УстановитьПараметр("ФормаДокумента", ФормаДокументов);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Результат = Запрос.Выполнить();
			Если Не Результат.Пустой() Тогда 
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'В дело списаны документы с другой формой хранения. Выбрать указанное значение ""%1"" нельзя.'"), 
					ФормаДокументов);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ФормаДокументов",,
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЭтоНовый() Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Дела.Ссылка
			|ИЗ
			|	Справочник.ДелаХраненияДокументов КАК Дела
			|ГДЕ
			|	Дела.НоменклатураДел = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ДелоОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДелоОбъект.Записать();
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Делопроизводство.НаименованиеНоменклатурыДел(ЭтотОбъект);
	
	ВидыДокументовЗаполнены = (ВидыДокументов.Количество() > 0);
	КонтрагентыЗаполнены = (Контрагенты.Количество() > 0);
	ВопросыДеятельностиЗаполнены = (ВопросыДеятельности.Количество() > 0);
	
КонецПроцедуры

#КонецЕсли