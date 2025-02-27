﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ОбновитьДанныеГруппыВАдреснойКниге;
Перем ОбновитьДанныеКонтактовГруппыВАдреснойКниге;

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НомерСтроки = ЭтотОбъект.Контакты.Количество() - 1;
	
	Пока НЕ Отказ И НомерСтроки >= 0 Цикл
		
		ТекущаяСтрока = ЭтотОбъект.Контакты.Получить(НомерСтроки);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Контакт)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.КонтактнаяИнформация) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен адресат.'"),
			                                                  ЭтотОбъект,
			                                                  "Контакты[" + Формат(НомерСтроки, "ЧГ=0") + "].Контакт",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		
		ЧислоНайденных = 0;
		Для Каждого СтрокаСписка Из ЭтотОбъект.Контакты Цикл
			Если СтрокаСписка.Контакт = ТекущаяСтрока.Контакт
				И СтрокаСписка.КонтактнаяИнформация = ТекущаяСтрока.КонтактнаяИнформация Тогда
				ЧислоНайденных = ЧислоНайденных + 1;
			КонецЕсли;	
		КонецЦикла;	
		
		Если ЧислоНайденных > 1 Тогда
			
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Адресат ""%1"" повторяется.'"), ТекущаяСтрока.Контакт);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки,
			                                                  ЭтотОбъект,
			                                                  "Контакты[" + Формат(НомерСтроки, "ЧГ=0") + "].Контакт",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.ГруппыКонтактовПользователей.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		
		Для каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			
			// Поиск удаляемого участника в итоговой рабочей группе
			Для каждого Эл2 Из РабочаяГруппа Цикл
				
				Если Эл2.Участник = Эл.Участник Тогда
					
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
				
		КонецЦикла;
			
	КонецЕсли;
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь); //ОбновитьПраваДоступа
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
	// Обновление адресной книги
	ОбновитьДанныеГруппыВАдреснойКниге = Ложь;
	ОбновитьДанныеКонтактовГруппыВАдреснойКниге = Ложь;
	Если ЭтоНовый() Тогда
		Если ЗначениеЗаполнено(Родитель) Тогда
			ОбновитьДанныеГруппыВАдреснойКниге = Истина;
		КонецЕсли;
		ОбновитьДанныеКонтактовГруппыВАдреснойКниге = Истина;
	Иначе
		РеквизитыГруппыКонтактовПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Ссылка, "Родитель, Контакты, ПометкаУдаления, ОбщийСписокРассылки, Наименование");
		
		Если ЗначениеЗаполнено(Родитель)
			И (РеквизитыГруппыКонтактовПоСсылке.Родитель <> Родитель
				Или РеквизитыГруппыКонтактовПоСсылке.ПометкаУдаления <> ПометкаУдаления
				Или РеквизитыГруппыКонтактовПоСсылке.ОбщийСписокРассылки <> ОбщийСписокРассылки)
				Или РеквизитыГруппыКонтактовПоСсылке.Наименование <> Наименование Тогда
			
			ОбновитьДанныеГруппыВАдреснойКниге = Истина;
		КонецЕсли;
		
		Если РеквизитыГруппыКонтактовПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбновитьДанныеКонтактовГруппыВАдреснойКниге = Истина;
		КонецЕсли;
		
		КонтактыИзменены = Ложь;
		ПредыдущиеКонтакты = РеквизитыГруппыКонтактовПоСсылке.Контакты.Выгрузить();
		НовыеКонтакты = Контакты.Выгрузить();
		
		Для Каждого СтрКонтакт ИЗ НовыеКонтакты Цикл
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Контакт", СтрКонтакт.Контакт);
			Если Не ЗначениеЗаполнено(СтрКонтакт.Контакт) Тогда
				СтруктураПоиска.Вставить("КонтактнаяИнформация", СтрКонтакт.КонтактнаяИнформация);
			КонецЕсли;
			Если ПредыдущиеКонтакты.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
				КонтактыИзменены = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ КонтактыИзменены Тогда
			Для Каждого СтрКонтакт ИЗ ПредыдущиеКонтакты Цикл
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Контакт", СтрКонтакт.Контакт);
				Если Не ЗначениеЗаполнено(СтрКонтакт.Контакт) Тогда
					СтруктураПоиска.Вставить("КонтактнаяИнформация", СтрКонтакт.КонтактнаяИнформация);
				КонецЕсли;
				Если НовыеКонтакты.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					КонтактыИзменены = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если КонтактыИзменены
			Или РеквизитыГруппыКонтактовПоСсылке.ОбщийСписокРассылки <> ОбщийСписокРассылки Тогда
			
			ОбновитьДанныеКонтактовГруппыВАдреснойКниге = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Родитель) И КонтактыИзменены Тогда
			ОбновитьДанныеГруппыВАдреснойКниге = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги
	Если ОбщийСписокРассылки Тогда
		ОбъектДоступа = Ссылка;
	Иначе
		ОбъектДоступа = Автор;
	КонецЕсли;
	
	Если ОбновитьДанныеГруппыВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка, Родитель, Справочники.АдреснаяКнига.Избранное, ОбъектДоступа);
	КонецЕсли;
	Если ОбновитьДанныеКонтактовГруппыВАдреснойКниге Тогда
		
		НовыеКонтакты = Новый Массив;
		Для Каждого СтрКонтакт Из Контакты Цикл
			Если ЗначениеЗаполнено(СтрКонтакт.Контакт) Тогда
				НовыеКонтакты.Добавить(СтрКонтакт.Контакт);
			Иначе
				НовыеКонтакты.Добавить(СтрКонтакт.КонтактнаяИнформация);
			КонецЕсли;
		КонецЦикла;
		
		Справочники.АдреснаяКнига.ОбновитьСписокПодчиненныхОбъектов(
			Ссылка,Родитель,
			НовыеКонтакты,
			Справочники.АдреснаяКнига.Избранное,
			ОбъектДоступа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли