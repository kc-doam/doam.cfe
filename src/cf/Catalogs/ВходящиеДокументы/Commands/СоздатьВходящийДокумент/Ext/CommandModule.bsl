﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипШаблонаДокумента", "ШаблоныВходящихДокументов");
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Истина);
	
	РежимОткрытияФормы = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону = Новый ОписаниеОповещения(
		"СозданиеДокументаПоШаблонуЗавершение", ЭтотОбъект, ПараметрыВыполненияКоманды);
	
	Попытка
		
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону",
			ПараметрыФормы,,,,,
			ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
			РежимОткрытияФормы);
			
		Возврат;
		
	Исключение
		
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
				"СоздатьПустойДокумент");
		Иначе
			ВызватьИсключение;
		КонецЕсли;
		
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура СозданиеДокументаПоШаблонуЗавершение(Результат, Параметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) ИЛИ Результат = "ПрерватьОперацию" Тогда
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = "ВходящиеДокументыВыполнениеКомандыСоздать";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

	ПараметрыФормы = Новый Структура;
	
	Если (ТипЗнч(Результат) <> Тип("Строка")) Тогда 
		ШаблонДокумента = Результат.ШаблонДокумента;
		// Регламентированный учет обращений
		Если Результат.Свойство("ТаблицаВопросы") 
			И Результат.ТаблицаВопросы.Количество() > 0 Тогда 
			ПараметрыФормы.Вставить("ТаблицаВопросы", Результат.ТаблицаВопросы);
		КонецЕсли;
		// Конец Регламентированный учет обращений
	Иначе
		ШаблонДокумента = Результат;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ШаблонДокумента", ШаблонДокумента);
	ПараметрыФормы.Вставить("ЗаполнятьРеквизитыДоСоздания", Ложь);
	
	ИмяФормы = "Справочник.ВходящиеДокументы.ФормаОбъекта";
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, Параметры.Источник);
	
КонецПроцедуры
