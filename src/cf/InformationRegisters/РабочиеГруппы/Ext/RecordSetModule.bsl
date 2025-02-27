﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		
		Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;
		
		ОбработанныеОбъекты = Новый Соответствие;
		ТипыОбъектовВходящихВМеханизмПрав = 
			ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующихДоступПоДескрипторам();
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			ТекущийОбъект = Запись.Объект;
			Если ОбработанныеОбъекты.Получить(ТекущийОбъект) = Неопределено Тогда
				ТипОбъекта = ТипЗнч(ТекущийОбъект);
				Если ТипыОбъектовВходящихВМеханизмПрав.Найти(ТипОбъекта) <> Неопределено Тогда
					
					Если РегистрыСведений.ДескрипторыДляОбъектов.ЕстьДескрипторыОбъекта(ТекущийОбъект) Тогда
						ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ТекущийОбъект);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
			
			ОбработанныеОбъекты.Вставить(ТекущийОбъект, Истина);
			
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	ОбъектОтбора = ЭтотОбъект.Отбор.Объект.Значение;
	Если ЗначениеЗаполнено(ОбъектОтбора) И ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектОтбора.Метаданные()) Тогда
		
		// Запись в РС УчастникиПроцессов
		НаборИзменен = Ложь;
		ТаблицаНабора = РегистрыСведений.УчастникиПроцессов.ПолучитьУчастников(ОбъектОтбора);
		СтруктураПоиска = Новый Структура("Участник");
		
		Для Каждого СтрокаРГ Из ЭтотОбъект Цикл
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаРГ);
			НайденныеСтроки = ТаблицаНабора.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НаборИзменен = Истина;
				ЗаполнитьЗначенияСвойств(ТаблицаНабора.Добавить(), СтрокаРГ);
			КонецЕсли;
		КонецЦикла;
		
		Если НаборИзменен Тогда
			РегистрыСведений.УчастникиПроцессов.ЗаписатьНаборПоПроцессу(ОбъектОтбора, ТаблицаНабора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли