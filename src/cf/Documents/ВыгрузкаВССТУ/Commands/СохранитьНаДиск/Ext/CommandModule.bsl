﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ФайлДокумента = ПолучитьФайлДокумента(ПараметрКоманды);
	Если ФайлДокумента = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'У выбранного документа нет файлов.'"));
	Иначе
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(ФайлДокумента);
		КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьФайлДокумента(Документ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Ссылка
		|ИЗ
		|	Справочник.Файлы
		|ГДЕ
		|	ВладелецФайла = &Документ
		|	И НЕ ПометкаУдаления
		|");
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти